--[[
  Client entry point for delivery job

  @author Astymeus
  @date 2019-07-24
  @version 1.0
--]]
DeliveryJob = {}
local ClosetOfMissionPoint = false
local ClosetOfBoxSpawnPoint = false
local ClosetOfSpawnForkliftPoint = false
local indexSpawnFroklift = nil
local UserIsInService = false

-- ACTIONS message
local TAKE_TRUNK_ACTION_MSG = "Appuyez sur ~INPUT_CONTEXT~ pour récupérer ta camionnette"
local LOAD_BOXE_IN_TRUNK_ACTION_MSG = "Appuyez sur la touche ~INPUT_CONTEXT~ pour charger la caisse."
local PUT_BOX_ON_GROUND_ACTION_MSG = "Appuyez sur la touche ~INPUT_CONTEXT~ pour poser par terre."
local PUT_BOX_ON_TRUNK_ACTION_MSG = "Appuyez sur la touche ~INPUT_CONTEXT~ pour la mettre dans le camion."
local OPEN_ITEMS_MENU_ACTION_MSG = "Appuyez sur la touche ~INPUT_CONTEXT~ pour récupérer des marchandises."
local PUT_ITEMS_IN_BOX_ACTION_MSG = "Appuyez sur la touche ~INPUT_CONTEXT~ pour mettre vos marchandises dans la caisse"
local GET_FORKLIFT_ACTION_MSG = "Appuyez sur la touche ~INPUT_CONTEXT~ pour récupérer un forklift"
local CANT_PUT_ITEMS_IN_BOX_MSG = "La caisse doit être déchargé du camion pour mettre vos marchandise."
local NO_BOX_ON_HAND = "Vous n'avez aucune marchandise dans les mains."
local OPEN_CHOSE_MISSION = "Appuyez sur ~INPUT_CONTEXT~ pour choisir une mission."
local SPAWN_BOX = "Appuyez sur ~INPUT_CONTEXT~ pour récupérer une caisse."

-- OTHERS message
local LOAD_TRUNK_MSG = "Prenez votre camion et aller chercher votre caisse de marchandise."
local LOAD_BOX_ON_TRUCK = "Utiliser le forklift pour mettre la caisse dans votre camion, les portes arrière doivent etre ouvert."
local LOAD_BOX_MSG = "Rejoingner les entrepots adapté à votre livraision (~BLIP_408~ sur la carte) "
local TAKE_IN_BOX_MSG = "Veuillez prendre les items dans les caisses"
local DELIVERY_MSG = "veuillez livrer votre chargement à destination ~BLIP_119~"

function DeliveryJob.isEnabled()
  return DeliveryJobConfig.enabled
end

function DeliveryJob.getServiceLocation()
  return DeliveryJobConfig.serviceLocation
end

function DeliveryJob.init()
    TriggerServerEvent("DeliveryJob:getWarehouses")
end

function DeliveryJob.commands()
  if IsControlJustReleased(1, Keys["INPUT_CONTEXT"]) and
    DeliveryJobConfig.onTrunkDrop ~= nil and
    (DeliveryJobConfig.trunk ~= nil and GetEntityModel(GetVehiclePedIsIn(player,
      false)) == GetHashKey(DeliveryJobConfig.TRUNK_KEY)
      or DeliveryJobConfig.trunk == nil) then
    if IsPedInVehicle(GetPlayerPed(-1), DeliveryJobConfig.trunk) then
      despawnTrunk()
      despawnForklift()
      despawnBox()
    else
      spawnTrunk()
      spawnForklift()
      spawnBox()
    end
  end
end

function takeMission()
  TriggerServerEvent("DeliveryJob:takeMission")
end

function takeMissionPrecise(nb)
  TriggerServerEvent("DeliveryJob:takeMissionPrecise", nb)
  RemoveBlip(DeliveryJobConfig.gpsroute["Choix des livraisons"])
  DeliveryJobConfig.gpsroute["Choix des livraisons"] = nil
  local name = "Caisse de transport"
  if not DeliveryJobConfig.gpsroute[name] then
    local blip = JobTools.addBlip(DeliveryJobConfig.takebox, name, 478, 2, true)
    DeliveryJobConfig.gpsroute[name] = blip
  end
  spawnTrunk()
end

function abortMission()
  if DeliveryJobConfig.mission.shop ~= nil then
    TriggerServerEvent("DeliveryJob:abortMission", DeliveryJobConfig.mission.orderId)
  end
  DeliveryJobConfig.currentStep = 0
  DeliveryJobConfig.itemsTaken = {}
  DeliveryJobConfig.itemsTrunk = {}
  DeliveryJobConfig.mission = nil
  DeliveryJobConfig.order = nil
  DeliveryJobConfig.destination = nil
  DropInTheBiggestBoxForitemsTaken()

  Menu.close()
  JobsConfig.isMenuOpen = false
end

function DeliveryJob.showMenu()
  if DeliveryJobConfig.currentStep == 0 then
  --  Menu.addButton("Effectuer la livraison", "takeMission")
  else
    Menu.addButton("Abandonner la livraison", "abortMission")
  end
end

