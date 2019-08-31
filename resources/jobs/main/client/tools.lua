--[[
  Client entry point for job tools

  @author Astymeus
  @date 2019-08-06
  @version 1.0
--]]
JobTools = {}

-- Wrapper for button actions
--RegisterNetEvent("Menu:Execute")
--AddEventHandler("Menu:Execute", function(params)
--  _ = _G[params.fn] and _G[params.fn](params.args)
--end)

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
  print(name .. " - x : " .. (position.x or position.posX))
  print(name .. " - y : " .. (position.y or position.posY))
  print(name .. " - z : " .. (position.z or position.posZ))
  local blip = AddBlipForCoord(position.x or position.posX, position.y or position.posY, position.z or position.posZ)
  SetBlipSprite(blip, blipId)
  SetBlipColour(blip, blipColor)
  SetBlipScale(blip, 1.0)
  SetBlipAsShortRange(blip, not drawRoute)
  SetBlipRoute(blip, drawRoute)
  if drawRoute then SetBlipRouteColour(blip, 17) end

  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString(name)
  EndTextCommandSetBlipName(blip)
  return blip
end

local scaleform = nil
function JobTools.RequestDeathScaleform()
  scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")
  while not HasScaleformMovieLoaded(scaleform) do
    Wait(0)
  end

  return scaleform
end

local deathscale = nil
local locksound = false

function JobTools.showServiceMessage(jobName, isInService)
  if not locksound then
    deathscale = JobTools.RequestDeathScaleform()
    locksound = true
  end

  PushScaleformMovieFunction(deathscale, "SHOW_CENTERED_MP_MESSAGE")
  PushScaleformMovieFunctionParameterString(jobName)
  if isInService then
    PushScaleformMovieFunctionParameterString("Vous entrez en service")
  else
    PushScaleformMovieFunctionParameterString("Vous quittez le service")
  end

  PushScaleformMovieFunctionParameterFloat(105.0)
  PushScaleformMovieFunctionParameterBool(true)
  PopScaleformMovieFunctionVoid()

  SetScreenDrawPosition(0.00, 0.00)
  DrawScaleformMovieFullscreen(deathscale, 255, 255, 255, 255, 0)
  return deathscale
end

function JobTools.hideServiceMessage()
  locksound = false
  SetScaleformMovieAsNoLongerNeeded(deathscale)
end
