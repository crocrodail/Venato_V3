RegisterServerEvent('debuge')
AddEventHandler('debuge', function()
	local SteamId = getSteamID(source)
	accessGranded(SteamId, source)
end)

RegisterServerEvent('Inventory:UpdateInventory')
AddEventHandler('Inventory:UpdateInventory', function(source)
	local source = source
	local Inv = {}
	local inventaire = {}
	local poid = 0
	MySQL.Async.fetchAll("SELECT * FROM user_inventory JOIN items ON `user_inventory`.`item_id` = `items`.`id` WHERE identifier = @SteamId", { ['@SteamId'] = DataPlayers[source].SteamId }, function(result)
		if result[1] ~= nil then
			for i,v in ipairs(result) do
				Inv = {["id"] = v.item_id, ["libelle"] = v.libelle, ["quantity"] = v.quantity, ["poid"] = tonumber(v.poid)*v.quantity, ["uPoid"] = tonumber(v.poid) }
				inventaire[v.item_id] = Inv
				poid = poid + tonumber(v.poid)*v.quantity
			end
			DataPlayers[source].Poid = poid + Venato.Round(DataPlayers[source].Money*0.000075,1)
			DataPlayers[source].Inventaire = inventaire
		end
	end)
end)

RegisterServerEvent('Inventory:ShowMe')
AddEventHandler('Inventory:ShowMe', function()
	TriggerClientEvent("Inventory:ShowMe:cb", source, DataPlayers[source] )
end)

RegisterServerEvent('Inventory:DataItem')
AddEventHandler('Inventory:DataItem', function(id)
	local source = source
	local table = {}
	MySQL.Async.fetchAll("SELECT * FROM items WHERE id = @id", { ['@id'] = id }, function(result)
		if result ~= nil then
			table = { water = result[1].water, food = result[1].food, need = result[1].need, sool = result[1].sool, drug = result[1].drug }
			DataPlayers[source].Food = DataPlayers[source].Food - table.food
			DataPlayers[source].Water = DataPlayers[source].Water - table.water
			DataPlayers[source].Need = DataPlayers[source].Need + table.need
			DataPlayers[source].Sool = DataPlayers[source].Sool + table.sool
			TriggerClientEvent("Stade:UpdateState", source, table)  -- ###########################   non atribué-- ###########################   non atribué-- ###########################   non atribué-- ###########################   non atribué
		end
	end)
end)

RegisterServerEvent('Inventory:SetItem')
AddEventHandler('Inventory:SetItem', function(qty, id, NewSource)
	local source = source
	local AlreadyExist = false
	if NewSource ~= nil then
		source = NewSource
	end
	if DataPlayers[source].Inventaire ~= nil then
		for k,v in pairs(DataPlayers[source].Inventaire) do
			if v.id == id then
				AlreadyExist = true
			end
		end
		if AlreadyExist then
			if qty > 0 then
				MySQL.Async.execute("UPDATE user_inventory SET quantity = @qty WHERE identifier = @SteamId AND item_id = @id", {['@qty'] = qty, ['@SteamId'] = DataPlayers[source].SteamId , ['@id'] = id })
			else
				MySQL.Async.execute("DELETE FROM user_inventory WHERE identifier = @SteamId AND item_id = @id", {['@SteamId'] = DataPlayers[source].SteamId , ['@id'] = id })
			end
		else
			MySQL.Async.execute("INSERT INTO user_inventory (`identifier`, `item_id`, `quantity`) VALUES (@player, @item, @qty)",{['@player'] = DataPlayers[source].SteamId, ['@item'] = id, ['@qty'] = qty })
		end
		Citizen.Wait(300)
		TriggerEvent("Inventory:UpdateInventory", source)
	end
end)

RegisterServerEvent('Inventory:AddItem')
AddEventHandler('Inventory:AddItem', function(qty, id, NewSource)
	local source = source
	local qty = qty
	local AlreadyExist = false
	if NewSource ~= nil then
		source = NewSource
	end
	if DataPlayers[source].Inventaire ~= nil then
		for k,v in pairs(DataPlayers[source].Inventaire) do
			if v.id == id then
				AlreadyExist = true
				qty = qty + DataPlayers[source].Inventaire[k].quantity
			end
		end
		if AlreadyExist then
			if qty > 0 then
				MySQL.Async.execute("UPDATE user_inventory SET quantity = @qty WHERE identifier = @SteamId AND item_id = @id", {['@qty'] = qty, ['@SteamId'] = DataPlayers[source].SteamId , ['@id'] = id })
			else
				MySQL.Async.execute("DELETE FROM user_inventory WHERE identifier = @SteamId AND item_id = @id", {['@SteamId'] = DataPlayers[source].SteamId , ['@id'] = id })
			end
		else
			MySQL.Async.execute("INSERT INTO user_inventory (`identifier`, `item_id`, `quantity`) VALUES (@player, @item, @qty)",{['@player'] = DataPlayers[source].SteamId, ['@item'] = id, ['@qty'] = qty })
		end
		Citizen.Wait(300)
		TriggerEvent("Inventory:UpdateInventory", source)
	end
end)