function UserTakingServiceLivery()
  DeliveryJobConfig.currentStep = 0
  local name = "Choix des livraisons"
  if not DeliveryJobConfig.gpsroute[name] then
    local blip = JobTools.addBlip(DeliveryJobConfig.chosemission, name, 515, 2, true)
    DeliveryJobConfig.gpsroute[name] = blip
  end
  local ped = GetPlayerPed(-1)
  local props = {}
  local components ={}
  --{"tshirt_1":59,"torso_1":89,"arms":31,"pants_1":36,"glasses_1":19,"decals_2":0,"hair_color_2":0,"helmet_2":0,"hair_color_1":0,"face":2,"glasses_2":0,"torso_2":1,"shoes":35,"hair_1":0,"skin":0,"sex":0,"glasses_1":19,"pants_2":0,"hair_2":0,"decals_1":0,"tshirt_2":0,"helmet_1":5} --------------{"tshirt_1":36,"torso_1":0,"arms":68,"pants_1":30,"glasses_1":15,"decals_2":0,"hair_color_2":0,"helmet_2":0,"hair_color_1":0,"face":27,"glasses_2":0,"torso_2":11,"shoes":26,"hair_1":5,"skin":0,"sex":1,"glasses_1":15,"pants_2":2,"hair_2":0,"decals_1":0,"tshirt_2":0,"helmet_1":19}

  if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then
     props = {
      { 0, -1, 0 }, -- casque
      { 1, -1, 0 }, -- lunette
      { 2, 0, 0 }, -- ecouteur
      { 3, 3, 0 } -- montre
    }
    components = {
      { 1, 11, 2 }, -- masque
      { 3, 0, 0 }, -- gant/bras
      { 4, 36, 0 }, -- pantalon
      { 5, 0, 0 }, -- parachute
      { 6, 35, 0 }, --chaussure
      { 7, 0, 0 }, --acssessoir
      { 8, 59, 5 }, -- ceinture/t-shirt
      { 9, 0, 0 }, -- armur
      { 10, 0, 0 }, -- emblème
      { 11, 1, 0 } -- chemise/pull/veste
    }
  else -- femme
    props = {
      { 0, -1, 0 }, -- casque
      { 1, -1, 0 }, -- lunette
      { 2, 0, 0 }, -- ecouteur
      { 3, 3, 0 } -- montre
    }
    components = {
      { 1, 11, 2 }, -- masque
      { 3, 0, 1 }, -- gant/bras
      { 4, 30, 2 }, -- pantalon
      { 5, 0, 0 }, -- parachute
      { 6, 26, 0 }, --chaussure
      { 7, 0, 0 }, --acssessoir
      { 8, 36, 0 }, -- ceinture/t-shirt
      { 9, 0, 0 }, -- armur
      { 10, 0, 0 }, -- emblème
      { 11, 0, 1 } -- chemise/pull/veste
    }

  end

  for _, comp in ipairs(components) do
     SetPedComponentVariation(ped, comp[1], comp[2], comp[3], 0)
  end

  for _, comp in ipairs(props) do
      if comp[2] == -1 then
          ClearPedProp(ped, comp[1])
      else
          SetPedPropIndex(ped, comp[1], comp[2] , comp[3] , true)
      end
  end
end

function spawnBoxFromMission()
  local boxx = GetClosestObjectOfType(DeliveryJobConfig.trunkDrops.box.x,DeliveryJobConfig.trunkDrops.box.y,DeliveryJobConfig.trunkDrops.box.z, 3.0, GetHashKey(DeliveryJobConfig.BOX_KEY), false)
  if boxx == 0 then
    spawnBox()
    DeliveryJobConfig.currentStep = 1.1
  else
    JobsConfig.jobsNotification.message = "<span class='red--text'>un élément block le spawn de caisse.</span>"
    Venato.notify(JobsConfig.jobsNotification)
  end
end

function openMenuSpawnBox()
  Menu.clearMenu()
  Menu.open()
  Menu.setTitle("livraison")
  Menu.addButton("Récupérer une caisse", "spawnBoxFromMission")
  Menu.addButton("Récupérer un Forklift", "spawnForkliftfunction")
end

function spawnForkliftfunction()
  local playerPos = GetEntityCoords(GetPlayerPed(-1))
  spawnForklift({x=playerPos.x, y=playerPos.y, z=playerPos.z})
end

function openChoseMission()
  Menu.clearMenu()
  Menu.open()
  Menu.setTitle("Choix de la livraison")
  if DeliveryJobConfig.currentStep == 0 then
    Menu.addButton("livraison pour le Taquila-la", "takeMissionPrecise", 1)
    Menu.addButton("livraison pour l'hospital'", "takeMissionPrecise", 2)
    Menu.addButton("livraison pour la LSPD", "takeMissionPrecise", 3)
    --Menu.addButton("livraison test", "takeMissionPrecise", 4)
  else
    Menu.addButton("Abandonner la livraison", "abortMission")
  end
end

