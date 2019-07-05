function getShops()
    local result = MySQL.Sync.fetchAll("SELECT * FROM shops", {})
    return result or {}
end

RegisterServerEvent('Shops:LoadShops')
AddEventHandler('Shops:LoadShops', function()
    TriggerClientEvent("Shops:LoadShops:cb", source, getShops())
end)

function getShop(shopName)
    shop = {}
    shop.Items = {}
    local result = MySQL.Sync.fetchAll(
        'SELECT s.Id, s.Name, it.id as ItemId, it.libelle as ItemName, c.Price as ItemPrice, c.Quantity as ItemQuantity '..
            'FROM shops s ' ..
            'INNER JOIN shop_inventory i ON s.InventoryID = i.Id '..
            'INNER JOIN shop_content c ON i.Id = c.InventoryId '..
            'INNER JOIN items it on c.ItemId = it.id '..
            'WHERE s.Name=@Name', {["@Name"] = shopName})
    for _, item in ipairs(result) do
        shop.Id = item.Id
        shop.Name = item.Name
        table.insert(shop.Items, {
            ["Id"]=item.ItemId,
            ["Name"]=item.ItemName,
            ["Price"]=item.ItemPrice,
            ["Quantity"]=item.ItemQuantity,
        }) 
    end
    return shop
end

RegisterServerEvent('Shops:ShowInventory')
AddEventHandler('Shops:ShowInventory', function(shopName)
    TriggerClientEvent("Shops:ShowInventory:cb", source, getShop(shopName))
end)


RegisterServerEvent('Shops:TestBuy')
AddEventHandler('Shops:TestBuy', function(itemId, price, quantity)
    if price > DataPlayers[source].Money then
        TriggerClientEvent("Shops:NotEnoughMoney")
        return;
    end


    TriggerEvent("Inventory:RemoveMoney", price, source)
    TriggerEvent("Inventory:AddItem", quantity, itemId)
end)
