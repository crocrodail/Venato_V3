
RegisterNetEvent("Tattoo:Buy")
AddEventHandler("Tattoo:Buy", function(tattoo)
	local source = source
	local paymentCB = venato.paymentCB(source, tattoo.price)
    if paymentCB.status then
		table.insert(DataPlayers[tonumber(source)].Tattoos, tattoo)
        MySQL.Async.execute("INSERT INTO user_tattoos (identifier, tattoos) VALUES (@steamId,@tattooId)", { ["@steamId"] = DataPlayers[tonumber(source)].SteamId, ["@tattooId"] = tattoo.id }, function(result) 
           TriggerClientEvent("Tattoo:Buy:response", source, {status = true, tattoo})
        end)		
	else
		TriggerClientEvent("Tattoo:Buy:response", source, {status = false, message = paymentCB.message})
	end
end)