function DeliveryJob.mainLoop()
    local dropPoint = DeliveryJobConfig.trunkDrops['box']

    while true do
    if DeliveryJob.isEnabled() then
      local player = GetPlayerPed(-1)
      Wait(0)

      interactTxt = false

      if ClosetOfMissionPoint ~= false and DeliveryJobConfig.currentStep ~= nil then
        if ClosetOfMissionPoint < 20 then
          DrawMarker(27, DeliveryJobConfig.chosemission.x, DeliveryJobConfig.chosemission.y, DeliveryJobConfig.chosemission.z, 0, 0, 0, 0, 0, 0, 1.9, 1.9, 1.9, 0, 112, 168,174, 0, 0, 0, 0)
        end
        if ClosetOfMissionPoint < 2 then
          Venato.InteractTxt(OPEN_CHOSE_MISSION)
          if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
            openChoseMission()
          end
        end
      end

      if ClosetOfBoxSpawnPoint ~= false and DeliveryJobConfig.currentStep ~= nil then
        if ClosetOfBoxSpawnPoint < 20 then
          DrawMarker(27, DeliveryJobConfig.takebox.x, DeliveryJobConfig.takebox.y, DeliveryJobConfig.takebox.z, 0, 0, 0, 0, 0, 0, 1.9, 1.9, 1.9, 0, 112, 168,174, 0, 0, 0, 0)
        end
        if ClosetOfBoxSpawnPoint < 2 then
          Venato.InteractTxt(SPAWN_BOX)
          if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
            openMenuSpawnBox()
          end
        end
      end

      if ClosetOfSpawnForkliftPoint ~= false and indexSpawnFroklift ~= nil and DeliveryJobConfig.currentStep ~= nil then
        if ClosetOfSpawnForkliftPoint < 20 then
          DrawMarker(27, DeliveryJobConfig.trunkDrops["forklift"][indexSpawnFroklift].x, DeliveryJobConfig.trunkDrops["forklift"][indexSpawnFroklift].y, DeliveryJobConfig.trunkDrops["forklift"][indexSpawnFroklift].z, 0, 0, 0, 0, 0, 0, 1.9, 1.9, 1.9, 0, 112, 168,174, 0, 0, 0, 0)
        end
        if ClosetOfSpawnForkliftPoint < 2 then
          Venato.InteractTxt(SPAWN_BOX)
          if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
            local playerPos = GetEntityCoords(GetPlayerPed(-1))
            spawnForklift({x=DeliveryJobConfig.trunkDrops["forklift"][indexSpawnFroklift].x, y=DeliveryJobConfig.trunkDrops["forklift"][indexSpawnFroklift].y, z=DeliveryJobConfig.trunkDrops["forklift"][indexSpawnFroklift].z , heading=DeliveryJobConfig.trunkDrops["forklift"][indexSpawnFroklift].heading})
          end
        end
      end

      if JobsConfig.inService then
        local playerPos = GetEntityCoords(GetPlayerPed(-1))
        local distance = GetDistanceBetweenCoords(playerPos, dropPoint.x, dropPoint.y, dropPoint.z, true)

        if distance < 45 and (DeliveryJobConfig.trunk ~= nil and GetEntityModel(GetVehiclePedIsIn(player, false)) ==
          GetHashKey(DeliveryJobConfig.TRUNK_KEY) or DeliveryJobConfig.trunk == nil) then
          DrawMarker(27, dropPoint.x, dropPoint.y, dropPoint.z, 0, 0, 0, 0, 0, 0, 1.9, 1.9, 1.9, 0, 112, 168,
            174, 0, 0, 0, 0)
        end
        if distance < 2 and (DeliveryJobConfig.trunk ~= nil and GetEntityModel(GetVehiclePedIsIn(player,
          false)) == GetHashKey(DeliveryJobConfig.TRUNK_KEY) or DeliveryJobConfig.trunk == nil) then
          DeliveryJobConfig.onTrunkDrop = dropPoint
          Venato.InteractTxt(TAKE_TRUNK_ACTION_MSG)
          interactTxt = true
        elseif DeliveryJobConfig.onTrunkDrop == dropPoint and distance > 1.5 then
          DeliveryJobConfig.onTrunkDrop = nil
        end
        if DeliveryJobConfig.boxCoord ~= {} and (not DeliveryJobConfig.boxOnForklift or DeliveryJobConfig.boxOnTrunk) then
          for i, v in ipairs(DeliveryJobConfig.boxCoord) do
            local distance = GetDistanceBetweenCoords(v.x, v.y, v.z, playerPos["x"], playerPos["y"], playerPos["z"],
              true)
            if distance < 0.6 and GetEntityModel(GetVehiclePedIsIn(player,
              false)) == GetHashKey(DeliveryJobConfig.FORKLIFT_KEY)
            then
              Venato.InteractTxt(LOAD_BOXE_IN_TRUNK_ACTION_MSG)
              interactTxt = true
              if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
                takeBox(player)
                DeliveryJobConfig.boxOnForklift = true
                DeliveryJobConfig.boxOnTrunk = false
                DeliveryJobConfig.isTrunkReady = false
              end
            end
          end
        elseif DeliveryJobConfig.boxOnForklift and DeliveryJobConfig.globalTrunk == nil then
          for i, v in ipairs(DeliveryJobConfig.boxCoord) do
            local distance = GetDistanceBetweenCoords(v.x, v.y, v.z + 0.9,
              playerPos["x"], playerPos["y"], playerPos["z"],
              true)
            if distance < 0.5 and GetEntityModel(GetVehiclePedIsIn(player,
              false)) == GetHashKey(DeliveryJobConfig.FORKLIFT_KEY) then
              Venato.InteractTxt(PUT_BOX_ON_GROUND_ACTION_MSG)
              interactTxt = true
              if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
                dropBoxInForklift(player)
                DeliveryJobConfig.boxOnForklift = false
                DeliveryJobConfig.boxOnTrunk = false
              end
            end
          end
        elseif DeliveryJobConfig.globalTrunk ~= nil and not DeliveryJobConfig.boxOnTrunk then
          local distance = GetDistanceBetweenCoords(
            DeliveryJobConfig.trunkCoord.x, DeliveryJobConfig.trunkCoord.y, DeliveryJobConfig.trunkCoord.z + 0.9,
            playerPos["x"], playerPos["y"], playerPos["z"],
            true)
          if distance < 0.5 and GetEntityModel(GetVehiclePedIsIn(player,
            false)) == GetHashKey(DeliveryJobConfig.FORKLIFT_KEY) then
            Venato.InteractTxt(PUT_BOX_ON_TRUNK_ACTION_MSG)
            interactTxt = true
            if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
              loadOnTrunk()
              DeliveryJobConfig.boxOnForklift = false
              DeliveryJobConfig.boxOnTrunk = true
              if DeliveryJobConfig.currentStep == 1.1 then
                DeliveryJobConfig.currentStep = 2
                RemoveBlip(DeliveryJobConfig.gpsroute["Caisse de transport"])
                DeliveryJobConfig.gpsroute["Caisse de transport"] = nil
              end
            end
          end
        end

        if DeliveryJobConfig.mission and DeliveryJobConfig.currentStep >= 1 then
          DrawRect(0.1, 0.3, 0.2, 0.4, 0, 0, 0, 150)
          printTxt("~y~Commande :", 0.1, 0.1, true, 0.8)
          local y_ = 0.15
          DeliveryJobConfig.orderComplete = true
          for _, item in pairs(DeliveryJobConfig.order) do
            local alreadyTaken = DeliveryJobConfig.itemsTrunk[item.id] or 0
            local checkBox = item.quantity - alreadyTaken > 0 and "~r~[ ]~b~" or "~g~[x]~b~"
            printTxt(checkBox .. " " .. item.name ..
              " ~s~(" .. alreadyTaken .. "/" .. item.quantity .. ")",
              0.01, y_, false)
            if DeliveryJobConfig.orderComplete and item.quantity - alreadyTaken <= 0 then
              DeliveryJobConfig.orderComplete = true
            else
              DeliveryJobConfig.orderComplete = false
            end
            y_ = y_ + .025
          end
          if DeliveryJobConfig.orderComplete then
            DeliveryJobConfig.currentStep = 3
          end
        end

        if DeliveryJobConfig.mission and DeliveryJobConfig.orderComplete and DeliveryJobConfig.currentStep == 3 then
          local destination = DeliveryJobConfig.destination
          local distance = GetDistanceBetweenCoords(playerPos, destination.x, destination.y, destination.z, true)
          local boxCoord = GetEntityCoords(DeliveryJobConfig.globalBox)
          local destPos = vector3(destination.x, destination.y, destination.z)
          local boxOnDestination = GetDistanceBetweenCoords(destPos, boxCoord.x, boxCoord.y, boxCoord.z, true)
          if distance < 20 then
            DrawMarker(27, destination.x, destination.y, destination.z, 0, 0, 0, 0, 0, 0, 1.9, 1.9, 1.9, 0, 112, 168,
              174, 0, 0, 0, 0)
          end
          if distance < 1.5 and GetEntityModel(GetVehiclePedIsIn(player,
            false)) ~= GetHashKey(DeliveryJobConfig.FORKLIFT_KEY) then
            DeliveryJobConfig.onDeliveryPoint = destination
            Venato.InteractTxt(GET_FORKLIFT_ACTION_MSG)
            interactTxt = true
            if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
              spawnForklift(destination)
            end
          elseif boxOnDestination < 3 and not DeliveryJobConfig.boxOnForklift then
            DeliveryJobConfig.onDeliveryPoint = destination
            if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
              ValidateMission()
            end
          elseif DeliveryJobConfig.onDeliveryPoint == destination and distance > 5 then
            DeliveryJobConfig.onDeliveryPoint = nil
          end
        end

        if not interactTxt then
          if DeliveryJobConfig.currentStep == 1 then
            Venato.InteractTxt(LOAD_TRUNK_MSG)
          elseif DeliveryJobConfig.currentStep == 1.1 then
            Venato.InteractTxt(LOAD_BOX_ON_TRUCK)
          elseif DeliveryJobConfig.currentStep == 2 then
            if not DeliveryJobConfig.inWarehouse then
              if DeliveryJobConfig.globalBox == DeliveryJobConfig.box and next(DeliveryJobConfig.itemsTaken) ~= nil then
                if not DeliveryJobConfig.boxOnTrunk and not DeliveryJobConfig.boxOnForklift then
                  if DeliveryJobConfig.carryBoxWithHand then
                    Venato.InteractTxt(PUT_ITEMS_IN_BOX_ACTION_MSG)
                    if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
                      putItemInTrunk()
                    end
                  else
                    Venato.InteractTxt(NO_BOX_ON_HAND)
                  end
                else
                  Venato.InteractTxt(CANT_PUT_ITEMS_IN_BOX_MSG)
                end
              else
                Venato.InteractTxt(LOAD_BOX_MSG)
              end
              DeliveryJobConfig.ShopProOrNot = true
            else
              DeliveryJobConfig.ShopProOrNot = false
              for k,v in pairs(DeliveryJobConfig.StockItems) do
                if GetDistanceBetweenCoords(playerPos, v.x, v.y, v.z, true) < 2 then
                  Venato.InteractTxt(OPEN_ITEMS_MENU_ACTION_MSG)
                  if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
                    if not DeliveryJobConfig.carryBoxWithHand then
                      JobsConfig.isMenuOpen = not JobsConfig.isMenuOpen
                      if not JobsConfig.isMenuOpen then
                        Menu.close()
                      else
                        Menu.clearMenu()
                        Menu.open()
                        Menu.setTitle("Marchandises")
                        Menu.setSubtitle("Quelle marchandise veux-tu mon brave ?")
                        showWarehouseItemButtons()
                      end
                    else
                      JobsConfig.jobsNotification.message = "<span class='red--text'>Vous pouvez prendre qu'un type de marchandise à la fois</span>"
                      Venato.notify(JobsConfig.jobsNotification)
                    end
                  end
                else
                  Venato.InteractTxt(TAKE_IN_BOX_MSG)
                end
              end
            end
          elseif DeliveryJobConfig.currentStep == 3 then
            Venato.InteractTxt(DELIVERY_MSG)
          end
        end
      end
    end
    if DeliveryJobConfig.ShopProOrNot and DeliveryJobConfig.isPro then
      local playerPos = GetEntityCoords(GetPlayerPed(-1))
      if playerPos.z <= -38 and playerPos.x >= 992.29 and playerPos.x <= 1027.76 and playerPos.y >= -3113.05 and playerPos .y <= -3090.70 then
        DeliveryJobConfig.inWarehouse = "Autre"
      elseif playerPos.z <= -38 and playerPos.x >= 1048.35 and playerPos.x <= 1073.10 and playerPos.y >= -3110.9 and playerPos .y <= -3094.4 then
        DeliveryJobConfig.inWarehouse = "Nourriture"
      elseif playerPos.z <= -38 and playerPos.x >= 1088.27 and playerPos.x <= 1105.1 and playerPos.y >= -3103.0 and playerPos .y <= -3095.5 then
        DeliveryJobConfig.inWarehouse = "Boisson"
      else
        DeliveryJobConfig.inWarehouse = nil
      end
      for k,v in pairs(DeliveryJobConfig.StockItems) do
        if GetDistanceBetweenCoords(playerPos, v.x, v.y, v.z, true) < 2 then
          Venato.InteractTxt(OPEN_ITEMS_MENU_ACTION_MSG)
          if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
              JobsConfig.isMenuOpen = not JobsConfig.isMenuOpen
              if not JobsConfig.isMenuOpen then
                Menu.close()
              else
                Menu.clearMenu()
                Menu.open()
                Menu.setTitle("Marchandises")
                Menu.setSubtitle("Quelle marchandise veux-tu mon brave ?")
                showWarehouseShopPro()
              end
          end
        end
      end



    end
  end
