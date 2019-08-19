--[[
  Client entry point for delivery job

  @author Astymeus
  @date 2019-07-24
  @version 1.0
--]]
DeliveryJob = {}

function DeliveryJob.isEnabled()
  return DeliveryJobConfig.enabled
end

function DeliveryJob.getServiceLocation()
  return DeliveryJobConfig.serviceLocation
end

function DeliveryJob.init()
  if DeliveryJob.isEnabled() then


    local defaultDestinations = DeliveryJobConfig.defaultDropLocations
    local defaultOrders = DeliveryJobConfig.defaultOrders
    local trunkDrops = DeliveryJobConfig.trunkDrops
    local warehouses = DeliveryJobConfig.warehouses

    local mission = DeliveryJobConfig.defaultMissions[1]

    local teleportAction = "Teleport:SetTeleport"
    --if not JobsConfig.inService then
    --  teleportAction = "Teleport:RemoveTeleport"
    --end
    for warehouseName, warehouse in pairs(warehouses) do
      TriggerEvent(teleportAction,
        warehouseName,
        warehouse
      )
    end

    for _, dropPoint in ipairs(trunkDrops) do
      addTrunkDropsBlip(dropPoint)
    end

    if mission then
      local destination = defaultDestinations[mission.targetId]
      local order = defaultOrders[mission.orderId]
      addDestinationBlip(destination)
    end
  end
end

function DeliveryJob.commands()
  if IsControlJustReleased(1, Keys["INPUT_CONTEXT"]) and DeliveryJobConfig.onTrunkDrop ~= nil then
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

function takeMission(mission)
  print('Mission taken !' .. mission)
  TriggerServerEvent("Venato:dump", { "Mission taken !", mission })
  DeliveryJobConfig.isInMission = true
  JobsConfig.isMenuOpen = false
end

function DeliveryJob.showMenu()
  if not DeliveryJobConfig.isInMission then
    TriggerEvent('Menu:AddButton', "Effectuer la livraison", "takeMission", "toto")
  end
end

function DeliveryJob.mainLoop()
  if DeliveryJob.isEnabled() then
    local player = GetPlayerPed(-1)
    while true do
      Wait(0)

      local playerPos = GetEntityCoords(player)
      local dropPoint = DeliveryJobConfig.trunkDrops['trunk']

      distance = GetDistanceBetweenCoords(playerPos, dropPoint.x, dropPoint.y, dropPoint.z, true)

      if distance < 20 then
        DrawMarker(27, dropPoint.x, dropPoint.y, dropPoint.z, 0, 0, 0, 0, 0, 0, 1.9, 1.9, 1.9, 0, 112, 168,
          174, 0, 0, 0, 0)
      end
      if distance < 1.5 then
        DeliveryJobConfig.onTrunkDrop = dropPoint
        TriggerEvent("Venato:InteractTxt", "Appuyez sur ~INPUT_CONTEXT~ pour récupérer ta camionnette")
      elseif DeliveryJobConfig.onTrunkDrop == dropPoint and distance > 1.5 then
        DeliveryJobConfig.onTrunkDrop = nil
      end

      if DeliveryJobConfig.boxCoord ~= {} and (not DeliveryJobConfig.boxOnForklift or DeliveryJobConfig.boxOnTrunk) then
        for i, v in ipairs(DeliveryJobConfig.boxCoord) do
          local distance = GetDistanceBetweenCoords(v.x, v.y, v.z, playerPos["x"], playerPos["y"], playerPos["z"], true)
          if distance < 0.5 and GetEntityModel(GetVehiclePedIsIn(player, false)) == GetHashKey("FORKLIFT") then
            TriggerEvent("Venato:InteractTxt", "Appuyez sur la touche ~INPUT_CONTEXT~ pour charger la caisse.")
            if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
              takeBox(player)
              DeliveryJobConfig.boxOnForklift = true
              DeliveryJobConfig.boxOnTrunk = false
            end
          end
        end
      elseif DeliveryJobConfig.boxOnForklift and DeliveryJobConfig.globalTrunk == nil then
        for i, v in ipairs(DeliveryJobConfig.boxCoord) do
          local distance = GetDistanceBetweenCoords(v.x, v.y, v.z + 0.9,
            playerPos["x"], playerPos["y"], playerPos["z"],
            true)
          if distance < 0.5 and GetEntityModel(GetVehiclePedIsIn(player, false)) == GetHashKey("FORKLIFT") then
            TriggerEvent("Venato:InteractTxt", "Appuyez sur la touche ~INPUT_CONTEXT~ pour poser par terre.")
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
        if distance < 0.5 and GetEntityModel(GetVehiclePedIsIn(player, false)) == GetHashKey("FORKLIFT") then
          TriggerEvent("Venato:InteractTxt", "Appuyez sur la touche ~INPUT_CONTEXT~ pour la mettre dans le camion.")
          if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
            loadOnTrunk()
            DeliveryJobConfig.boxOnForklift = false
            DeliveryJobConfig.boxOnTrunk = true
          end
        end
      end
      --TriggerEvent("Venato:InteractTxt", "Livraison en cours, veuillez vous rendre à destination ~BLIP_119~")

    end
  end
