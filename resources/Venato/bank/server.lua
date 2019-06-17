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
