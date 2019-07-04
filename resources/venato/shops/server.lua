RegisterServerEvent('Shops:LoadShops')
AddEventHandler('Shops:LoadShops', function()
	local shops = {}
    MySQL.Async.fetchAll("SELECT * FROM shops", {}, function(result)
        for i,v in ipairs(result) do
            shops[v.Id] = v
        end
	end)
	TriggerClientEvent("Shops:LoadShops:cb", source, shops)
end)

RegisterServerEvent('Shops:ShowInventory')
AddEventHandler('Shops:ShowInventory', function(shopName)
	local shop = MySQL.Async.fetchScalar("SELECT * FROM shops WHERE Name = @Name", {["@Name"] = shopName})
	TriggerClientEvent("Shops:ShowInventory:cb", source, shop)
end)