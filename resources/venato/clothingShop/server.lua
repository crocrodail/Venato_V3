RegisterNetEvent("ClothingShop:CallData")
AddEventHandler("ClothingShop:CallData", function()
	local source = source
	TriggerClientEvent("ClothingShop:CallData:cb", source, DataPlayers[source])
end)

RegisterNetEvent("ClothingShop:SaveClothes")
AddEventHandler("ClothingShop:SaveClothes", function(clothes, price)
	local source = source
	if Venato.paymentCB(source, price) then
		DataPlayers[source].Clothes = clothes
		MySQL.Async.execute("UPDATE users SET clothes = @clothes WHERE identifier = @steamId", { ["@steamId"] = DataPlayers[source].SteamId, ["@clothes"] = json.encode(DataPlayers[source].Clothes) })
		TriggerClientEvent("ClothingShop:SaveClothes:response", source, true)
	else
		TriggerClientEvent("ClothingShop:SaveClothes:response", source, false)
	end
end)