end

function DeliveryJob.checkLoop()
  local player = GetPlayerPed(-1)
  while true do
    Wait(1000)

    if JobsConfig.inService then
      if UserIsInService == false then
        UserIsInService = true
        UserTakingServiceLivery()
      end
      local playerPos = GetEntityCoords(GetPlayerPed(-1))
      local obj = GetClosestObjectOfType(playerPos.x, playerPos.y, playerPos.z,
        DeliveryJobConfig.inWarehouse and 1. or 2.0,
        GetHashKey(DeliveryJobConfig.BOX_KEY), false, true, true)
      local veh = GetClosestVehicle(playerPos.x, playerPos.y, playerPos.z, 10.0,
        GetHashKey(DeliveryJobConfig.TRUNK_KEY),
        127)
      if obj > 0 and obj == DeliveryJobConfig.box then
        local x1, y1, z1 = {}
        local x2, y2, z2 = {}
        if DeliveryJobConfig.boxOnTrunk then
          x1, y1, z1 = table.unpack(GetOffsetFromEntityInWorldCoords(obj, 0, 2.0, -0.6))
          x2, y2, z2 = table.unpack(GetOffsetFromEntityInWorldCoords(obj, 0, -2.7, -0.6))
        else
          x1, y1, z1 = table.unpack(GetOffsetFromEntityInWorldCoords(obj, 0, 2.0, -0.2))
          x2, y2, z2 = table.unpack(GetOffsetFromEntityInWorldCoords(obj, 0, -2.0, -0.2))
        end
        DeliveryJobConfig.boxCoord = { { x = x1, y = y1, z = z1 }, { x = x2, y = y2, z = z2 } }
        DeliveryJobConfig.globalBox = obj
      else
        DeliveryJobConfig.globalBox = nil
        DeliveryJobConfig.boxCoord = {}
      end
      if veh ~= 0 then
        local x3, y3, z3 = table.unpack(GetOffsetFromEntityInWorldCoords(veh, 0, -5.5, -1.5))
        DeliveryJobConfig.trunkCoord = { x = x3, y = y3, z = z3 }
        DeliveryJobConfig.globalTrunk = veh
      else
        DeliveryJobConfig.trunkCoord = {}
        DeliveryJobConfig.globalTrunk = nil
      end

      -- Manage warehouses content
      local playerPos = GetEntityCoords(player)
      if playerPos.z <= -38 and playerPos.x >= 992.29 and playerPos.x <= 1027.76 and playerPos.y >= -3113.05 and playerPos .y <= -3090.70 then
        showBigWarehouseBoxes()
        DeliveryJobConfig.inWarehouse = "Autre"
      elseif playerPos.z <= -38 and playerPos.x >= 1048.35 and playerPos.x <= 1073.10 and playerPos.y >= -3110.9 and playerPos .y <= -3094.4 then
        showMiddleWarehouseBoxes()
        DeliveryJobConfig.inWarehouse = "Nourriture"
      elseif playerPos.z <= -38 and playerPos.x >= 1088.27 and playerPos.x <= 1105.1 and playerPos.y >= -3103.0 and playerPos .y <= -3095.5 then
        showLittleWarehouseBoxes()
        DeliveryJobConfig.inWarehouse = "Boisson"
      else
        hideWarehouseBoxes()
        DeliveryJobConfig.inWarehouse = nil
      end

    else
      if UserIsInService == true then
        UserIsInService = false
        DeliveryJobConfig.currentStep = nil
        TriggerEvent("Venato:LoadClothes")
      end
    end

    manageBlip()

  end
