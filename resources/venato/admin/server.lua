RegisterNetEvent("Admin:CallDataUsers")
AddEventHandler("Admin:CallDataUsers", function()
	TriggerClientEvent("Admin:CallDataUsers:cb", source, DataPlayers)
end)
