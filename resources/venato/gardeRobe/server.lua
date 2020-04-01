RegisterNetEvent("gardeRobe:test")
AddEventHandler("gardeRobe:test", function(arg)
  TriggerClientEvent("gardeRobe:test:cb", source, "tamer#######")
end)