RegisterServerEvent('Inventory:CallInfo')
AddEventHandler('Inventory:CallInfo', function(ClosePlayer, nb, table)
	TriggerClientEvent("Inventory:CallInfo:cb", source, ClosePlayer, nb, table, DataPlayers[source].Poid, DataPlayers[source].Inventaire[table[2]].quantity)
end)

ItemsOnTheGround = {}
ItemsOnTheGroundIndex = 0
RegisterServerEvent('Inventory:DropItem')
AddEventHandler('Inventory:DropItem', function(libelle, qty, id, uPoid, x, poid)
	local x, y, z = table.unpack(x)
	ItemsOnTheGroundIndex = ItemsOnTheGroundIndex + 1
	ItemsOnTheGround[ItemsOnTheGroundIndex] = {id = id, libelle = libelle, qty = qty, uPoid = uPoid, poid = poid, x = x, y = y, z = z}
	ActualiseTableOfItemOnTheGround()
end)

RegisterServerEvent('Inventory:DelItemsOnTheGround')
AddEventHandler('Inventory:DelItemsOnTheGround', function(index)
	ItemsOnTheGround[index] = nil
	ActualiseTableOfItemOnTheGround()
end)

function ActualiseTableOfItemOnTheGround()
	TriggerClientEvent("Inventory:SendItemsOnTheGround", -1, ItemsOnTheGround)
end

RegisterServerEvent('Inventory:CallInfoMoney')
AddEventHandler('Inventory:CallInfoMoney', function(ClosePlayer, qty, table)
	if DataPlayers[ClosePlayer].Poid + Venato.Round(qty * 0.000075) >= DataPlayers[ClosePlayer].PoidMax then
		TriggerEvent("Inventory:AddMoney", qty, ClosePlayer)
		TriggerEvent("Inventory:RemoveMoney", qty, source)
		--TriggerClientEvent("Venato:Anim", source, ...)-- ###########################   non atribué-- ###########################   non atribué-- ###########################-- ###########################   non atribué-- ###########################   non atribué-- ###########################
		TriggerClientEvent("Venato:notify", source, "Vous avez donner "..qty.." €")
		TriggerClientEvent("Venato:notify", ClosePlayer, "Vous avez reçu "..qty.." €")
	else
		TriggerClientEvent("Venato:notify", source, "La personne est trop lourde pour reçevoir "..qty.." €")
		TriggerClientEvent("Venato:notify", ClosePlayer, "Vous etes trop lourd pour reçevoir "..qty.." €")
	end
end)

RegisterNetEvent("Inventory:AddMoney")
AddEventHandler("Inventory:AddMoney", function(qty, NewSource)
	local source = source
	local qty = qty
	if NewSource ~= nil then
		source = NewSource
	end
	local new = DataPlayers[source].Money + qty
	DataPlayers[source].Money = new
	MySQL.Async.execute('UPDATE users SET money = @Money WHERE identifier = @SteamId', {["@SteamId"] = DataPlayers[source].SteamId, ["@Money"] = new})
end)

RegisterNetEvent("Inventory:RemoveMoney")
AddEventHandler("Inventory:RemoveMoney", function(qty, NewSource)
	local source = source
	local qty = qty
	if NewSource ~= nil then
		source = NewSource
	end
	local new = DataPlayers[source].Money - qty
	DataPlayers[source].Money = new
	MySQL.Async.execute('UPDATE users SET money = @Money WHERE identifier = @SteamId', {["@SteamId"] = DataPlayers[source].SteamId, ["@Money"] = new})
end)

RegisterNetEvent("Inventory:SetMoney")
AddEventHandler("Inventory:SetMoney", function(qty, NewSource)
	local source = source
	local qty = qty
	if NewSource ~= nil then
		source = NewSource
	end
	local new = qty
	DataPlayers[source].Money = new
	MySQL.Async.execute('UPDATE users SET money = @Money WHERE identifier = @SteamId', {["@SteamId"] = DataPlayers[source].SteamId, ["@Money"] = new})
end)

MoneyOnTheGround = {}
MoneyOnTheGroundIndex = 0
RegisterServerEvent('Inventory:DropMoney')
AddEventHandler('Inventory:DropMoney', function(qty, tableau, pos, poid)
	local x, y, z = table.unpack(pos)
	MoneyOnTheGroundIndex = MoneyOnTheGroundIndex + 1
	MoneyOnTheGround[MoneyOnTheGroundIndex] = {qty = qty, poid = tableau[3], PlayerMoney = tableau[1], x = x, y = y, z = z}
	ActualiseTableOfMoneyOnTheGround()
end)

RegisterServerEvent('Inventory:DelMoneyOnTheGround')
AddEventHandler('Inventory:DelMoneyOnTheGround', function(index)
	MoneyOnTheGround[index] = nil
	ActualiseTableOfMoneyOnTheGround()
end)

function ActualiseTableOfMoneyOnTheGround()
	TriggerClientEvent("Inventory:SendMoneyOnTheGround", -1, MoneyOnTheGround)
end
