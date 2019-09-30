RegisterNetEvent("gcphone:callData")
AddEventHandler("gcphone:callData", function()
  TriggerClientEvent("gcphone:callData:cb", source, DataPlayers[tonumber(source)])
end)

RegisterNetEvent("ConsolePrint")
AddEventHandler("ConsolePrint", function(print)
  print(print)
end)

RegisterNetEvent("Venato:CallDataPlayerSpawn")
AddEventHandler("Venato:CallDataPlayerSpawn", function(PlayerId)
  local source = source
  DataPlayers[tonumber(source)].PlayerIdClient = PlayerId
  TriggerClientEvent("Venato:SpawnInit", source, DataPlayers, source)
end)

RegisterNetEvent("venato:setService")
AddEventHandler("venato:setService", function(job, bool)
  local source = source
  DataPlayers[tonumber(source)].IsInService = {job,bool}
end)
