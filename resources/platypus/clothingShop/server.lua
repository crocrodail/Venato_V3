RegisterNetEvent("ClothingShop:CallData")
AddEventHandler("ClothingShop:CallData", function()
	local source = source
	TriggerClientEvent("ClothingShop:CallData:cb", source, DataPlayers[tonumber(source)])
end)

RegisterNetEvent("ClothingShop:SaveClothes")
AddEventHandler("ClothingShop:SaveClothes", function(clothes, price)
	local source = source
	local paymentCB = platypus.paymentCB(source, price)
	if paymentCB.status then
		DataPlayers[tonumber(source)].Clothes = clothes
		MySQL.Async.execute("UPDATE users SET clothes = @clothes WHERE identifier = @steamId", { ["@steamId"] = DataPlayers[tonumber(source)].SteamId, ["@clothes"] = json.encode(DataPlayers[tonumber(source)].Clothes) })
		TriggerClientEvent("ClothingShop:SaveClothes:response", source, {status = true})
	else
		TriggerClientEvent("ClothingShop:SaveClothes:response", source, {status = false, message = paymentCB.message})
	end
end)
