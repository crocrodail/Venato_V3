RegisterServerEvent('Bank:GetDataMoneyForATM')
AddEventHandler('Bank:GetDataMoneyForATM', function()
  local godDamn = false
	for k,v in pairs(DataPlayers[source].Inventaire) do
    if tonumber(k) == 41 then
      godDamn = true
    end
  end
  if godDamn then
    TriggerClientEvent("Bank:GetDataMoneyForATM:cb", source, DataPlayers[source])
  else
    TriggerClientEvent('Venato:notify', source, "Vous n'avez pas de carte banquaire.")
  end
end)

RegisterServerEvent('Bank:GetDataMoneyForBank')
AddEventHandler('Bank:GetDataMoneyForBank', function()
  TriggerClientEvent("Bank:GetDataMoneyForBank:cb", source, DataPlayers[source])
end)


RegisterServerEvent('Bank:insert')
AddEventHandler('Bank:insert', function(amount)
	local source = source
	amount = tonumber(amount)
	if amount > DataPlayers[source].Money then
		print("Bank: ERROR")
	else
    TriggerEvent("Bank:AddBankMoney", amount, source)
    TriggerEvent("Inventory:RemoveMoney", amount, source)
		TriggerClientEvent('Venato:notify', source, 'Vous avez déposé ~g~' .. amount .. ' €~s~')
	end
end)

-- Take money
RegisterServerEvent('Bank:take')
AddEventHandler('Bank:take', function(amount)
	local source = source
	amount = tonumber(amount)
	local accountMoney = 0
	accountMoney = DataPlayers[source].Bank
	if amount > accountMoney then
		print("Bank: ERROR")
	else
    TriggerEvent("Bank:RemoveBankMoney", amount, source)
    TriggerEvent("Inventory:AddMoney", amount, source)
		TriggerClientEvent('Venato:notify', source, 'Vous avez retiré ~g~' .. amount .. ' €~s~ ')
	end
end)

RegisterServerEvent('Bank:transfer')
AddEventHandler('Bank:transfer', function(amount, receiver)
  local source = source
  MySQL.Async.fetchAll('SELECT identifier FROM users WHERE account = @account', {['@account'] = receiver}, function (result)
    if (result[1] ~= nil) then
      local recPlayer    = result[1].source
      local recPlayerBank = result[1].bank
    	local amount       = tonumber(amount)
    	local accountMoney = DataPlayers[source].Bank

    	if amount >= accountMoney then
    		print("JSFOUR-ATM: ERROR")
    	else
        TriggerEvent("Bank:RemoveBankMoney", amount, source)
        if DataPlayers[recPlayer] ~= nil then
          TriggerEvent("Bank:AddBankMoney", amount, recPlayer)
        else
          MySQL.Async.execute('UPDATE users SET bank = @Money WHERE identifier = @SteamId', {["@SteamId"] = DataPlayers[source].SteamId, ["@Money"] = recPlayerBank + amount})
        end
        TriggerClientEvent('Venato:notify', source, 'Vous avez envoyé ~g~' .. amount .. ' €~s~ à ' .. result[1].prenom .. ' ' .. result[1].nom)
        TriggerClientEvent('Venato:notify', recPlayer, 'Vous avez reçu ~g~' .. amount .. ' €~s~ de la part de ' .. DataPlayers[source].Prenom .. ' ' .. DataPlayers[source].Nom)
      end
    end
  end)
end)

RegisterServerEvent('Bank:createAccount')
AddEventHandler('Bank:createAccount', function()
  math.randomseed(math.floor(os.time() + math.random(1000)))
  local source = source
  local lettre = string.sub (DataPlayers[source].Nom, 1,1)..""..string.sub (DataPlayers[source].Prenom, 1,1)
  local account = lettre..''..math.random(00,99) .. ' VnT-'.. math.random(000,999)
  DataPlayers[source].Account = account
  MySQL.Async.execute("UPDATE users SET account=@account WHERE identifier=@identifier", {["@account"]=account, ["@identifier"]=DataPlayers[source].SteamId})
  TriggerClientEvent('Venato:notify', source, "~g~Le compte ~b~"..account.."~g~ de "..DataPlayers[source].Nom.." "..DataPlayers[source].Prenom.." a bien été ouvert.")
end)


