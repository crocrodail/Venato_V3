RegisterServerEvent('Bank:GetDataMoneyForATM')
AddEventHandler('Bank:GetDataMoneyForATM', function()
  TriggerClientEvent("Bank:GetDataMoneyForATM:cb", source, DataPlayers[source])
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
		print("JSFOUR-ATM: ERROR")
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
		print("JSFOUR-ATM: ERROR")
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

-- Create bank-account
RegisterServerEvent('jsfour-atm:createAccount')
AddEventHandler('jsfour-atm:createAccount', function( src )
  math.randomseed(math.floor(os.time() + math.random(1000)))

  local _source = source
  local identifier = nil

  if src == nil then
    identifier = ESX.GetPlayerFromId(_source).identifier
  else
    identifier = ESX.GetPlayerFromId(src).identifier
  end

  local account = '4272-2, ' .. math.random(0,9) .. ' ' .. math.random(000,999) .. ' ' .. math.random(000,999) .. '-' ..math.random(0,9)

  MySQL.Async.fetchAll('SELECT account FROM jsfour_atm WHERE account = @account', {['@account'] = account},
  function (result)
    if (result[1] == nil) then
      MySQL.Async.fetchAll('SELECT identifier FROM jsfour_atm WHERE identifier = @identifier', {['@identifier'] = identifier},
      function (result)
        if (result[1] == nil) then
          MySQL.Async.execute('INSERT INTO jsfour_atm (identifier, account) VALUES (@identifier, @account)',
            {
              ['@identifier']   = identifier,
              ['@account']      = account
            }
          )
        end
      end)
    else
      TriggerEvent('jsfour-atm:createAccount', _source)
    end
  end)
end)

-- Create card *NOT IN USE*
RegisterServerEvent('jsfour-atm:createCard')
AddEventHandler('jsfour-atm:createCard', function( src )
  math.randomseed(math.floor(os.time() + math.random(1000)))

  local _source = source
  local identifier

  if src == nil then
    identifier = ESX.GetPlayerFromId(_source).identifier
  else
    identifier = ESX.GetPlayerFromId(src).identifier
  end

  local number = math.random(0000000000000000,9999999999999999)
  local code = math.random(0000,9999)

  MySQL.Async.fetchAll('SELECT number FROM creditcard WHERE number = @number', {['@number'] = number},
  function (result)
    if (result[1] == nil) then
      MySQL.Async.execute('INSERT INTO creditcard (owner, number, code) VALUES (@owner, @number, @code)',
        {
          ['@owner']      = identifier,
          ['@number']     = number,
          ['@code']       = code
        }
      )
    else
      TriggerEvent('jsfour-atm:createCard', _source)
    end
  end)
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
	MySQL.Async.execute('UPDATE users SET bank = @Money WHERE identifier = @SteamId', {["@SteamId"] = DataPlayers[source].SteamId, ["@Money"] = new})
end)
