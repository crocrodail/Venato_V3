RegisterServerEvent('debuge')
AddEventHandler('debuge', function()
  local SteamId = getSteamID(source)
  accessGranded(SteamId, source, "")
end)

RegisterServerEvent('Inventory:UpdateInventory')
AddEventHandler('Inventory:UpdateInventory', function(source)
	local source = source
	local Inv = {}
	local inventaire = {}
	local Wp = {}
	local Weapon = {}
	local doc = {}
	local Document = {}
	local poid = Venato.MoneyToPoid(DataPlayers[source].Money)
	MySQL.Async.fetchAll("SELECT * FROM user_inventory JOIN items ON `user_inventory`.`item_id` = `items`.`id` WHERE identifier = @SteamId", { ['@SteamId'] = DataPlayers[source].SteamId }, function(result)
		if result[1] ~= nil then
			for i,v in ipairs(result) do
				Inv = {["id"] = v.item_id, ["libelle"] = v.libelle, ["quantity"] = v.quantity, ["poid"] = tonumber(v.poid)*v.quantity, ["uPoid"] = tonumber(v.poid), ["picture"] = v.picture }
				inventaire[v.item_id] = Inv
				poid = poid + tonumber(v.poid)*v.quantity
			end
			DataPlayers[source].Poid = poid
			DataPlayers[source].Inventaire = inventaire
		end
	end)
	MySQL.Async.fetchAll("SELECT * FROM user_weapons JOIN weapon_model ON `user_weapons`.`weapon_model` = `weapon_model`.`weapond` WHERE identifier = @SteamId", { ['@SteamId'] = DataPlayers[source].SteamId }, function(result)
		if result[1] ~= nil then
			for i,v in ipairs(result) do
				Wp = {["id"] = v.weapon_model, ["libelle"] = v.libelle, ["poid"] = tonumber(v.poid), ["ammo"] = tonumber(v.balles)}
				Weapon[v.id] = Wp
				poid = poid + tonumber(v.poid)
				TriggerClientEvent("Inventory:AddWeaponClient", source, v.weapon_model, tonumber(v.balles))
			end
			DataPlayers[source].Poid = poid
			DataPlayers[source].Weapon = Weapon
		end
	end)
	MySQL.Async.fetchAll("SELECT * FROM user_document WHERE identifier = @SteamId", { ['@SteamId'] = DataPlayers[source].SteamId }, function(result)
		if result[1] ~= nil then
			for i,v in ipairs(result) do
				doc = {["type"] = v.type, ["nom1"] = v.nom, ["prenom1"] = v.prenom, ["montant"] = tonumber(v.montant), ["numeroDeCompte"] = v.numero_de_compte, ["date"] = v.date, ["nom2"] = v.nom_du_factureur, ["prenom2"] = v.prenom_du_factureur}
				Document[v.id] = doc
			end
			DataPlayers[source].Documents = Document
		end
	end)
end)

RegisterServerEvent('Inventory:ShowMe')
AddEventHandler('Inventory:ShowMe', function()
	TriggerClientEvent("Inventory:ShowMe:cb", source, DataPlayers[source])
end)

