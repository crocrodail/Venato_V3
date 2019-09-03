--[[
  Client entry point for delivery job

  @author Astymeus
  @date 2019-07-24
  @version 1.0
--]]
DeliveryJob = {}

-- ACTIONS message
local TAKE_TRUNK_ACTION_MSG = "Appuyez sur ~INPUT_CONTEXT~ pour récupérer ta camionnette"
local LOAD_BOXE_IN_TRUNK_ACTION_MSG = "Appuyez sur la touche ~INPUT_CONTEXT~ pour charger la caisse."
local PUT_BOX_ON_GROUND_ACTION_MSG = "Appuyez sur la touche ~INPUT_CONTEXT~ pour poser par terre."
local PUT_BOX_ON_TRUNK_ACTION_MSG = "Appuyez sur la touche ~INPUT_CONTEXT~ pour la mettre dans le camion."
local OPEN_ITEMS_MENU_ACTION_MSG = "Appuyez sur la touche ~INPUT_CONTEXT~ pour récupérer des marchandises."
local PUT_ITEMS_IN_BOX_ACTION_MSG = "Appuyez sur la touche ~INPUT_CONTEXT~ pour mettre vos marchandises dans la caisse"
local GET_FORKLIFT_ACTION_MSG = "Appuyez sur la touche ~INPUT_CONTEXT~ pour récupérer un forklift"

-- OTHERS message
local LOAD_TRUNK_MSG = "Veuillez charger le camion avec la caisse pour commencer."
local LOAD_BOX_MSG = "Veuillez remplir la caisse avec les marchandises dans les entrepots ~BLIP_478~"
local TAKE_IN_BOX_MSG = "Veuillez prendre les items dans les caisses"
local DELIVERY_MSG = "veuillez livrer votre chargement à destination ~BLIP_119~"

function DeliveryJob.isEnabled()
  return DeliveryJobConfig.enabled
end

function DeliveryJob.getServiceLocation()
  return DeliveryJobConfig.serviceLocation
end

function DeliveryJob.init()
  if DeliveryJob.isEnabled() then
    TriggerServerEvent("DeliveryJob:getWarehouses")
  end
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
  TriggerServerEvent("DeliveryJob:TakeMission")
end

function abortMission()
  DeliveryJobConfig.currentStep = nil
  DeliveryJobConfig.itemsTaken = {}
  DeliveryJobConfig.itemsTrunk = {}
  DeliveryJobConfig.mission = nil
  DeliveryJobConfig.order = nil
  DeliveryJobConfig.destination = nil

  Menu.close()
  JobsConfig.isMenuOpen = false
end

function DeliveryJob.showMenu()
  if DeliveryJobConfig.currentStep == nil then
    Menu.addButton("Effectuer la livraison", "takeMission")
  else
    Menu.addButton("Abandonner la livraison", "abortMission")
  end
end

