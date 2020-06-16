RegisterNetEvent("gcphone:callData")
AddEventHandler("gcphone:callData", function()
  TriggerClientEvent("gcphone:callData:cb", source, DataPlayers[tonumber(source)])
end)

RegisterNetEvent("ConsolePrint")
AddEventHandler("ConsolePrint", function(print)
  print(print)
end)

RegisterNetEvent("venato:CallDataPlayerSpawn")
AddEventHandler("venato:CallDataPlayerSpawn", function(PlayerId)
  local source = source
  DataPlayers[tonumber(source)].PlayerIdClient = PlayerId
  TriggerClientEvent("venato:SpawnInit", source, DataPlayers, source)
end)

RegisterNetEvent("venato:setService")
AddEventHandler("venato:setService", function(job, bool)
  local source = source
  DataPlayers[tonumber(source)].IsInService = {job,bool}
end)

RegisterNetEvent("venato:GetDataPlayer")
AddEventHandler("venato:GetDataPlayer", function()
  if DataPlayers ~= nil or DataPlayers[tonumber(source)] ~= nil then
    TriggerClientEvent("venato:GetDataPlayer:cb", source, DataPlayers[source])
  end
end)
