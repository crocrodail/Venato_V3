JobTools = {}
function JobTools._CreateVehicle(modelName, coordX, coordY, coordZ, heading, cb)
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


function JobTools.addBlip(position, name, blipId, blipColor, drawRoute)
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
