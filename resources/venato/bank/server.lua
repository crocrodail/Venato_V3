local defaultNotification = {
  title ="Information",
  source = "Venato Bank",
  logo = "https://i.ibb.co/0V3MVZn/venato-bank-icon-48.png"
}

local plafondDepot = 15000
local plafondRetrait = 10000

local transactionType = {
  retrait = 0,
  depot = 1,
  encaisseCheque = 2,
  emitCheque = 3,
  encaisseChequeBois = 4,
  emitChequeBois = 5,
  createAccount = 6,
  buyCard = 7,
  buyCheque = 8,
  blockAccount = 9,
  getPayment = 10,
  payment = 11,
  virementIn = 12,
  virementOut = 13
}

RegisterServerEvent('Bank:GetDataMoneyForATM')
AddEventHandler('Bank:GetDataMoneyForATM', function()
  local godDamn = false
	for k,v in pairs(DataPlayers[tonumber(source)].Inventaire) do
    if tonumber(k) == 41 then
      godDamn = true
    end
  end
  if godDamn then
    TriggerClientEvent("Bank:GetDataMoneyForATM:cb", source, DataPlayers[tonumber(source)])
  else
    defaultNotification.message = "Vous n'avez pas de carte bancaire."
    TriggerClientEvent('venato:notify', source, defaultNotification)
  end
end)

RegisterServerEvent('Bank:GetDataMoneyForBank')
AddEventHandler('Bank:GetDataMoneyForBank', function()
  TriggerClientEvent("Bank:GetDataMoneyForBank:cb", source, DataPlayers[tonumber(source)])
end)


