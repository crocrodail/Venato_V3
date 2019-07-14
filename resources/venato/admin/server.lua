RegisterNetEvent("Admin:CallDataUsers")
AddEventHandler("Admin:CallDataUsers", function()
	local source = source
	TriggerClientEvent("Admin:CallDataUsers:cb", source, DataPlayers, source)
end)

RegisterNetEvent("AdminVnT:sendMsG")
AddEventHandler("AdminVnT:sendMsG", function(msg)
	TriggerClientEvent("Venato:notify", -1 , msg)
end)