end

function manageBlip()
  if DeliveryJobConfig.currentStep ~= nil then
    addSpawnForkliftBlip()
  else
    for i,v in ipairs(DeliveryJobConfig.trunkDrops.forklift) do
      if DeliveryJobConfig.blips["Forklift"] ~= nil then
        RemoveBlip(DeliveryJobConfig.blips["Forklift"][i])
        DeliveryJobConfig.blips["Forklift"][i] = nil
      end
    end
  end
  if DeliveryJobConfig.mission and DeliveryJobConfig.orderComplete and DeliveryJobConfig.currentStep == 3 then
    addDestinationBlip(DeliveryJobConfig.destination)
  elseif DeliveryJobConfig.mission then
    local destination = DeliveryJobConfig.destination
    RemoveBlip(DeliveryJobConfig.blips[destination.Name])
    DeliveryJobConfig.blips[destination.Name] = nil
  end
end

function addSpawnForkliftBlip()
  local name = "Forklift"
  for i,v in ipairs(DeliveryJobConfig.trunkDrops["forklift"]) do
    local index = i
    local point = {x=v.x,y=v.y,z=v.z}
    if not DeliveryJobConfig.blips[name] then
      local blip = JobTools.addBlip(point, name, 85, 2, false)
      if DeliveryJobConfig.blips[name] == nil then
        DeliveryJobConfig.blips[name] = {}
      end
      DeliveryJobConfig.blips[name][index] = blip
    end
  end