RegisterServerEvent('Bank:createCard')
AddEventHandler('Bank:createCard', function()
  math.randomseed(math.floor(os.time() + math.random(1000)))
  local source = source
  local code = math.random(1000,9999)
  DataPlayers[source].Code = code
  MySQL.Async.execute("UPDATE users SET code=@code WHERE identifier=@identifier", {["@code"]=code, ["@identifier"]=DataPlayers[source].SteamId})
  TriggerEvent("Inventory:AddItem", 1, 41, source)
  TriggerClientEvent('Venato:notify', source, "~g~Vous avez reçu votre carte, le code cofidentiel à retenir est : ~r~"..code.."~g~.")
end)

RegisterServerEvent('Bank:createCheque')
AddEventHandler('Bank:createCheque', function()
  local source = source
  DataPlayers[source].Code = code
  MySQL.Async.execute("INSERT INTO user_document (`identifier`, `type`, `montant`) VALUES (@identifier, @type, @montant )", {["@identifier"]=DataPlayers[source].SteamId, ["@type"]="chequier", ["@montant"]=5})
  TriggerClientEvent('Venato:notify', source, "~g~Vous avez bien reçu un carnet de 5 cheque.")
  SetTimeout(1000, function()
		MySQL.Async.fetchScalar("SELECT id FROM user_document WHERE identifier = @identifier ORDER BY id DESC", {['@identifier'] = DataPlayers[source].SteamId}, function(result)
			DataPlayers[source].Documents[result] = {["type"] = "chequier", ["montant"] = 5}
		end)
	end)
end)


RegisterNetEvent("Bank:DepotCheque")
AddEventHandler("Bank:DepotCheque", function(index)
	local source = source
  TriggerEvent("Bank:AddBankMoney", DataPlayers[source].Documents[index].montant, source)
  MySQL.Async.execute("DELETE FROM user_document WHERE identifier = @SteamId AND id = @id", {['@SteamId'] = DataPlayers[source].SteamId , ['@id'] = index })
  TriggerClientEvent('Venato:notify', source, "~g~Vous avez bien déposé une chèque de "..DataPlayers[source].Documents[index].montant.." € sur votre compte banquaire.")
  DataPlayers[source].Documents[index] = nil
end)








RegisterNetEvent("Bank:AddBankMoney")
AddEventHandler("Bank:AddBankMoney", function(qty, NewSource)
	local source = source
	local qty = qty
	if NewSource ~= nil then
		source = NewSource
	end
	local new = DataPlayers[source].Bank + qty
	DataPlayers[source].Bank = new
  TriggerClientEvent("gcphone:updateBank", source, new)
	MySQL.Async.execute('UPDATE users SET bank = @Money WHERE identifier = @SteamId', {["@SteamId"] = DataPlayers[source].SteamId, ["@Money"] = new})
end)

RegisterNetEvent("Bank:RemoveBankMoney")
AddEventHandler("Bank:RemoveBankMoney", function(qty, NewSource)
	local source = source
	local qty = qty
	if NewSource ~= nil then
		source = NewSource
	end
	local new = DataPlayers[source].Bank - qty
	DataPlayers[source].Bank = new
  TriggerClientEvent("gcphone:updateBank", source, new)
	MySQL.Async.execute('UPDATE users SET bank = @Money WHERE identifier = @SteamId', {["@SteamId"] = DataPlayers[source].SteamId, ["@Money"] = new})
end)

RegisterNetEvent("Bank:SetBankMoney")
AddEventHandler("Bank:SetBankMoney", function(qty, NewSource)
	local source = source
	local qty = qty
	if NewSource ~= nil then
		source = NewSource
	end
	local new = qty
	DataPlayers[source].Bank = new
  TriggerClientEvent("gcphone:updateBank", source, new)
	MySQL.Async.execute('UPDATE users SET bank = @Money WHERE identifier = @SteamId', {["@SteamId"] = DataPlayers[source].SteamId, ["@Money"] = new})
end)
