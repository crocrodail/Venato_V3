local defaultNotification = {
  type = "info",
  title ="Banque",
  logo = "https://img.icons8.com/officel/80/000000/bank-euro.png"
}

local plafondDepot = 15000
local plafondRetrait = 10000

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
    defaultNotification.message = "Vous n'avez pas de carte bancaire."
    TriggerClientEvent('Venato:notify', source, defaultNotification)
  end
end)

RegisterServerEvent('Bank:GetDataMoneyForBank')
AddEventHandler('Bank:GetDataMoneyForBank', function()
  TriggerClientEvent("Bank:GetDataMoneyForBank:cb", source, DataPlayers[source])
end)


RegisterServerEvent('Bank:insert')
AddEventHandler('Bank:insert', function(amount)
	local source = source
	amount = round(tonumber(amount),0)
	if amount <= 0 or amount > DataPlayers[source].Money then
		print("Bank: ERROR")
	else
    TriggerEvent("Bank:AddBankMoney", amount, source)
    TriggerEvent("Inventory:RemoveMoney", amount, source)
    defaultNotification.message = 'Vous avez déposé <span class="green--text">' .. amount .. ' €</span>'
    TriggerClientEvent('Venato:notify', source, defaultNotification)
    MySQL.Async.execute('INSERT INTO bank_transactions(identifier,isDepot,montant) VALUES (@SteamId,1,@amount)', {["@SteamId"] = DataPlayers[source].SteamId, ["@amount"] = amount}, function()
        CheckPlafondDepot(source)
    end)
	end
end)

-- Take money
RegisterServerEvent('Bank:take')
AddEventHandler('Bank:take', function(amount)
	local source = source
	amount = round(tonumber(amount),0)
	local accountMoney = 0
	accountMoney = DataPlayers[source].Bank
	if amount <= 0 or amount > accountMoney then
		print("Bank: ERROR")
  else
    MySQL.Async.execute('INSERT INTO bank_transactions(identifier,isDepot,montant) VALUES (@SteamId,0,@amount)', {["@SteamId"] = DataPlayers[source].SteamId, ["@amount"] = amount}, function()
      if CheckPlafondRetrait(source, amount) then
        TriggerEvent("Bank:RemoveBankMoney", amount, source)
        TriggerEvent("Inventory:AddMoney", amount, source)
        defaultNotification.message = 'Vous avez retiré <span class="green--text">' .. amount .. ' €</span> '
        TriggerClientEvent('Venato:notify', source, defaultNotification)
      else
        defaultNotification.message = "Vous avez dépassé votre plafond vous ne pouvez pas retirer d'argent pour le moment."
        TriggerClientEvent('Venato:notify', source, defaultNotification)
      end
    end)
	end
end)

RegisterServerEvent('Bank:transfer')
AddEventHandler('Bank:transfer', function(amount, receiver)
  local source = source
  if amount <= 0 then
    print("Bank: ERROR")
    return
  end
  MySQL.Async.fetchAll('SELECT * FROM users WHERE account = @account', {['@account'] = receiver}, function (result)
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
        defaultNotification.message = 'Vous avez envoyé <span class="green--text">' .. amount .. ' €</span> à ' .. result[1].prenom .. ' ' .. result[1].nom
        TriggerClientEvent('Venato:notify', source, defaultNotification)
        defaultNotification.message = 'Vous avez reçu <span class="green--text">' .. amount .. ' €</span> de la part de ' .. DataPlayers[source].Prenom .. ' ' .. DataPlayers[source].Nom
        TriggerClientEvent('Venato:notify', recPlayer, defaultNotification)
      end
    else
      TriggerClientEvent('Venato:notifyError', source, "Le numéro de compte renseigné est erroné.")
      TriggerClientEvent("Bank:ActuSoldeErrone", source, DataPlayers[source])
    end
  end)
end)

RegisterServerEvent('Bank:createAccount')
AddEventHandler('Bank:createAccount', function()
  math.randomseed(math.floor(os.time() + math.random(1000)))
  local source = source
  local lettre = string.sub (DataPlayers[source].Nom, 1,1)..""..string.sub (DataPlayers[source].Prenom, 1,1)
  local account = lettre..''..math.random(00,99) .. '-VnT-'.. math.random(000,999)
  DataPlayers[source].Account = account
  MySQL.Async.execute("UPDATE users SET account=@account WHERE identifier=@identifier", {["@account"]=account, ["@identifier"]=DataPlayers[source].SteamId})
  defaultNotification.message = 'Le compte <span class="blue--text">'..account..'</span> de '..DataPlayers[source].Nom..' '..DataPlayers[source].Prenom.." a bien été ouvert."
  TriggerClientEvent('Venato:notify', source, defaultNotification)
end)


RegisterServerEvent('Bank:createCard')
AddEventHandler('Bank:createCard', function()
  math.randomseed(math.floor(os.time() + math.random(1000)))
  local source = source
  local code = math.random(1000,9999)
  DataPlayers[source].Code = code
  MySQL.Async.execute("UPDATE users SET code=@code WHERE identifier=@identifier", {["@code"]=code, ["@identifier"]=DataPlayers[source].SteamId})
  TriggerEvent("Inventory:AddItem", 1, 41, source)
  defaultNotification.message = 'Vous avez reçu votre carte, le code confidentiel à retenir est : <span class="red--text">'..code..'</span>.'
  defaultNotification.timeout = 15000
  TriggerClientEvent('Venato:notify', source, defaultNotification)
  defaultNotification.timeout = nil
end)

