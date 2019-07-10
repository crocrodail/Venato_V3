-- ######## CONFIG ##############
local PoidMax = 20 -- Kg
--##############################

function getShops()
    local result = MySQL.Sync.fetchAll("SELECT * FROM shops WHERE Enabled=1", {})
    return result or {}
end

RegisterServerEvent('Shops:LoadShops')
AddEventHandler('Shops:LoadShops', function()
    TriggerClientEvent("Shops:LoadShops:cb", source, getShops())
end)

function getManagers(shopId, source)
    local managers = {}
    local isSupervisor = false

    local steamId = getSteamID(source)
    local resultManagers = MySQL.Sync.fetchAll(
        'SELECT u.id, u.identifier, u.nom '..
            'FROM shops s ' ..
            'INNER JOIN shop_manager m ON s.Id = m.ShopId '..
            'INNER JOIN users u ON u.Id = m.ManagerId '..
            'WHERE s.Id=@Id', {["@Id"] = shopId})
    for _, item in ipairs(resultManagers) do
        table.insert(managers, {
            ["Id"]=item.id,
            ["Name"]=item.nom,
            ["Identifier"]=item.identifier
        })
        isSupervisor = isSupervisor or steamId == item.identifier
    end

    return managers, isSupervisor
end

function getShop(shopId, source)
    shop = {}
    shop.IsSupervisor = false
    shop.Items = {}
    shop.Managers = {}
    local result = MySQL.Sync.fetchAll(
        'SELECT s.Id, s.Name, s.Renamed, s.Money, s.Supervised, it.id as ItemId, it.libelle as ItemName, c.Price as ItemPrice, c.Quantity as ItemQuantity, c.Id as ContentId '..
            'FROM shops s ' ..
            'INNER JOIN shop_inventory i ON s.InventoryID = i.Id '..
            'INNER JOIN shop_content c ON i.Id = c.InventoryId '..
            'INNER JOIN items it on c.ItemId = it.id '..
            'WHERE s.Id=@Id', {["@Id"] = shopId})
    for _, item in ipairs(result) do
        shop.Id = item.Id
        shop.Name = item.Name
        shop.Renamed = item.Renamed
        shop.Money = item.Money
        shop.Supervised = item.Supervised
        table.insert(shop.Items, {
            ["Id"]=item.ItemId,
            ["Name"]=item.ItemName,
            ["Price"]=item.ItemPrice,
            ["Quantity"]=item.ItemQuantity,
            ["ContentId"]=item.ContentId,
        }) 
    end

    if shop.Supervised then
        shop.Managers, shop.IsSupervisor = getManagers(shopId, source)
    end

    return shop
end

RegisterServerEvent('Shops:ShowInventory')
AddEventHandler('Shops:ShowInventory', function(shopName)
    TriggerClientEvent("Shops:ShowInventory:cb", source, getShop(shopName, source))
end)


RegisterServerEvent('Shops:TestBuy')
AddEventHandler('Shops:TestBuy', function(item, shopId, quantity, NewSource)
	local source = source
	if NewSource ~= nil then
		source = NewSource
    end
    local result = MySQL.Sync.fetchAll(
        'SELECT c.Quantity as Quantity, c.Price as Price, c.ItemId as ItemId, it.poid as Poid, it.libelle as Libelle '..
            'FROM shop_content c '..
            'INNER JOIN items it on c.ItemId = it.id '..
            'WHERE c.Id=@Id', {["@Id"] = item.ContentId})
    if result[1] == nil then return end
    content = result[1]

    quantity = quantity or 1
    local totalPrice = quantity * content.Price
    local totalPoid = quantity * content.Poid

    if totalPrice > DataPlayers[source].Money then
        TriggerClientEvent("Shops:NotEnoughMoney", source, content.Libelle)
    elseif content.Quantity >= 0 and content.Quantity < quantity then
        TriggerClientEvent("Shops:NotEnoughQuantity", source, content.Libelle)
    elseif PoidMax < (DataPlayers[source].Poid + totalPoid) then
        TriggerClientEvent("Shops:TooHeavy", source, content.Libelle)
    else
        print("Give item to player")
        TriggerEvent("Inventory:AddItem", quantity, content.ItemId, source)
        if content.Quantity > 0 then
            print("Remove item from stock")
            TriggerEvent("Shops:RemoveItem", quantity, item.ContentId)
        end

        TriggerEvent("Inventory:RemoveMoney", totalPrice, source)
        TriggerEvent("Shops:AddMoney", totalPrice, shopId)
        TriggerClientEvent("Shops:TestBuy:cb", source, content.Libelle)
    end
end)


RegisterServerEvent('Shops:RemoveItem')
AddEventHandler('Shops:RemoveItem', function(quantity, contentId)
    MySQL.Async.execute('UPDATE shop_content SET Quantity = Quantity - @Quantity WHERE Id=@Id', {["@Quantity"]=quantity, ["@Id"]=contentId})
end)


RegisterServerEvent('Shops:AddMoney')
AddEventHandler('Shops:AddMoney', function(price, shopId)
    MySQL.Async.execute('UPDATE shops SET Money = Money + @Price WHERE Id=@Id', {["@Price"]=price, ["@Id"]=shopId})
end)

RegisterServerEvent('Shops:RemoveMoney')
AddEventHandler('Shops:RemoveMoney', function(price, shopId)
    MySQL.Async.execute('UPDATE shops SET Money = Money - @Price WHERE Id=@Id', {["@Price"]=price, ["@Id"]=shopId})
end)

RegisterServerEvent('Shops:getMoney')
AddEventHandler('Shops:getMoney', function(price, shopId, NewSource)
	local source = source
	if NewSource ~= nil then
		source = NewSource
    end
    local shop = getShop(shopId, source)
    print('Try to get money from shop ('..shopId..'): '..price)
    print('Player isn\'t authorized? '..tostring(not shop.IsSupervisor))
    print('Shop hasn\'t enough money? '..tostring(shop.Money < price))
    if not shop.IsSupervisor or shop.Money < price then
        print('Not enough: '..source.." "..price)
        TriggerClientEvent("Shops:NotEnoughShopMoney", source, price)
    else
        TriggerEvent("Inventory:AddMoney", price, source)
        TriggerEvent("Shops:RemoveMoney", price, shopId)
        TriggerClientEvent("Shops:getMoney:cb", source, price)
    end
end)