RegisterServerEvent('Bank:insert')
AddEventHandler('Bank:insert', function(amount)
	local source = source
	amount = round(tonumber(amount),0)
	if amount <= 0 or amount > DataPlayers[tonumber(source)].Money then
    defaultNotification.message = 'Le montant entré est incorrect.'
    TriggerClientEvent('venato:notify', source, defaultNotification)
	else
    TriggerEvent("Bank:AddBankMoney", amount, source)
    TriggerEvent("Inventory:RemoveMoney", amount, source)
    defaultNotification.message = 'Vous avez déposé <span class="green--text">' .. amount .. ' €</span>'
    TriggerClientEvent('venato:notify', source, defaultNotification)
    MySQL.Async.execute('INSERT INTO bank_transactions(identifier,transactionType,montant) VALUES (@SteamId,@transactionType,@amount)', {["@SteamId"] = DataPlayers[tonumber(source)].SteamId, ["@transactionType"] = transactionType.depot, ["@amount"] = amount}, function()
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
	accountMoney = DataPlayers[tonumber(source)].Bank
	if amount <= 0 or amount > accountMoney then
    defaultNotification.message = 'Le montant entré est incorrect.'
    TriggerClientEvent('venato:notify', source, defaultNotification)
  else
      if CheckPlafondRetrait(source, amount) == true then
        MySQL.Async.execute('INSERT INTO bank_transactions(identifier,transactionType,montant) VALUES (@SteamId,@transactionType,@amount)', {["@SteamId"] = DataPlayers[tonumber(source)].SteamId, ["@transactionType"] = transactionType.retrait,["@amount"] = amount}, function()
          TriggerEvent("Bank:RemoveBankMoney", amount, source)
          TriggerEvent("Inventory:AddMoney", amount, source)
          defaultNotification.message = 'Vous avez retiré <span class="green--text">' .. amount .. ' €</span> '
          TriggerClientEvent('venato:notify', source, defaultNotification)
        end)
      else
        MySQL.Async.execute('INSERT INTO bank_transactions(identifier,transactionType,montant, description) VALUES (@SteamId,@transactionType,@amount, @description)', {["@SteamId"] = DataPlayers[tonumber(source)].SteamId, ["@transactionType"] = transactionType.blockAccount,["@amount"] = amount, ["@description"] = "Tentative de retrait de "..amount.."€. Plafond dépassé, compte bloqué."})
        defaultNotification.message = "Vous avez dépassé votre plafond vous ne pouvez pas retirer d'argent pour le moment."
        TriggerClientEvent('venato:notify', source, defaultNotification)
      end
	end
end)

RegisterServerEvent('Bank:transfer')
AddEventHandler('Bank:transfer', function(amount, receiver)
  local source = source
  if tonumber(amount) <= 0 then
    defaultNotification.message = 'Le montant entré est incorrect.'
    TriggerClientEvent('venato:notify', source, defaultNotification)
    return
  else
    MySQL.Async.fetchAll('SELECT * FROM users WHERE account = @account', {['@account'] = receiver}, function (result)
      if (result[1] ~= nil) then
        local recPlayer    = result[1].source
        local recPlayerBank = result[1].bank
        local amount       = tonumber(amount)
        local accountMoney = DataPlayers[tonumber(source)].Bank

        if amount >= accountMoney then
          defaultNotification.message = 'Vous n\'avez pas les fond suffisant pour faire ce virement'
          TriggerClientEvent('venato:notify', source, defaultNotification)
        else
          TriggerEvent("Bank:RemoveBankMoney", amount, source)
          
          if DataPlayers[recPlayer] ~= nil then
            TriggerEvent("Bank:AddBankMoney", amount, recPlayer)
          else
            MySQL.Async.execute('UPDATE users SET bank = @Money WHERE identifier = @SteamId', {["@SteamId"] = result[1].identifier, ["@Money"] = recPlayerBank + amount})
          end

          MySQL.Async.execute('INSERT INTO bank_transactions(identifier,transactionType,montant, description) VALUES (@SteamId,@transactionType,@amount, @description)', {["@SteamId"] = DataPlayers[tonumber(source)].SteamId, ["@transactionType"] = transactionType.virementOut,["@amount"] = amount, ["@description"] = "Virement à "..result[1].prenom.." ".. result[1].nom.."."})
          MySQL.Async.execute('INSERT INTO bank_transactions(identifier,transactionType,montant, description) VALUES (@SteamId,@transactionType,@amount, @description)', {["@SteamId"] = result[1].identifier, ["@transactionType"] = transactionType.virementIn,["@amount"] = amount, ["@description"] = "Virement de "..DataPlayers[tonumber(source)].Prenom.." ".. DataPlayers[tonumber(source)].Nom.."."})

          defaultNotification.message = 'Vous avez envoyé <span class="green--text">' .. amount .. ' €</span> à ' .. result[1].prenom .. ' ' .. result[1].nom
          TriggerClientEvent('venato:notify', source, defaultNotification)
          
          defaultNotification.message = 'Vous avez reçu <span class="green--text">' .. amount .. ' €</span> de la part de ' .. DataPlayers[tonumber(source)].Prenom .. ' ' .. DataPlayers[tonumber(source)].Nom
          TriggerClientEvent('venato:notify', recPlayer, defaultNotification)
        end
      else
        TriggerClientEvent('venato:notifyError', source, "Le numéro de compte renseigné est erroné.")
        TriggerClientEvent("Bank:ActuSoldeErrone", source, DataPlayers[tonumber(source)])
      end
    end)
  end
end)

RegisterServerEvent('Bank:createAccount')
AddEventHandler('Bank:createAccount', function()
  
  if DataPlayers[tonumber(source)].Bank <= 1000 then
    venato.notifyError("Vous n'avez pas les fonds nécessaires pour créé votre compte.")
    return;
  end
  TriggerEvent("Bank:RemoveBankMoney", 1000, source)

  math.randomseed(math.floor(os.time() + math.random(1000)))
  local source = source
  local lettre = string.sub (DataPlayers[tonumber(source)].Nom, 1,1)..""..string.sub (DataPlayers[tonumber(source)].Prenom, 1,1)
  local account = lettre..''..math.random(00,99) .. '-VnT-'.. math.random(000,999)
  DataPlayers[tonumber(source)].Account = account
  MySQL.Async.execute("UPDATE users SET account=@account WHERE identifier=@identifier", {["@account"]=account, ["@identifier"]=DataPlayers[tonumber(source)].SteamId})
  defaultNotification.message = 'Le compte <span class="blue--text">'..account..'</span> de '..DataPlayers[tonumber(source)].Nom..' '..DataPlayers[tonumber(source)].Prenom.." a bien été ouvert."
  TriggerClientEvent('venato:notify', source, defaultNotification)
  MySQL.Async.execute('INSERT INTO bank_transactions(identifier,transactionType,montant) VALUES (@SteamId, @transactionType, @amount)', {["@SteamId"] = DataPlayers[tonumber(source)].SteamId, ["@transactionType"] = transactionType.createAccount,["@amount"] = 1000})

end)


RegisterServerEvent('Bank:createCard')
AddEventHandler('Bank:createCard', function()
  
  if DataPlayers[tonumber(source)].Bank <= 1000 then
    venato.notifyError("Vous n'avez pas les fonds nécessaires pour commander une carte bleue.")
    return;
  end
  TriggerEvent("Bank:RemoveBankMoney", 1000, source)

  math.randomseed(math.floor(os.time() + math.random(1000)))
  local source = source
  local code = math.random(1000,9999)
  DataPlayers[tonumber(source)].Code = code
  MySQL.Async.execute("UPDATE users SET code=@code WHERE identifier=@identifier", {["@code"]=code, ["@identifier"]=DataPlayers[tonumber(source)].SteamId})
  TriggerEvent("Inventory:AddItem", 1, 41, source)  
  defaultNotification.message = 'Vous avez reçu votre carte, le code confidentiel à retenir est : <span class="red--text headline">'..code..'</span>.'
  defaultNotification.timeout = 15000
  TriggerClientEvent('venato:notify', source, defaultNotification)
  defaultNotification.timeout = nil
  
  MySQL.Async.execute('INSERT INTO bank_transactions(identifier,transactionType,montant, description) VALUES (@SteamId,@transactionType,@amount, @description)', {["@SteamId"] = DataPlayers[tonumber(source)].SteamId, ["@transactionType"] = transactionType.buyCard,["@amount"] = 1000, ["@description"] = "Achat d'une carte de crédit."})  
end)

RegisterServerEvent('Bank:createCheque')
AddEventHandler('Bank:createCheque', function()
  local source = source
  if DataPlayers[tonumber(source)].Bank <= 1000 then
    venato.notifyError("Vous n'avez pas les fonds nécessaires pour acheter un chéquier.")
    return;
  end

  TriggerEvent("Bank:RemoveBankMoney", 1000, source)

  MySQL.Async.fetchAll('SELECT montant as nbCheque FROM user_document WHERE identifier = @steamId and type = \'chequier\'', {['@steamId'] = DataPlayers[tonumber(source)].SteamId}, function (result)
    local createCheque = true
    if (result[1] ~= nil) then
      if (result[1].nbCheque > 0) then
        createCheque = false
        local newNbCheque = result[1].nbCheque +5
        MySQL.Async.execute("UPDATE user_document SET montant = @nbCheque WHERE identifier = @identifier AND type = \'chequier\'", {["@identifier"]=DataPlayers[tonumber(source)].SteamId, ["@nbCheque"]=newNbCheque}, function()
          defaultNotification.message = "Vous avez bien reçu un carnet de 5 cheques."
          TriggerClientEvent('venato:notify', source, defaultNotification)    
          MySQL.Async.fetchScalar("SELECT id FROM user_document WHERE identifier = @identifier ORDER BY id DESC", {['@identifier'] = DataPlayers[tonumber(source)].SteamId}, function(result)
            DataPlayers[tonumber(source)].Documents[result] = {["type"] = "chequier", ["montant"] = newNbCheque}
          end)        
        end)
      end
    end

    if createCheque then
      MySQL.Async.execute("INSERT INTO user_document (`identifier`, `type`, `montant`) VALUES (@identifier, @type, @montant )", {["@identifier"]=DataPlayers[tonumber(source)].SteamId, ["@type"]="chequier", ["@montant"]=5}, function()
        defaultNotification.message = "Vous avez bien reçu un carnet de 5 cheques."
        TriggerClientEvent('venato:notify', source, defaultNotification)    
        MySQL.Async.fetchScalar("SELECT id FROM user_document WHERE identifier = @identifier ORDER BY id DESC", {['@identifier'] = DataPlayers[tonumber(source)].SteamId}, function(result)
          DataPlayers[tonumber(source)].Documents[result] = {["type"] = "chequier", ["montant"] = 5}
        end)        
      end)
    end
  end)
  MySQL.Async.execute('INSERT INTO bank_transactions(identifier,transactionType,montant, description) VALUES (@SteamId,@transactionType,@amount, @description)', {["@SteamId"] = DataPlayers[tonumber(source)].SteamId, ["@transactionType"] = transactionType.buyCheque,["@amount"] = 1000, ["@description"] = "Achat d'un carnet de 5 chèques."})  
end)


RegisterNetEvent("Bank:DepotCheque")
AddEventHandler("Bank:DepotCheque", function(index)
  local source = source
  local cheque = DataPlayers[tonumber(source)].Documents[tonumber(index)]
  if cheque.numeroDeCompte == "Entreprise" then
    TriggerEvent("Bank:AddBankMoney", cheque.montant, source)
    MySQL.Async.execute("DELETE FROM user_document WHERE identifier = @SteamId AND id = @id", {['@SteamId'] = DataPlayers[tonumber(source)].SteamId , ['@id'] = index })
    defaultNotification.message = "Vous avez bien déposé un chèque de "..cheque.montant.." € sur votre compte bancaire."
    TriggerClientEvent('venato:notify', source, defaultNotification)
    DataPlayers[tonumber(source)].Documents[tonumber(index)] = nil
    MySQL.Async.execute('INSERT INTO bank_transactions(identifier,transactionType,montant, description) VALUES (@SteamId,@transactionType,@amount, @description)', {["@SteamId"] = DataPlayers[tonumber(source)].SteamId, ["@transactionType"] = transactionType.encaisseCheque,["@amount"] = cheque.montant, ["@description"] = "Encaissement chèque entreprise."})
  else
    MySQL.Async.fetchAll("SELECT * FROM users WHERE account = @account",{["@account"]=cheque.numeroDeCompte}, function(result)
      if result[1] ~= nil then
        if tonumber(result[1].bank) >= tonumber(cheque.montant) then
          if result[1].source ~= 'disconnect' then
            TriggerEvent("Bank:RemoveBankMoney", cheque.montant, result[1].source)
            defaultNotification.message = "Votre chèque de "..cheque.montant.." € a été encaissé par "..DataPlayers[tonumber(source)].Prenom .. " " .. DataPlayers[tonumber(source)].Nom
            TriggerClientEvent('venato:notify', result[1].source, defaultNotification)
          else            
            MySQL.Async.execute('UPDATE users SET bank= @Money WHERE identifier = @SteamId', {["@SteamId"] = result[1].identifier, ["@Money"] = tonumber(result[1].bank)-tonumber(cheque.montant)})
          end
          
          TriggerEvent("Bank:AddBankMoney", tonumber(cheque.montant), source)
          defaultNotification.message = "Vous avez bien déposé un chèque de "..cheque.montant.." € sur votre compte bancaire."
          TriggerClientEvent('venato:notify', source, defaultNotification)
          
          MySQL.Async.execute('INSERT INTO bank_transactions(identifier,transactionType,montant, description) VALUES (@SteamId,@transactionType,@amount, @description)', {["@SteamId"] = DataPlayers[tonumber(source)].SteamId, ["@transactionType"] = transactionType.encaisseCheque,["@amount"] = cheque.montant, ["@description"] = "Chèque venant de  "..result[1].prenom .. " " .. result[1].nom..": encaissé."})
          MySQL.Async.execute('INSERT INTO bank_transactions(identifier,transactionType,montant, description) VALUES (@SteamId,@transactionType,@amount, @description)', {["@SteamId"] = result[1].identifier, ["@transactionType"] = transactionType.emitCheque,["@amount"] = cheque.montant, ["@description"] = "Chèque à destination de  "..DataPlayers[tonumber(source)].Prenom .. " " .. DataPlayers[tonumber(source)].Nom..": encaissé."})
          
        else
          TriggerClientEvent('venato:notifyError', source, "Il semblerait que ce soit un chèque en bois, le transfert a été refusé pour solde insuffisant.")          
          MySQL.Async.execute('UPDATE users SET isBankAccountBlocked = 1 WHERE identifier = @SteamId', {["@SteamId"] = result[1].identifier, ["@Money"] = tonumber(result[1].bank)-tonumber(cheque.montant)})
          MySQL.Async.execute('INSERT INTO bank_transactions(identifier,transactionType,montant, description) VALUES (@SteamId,@transactionType,@amount, @description)', {["@SteamId"] = result[1].identifier, ["@transactionType"] = transactionType.emitChequeBois,["@amount"] = cheque.montant, ["@description"] = "Chèque pour "..DataPlayers[tonumber(source)].Prenom .. " " .. DataPlayers[tonumber(source)].Nom..": refusé pour solde insufisant."})
          MySQL.Async.execute('INSERT INTO bank_transactions(identifier,transactionType,montant, description) VALUES (@SteamId,@transactionType,@amount, @description)', {["@SteamId"] = result[1].identifier, ["@transactionType"] = transactionType.blockAccount,["@amount"] = 0, ["@description"] = "Blocage du compte pour chèque en bois."})
          MySQL.Async.execute('INSERT INTO bank_transactions(identifier,transactionType,montant, description) VALUES (@SteamId,@transactionType,@amount, @description)', {["@SteamId"] = DataPlayers[tonumber(source)].SteamId, ["@transactionType"] = transactionType.encaisseChequeBois,["@amount"] = cheque.montant, ["@description"] = "Chèque venant de  "..result[1].prenom .. " " ..result[1].nom ..": refusé pour solde insufisant."})
          if result[1].source ~= 'disconnect' then
            defaultNotification.message = "Votre chèque de "..cheque.montant.." € pour "..DataPlayers[tonumber(source)].Prenom .. " " .. DataPlayers[tonumber(source)].Nom .. "n'a pas pu être encaissé pour cause de solde insufisant.<br/> Votre compte est donc <span class='red--text'>bloqué</span>. Rendez vous au <class='yellow--text'>LSPD</span> pour régulariser votre situation."
            TriggerClientEvent('venato:notify', result[1].source, defaultNotification)
          end
        end
      else
        TriggerClientEvent('venato:notifyError', source, "Il semblerait que ce chèque soit un faux, aucun numero de compte ne correspond à ce dernier.")
        MySQL.Async.execute('INSERT INTO bank_transactions(identifier,transactionType,montant, description) VALUES (@SteamId,@transactionType,@amount, @description)', {["@SteamId"] = DataPlayers[tonumber(source)].SteamId, ["@transactionType"] = transactionType.encaisseChequeBois,["@amount"] = cheque.montant, ["@description"] = "Encaissement chèque avec numéro de compte inconnu : "..cheque.numeroDeCompte.."."})
       
      end
      DataPlayers[tonumber(source)].Documents[tonumber(index)] = nil
      MySQL.Async.execute("DELETE FROM user_document WHERE identifier = @SteamId AND id = @id", {['@SteamId'] = DataPlayers[tonumber(source)].SteamId , ['@id'] = index })      
    end)
  end
end)


RegisterNetEvent("Bank:cancelCheque")
AddEventHandler("Bank:cancelCheque", function(index)
	local source = source
  MySQL.Async.execute("DELETE FROM user_document WHERE identifier = @SteamId AND id = @id", {['@SteamId'] = DataPlayers[tonumber(source)].SteamId , ['@id'] = index })
  TriggerClientEvent('venato:notify', source, 'Vous avez bien <span class="red--text">annulé</span> un chèque de '..DataPlayers[tonumber(source)].Documents[index].montant.." €.","success")
  DataPlayers[tonumber(source)].Documents[index] = nil
end)

RegisterNetEvent("Bank:AddBankMoney")
AddEventHandler("Bank:AddBankMoney", function(qty, NewSource)
	local source = source
	local qty = tonumber(qty)
	if NewSource ~= nil then
		source = NewSource
	end
	local new = DataPlayers[tonumber(source)].Bank + qty
	DataPlayers[tonumber(source)].Bank = new
  TriggerClientEvent("gcphone:updateBank", source, new)
  MySQL.Async.execute('UPDATE users SET bank = @Money WHERE identifier = @SteamId', {["@SteamId"] = DataPlayers[tonumber(source)].SteamId, ["@Money"] = new})
end)

RegisterNetEvent("Bank:Salaire")
AddEventHandler("Bank:Salaire", function(qty, metier)
  local source = source
  MySQL.Async.execute('INSERT INTO bank_transactions(identifier,transactionType,montant, description) VALUES (@SteamId,@transactionType,@amount, @description)', {["@SteamId"] = DataPlayers[tonumber(source)].SteamId, ["@transactionType"] = transactionType.getPayment, ["@amount"] = qty, ["@description"] = "Paiement reçu "..metier.." : "..qty.."€."})
  TriggerEvent("Bank:AddBankMoney", qty, source)
end)

RegisterNetEvent("Bank:RemoveBankMoney")
AddEventHandler("Bank:RemoveBankMoney", function(qty, NewSource)
	local source = source
	local qty = tonumber(qty)
	if NewSource ~= nil then
		source = NewSource
	end
	local new = DataPlayers[tonumber(source)].Bank - qty
	DataPlayers[tonumber(source)].Bank = new
  TriggerClientEvent("gcphone:updateBank", source, new)	  
  MySQL.Async.execute('UPDATE users SET bank = @Money WHERE identifier = @SteamId', {["@SteamId"] = DataPlayers[tonumber(source)].SteamId, ["@Money"] = new})
end)

RegisterNetEvent("Bank:SetBankMoney")
AddEventHandler("Bank:SetBankMoney", function(qty, NewSource)
	local source = source
	local qty = qty
	if NewSource ~= nil then
		source = NewSource
	end
	local new = qty
	DataPlayers[tonumber(source)].Bank = new
  TriggerClientEvent("gcphone:updateBank", source, new)
	MySQL.Async.execute('UPDATE users SET bank = @Money WHERE identifier = @SteamId', {["@SteamId"] = DataPlayers[tonumber(source)].SteamId, ["@Money"] = new})
end)

function CheckPlafondDepot(source)
    MySQL.Async.fetchAll("SELECT SUM(montant) as montant FROM bank_transactions WHERE identifier = @SteamId and transactionType = 1 AND date BETWEEN DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY) AND DATE_ADD(CURRENT_DATE, INTERVAL 3 DAY)",{["@SteamId"] = DataPlayers[tonumber(source)].SteamId}, function(result)
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
  local result = MySQL.Sync.fetchAll("SELECT SUM(montant) as montant FROM bank_transactions WHERE identifier = @SteamId and transactionType = 0 AND date BETWEEN DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY) AND DATE_ADD(CURRENT_DATE, INTERVAL 3 DAY)",{["@SteamId"] = DataPlayers[tonumber(source)].SteamId })
  if result[1].montant ~= nil then
    if result[1].montant + amount <= plafondRetrait then
      return true
    end
    BlockAccount(source)
    return false
  end
  return true
end

function BlockAccount(source)
  defaultNotification.message = "Votre compte est bloqué pour mouvement de fonds suspicieux. Rendez-vous au LSPD pour justifier ces mouvements et faire débloquer votre compte."
  defaultNotification.timeout = 5000
  TriggerClientEvent('venato:notify', source, defaultNotification)
  MySQL.Async.execute('UPDATE users SET isBankAccountBlocked = 1 WHERE identifier = @SteamId', {["@SteamId"] = DataPlayers[tonumber(source)].SteamId})
  DataPlayers[tonumber(source)].IsBankAccountBlocked = true
  TriggerClientEvent("Bank:AccountIsBlocked:Set", source, true)

end
