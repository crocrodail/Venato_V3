RegisterNetEvent("Admin:CallDataUsers")
AddEventHandler("Admin:CallDataUsers", function()
	local source = source
	TriggerClientEvent("Admin:CallDataUsers:cb", source, DataPlayers, source)
end)

RegisterNetEvent("AdminVnT:sendMsG")
AddEventHandler("AdminVnT:sendMsG", function(msg)
	TriggerClientEvent("Venato:notify", -1 , msg)
end)

RegisterNetEvent("Admin:ActionOnPlayer")
AddEventHandler("Admin:ActionOnPlayer", function(action, target, msg)
	local source = source
	if action == "kick" then
		DropPlayer(target, "Vous avez été kick : "..msg)
	else
		DropPlayer(target, "Vous avez été ban : "..msg)
		MySQL.Async.execute("INSER INTO ban (`banned`, `banner`, `reason`, `ip`) VALUES (@banned, @banner, @reason, @ip)", {["@banned"] = DataPlayers[target].SteamId, ["@banner"] = DataPlayers[source].SteamId, ["@reason"] = msg, ["@ip"] = DataPlayers[target].Ip})
	end
end)
