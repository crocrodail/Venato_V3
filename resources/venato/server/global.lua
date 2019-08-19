RegisterNetEvent("gcphone:callData")
AddEventHandler("gcphone:callData", function()
  TriggerClientEvent("gcphone:callData:cb", source, DataPlayers[source])
end)

RegisterNetEvent("ConsolePrint")
AddEventHandler("ConsolePrint", function(print)
  print(print)
end)

RegisterNetEvent("Venato:CallDataPlayerSpawn")
AddEventHandler("Venato:CallDataPlayerSpawn", function(PlayerId)
  local source = source
  DataPlayers[source].PlayerIdClient = PlayerId
  TriggerClientEvent("Venato:SpawnInit", source, DataPlayers, source)
end)