RegisterServerEvent('Inventory:DataItem')
AddEventHandler('Inventory:DataItem', function(id, qty)
	local source = source
	local table = {}
	MySQL.Async.fetchAll("SELECT * FROM items WHERE id = @id", { ['@id'] = id }, function(result)
		if result[1] ~= nil then
			if tonumber(result[1].consomable) == 1 then
				TriggerEvent("Inventory:SetItem", qty-1, id, source)
				table = { water = result[1].water, food = result[1].food, sool = result[1].sool, drug = result[1].drug }
				DataPlayers[source].Food = DataPlayers[source].Food - table.food
				DataPlayers[source].Water = DataPlayers[source].Water - table.water
				-- DataPlayers[source].Need = DataPlayers[source].Need + table.need
				DataPlayers[source].Sool = DataPlayers[source].Sool + table.sool
				local needs = {
					water = DataPlayers[source].Water,
					food = DataPlayers[source].Food,
					alcool = DataPlayers[source].Sool
				}
				TriggerClientEvent("Life:UpdateState", source, needs)  -- ###########################   non atribué-- ###########################   non atribué-- ###########################   non atribué-- ###########################   non atribué
			else
				TriggerClientEvent('Venato:notify', source, "Cette item n'est pas utilisable.", 'danger')
			end
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
			local poidBefore = DataPlayers[source].Inventaire[id].poid
			DataPlayers[source].Poid = DataPlayers[source].Poid - poidBefore
			if qty > 0 then
				MySQL.Async.execute("UPDATE user_inventory SET quantity = @qty WHERE identifier = @SteamId AND item_id = @id", {['@qty'] = qty, ['@SteamId'] = DataPlayers[source].SteamId , ['@id'] = id })
				DataPlayers[source].Inventaire[id].quantity = qty
				DataPlayers[source].Inventaire[id].poid =  qty * DataPlayers[source].Inventaire[id].uPoid
				DataPlayers[source].Poid = DataPlayers[source].Poid + DataPlayers[source].Inventaire[id].poid
			else
				DataPlayers[source].Inventaire[id] = nil
				MySQL.Async.execute("DELETE FROM user_inventory WHERE identifier = @SteamId AND item_id = @id", {['@SteamId'] = DataPlayers[source].SteamId , ['@id'] = id })
			end
		else
			MySQL.Async.fetchAll("SELECT * FROM items WHERE id = @id", { ['@id'] = id }, function(result)
				if result[1] ~= nil then
					DataPlayers[source].Inventaire[id] =  {["id"] = id, ["libelle"] = result[1].libelle, ["quantity"] = qty, ["poid"] = tonumber(result[1].poid)*qty, ["uPoid"] = tonumber(result[1].poid), ["picture"] = result[1].picture }
					DataPlayers[source].Poid = DataPlayers[source].Poid + DataPlayers[source].Inventaire[id].poid
				else
					print("GROS Probleme !!")
				end
			end)
			MySQL.Async.execute("INSERT INTO user_inventory (`identifier`, `item_id`, `quantity`) VALUES (@player, @item, @qty)",{['@player'] = DataPlayers[source].SteamId, ['@item'] = id, ['@qty'] = qty })
		end
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
			local poidBefore = DataPlayers[source].Inventaire[id].poid
			DataPlayers[source].Poid = DataPlayers[source].Poid - poidBefore
			if qty > 0 then
				DataPlayers[source].Inventaire[id].quantity = qty
				DataPlayers[source].Inventaire[id].poid =  qty * DataPlayers[source].Inventaire[id].uPoid
				DataPlayers[source].Poid = DataPlayers[source].Poid + DataPlayers[source].Inventaire[id].poid
				MySQL.Async.execute("UPDATE user_inventory SET quantity = @qty WHERE identifier = @SteamId AND item_id = @id", {['@qty'] = qty, ['@SteamId'] = DataPlayers[source].SteamId , ['@id'] = id })
			else
				DataPlayers[source].Inventaire[id] = nil
				MySQL.Async.execute("DELETE FROM user_inventory WHERE identifier = @SteamId AND item_id = @id", {['@SteamId'] = DataPlayers[source].SteamId , ['@id'] = id })
			end
		else
			MySQL.Async.fetchAll("SELECT * FROM items WHERE id = @id", { ['@id'] = id }, function(result)
				if result[1] ~= nil then
					DataPlayers[source].Inventaire[id] =  {["id"] = id, ["libelle"] = result[1].libelle, ["quantity"] = qty, ["poid"] = tonumber(result[1].poid)*qty, ["uPoid"] = tonumber(result[1].poid), ["picture"] = result[1].picture}
					DataPlayers[source].Poid = DataPlayers[source].Poid + DataPlayers[source].Inventaire[id].poid
				else
					print("GROS Probleme !!")
				end
			end)
			MySQL.Async.execute("INSERT INTO user_inventory (`identifier`, `item_id`, `quantity`) VALUES (@player, @item, @qty)",{['@player'] = DataPlayers[source].SteamId, ['@item'] = id, ['@qty'] = qty })
		end
	end
end)

RegisterServerEvent('Inventory:RemoveItem')
AddEventHandler('Inventory:RemoveItem', function(qty, id, NewSource)
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
				qty = DataPlayers[source].Inventaire[k].quantity - qty
			end
		end
		if AlreadyExist then
			local poidBefore = DataPlayers[source].Inventaire[id].poid
			DataPlayers[source].Poid = DataPlayers[source].Poid - poidBefore
			if qty > 0 then
				DataPlayers[source].Inventaire[id].quantity = qty
				DataPlayers[source].Inventaire[id].poid =  qty * DataPlayers[source].Inventaire[id].uPoid
				DataPlayers[source].Poid = DataPlayers[source].Poid + DataPlayers[source].Inventaire[id].poid
				MySQL.Async.execute("UPDATE user_inventory SET quantity = @qty WHERE identifier = @SteamId AND item_id = @id", {['@qty'] = qty, ['@SteamId'] = DataPlayers[source].SteamId , ['@id'] = id })
			else
				DataPlayers[source].Inventaire[id] = nil
				MySQL.Async.execute("DELETE FROM user_inventory WHERE identifier = @SteamId AND item_id = @id", {['@SteamId'] = DataPlayers[source].SteamId , ['@id'] = id })
			end
		else
			MySQL.Async.fetchAll("SELECT * FROM items WHERE id = @id", { ['@id'] = id }, function(result)
				if result[1] ~= nil then
					DataPlayers[source].Inventaire[id] =  {["id"] = id, ["libelle"] = result[1].libelle, ["quantity"] = qty, ["poid"] = tonumber(result[1].poid)*qty, ["uPoid"] = tonumber(result[1].poid), ["picture"] = result[1].picture}
					DataPlayers[source].Poid = DataPlayers[source].Poid + DataPlayers[source].Inventaire[id].poid
				else
					print("GROS Probleme !!")
				end
			end)
			MySQL.Async.execute("INSERT INTO user_inventory (`identifier`, `item_id`, `quantity`) VALUES (@player, @item, @qty)",{['@player'] = DataPlayers[source].SteamId, ['@item'] = id, ['@qty'] = qty })
		end
	end
end)

RegisterServerEvent('Inventory:CallInfo')
AddEventHandler('Inventory:CallInfo', function(ClosePlayer, nb, row)
  local qtyTarget
  if DataPlayers[ClosePlayer].Inventaire[row[2]] == nil then
    qtyTarget = 0
  else
    qtyTarget = DataPlayers[ClosePlayer].Inventaire[row[2]].quantity
  end
	TriggerClientEvent("Inventory:CallInfo:cb", source, ClosePlayer, nb, row, DataPlayers[source].Poid, qtyTarget)
end)

ItemsOnTheGround = {}
ItemsOnTheGroundIndex = 0
RegisterServerEvent('Inventory:DropItem')
AddEventHandler('Inventory:DropItem', function(libelle, qty, id, uPoid, x,y,z, poid, picture)
	ItemsOnTheGroundIndex = ItemsOnTheGroundIndex + 1
	ItemsOnTheGround[ItemsOnTheGroundIndex] = {id = id, libelle = libelle, qty = qty, uPoid = uPoid, poid = poid, x = x, y = y, z = z, picture = picture}
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
	if DataPlayers[ClosePlayer].Poid + Venato.MoneyToPoid(qty) >= DataPlayers[ClosePlayer].PoidMax then
		TriggerEvent("Inventory:AddMoney", qty, ClosePlayer)
		TriggerEvent("Inventory:RemoveMoney", qty, source)
		TriggerClientEvent("Inventory:AnimGive", source)		TriggerClientEvent("Venato:notify", source, "Vous avez donner "..qty.." €")
		TriggerClientEvent("Venato:notify", ClosePlayer, "Vous avez reçu "..qty.." €")
	else
		TriggerClientEvent("Venato:notify", source, "La personne n'a pas la place pour recevoir "..qty.." €")
		TriggerClientEvent("Venato:notify", ClosePlayer, "Vous n'avez pas la place pour recevoir "..qty.." €")
	end
end)

RegisterNetEvent("Inventory:AddMoney")
AddEventHandler("Inventory:AddMoney", function(qty, NewSource)
	local source = source
	local qty = qty
	if NewSource ~= nil then
		source = NewSource
	end
	DataPlayers[source].Poid = DataPlayers[source].Poid + Venato.MoneyToPoid(qty)
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
	DataPlayers[source].Poid = DataPlayers[source].Poid - Venato.MoneyToPoid(qty)
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
	local newPoid = DataPlayers[source].Poid - Venato.MoneyToPoid(DataPlayers[source].Money)
	local new = qty
	DataPlayers[source].Poid = DataPlayers[source].Poid + Venato.MoneyToPoid(qty)
	DataPlayers[source].Money = new
	MySQL.Async.execute('UPDATE users SET money = @Money WHERE identifier = @SteamId', {["@SteamId"] = DataPlayers[source].SteamId, ["@Money"] = new})
end)

MoneyOnTheGround = {}
MoneyOnTheGroundIndex = 0
RegisterServerEvent('Inventory:DropMoney')
AddEventHandler('Inventory:DropMoney', function(qty, tableau, x,y,z, poid)
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

RegisterServerEvent('Inventory:CallInfoWeapon')
AddEventHandler('Inventory:CallInfoWeapon', function(ClosePlayer, table)
	if DataPlayers[ClosePlayer].Poid + table[4] >= DataPlayers[ClosePlayer].PoidMax then
		TriggerEvent("Inventory:AddWeapon", table[3], table[5], table[4], table[2], ClosePlayer)
		TriggerEvent("Inventory:RemoveWeapon", table[3], table[1], source)
		TriggerClientEvent("Inventory:AnimGive", source)
		TriggerClientEvent("Venato:notify", ClosePlayer, "Vous avez reçu une arme.")
	else
		TriggerClientEvent("Venato:notify", source, "La personne est trop lourde pour reçevoir une arme.")
		TriggerClientEvent("Venato:notify", ClosePlayer, "Vous etes trop lourd pour reçevoir une arme.")
	end
end)

WeaponOnTheGround = {}
WeaponOnTheGroundIndex = 0
RegisterServerEvent('Inventory:DropWeapon')
AddEventHandler('Inventory:DropWeapon', function(tableau, x,y,z)
	WeaponOnTheGroundIndex = WeaponOnTheGroundIndex + 1
	WeaponOnTheGround[WeaponOnTheGroundIndex] = {id = tableau[3], libelle = tableau[2], ammo = tableau[5], uPoid = tableau[4], x = x, y = y, z = z, poid = tableau[6]}
	ActualiseTableOfWeaponOnTheGround()
end)

RegisterServerEvent('Inventory:DelWeaponOnTheGround')
AddEventHandler('Inventory:DelWeaponOnTheGround', function(index)
	WeaponOnTheGround[index] = nil
	ActualiseTableOfWeaponOnTheGround()
end)

function ActualiseTableOfWeaponOnTheGround()
	TriggerClientEvent("Inventory:SendWeaponOnTheGround", -1, WeaponOnTheGround)
end

RegisterServerEvent('Inventory:AddWeapon')
AddEventHandler('Inventory:AddWeapon', function(weapon, ammo, poid, libelle, NewSource)
	local source = source
	local libelle = libelle
	local qty = qty
	if NewSource ~= nil then
		source = NewSource
	end
	if poid ~= nil then
		DataPlayers[source].Poid = DataPlayers[source].Poid + poid
	end
	if libelle == nil then
		libelle = "inconue"
	end
	TriggerClientEvent("Inventory:AddWeaponClient", source, weapon, ammo)
	MySQL.Async.execute("INSERT INTO user_weapons (`identifier`, `weapon_model`, `balles`) VALUES (@identifier, @weapon_model, @balles)",{['@identifier'] = DataPlayers[source].SteamId, ['@weapon_model'] = weapon, ['@balles'] = ammo }, function()
		MySQL.Async.fetchScalar("SELECT id FROM user_weapons WHERE identifier = @identifier ORDER BY id DESC", {['@identifier'] = DataPlayers[source].SteamId}, function(result)
			DataPlayers[source].Weapon[result] = {["id"] = weapon, ["libelle"] = libelle, ["poid"] = poid, ["ammo"] = ammo}
		end)
	end)
end)

RegisterServerEvent('Inventory:AddWeaponAmmo')
AddEventHandler('Inventory:AddWeaponAmmo', function(weapon, ammo, index, NewSource)
	local source = source
	if NewSource ~= nil then
		source = NewSource
	end
	DataPlayers[source].Weapon[DataPlayers[source].Index].ammo = ammo
	TriggerClientEvent("Inventory:AddWeaponAmmoClient", source, weapon, ammo)
	MySQL.Async.execute("UPDATE user_weapons SET balles = @ammo WHERE id = @index",{['@ammo'] = ammo, ['@index'] = index})
end)

RegisterServerEvent('Inventory:RemoveWeapon')
AddEventHandler('Inventory:RemoveWeapon', function(weapon, id, poid, NewSource)
	local source = source
	local qty = qty
	if NewSource ~= nil then
		source = NewSource
	end
	if poid ~= nil then
		DataPlayers[source].Poid = DataPlayers[source].Poid - poid
	end
	TriggerClientEvent("Inventory:RemoveWeaponClient", source, weapon)
	DataPlayers[source].Weapon[tonumber(id)] = nil
	MySQL.Async.execute("DELETE FROM user_weapons WHERE id = @id", {['@id'] = tonumber(id) })
end)

RegisterServerEvent('Inventory:ShowToOtherPermis')
AddEventHandler('Inventory:ShowToOtherPermis', function(data, target)
	TriggerClientEvent("Inventory:ShowToOtherPermis:cb", target, data)
end)

RegisterServerEvent('Inventory:ShowToOtherIdCard')
AddEventHandler('Inventory:ShowToOtherIdCard', function(data, target)
	TriggerClientEvent("Inventory:ShowToOtherIdCard:cb", target, data)
end)


RegisterServerEvent('Inventory:ShowToOtherVisa')
AddEventHandler('Inventory:ShowToOtherVisa', function(data, target)
	TriggerClientEvent("Inventory:ShowToOtherVisa:cb", target, data)
end)

RegisterServerEvent('Inventory:CreateCheque')
AddEventHandler('Inventory:CreateCheque', function(player, montant)
	local source = source
  local target = player
  local date = os.date("%Y/%m/%d")
  local Notification = {
   title= "Inventaire",
   type = "success", --  danger, error, alert, info, success, warning
   logo = "https://img.icons8.com/dusk/64/000000/paycheque.png",
   message = "Vous avez bien donné un chèque.",
  }
	MySQL.Async.execute("INSERT INTO user_document (`identifier`, `type`, `nom`, `prenom`, `montant`, `numero_de_compte`, `nom_du_factureur`,`prenom_du_factureur`, `date`) VALUES (@identifier, @type, @nom, @prenom, @montant, @numero_de_compte, @nom_du_factureur, @prenom_du_factureur, @date)",
  {
    ["@identifier"] = DataPlayers[target].SteamId,
    ["@type"] = "cheque",
    ["@nom"] = DataPlayers[target].Nom,
    ["@prenom"] = DataPlayers[target].Prenom,
    ["@montant"] = montant,
    ["@numero_de_compte"] = DataPlayers[source].Account,
    ["@nom_du_factureur"] = DataPlayers[source].Nom,
    ["@prenom_du_factureur"] = DataPlayers[source].Prenom,
    ["@date"] = date,
  }, function()
    MySQL.Async.fetchScalar("SELECT id FROM user_document WHERE identifier = @identifier ORDER BY id DESC", {["@identifier"] = DataPlayers[target].SteamId}, function(result)
      DataPlayers[target].Documents[result] = {["type"] = "cheque", ["nom1"] = DataPlayers[target].Nom, ["prenom1"] = DataPlayers[target].Prenom, ["montant"] = montant, ["numeroDeCompte"] = DataPlayers[source].Account, ["date"] = date, ["nom2"] = DataPlayers[source].Nom, ["prenom2"] = DataPlayers[source].Prenom}
      for k,v in pairs(DataPlayers[source].Documents) do
        if type == "chequier" then
          DataPlayers[source].Documents[k].montant = DataPlayers[source].Documents[k].montant - 1
          if DataPlayers[source].Documents[k].montant == 0 then
            MySQL.Async.execute("DELETE FROM user_document WHERE identifier = @identifier and id = @id", {["@identifier"] = DataPlayers[source].SteamId, ["@id"] = k})
          else
            MySQL.Async.execute("UPDATE user_document SET montant = @montant WHERE identifier = @identifier and id = @id", {["@montant"] = DataPlayers[source].Documents[k].montant, ["@identifier"] = DataPlayers[source].SteamId, ["@id"] = k})
          end
          break
        end
      end
      TriggerClientEvent('Venato:notify', source, Notification)
      Notification.message = "Vous avez reçu un chèque de "..montant.." € ."
      TriggerClientEvent('Venato:notify', target, Notification)
    end)
  end)
end)

RegisterServerEvent('Inventory:NotifGive')
AddEventHandler('Inventory:NotifGive', function(recever, qty, id)
  local source = source
  local Notification = {
   title= "Inventaire",
   type = "info", --  danger, error, alert, info, success, warning
   logo = DataPlayers[source].Inventaire[id].picture,
   message = "Vous avez reçu "..qty.." "..DataPlayers[source].Inventaire[id].libelle..".",
  }
  TriggerClientEvent('Venato:notify', recever, Notification)
  Notification.message = "Vous avez donné "..qty.." "..DataPlayers[source].Inventaire[id].libelle.."."
  TriggerClientEvent('Venato:notify', source, Notification)
end)

RegisterServerEvent('Inventaire:ForceDeleteObject')
AddEventHandler('Inventaire:ForceDeleteObject', function(id)
  TriggerClientEvent("Inventaire:ForceDeleteObject:cb", -1, id)
end)
