RegisterNetEvent("gcphone:callData")
AddEventHandler("gcphone:callData", function()
  TriggerClientEvent("gcphone:callData:cb", source, DataPlayers[tonumber(source)])
end)

RegisterNetEvent("ConsolePrint")
AddEventHandler("ConsolePrint", function(print)
  print(print)
end)

RegisterNetEvent("platypus:CallDataPlayerSpawn")
AddEventHandler("platypus:CallDataPlayerSpawn", function(PlayerId)
  local source = source
  DataPlayers[tonumber(source)].PlayerIdClient = PlayerId
  TriggerClientEvent("platypus:SpawnInit", source, DataPlayers, source)
end)

RegisterNetEvent("platypus:setService")
AddEventHandler("platypus:setService", function(job, bool)
  local source = source
  DataPlayers[tonumber(source)].IsInService = {job,bool}
end)
