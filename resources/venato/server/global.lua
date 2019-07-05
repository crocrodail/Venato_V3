RegisterNetEvent("gcphone:callData")
AddEventHandler("gcphone:callData", function()
  TriggerClientEvent("gcphone:callData:cb", source, DataPlayers[source])
end)