end

function DeliveryJob.checkLoop()
  local player = GetPlayerPed(-1)
  while true do
    Citizen.Wait(1000)

    local playerPos = GetEntityCoords(player)
    local obj = GetClosestObjectOfType(playerPos.x, playerPos.y, playerPos.z, 10.0,
      GetHashKey(DeliveryJobConfig.BOX_KEY), false, true, true)
    local veh = GetClosestVehicle(playerPos.x, playerPos.y, playerPos.z, 10.0, GetHashKey(DeliveryJobConfig.TRUNK_KEY),
      127)
    if obj then
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
    --else
    --  DeliveryJobConfig.globalBox = nil
    --  DeliveryJobConfig.boxCoord = {}
    end
    if veh ~= 0 then
      local x3, y3, z3 = table.unpack(GetOffsetFromEntityInWorldCoords(veh, 0, -5.5, -1.5))
      DeliveryJobConfig.trunkCoord = { x = x3, y = y3, z = z3 }
      DeliveryJobConfig.globalTrunk = veh
    else
      DeliveryJobConfig.trunkCoord = {}
      DeliveryJobConfig.globalTrunk = nil
    end
  end
end

function addTrunkDropsBlip(point)
  JobTools.addBlip(point, "camionnette", 85, 12, false)
end

function addDestinationBlip(destination)
  JobTools.addBlip(destination, destination.name, 119, 17, true)
end

function spawnTrunk()
  local name = DeliveryJobConfig.TRUNK_KEY
  local coords = DeliveryJobConfig.trunkDrops.trunk
  if name ~= nil and name ~= '' and name ~= ' ' and IsModelValid(GetHashKey(string.upper(name))) ~= false then
    despawnTrunk()
    JobTools._CreateVehicle(
      string.upper(name),
      coords.x, coords.y, coords.z, coords.heading,
      function(vehicle)
        DeliveryJobConfig.trunk = vehicle
        SetVehicleNumberPlateText(vehicle, "Trunk_" .. math.random(100, 999))
        SetPedIntoVehicle(GetPlayerPed(GetPlayerFromServerId(ClientSource)), vehicle, -1)
        TriggerEvent('lock:addVeh', GetVehicleNumberPlateText(vehicle),
          GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
      end)
  end
end

function spawnForklift()
  local name = DeliveryJobConfig.FORKLIFT_KEY
  local coords = DeliveryJobConfig.trunkDrops.forklift
  if name ~= nil and name ~= '' and name ~= ' ' and IsModelValid(GetHashKey(string.upper(name))) ~= false then
    despawnForklift()
    JobTools._CreateVehicle(
      string.upper(name),
      coords.x, coords.y, coords.z, coords.heading,
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

  local objet = JobTools.CreateObject(DeliveryJobConfig.BOX_KEY, coords.x, coords.y, coords.z)
  DeliveryJobConfig.AllObject[objet] = objet
  local bassin1 = JobTools.CreateObject(DeliveryJobConfig.BASSIN_KEY, coords.x, coords.y, coords.z)
  DeliveryJobConfig.AllObject[bassin1] = bassin1
  SetEntityHeading(bassin1, 90.0)
  local bassin2 = JobTools.CreateObject(DeliveryJobConfig.BASSIN_KEY, coords.x, coords.y, coords.z)
  DeliveryJobConfig.AllObject[bassin2] = bassin2
  SetEntityHeading(bassin2, 90.0)
  AttachEntityToEntity(bassin1, objet, 0, -0.6, 0.0, -0.08, 0.0, 0.0, 90.0, false, false, false, false, 2, true)
  AttachEntityToEntity(bassin2, objet, 0, 0.6, 0.0, -0.08, 0.0, 0.0, 90.0, false, false, false, false, 2, true)
  PlaceObjectOnGroundProperly(objet)
  SetEntityHeading(objet, coords.heading)
  SetEntityCoords(objet, coords.x, coords.y, coords.z + 0.12, 0, 0, 0, true)
  FreezeEntityPosition(objet, true)

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
  DetachEntity(DeliveryJobConfig.box)
  AttachEntityToEntity(DeliveryJobConfig.box, DeliveryJobConfig.trunk, nil, 0.0, -3.0, 0.12, 0.0, 0, 0.0, false, false,
    false, false, 2, true)
  SetEntityCollision(DeliveryJobConfig.box, true, true)
end

function dropBoxInForklift(player)
  local coords = GetOffsetFromEntityInWorldCoords(player, 0, 2.0, 0)
  DetachEntity(DeliveryJobConfig.box)
  PlaceObjectOnGroundProperly(DeliveryJobConfig.box)
  coords = GetEntityCoords(DeliveryJobConfig.box, 0)
  SetEntityCoords(DeliveryJobConfig.box, coords["x"], coords["y"], coords["z"] + 0.12, 0, 0, 0, true)
  FreezeEntityPosition(DeliveryJobConfig.box, true)
  SetEntityCollision(DeliveryJobConfig.box, true, true)
end


-- TODO: See crocro branch and test.lua file to continue forklift, box, ... management
