LockedVehicle =  { ["LAMA"] = { ["plate"] = "LAMA" , ["locked"] = 2 } }
local id = 0



RegisterServerEvent("lock:lockveh")
AddEventHandler("lock:lockveh", function( plate )
  local LockedVehiclea = {}
  local plates = plate
  if LockedVehicle[plates] == nil then
    LockedVehiclea = { ["plate"] = plates, ["locked"] = 2 }
    LockedVehicle[plates] = LockedVehiclea
  else
    LockedVehicle[plates].locked = 2
  end
  TriggerClientEvent("lock:refresh", -1, LockedVehicle)
  LockedVehiclea = {}
end)


RegisterServerEvent("lock:unlockveh")
AddEventHandler("lock:unlockveh", function( plate )
  local LockedVehiclea = {}
  local plates = plate
  if LockedVehicle[plates] == nil then
    LockedVehiclea = { ["plate"] = plates, ["locked"] = 1 }
    LockedVehicle[""..plates] = LockedVehiclea
  else
    LockedVehicle[plates].locked = 1
  end
  TriggerClientEvent("lock:refresh", -1, LockedVehicle)
  LockedVehiclea = {}
end)

RegisterServerEvent("lock:synchr")
AddEventHandler("lock:synchr", function()
  local source = source
  TriggerClientEvent("lock:refresh", source, LockedVehicle)
end)
