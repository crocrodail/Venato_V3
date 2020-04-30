RegisterNetEvent("gardeRobe:saveClothes")
AddEventHandler("gardeRobe:saveClothes", function(arg)
	local source = source
	local name = arg[1]
	local clothes = arg[2]
	MySQL.Async.execute("INSERT INTO user_garderobe (identifier, name, clothes) VALUES (@identifier, @name, @clothes)", {["@identifier"] = DataPlayers[source].SteamId, ["@name"] = name, ["@clothes"] = json.encode(DataPlayers[source].Clothes)}, function()
		MySQL.Async.fetchScalar("SELECT Id FROM user_garderobe WHERE clothes = @clothes", {["@clothes"] = json.encode(DataPlayers[source].Clothes)}, function(result)
			if result ~= nil then
				MySQL.Async.execute("UPDATE users SET clothes=@clothes WHERE identifier=@identifier", {["@clothes"] = json.encode(clothes), ["@identifier"] = DataPlayers[source].SteamId})
				DataPlayers[source].GardeRobe[result] = { name, DataPlayers[source].Clothes }
				DataPlayers[source].Clothes = clothes
				TriggerClientEvent("gardeRobe:saveClothes:cb", source, 'true')
				TriggerClientEvent("venato:notify", source, {
					message = "Votre tenue a bien été stoké dans votre Garde-Robe",
					type = "success", --  danger, error, alert, info, success, warning
					timeout = 6000,
					logo = "https://www.affichez.ca/wp-content/uploads/2014/01/icone_vetement-promo.png",
					title = "Garde-Robe",
				})
			end
		end)
	end)
end)

RegisterNetEvent("GardeRobe:UpdateGardeRobe")
AddEventHandler("GardeRobe:UpdateGardeRobe", function(source)
	MySQL.Async.fetchAll("SELECT * FROM user_garderobe WHERE identifier=@identifier ", {["@identifier"] = DataPlayers[source].SteamId}, function(result)
		if result[1] ~= nil then
			local GardeRobe = {}
			for i,v in ipairs(result) do
				GardeRobe[v.Id] = {name = v.name, clothes = json.decode(v.clothes)}
			end
			DataPlayers[source].GardeRobe = GardeRobe
		end
	end)
end)

RegisterNetEvent("GardeRobe:ChangeClothes")
AddEventHandler("GardeRobe:ChangeClothes", function(clothes)
	local source = source
	DataPlayers[source].Clothes = clothes
	MySQL.Async.execute("UPDATE users SET clothes=@clothes WHERE identifier=@identifier", {["@clothes"] = json.encode(clothes), ["@identifier"] = DataPlayers[source].SteamId})
end)