function DeliveryJob.mainLoop()
  if DeliveryJob.isEnabled() then
    local player = GetPlayerPed(-1)
    local dropPoint = DeliveryJobConfig.trunkDrops['box']
    
    while true do
      Wait(0)

      interactTxt = false

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
            if distance < 0.5 and GetEntityModel(GetVehiclePedIsIn(player,
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
              if DeliveryJobConfig.currentStep == 1 then
                DeliveryJobConfig.currentStep = 2
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
          elseif DeliveryJobConfig.currentStep == 2 then
            if not DeliveryJobConfig.inWarehouse then
              if DeliveryJobConfig.globalBox ~= nil and next(DeliveryJobConfig.itemsTaken) ~= nil then
                Venato.InteractTxt(PUT_ITEMS_IN_BOX_ACTION_MSG)
                if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
                  putItemInTrunk()
                end
              else
                Venato.InteractTxt(LOAD_BOX_MSG)
              end
            else
              if DeliveryJobConfig.globalBox ~= nil then
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
                    showWarehouseItemButtons()
                  end
                end
              else
                Venato.InteractTxt(TAKE_IN_BOX_MSG)
              end
            end
          elseif DeliveryJobConfig.currentStep == 3 then
            Venato.InteractTxt(DELIVERY_MSG)
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
      local playerPos = GetEntityCoords(GetPlayerPed(-1))
      local obj = GetClosestObjectOfType(playerPos.x, playerPos.y, playerPos.z,
        DeliveryJobConfig.inWarehouse and 1. or 4.0,
        GetHashKey(DeliveryJobConfig.BOX_KEY), false, true, true)
      local veh = GetClosestVehicle(playerPos.x, playerPos.y, playerPos.z, 10.0,
        GetHashKey(DeliveryJobConfig.TRUNK_KEY),
        127)
      if obj > 0 then
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

    end

    manageBlip()

  end
end

function manageBlip()
  local warehouses = DeliveryJobConfig.warehouses

  if DeliveryJobConfig.currentStep == 2 then
    for warehouseName, warehouse in pairs(warehouses) do
      if DeliveryJobConfig.blips[warehouseName] then
        TriggerEvent("Teleport:SetTeleport",
          warehouseName,
          warehouse
        )
      end
      addWarehousesBlip(warehouseName, warehouse.positionFrom)
    end
  else
    for warehouseName, warehouse in pairs(warehouses) do
      TriggerEvent("Teleport:RemoveTeleport", warehouseName)
      RemoveBlip(DeliveryJobConfig.blips[warehouseName])
      DeliveryJobConfig.blips[warehouseName] = nil
    end
  end

  if DeliveryJobConfig.currentStep ~= nil then
    addTrunkDropsBlip(DeliveryJobConfig.trunkDrops['box'])
  else
    RemoveBlip(DeliveryJobConfig.blips["Camionnette"])
    DeliveryJobConfig.blips["Camionnette"] = nil
  end

  if DeliveryJobConfig.mission and DeliveryJobConfig.orderComplete and DeliveryJobConfig.currentStep == 3 then
    addDestinationBlip(DeliveryJobConfig.destination)
  elseif DeliveryJobConfig.mission then
    local destination = DeliveryJobConfig.destination
    RemoveBlip(DeliveryJobConfig.blips[destination.Name])
    DeliveryJobConfig.blips[destination.Name] = nil
  end
end

function addTrunkDropsBlip(point)
  local name = "Camionnette"
  if not DeliveryJobConfig.blips[name] then
    local blip = JobTools.addBlip(point, name, 85, 2, false)
    DeliveryJobConfig.blips[name] = blip
  end
end

function addWarehousesBlip(name, point)
  if not DeliveryJobConfig.blips[name] then
    local blip = JobTools.addBlip(point,"Entrepot "..name, 408, 2, false)
    DeliveryJobConfig.blips[name] = blip
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
        SetVehicleNumberPlateText(vehicle, "DeliveryForklift_" .. math.random(100, 999))
        TriggerEvent('lock:addVeh', GetVehicleNumberPlateText(vehicle),
          GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
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

    local object = Venato.CreateObject(DeliveryJobConfig.BOX_KEY, x, y, z)
    --PlaceObjectOnGroundProperly(object)
    SetEntityHeading(object, heading)
    FreezeEntityPosition(object, true)
    SetEntityCoords(object, x, y, z, 0, 0, 0, true)
    table.insert(DeliveryJobConfig.boxes, object)
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

function takeItem(item)
  local nb = Venato.OpenKeyboard("", "", 10, "Combien voulez-vous de '" .. item.libelle .. "' ?")
  if tonumber(nb) ~= nil and tonumber(nb) >= 0 then
    qty = DeliveryJobConfig.itemsTaken[item.id] or 0
    qty = qty + tonumber(nb)
    DeliveryJobConfig.itemsTaken[item.id] = qty
    JobsConfig.jobsNotification.message = "<span class='green--text'>Vous avez maintenant " .. qty .. " " .. item .libelle .. "</span"
    Venato.notify(JobsConfig.jobsNotification)
  else
    JobsConfig.jobsNotification.message = "<span class='red--text'>Une erreur dans le nombre saisi</span>"
    Venato.notify(JobsConfig.jobsNotification)
  end
end

function putItemInTrunk(item)
  for id, qty in pairs(DeliveryJobConfig.itemsTaken) do
    _qty = DeliveryJobConfig.itemsTrunk[id] or 0
    _qty = _qty + qty
    DeliveryJobConfig.itemsTrunk[id] = _qty
  end
  DeliveryJobConfig.itemsTaken = {}
  JobsConfig.jobsNotification.message = "<span class='green--text'>Vous avez mis vos marchandises dans le camion</span"
  Venato.notify(JobsConfig.jobsNotification)
end

function ValidateMission()
  DeliveryJobConfig.currentStep = nil
  DeliveryJobConfig.itemsTaken = {}
  DeliveryJobConfig.itemsTrunk = {}
  DeliveryJobConfig.mission = nil
  DeliveryJobConfig.order = nil
  DeliveryJobConfig.destination = nil

  TriggerServerEvent("DeliveryJob:finishMission")
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
