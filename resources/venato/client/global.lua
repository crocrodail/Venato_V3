DataUser = {}

AddEventHandler('playerSpawned', function()
  SetTimeout(5000, function() TriggerServerEvent("Venato:CallDataPlayerSpawn") end)
end)

Citizen.CreateThread(function()
    TriggerServerEvent("Venato:SyncData")
end)

RegisterNetEvent("Venato:displaytext")
AddEventHandler("Venato:displaytext", function(text, time)
  ClearPrints()
  SetTextEntry_2("STRING")
  AddTextComponentString(text)
  DrawSubtitleTimed(time, 1)
end)

RegisterNetEvent("Venato:Connection")
AddEventHandler("Venato:Connection", function()
  LifeInit()
end)

RegisterNetEvent("Venato:SpawnInit")
AddEventHandler("Venato:SpawnInit", function(DataPlayers, source)
  if DataPlayers[source] ~= nil then
    LoadBlips()
    Venato.LoadClothes()
    Venato.LoadSkin(DataPlayers[source])
  end
end)
