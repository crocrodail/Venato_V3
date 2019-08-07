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
    while true do
      Wait(0)
      local playerPos = GetEntityCoords(GetPlayerPed(-1))
      local trunkDrops = DeliveryJobConfig.trunkDrops

      for _, dropPoint in ipairs(trunkDrops) do
        distance = GetDistanceBetweenCoords(playerPos, dropPoint.posX, dropPoint.posY, dropPoint.posZ, true)
        if distance < 20 then
          DrawMarker(27, dropPoint.posX, dropPoint.posY, dropPoint.posZ, 0, 0, 0, 0, 0, 0, 1.9, 1.9, 1.9, 0, 112, 168,
            174, 0, 0, 0, 0)
        end
        if distance < 1.5 then
          DeliveryJobConfig.onTrunkDrop = dropPoint
          TriggerEvent("Venato:InteractTxt", "Appuyez sur ~INPUT_CONTEXT~ pour récupérer ta camionnette")
        elseif DeliveryJobConfig.onTrunkDrop == dropPoint and distance > 1.5 then
          DeliveryJobConfig.onTrunkDrop = nil
        end
      end

      --TriggerEvent("Venato:InteractTxt", "Livraison en cours, veuillez vous rendre à destination ~BLIP_119~")

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
  if name ~= nil and name ~= '' and name ~= ' ' and IsModelValid(GetHashKey(string.upper(name))) ~= false then
    despawnTrunk()
    JobTools._CreateVehicle(
      string.upper(name),
      DeliveryJobConfig.onTrunkDrop.posX, DeliveryJobConfig.onTrunkDrop.posY, DeliveryJobConfig.onTrunkDrop.posZ,
      DeliveryJobConfig.onTrunkDrop.heading, function(vehicle)
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
  if name ~= nil and name ~= '' and name ~= ' ' and IsModelValid(GetHashKey(string.upper(name))) ~= false then
    despawnForklift()
    JobTools._CreateVehicle(
      string.upper(name),
      DeliveryJobConfig.onTrunkDrop.posX, DeliveryJobConfig.onTrunkDrop.posY, DeliveryJobConfig.onTrunkDrop.posZ,
      DeliveryJobConfig.onTrunkDrop.heading, function(vehicle)
        DeliveryJobConfig.forklift = vehicle
        SetVehicleNumberPlateText(vehicle, "DeliveryForklift_" .. math.random(100, 999))
        SetPedIntoVehicle(GetPlayerPed(GetPlayerFromServerId(ClientSource)), vehicle, -1)
        TriggerEvent('lock:addVeh', GetVehicleNumberPlateText(vehicle),
          GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
      end)
  end
end

function spawnBox()
  despawnBox()

  local coords = {
    ["x"] = DeliveryJobConfig.onTrunkDrop.posX,
    ["y"] = DeliveryJobConfig.onTrunkDrop.posY,
    ["z"] = DeliveryJobConfig.onTrunkDrop.posZ
  }

  local objet = Venato.CreateObject(DeliveryJobConfig.BOX_KEY, x or coords["x"], y or coords["y"], z or coords["z"])
  DeliveryJobConfig.AllObject[objet] = objet
  local bassin1 = Venato.CreateObject(DeliveryJobConfig.BASSIN_KEY, x or coords["x"], y or coords["y"],
    z or coords["z"])
  DeliveryJobConfig.AllObject[bassin1] = bassin1
  SetEntityHeading(bassin1, 90.0)
  local bassin2 = Venato.CreateObject(DeliveryJobConfig.BASSIN_KEY, x or coords["x"], y or coords["y"],
    z or coords["z"])
  DeliveryJobConfig.AllObject[bassin2] = bassin2
  SetEntityHeading(bassin2, 90.0)
  AttachEntityToEntity(bassin1, objet, 0, -0.6, 0.0, -0.08, 0.0, 0.0, 90.0, false, false, false, false, 2, true)
  AttachEntityToEntity(bassin2, objet, 0, 0.6, 0.0, -0.08, 0.0, 0.0, 90.0, false, false, false, false, 2, true)
  PlaceObjectOnGroundProperly(objet)
  coords = GetEntityCoords(objet, 0)
  SetEntityCoords(objet, coords["x"], coords["y"], coords["z"] + 0.12, 0, 0, 0, true)
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
    -- TODO: box management
    DeliveryJobConfig.box = nil
  end
end

function AttachOnCamion()
  DetachEntity(DeliveryJobConfig.box)
  AttachEntityToEntity(DeliveryJobConfig.box, DeliveryJobConfig.trunk, nil, 0.0, -3.0, 0.12, 0.0, 0, 0.0, false, false,
    false, false, 2, true)
  SetEntityCollision(DeliveryJobConfig.box, true, true)
end

function dropBoxInForklift()
  local coords = GetOffsetFromEntityInWorldCoords(Venato.GetPlayerPed(), 0, 2.0, 0)
  DetachEntity(DeliveryJobConfig.box)
  PlaceObjectOnGroundProperly(DeliveryJobConfig.box)
  coords = GetEntityCoords(DeliveryJobConfig.box, 0)
  SetEntityCoords(DeliveryJobConfig.box, coords["x"], coords["y"], coords["z"] + 0.12, 0, 0, 0, true)
  FreezeEntityPosition(DeliveryJobConfig.box, true)
  SetEntityCollision(DeliveryJobConfig.box, true, true)
end

function DetacheBoxInForklift()
  local coords = GetOffsetFromEntityInWorldCoords(Venato.GetPlayerPed(), 0, 2.0, 0)
  DetachEntity(DeliveryJobConfig.box)
  PlaceObjectOnGroundProperly(DeliveryJobConfig.box)
  coords = GetEntityCoords(DeliveryJobConfig.box, 0)
  SetEntityCoords(DeliveryJobConfig.box, coords["x"], coords["y"], coords["z"] + 0.12, 0, 0, 0, true)
  FreezeEntityPosition(DeliveryJobConfig.box, true)
  SetEntityCollision(DeliveryJobConfig.box, true, true)
end

-- TODO: See crocro branch and test.lua file to continue forklift, box, ... management
