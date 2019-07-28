RegisterNetEvent("gcphone:callData")
AddEventHandler("gcphone:callData", function()
  TriggerClientEvent("gcphone:callData:cb", source, DataPlayers[source])
end)

RegisterNetEvent("ConsolePrint")
AddEventHandler("ConsolePrint", function(print)
  print(tostring(print))
end)