end

function addDestinationBlip(destination)
  local name = destination.Name
  if not DeliveryJobConfig.blips[name] then
    local blip = JobTools.addBlip(destination, name, 119, 17, true)
    DeliveryJobConfig.blips[name] = blip
  end
end

function spawnTrunk()
  local name = DeliveryJobConfig.TRUNK_KEY
  local coords = DeliveryJobConfig.trunkDrops.trunk
  if name ~= nil and name ~= '' and name ~= ' ' and IsModelValid(GetHashKey(string.upper(name))) ~= false then
    despawnTrunk()
    Venato.CreateVehicle(
      string.upper(name),
      { ["x"] = coords.x, ["y"] = coords.y, ["z"] = coords.z }, coords.heading,
      function(vehicle)
        DeliveryJobConfig.trunk = vehicle
        SetVehicleLivery(vehicle, 1)
        SetVehicleNumberPlateText(vehicle, "Trunk_" .. math.random(100, 999))
        SetPedIntoVehicle(GetPlayerPed(GetPlayerFromServerId(ClientSource)), vehicle, -1)
        TriggerEvent('lock:addVeh', GetVehicleNumberPlateText(vehicle),
          GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
      end)
  end
end

function spawnForklift(coords)
  local name = DeliveryJobConfig.FORKLIFT_KEY
  local coords = coords or DeliveryJobConfig.trunkDrops.forklift
  if name ~= nil and name ~= '' and name ~= ' ' and IsModelValid(GetHashKey(string.upper(name))) ~= false then
    despawnForklift()
    Venato.CreateVehicle(
      string.upper(name),
      { ["x"] = coords.x, ["y"] = coords.y, ["z"] = coords.z }, coords.heading,
      function(vehicle)
        DeliveryJobConfig.forklift = vehicle
        SetVehicleNumberPlateText(vehicle, "FORKLIFT")
      --  TriggerEvent('lock:addVeh', GetVehicleNumberPlateText(vehicle),
      --    GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
      end)
  end
end

function spawnBox()
  despawnBox()

  local coords = DeliveryJobConfig.trunkDrops.box

  local object = Venato.CreateObject(DeliveryJobConfig.BOX_KEY, coords.x, coords.y, coords.z)
  DeliveryJobConfig.AllObject[object] = object
  local box1 = Venato.CreateObject(DeliveryJobConfig.MINI_BOX_KEY, coords.x, coords.y, coords.z)
  DeliveryJobConfig.AllObject[box1] = box1
  SetEntityHeading(box1, 90.0)
  local box2 = Venato.CreateObject(DeliveryJobConfig.MINI_BOX_KEY, coords.x, coords.y, coords.z)
  DeliveryJobConfig.AllObject[box2] = box2
  SetEntityHeading(box2, 90.0)
  AttachEntityToEntity(box1, object, 0, -0.6, 0.0, -0.08, 0.0, 0.0, 90.0, false, false, false, false, 2, true)
  AttachEntityToEntity(box2, object, 0, 0.6, 0.0, -0.08, 0.0, 0.0, 90.0, false, false, false, false, 2, true)
  PlaceObjectOnGroundProperly(object)
  SetEntityHeading(object, coords.heading)
  SetEntityCoords(object, coords.x, coords.y, coords.z + 0.12, 0, 0, 0, true)
  FreezeEntityPosition(object, true)
  DeliveryJobConfig.box = object
end

function despawnTrunk()
  if DeliveryJobConfig.trunk ~= nil then
    Citizen.InvokeNative(0xAE3CBE5BF394C9C9, Citizen.PointerValueIntInitialized(DeliveryJobConfig.trunk))
    DeliveryJobConfig.trunk = nil
  end
end

function despawnForklift()
  if DeliveryJobConfig.forklift ~= nil then
    Citizen.InvokeNative(0xAE3CBE5BF394C9C9, Citizen.PointerValueIntInitialized(DeliveryJobConfig.forklift))
    DeliveryJobConfig.forklift = nil
  end
end

function despawnBox()
  if DeliveryJobConfig.box ~= nil then
    DeleteEntity(DeliveryJobConfig.box)
    DeliveryJobConfig.box = nil
  end
end

function takeBox(player)
  AttachEntityToEntity(DeliveryJobConfig.globalBox, GetVehiclePedIsIn(player, false), 3, 0.0, 1.0, -0.4, 0.0, 0, 0.0,
    false, false, false, false, 2, true)
  SetEntityCollision(DeliveryJobConfig.globalBox, false, true)
end

function loadOnTrunk()
  DetachEntity(DeliveryJobConfig.globalBox)
  AttachEntityToEntity(DeliveryJobConfig.globalBox, DeliveryJobConfig.trunk, nil, 0.0, -3.0, 0.12, 0.0, 0, 0.0,
    false, false, false, false, 2, true)
  SetEntityCollision(DeliveryJobConfig.globalBox, true, true)
end

function dropBoxInForklift(player)
  local coords = GetOffsetFromEntityInWorldCoords(player, 0, 2.0, 0)
  DetachEntity(DeliveryJobConfig.globalBox)
  PlaceObjectOnGroundProperly(DeliveryJobConfig.globalBox)
  coords = GetEntityCoords(DeliveryJobConfig.globalBox, 0)
  SetEntityCoords(DeliveryJobConfig.globalBox, coords["x"], coords["y"], coords["z"] + 0.12, 0, 0, 0, true)
  FreezeEntityPosition(DeliveryJobConfig.globalBox, true)
  SetEntityCollision(DeliveryJobConfig.globalBox, true, true)
end

function showBoxes(startX, startY, startZ,
                   deltaX, deltaY, deltaZ,
                   xCount, yCount, zCount,
                   heading)
  local surfaceCount = yCount * xCount
  local totalCount = surfaceCount * zCount

  for index = 0, totalCount, 1 do

    local zFix = 0.0
    if (index / surfaceCount) > 1.0 then
      zFix = ((index / surfaceCount) - 1) * .2
    end

    local x = startX + (index % surfaceCount) / yCount * deltaX
    local y = startY + (index % yCount) * deltaY
    local z = startZ + (index / surfaceCount) * deltaZ - zFix
    Citizen.CreateThread(function()
      local object = Venato.CreateObject(DeliveryJobConfig.BOX_KEY, x, y, z)
      --PlaceObjectOnGroundProperly(object)
      SetEntityHeading(object, heading)
      FreezeEntityPosition(object, true)
      SetEntityCoords(object, x, y, z, 0, 0, 0, true)
      table.insert(DeliveryJobConfig.boxes, object)
    end)
  end

end

function showBigWarehouseBoxes()
  if #DeliveryJobConfig.boxes > 0 then
    return
  end

  showBoxes(
    993.09, -3111.49, -39.9,
    0, 2.4, 2.2,
    1, 3, 4,
    90.0
  )
  showBoxes(
    1027.13, -3096.52, -39.9,
    7.15, 2.4, 2.2,
    1, 3, 4,
    90.0
  )
  showBoxes(
    1026.75, -3111.22, -39.9,
    0, 2.4, 2.2,
    1, 3, 4,
    90.0
  )

  showBoxes(
    1003.63, -3108.68, -39.9,
    2.4, 5.81, 2.2,
    7, 4, 4,
    180.0
  )
end

function showMiddleWarehouseBoxes()
  if #DeliveryJobConfig.boxes > 0 then
    return
  end

  showBoxes(
    1053.0, -3109.9, -39.9,
    2.4, 7.15, 2.2,
    7, 3, 2,
    180.0
  )
end

function showLittleWarehouseBoxes()
  if #DeliveryJobConfig.boxes > 0 then
    return
  end

  showBoxes(
    1088.74, -3096.6, -39.9,
    2.4, 7.15, 2.2,
    2, 1, 2,
    180.0
  )
  showBoxes(
    1095.20, -3096.6, -39.9,
    2.4, 7.15, 2.2,
    2, 1, 2,
    180.0
  )
  showBoxes(
    1101.21, -3096.6, -39.9,
    2.4, 7.15, 2.2,
    2, 1, 2,
    180.0
  )
end

function hideWarehouseBoxes()
  for _, box in pairs(DeliveryJobConfig.boxes) do
    DeleteEntity(box)
  end
  DeliveryJobConfig.boxes = {}
end

function showWarehouseItemButtons()
  for _, item in pairs(DeliveryJobConfig.warehouses[DeliveryJobConfig.inWarehouse]["items"]) do
    Menu.addButton2(item.libelle, "takeItem", item, '', item.Picture)
  end
  Menu.CreateMenu()
end

function showWarehouseShopPro()
  for _, item in pairs(DeliveryJobConfig.warehouses[DeliveryJobConfig.inWarehouse]["items"]) do
    Menu.addButton2(item.libelle.." Prix : "..item.price/2, "BuyItemsPro", item, '', item.Picture)
  end
  Menu.CreateMenu()
end

function BuyItemsPro(item)
  local nb = Venato.OpenKeyboard("", "", 10, "Combien voulez-vous de '" .. item.libelle .. "' ?")
  if tonumber(nb) ~= nil and tonumber(nb) >= 0 then
    TriggerServerEvent("Shops:TestBuyPro", item.id, tonumber(nb))
    Menu.close()
  else
    JobsConfig.jobsNotification.message = "<span class='red--text'>Une erreur dans le nombre saisi</span>"
    Venato.notify(JobsConfig.jobsNotification)
  end
end

function takeItem(item)
  local nb = Venato.OpenKeyboard("", "", 10, "Combien voulez-vous de '" .. item.libelle .. "' ?")
  if tonumber(nb) ~= nil and tonumber(nb) >= 0 then
    qty = DeliveryJobConfig.itemsTaken[item.id] or 0
    CreateBoxForitemsTaken(qty, item.libelle)
    qty = qty + tonumber(nb)
    DeliveryJobConfig.itemsTaken[item.id] = qty
    JobsConfig.jobsNotification.message = "<span class='green--text'>Vous avez maintenant " .. qty .. " " .. item.libelle .. "</span"
    Venato.notify(JobsConfig.jobsNotification)
    Menu.close()
  else
    JobsConfig.jobsNotification.message = "<span class='red--text'>Une erreur dans le nombre saisi</span>"
    Venato.notify(JobsConfig.jobsNotification)
  end
end

function CreateBoxForitemsTaken(qty, libelle)
  local pedCoords = GetEntityCoords(PlayerPedId())
  DeliveryJobConfig.carryBoxWithHand = true
	DeliveryJobConfig.handbox = Venato.CreateObject(DeliveryJobConfig.TAKENBOX_KEY, pedCoords.x, pedCoords.y, pedCoords.z)
  Venato.playAnim({lib = "anim@heists@box_carry@", anim = "idle", useLib = true, flag = 50})
  AttachEntityToEntity(DeliveryJobConfig.handbox , PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  28422), 0.00, -0.4, 0.0, 195.0, 180.0, 180.0, 180.0, false, false, true, false, 1, false)
end

function DropInTheBiggestBoxForitemsTaken()
  DeliveryJobConfig.carryBoxWithHand = false
  DetachEntity(DeliveryJobConfig.handbox)
  DeleteEntity(DeliveryJobConfig.handbox)
  DeliveryJobConfig.handbox = nil
  ClearPedTasksImmediately(PlayerPedId())
end

function putItemInTrunk(item)
  for id, qty in pairs(DeliveryJobConfig.itemsTaken) do
    _qty = DeliveryJobConfig.itemsTrunk[id] or 0
    _qty = _qty + qty
    DeliveryJobConfig.itemsTrunk[id] = _qty
  end
  DeliveryJobConfig.itemsTaken = {}
  DropInTheBiggestBoxForitemsTaken()
  JobsConfig.jobsNotification.message = "<span class='green--text'>Vous avez mis vos marchandises dans la caisse</span"
  Venato.notify(JobsConfig.jobsNotification)
end

function ValidateMission()
  TriggerServerEvent("DeliveryJob:finishMission",DeliveryJobConfig.mission.orderId,  DeliveryJobConfig.mission.shop ~= nil)
  DeliveryJobConfig.currentStep = 0
  DeliveryJobConfig.itemsTaken = {}
  DeliveryJobConfig.itemsTrunk = {}
  DeliveryJobConfig.mission = nil
  DeliveryJobConfig.order = nil
  DeliveryJobConfig.destination = nil
end

function printTxt(text, x, y, center, police)
  local center = center or false
  local police = police or 0.5
  SetTextFont(4)
  SetTextScale(0.0, police)
  SetTextCentre(center)
  SetTextDropShadow(0, 0, 0, 0, 0)
  SetTextEdge(0, 0, 0, 0, 0)
  SetTextColour(255, 255, 255, 255)
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x, y)
end

Citizen.CreateThread(function()
  local await = 1000
  while true do
    Citizen.Wait(await)
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local disA = Vdist(pos.x, pos.y, pos.z, DeliveryJobConfig.chosemission.x, DeliveryJobConfig.chosemission.y, DeliveryJobConfig.chosemission.z)
    local disB = Vdist(pos.x, pos.y, pos.z, DeliveryJobConfig.takebox.x, DeliveryJobConfig.takebox.y, DeliveryJobConfig.takebox.z)
    for k,v in pairs(DeliveryJobConfig.trunkDrops["forklift"]) do
      local disC = Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z)
      if disC < 20 then
        ClosetOfSpawnForkliftPoint = disC
        indexSpawnFroklift = k
        break
      else
        ClosetOfSpawnForkliftPoint = false
      end
    end

    if disA < 20 then
      ClosetOfMissionPoint = disA
    else
      ClosetOfMissionPoint = false
    end

    if disB < 20 then
      ClosetOfBoxSpawnPoint = disB
    else
      ClosetOfBoxSpawnPoint = false
    end

    if DeliveryJobConfig.carryBoxWithHand then
      Venato.playAnim({lib = "anim@heists@box_carry@", anim = "idle", useLib = true, flag = 50})
    end
  end
end)
