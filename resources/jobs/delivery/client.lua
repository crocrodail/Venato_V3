--[[
  Client entry point for delivery job

  @author Astymeus
  @date 2019-07-24
  @version 1.0
--]]
DeliveryJob = {}
function DeliveryJob.init()
  CreateThread(function()
    if DeliveryJobConfig.enabled then


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
  end)
end

function DeliveryJob.commands()
  if IsControlJustReleased(1, Keys["INPUT_CONTEXT"]) and DeliveryJobConfig.onTrunkDrop ~= nil then
    if IsPedInVehicle(GetPlayerPed(-1), DeliveryJobConfig.trunk) then
      despawnTrunk()
    else
      spawnTrunk()
    end
  end
end

function DeliveryJob.mainLoop()
  CreateThread(function()
    if DeliveryJobConfig.enabled then
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
  end)
end

function addTrunkDropsBlip(point)
  addBlip(point, "camionnette", 85, 12, false)
end

function addDestinationBlip(destination)
  addBlip(destination, destination.name, 119, 17, true)
end

function addBlip(position, name, blipId, blipColor, drawRoute)
  local blip = AddBlipForCoord(position.posX, position.posY, position.posZ)
  SetBlipSprite(blip, blipId)
  SetBlipColour(blip, blipColor)
  SetBlipScale(blip, 1.0)
  SetBlipAsShortRange(blip, not drawRoute)
  SetBlipRoute(blip, drawRoute)
  if drawRoute then SetBlipRouteColour(blip, 17) end

  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString(name)
  EndTextCommandSetBlipName(blip)
end

function spawnTrunk()
  local name = "mule"
  if name ~= nil and name ~= '' and name ~= ' ' and IsModelValid(GetHashKey(string.upper(name))) ~= false then
    despawnTrunk()
    _CreateVehicle(
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

function despawnTrunk()
  if DeliveryJobConfig.trunk ~= nil then
    Citizen.InvokeNative(0xAE3CBE5BF394C9C9, Citizen.PointerValueIntInitialized(DeliveryJobConfig.trunk))
  end
end

function _CreateVehicle(modelName, coordX, coordY, coordZ, heading, cb)
  local model = modelName
  if tonumber(modelName) == nil then
    model = GetHashKey(modelName)
  end
  CreateThread(function()
    if not HasModelLoaded(model) then
      RequestModel(model)
      while not HasModelLoaded(model) do
        Wait(1)
      end
    end
    local vehicle = CreateVehicle(model, coordX, coordY, coordZ, heading, true, false)
    local id = NetworkGetNetworkIdFromEntity(vehicle)
    SetNetworkIdCanMigrate(id, true)
    SetEntityAsMissionEntity(vehicle, true, false)
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetVehicleNeedsToBeHotwired(vehicle, false)
    SetModelAsNoLongerNeeded(model)
    RequestCollisionAtCoord(coordX, coordY, coordZ)
    while not HasCollisionLoadedAroundEntity(vehicle) do
      RequestCollisionAtCoord(coordX, coordY, coordZ)
      Wait(0)
    end
    SetVehRadioStation(vehicle, 'OFF')
    if cb ~= nil then
      cb(vehicle)
    end
  end)
end

