-- ######## CONFIG ##############
local PoidMax = 20 -- Kg
--##############################

function getShops()
    local result = MySQL.Sync.fetchAll("SELECT * FROM shops WHERE enabled=1", {})
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
        'SELECT u.id as Id, u.identifier as Identifier, u.nom as Name '..
            'FROM shops s ' ..
            'INNER JOIN shop_manager m ON s.Id = m.ShopId '..
            'INNER JOIN users u ON u.Id = m.ManagerId '..
            'WHERE s.Id=@Id', {["@Id"] = shopId})
    for _, item in ipairs(resultManagers) do
        table.insert(managers, {
            ["Id"]=item.Id,
            ["Name"]=item.Name,
            ["Identifier"]=item.Identifier
        })
        isSupervisor = isSupervisor or steamId == item.Identifier
    end

    return managers, isSupervisor
end

function getShop(shopId, source)
    shop = {}
    shop.IsSupervisor = false
    shop.Items = {}
    shop.Managers = {}
    local result = MySQL.Sync.fetchAll(
        'SELECT s.Id, s.Name, s.Renamed, s.Supervised, it.id as ItemId, it.libelle as ItemName, c.Price as ItemPrice, c.Quantity as ItemQuantity, c.Id as ContentId '..
            'FROM shops s ' ..
            'INNER JOIN shop_inventory i ON s.InventoryID = i.Id '..
            'INNER JOIN shop_content c ON i.Id = c.InventoryId '..
            'INNER JOIN items it on c.ItemId = it.id '..
            'WHERE s.Id=@Id', {["@Id"] = shopId})
    for _, item in ipairs(result) do
        shop.Id = item.Id
        shop.Name = item.Name
        shop.Renamed = item.Renamed
        shop.Supervised = item.Supervised
        table.insert(shop.Items, {
            ["Id"]=item.ItemId,
            ["Name"]=item.ItemName,
            ["Price"]=item.ItemPrice,
            ["Quantity"]=item.ItemQuantity,
            ["ContentId"]=item.ContentId,
        }) 
    end

    if shop.Supervised == 1 then
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
        return;
    elseif content.Quantity >= 0 and content.Quantity < quantity then
        TriggerClientEvent("Shops:NotEnoughQuantity", source, content.Libelle)
        return;
    elseif PoidMax < (DataPlayers[source].Poid + totalPoid) then
        TriggerClientEvent("Shops:TooHeavy", source, content.Libelle)
        return;
    else
        print("Give item to player")
        TriggerEvent("Inventory:AddItem", quantity, content.ItemId, source)
        if content.Quantity > 0 then
            print("Remove item from stock")
            TriggerEvent("Shops:RemoveItem", quantity, item.ContentId)
        end

        print("Remove money from player")
        TriggerEvent("Inventory:RemoveMoney", totalPrice, source)
        print("Add money to shop")
        TriggerEvent("Shops:AddMoney", totalPrice, shopId)
        print("Notify client it's OK")
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