RegisterServerEvent('Bank:createCheque')
AddEventHandler('Bank:createCheque', function()
  local source = source
  DataPlayers[source].Code = code
  MySQL.Async.execute("INSERT INTO user_document (`identifier`, `type`, `montant`) VALUES (@identifier, @type, @montant )", {["@identifier"]=DataPlayers[source].SteamId, ["@type"]="chequier", ["@montant"]=5}, function()
    defaultNotification.message = "Vous avez bien reçu un carnet de 5 cheques."
    TriggerClientEvent('Venato:notify', source, defaultNotification)
	  MySQL.Async.fetchScalar("SELECT id FROM user_document WHERE identifier = @identifier ORDER BY id DESC", {['@identifier'] = DataPlayers[source].SteamId}, function(result)
		  DataPlayers[source].Documents[result] = {["type"] = "chequier", ["montant"] = 5}
	  end)
  end)
end)


RegisterNetEvent("Bank:DepotCheque")
AddEventHandler("Bank:DepotCheque", function(index)
  local source = source
  local cheque = DataPlayers[source].Documents[tonumber(index)]
  if cheque.numeroDeCompte == "Entreprise" then
    TriggerEvent("Bank:AddBankMoney", cheque.montant, source)
    MySQL.Async.execute("DELETE FROM user_document WHERE identifier = @SteamId AND id = @id", {['@SteamId'] = DataPlayers[source].SteamId , ['@id'] = index })
    defaultNotification.message = "Vous avez bien déposé un chèque de "..cheque.montant.." € sur votre compte bancaire."
    TriggerClientEvent('Venato:notify', source, defaultNotification)
    DataPlayers[source].Documents[tonumber(index)] = nil
  else
    MySQL.Async.fetchAll("SELECT * FROM users WHERE account = @account",{["@account"]=cheque.numeroDeCompte}, function(result)
      if result[1] ~= nil then
        if result[1].bank >= cheque.montant then
          if result[1].source ~= 'disconnect' then
            TriggerEvent("Bank:RemoveBankMoney", cheque.montant, result[1].source)
          else
            MySQL.Async.execute('UPDATE users SET bank = @Money WHERE identifier = @SteamId', {["@SteamId"] = result[1].identifier, ["@Money"] = result[1].bank-cheque.montant})
          end
          TriggerEvent("Bank:AddBankMoney", cheque.montant, source)
          MySQL.Async.execute("DELETE FROM user_document WHERE identifier = @SteamId AND id = @id", {['@SteamId'] = DataPlayers[source].SteamId , ['@id'] = index })
          defaultNotification.message = "Vous avez bien déposé un chèque de "..cheque.montant.." € sur votre compte bancaire."
          TriggerClientEvent('Venato:notify', source, defaultNotification)
          DataPlayers[source].Documents[tonumber(index)] = nil
        else
          TriggerClientEvent('Venato:notifyError', source, "Il s'emblerait que ce soit un chèque en bois, le transfère a été refusé pour solde insuffisant.")
        end
      else
        TriggerClientEvent('Venato:notifyError', source, "Il s'emblerait que ce chèque soit un faux, aucun numero de compte ne correspond à ce dernier.")
      end
    end)
  end
end)

RegisterNetEvent("Bank:cancelCheque")
AddEventHandler("Bank:cancelCheque", function(index)
	local source = source
  MySQL.Async.execute("DELETE FROM user_document WHERE identifier = @SteamId AND id = @id", {['@SteamId'] = DataPlayers[source].SteamId , ['@id'] = index })
  TriggerClientEvent('Venato:notify', source, 'Vous avez bien <span class="red--text">annulé</span> un chèque de '..DataPlayers[source].Documents[index].montant.." €.","success")
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

function CheckPlafondDepot(source)
    MySQL.Async.fetchAll("SELECT SUM(montant) as montant FROM bank_transactions WHERE identifier = @SteamId and isDepot = 1 AND date BETWEEN DATE_ADD(CURRENT_DATE, INTERVAL -1 MONTH) AND DATE_ADD(CURRENT_DATE, INTERVAL 1 MONTH)",{["@SteamId"] = DataPlayers[source].SteamId}, function(result)
      if result[1] ~= nil then
        if result[1].montant >= plafondDepot then
          BlockAccount(source)
          return false
        end
        return true
      end
      return true
    end)
end

function CheckPlafondRetrait(source, amount)
  MySQL.Async.fetchAll("SELECT SUM(montant) + @amount as montant FROM bank_transactions WHERE identifier = @SteamId and isDepot = 0 AND date BETWEEN DATE_ADD(CURRENT_DATE, INTERVAL -1 MONTH) AND DATE_ADD(CURRENT_DATE, INTERVAL 1 MONTH)",{["@SteamId"] = DataPlayers[source].SteamId, ["@amount"] = amount}, function(result)
    if result[1] ~= nil then
      if result[1].montant >= plafondDepot then
        return false
      end
      return true
    end
    return true
  end)
end

function BlockAccount(source)
  defaultNotification.message = "Votre compte est bloqué pour mouvement de fonds suspicieux. Rendez-vous au LSPD pour justifier ces mouvements et faire débloquer votre compte."
  defaultNotification.timeout = 5000
  TriggerClientEvent('Venato:notify', source, defaultNotification)
  MySQL.Async.execute('UPDATE users SET isBankAccountBlocked = 1 WHERE identifier = @SteamId', {["@SteamId"] = DataPlayers[source].SteamId})
  DataPlayers[source].IsBankAccountBlocked = true
  TriggerClientEvent("Bank:AccountIsBlocked:Set", source, true)

end
