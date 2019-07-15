-- ######## CONFIG ##############
local PoidMax = 20 -- Kg
--##############################

local getShopsRequest = 'SELECT * FROM shops WHERE Enabled=1'
local getShopRequest = 'SELECT s.Id, s.Name, s.Renamed, s.Money, s.Supervised FROM shops s WHERE s.Id=@Id'
local getShopItemsRequest = 'SELECT it.id, it.libelle, c.Price, c.Quantity, c.Id as ContentId FROM shops s INNER JOIN shop_inventory i ON s.InventoryID = i.Id INNER JOIN shop_content c ON i.Id = c.InventoryId INNER JOIN items it on c.ItemId = it.id WHERE s.Id=@Id'
local getShopOrdersRequest = 'SELECT o.Id, o.Ref, o.Started, o.Signed, o.Finalized FROM shops s INNER JOIN shop_orders o ON s.Id = o.ShopId WHERE s.Id=@Id ORDER BY o.Id DESC '
local getShopOrderRequest = 'SELECT o.Id, o.Ref, o.Signed, o.Started, o.Finalized FROM shop_orders o WHERE o.Id=@OrderId'
local getManagersRequest = 'SELECT u.id, u.identifier, u.nom FROM shops s INNER JOIN shop_manager m ON s.Id = m.ShopId INNER JOIN users u ON u.Id = m.ManagerId WHERE s.Id=@Id'
local getContentItemRequest = 'SELECT c.Quantity, c.Price, c.ItemId, it.poid, it.libelle FROM shop_content c INNER JOIN items it on c.ItemId = it.id WHERE c.Id=@Id'
local getOrderItemsRequest = 'SELECT it.id, it.libelle, c.Quantity, c.Price, oc.Quantity as Ordered FROM shop_orders o INNER JOIN shops s ON o.ShopID = s.Id INNER JOIN shop_inventory i ON s.InventoryID = i.Id INNER JOIN shop_content c ON i.Id = c.InventoryId INNER JOIN items it on c.ItemId = it.id LEFT JOIN shop_orders_content oc ON o.Id = oc.ShopOrderId and it.id = oc.ItemId WHERE o.Id=@OrderId'
local getOrderItemRequest = 'SELECT it.id, it.libelle, c.Quantity, c.Price, oc.Quantity as Ordered, oc.Price as OrderPrice FROM shops s INNER JOIN shop_inventory i ON s.InventoryID = i.Id INNER JOIN shop_content c ON i.Id = c.InventoryId INNER JOIN items it on c.ItemId = it.id LEFT JOIN shop_orders o ON s.Id = o.ShopId LEFT JOIN shop_orders_content oc ON o.Id = oc.ShopOrderId and it.id = oc.ItemId WHERE it.id=@ItemId and s.Id=@ShopId'
local getAllItemsRequest = 'SELECT it.id, it.libelle, it.price FROM items it'

local removeItemRequest = 'UPDATE shop_content SET Quantity = Quantity - @Quantity WHERE Id=@Id'
local addMoneyRequest = 'UPDATE shops SET Money = Money + @Price WHERE Id=@Id'
local removeMoneyRequest = 'UPDATE shops SET Money = Money - @Price WHERE Id=@Id'
local orderNewItemRequest = 'INSERT INTO shop_orders_content (ShopOrderId, ItemId, Quantity, Price) VALUES (@OrderId, @ItemId, @Quantity, @Price)'
local updateOrderItemRequest = 'UPDATE shop_orders_content SET Quantity=@Quantity WHERE ShopOrderId=@OrderId and ItemId=@ItemId'
local createOrderRequest = 'INSERT INTO shop_orders (ShopId, Ref) VALUES (@ShopId, @Ref)'
local finalizeOrderRequest = 'UPDATE shop_orders SET Finalized=1 WHERE Id=@OrderId'
local deleteOrderRequest = 'DELETE FROM shop_orders WHERE Id=@OrderId'

RegisterServerEvent('Shops:LoadShops')
AddEventHandler('Shops:LoadShops', function()
    TriggerClientEvent("Shops:LoadShops:cb", source, getShops())
end)

function getShops()
    local result = MySQL.Sync.fetchAll(getShopsRequest, {})
    return result or {}
end

function getManagers(shopId, source)
    local managers = {}
    local isSupervisor = false

    local steamId = getSteamID(source)
    local resultManagers = MySQL.Sync.fetchAll(getManagersRequest, {["@Id"] = shopId})
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
    local shop = {}
    shop.IsSupervisor = false
    shop.Items = {}
    shop.Orders = {}
    shop.Managers = {}
    local result = MySQL.Sync.fetchAll(getShopRequest, {["@Id"] = shopId})
    for _, item in ipairs(result) do
        shop.Id = item.Id
        shop.Name = item.Name
        shop.Renamed = item.Renamed
        shop.Money = item.Money
        shop.Supervised = item.Supervised
    end

    local result = MySQL.Sync.fetchAll(getShopItemsRequest, {["@Id"] = shopId})
    for _, item in ipairs(result) do
        table.insert(shop.Items, {
            ["Id"]=item.id,
            ["Name"]=item.libelle,
            ["Price"]=item.Price,
            ["Quantity"]=item.Quantity,
            ["ContentId"]=item.ContentId,
        }) 
    end

    local result = MySQL.Sync.fetchAll(getShopOrdersRequest, {["@Id"] = shopId})
    for _, item in ipairs(result) do
        table.insert(shop.Orders, {
            ["Id"]=item.Id,
            ["Ref"]=item.Ref,
            ["Started"]=item.Started,
            ["Signed"]=item.Signed,
            ["Finalized"]=item.Finalized
        })
    end

    if shop.Supervised then
        shop.Managers, shop.IsSupervisor = getManagers(shopId, source)
    end

    return shop
end

function getOrder(orderId)
    local order = {}
    order.Items = {}

    local result = MySQL.Sync.fetchAll(getShopOrderRequest, {["@OrderId"] = orderId})
    for _, item in ipairs(result) do
        order['Id'] = item.Id
        order['Ref'] = item.Ref
        order['Signed'] = item.Signed
        order['Started'] = item.Started
        order['Finalized'] = item.Finalized
    end

    local result = MySQL.Sync.fetchAll(getOrderItemsRequest, {["@OrderId"] = orderId})
    for _, item in ipairs(result) do
        table.insert(order.Items, {
            ['Id'] = item.id,
            ['Name'] = item.libelle,
            ['Quantity'] = item.Quantity,
            ['Price'] = item.Price,
            ['Ordered'] = item.Ordered
        })
    end

    return order
end

function getItem(args)
    local item = {}
    local result = MySQL.Sync.fetchAll(getOrderItemRequest, {["@ItemId"] = args.itemId, ["@ShopId"] = args.shopId})
    for _, item_ in ipairs(result) do
        item['Id'] = item_.id
        item['ShopId'] = item_.ShopId
        item['Name'] = item_.libelle
        item['Quantity'] = item_.Quantity
        item['Price'] = item_.Price
        item['Ordered'] = item_.Ordered
        item['OrderPrice'] = item_.OrderPrice or 0
    end

    return item
end

function getAllItems()
    local items = {}
    local result = MySQL.Sync.fetchAll(getAllItemsRequest)
    for _, item in ipairs(result) do
        table.insert(items, {
            ['Id'] = item.id,
            ['Name'] = item.libelle,
            ['Price'] = item.price
        })
    end

    return items
end

function getUsedItems(ContentId)
    local items = {}
    local result = MySQL.Sync.fetchAll(getShopItemsRequest, {["@Id"] = shopId})
    for _, item in ipairs(result) do
        table.insert(items, {
            ['Id'] = item.ItemId,
            ['Name'] = item.libelle
        })
    end

    return items
end

function getNotUsedItems(shopId)
    local items = {}
    local allItems = getAllItems()
    local usedItems = getUsedItems(shopId)

    for _, item in ipairs(allItems) do
        local notUsed = true
        for _, usedItem in ipairs(usedItems) do
            if item.Id == usedItem.Id then
                notUsed = false
                break
            end
        end
        if notUsed then
            table.insert(items, item)
        end
    end

    return items
end

RegisterServerEvent('Shops:ShowInventory')
AddEventHandler('Shops:ShowInventory', function(shopId)
    TriggerClientEvent("Shops:UpdateMenu:cb", source, getShop(shopId, source))
end)


RegisterServerEvent('Shops:TestBuy')
AddEventHandler('Shops:TestBuy', function(ContentId, shopId, quantity, NewSource)
	local source = source
	if NewSource ~= nil then
		source = NewSource
    end
    local result = MySQL.Sync.fetchAll(getContentItemRequest, {["@Id"] = ContentId})
    if result[1] == nil then return end
    local content = result[1]

    local quantity = quantity or 1
    local totalPrice = quantity * content.Price
    local totalPoid = quantity * content.poid

    if totalPrice > DataPlayers[source].Money then
        TriggerClientEvent("Shops:NotEnoughMoney", source, content.libelle)
    elseif content.Quantity >= 0 and content.Quantity < quantity then
        TriggerClientEvent("Shops:NotEnoughQuantity", source, content.libelle)
    elseif PoidMax < (DataPlayers[source].Poid + totalPoid) then
        TriggerClientEvent("Shops:TooHeavy", source, content.libelle)
    else
        TriggerEvent("Inventory:AddItem", quantity, content.ItemId, source)
        if content.Quantity > 0 then
            TriggerEvent("Shops:RemoveItem", quantity, ContentId)
        end

        TriggerEvent("Inventory:RemoveMoney", totalPrice, source)
        TriggerEvent("Shops:AddMoney", totalPrice, shopId)
        TriggerClientEvent("Shops:TestBuy:cb", source, content.libelle)
    end
end)


RegisterServerEvent('Shops:RemoveItem')
AddEventHandler('Shops:RemoveItem', function(quantity, contentId)
    MySQL.Async.execute(removeItemRequest, {["@Quantity"]=quantity, ["@Id"]=contentId})
end)


RegisterServerEvent('Shops:AddMoney')
AddEventHandler('Shops:AddMoney', function(price, shopId)
    MySQL.Async.execute(addMoneyRequest, {["@Price"]=price, ["@Id"]=shopId})
end)

RegisterServerEvent('Shops:RemoveMoney')
AddEventHandler('Shops:RemoveMoney', function(price, shopId)
    MySQL.Async.execute(removeMoneyRequest, {["@Price"]=price, ["@Id"]=shopId})
end)

RegisterServerEvent('Shops:getMoney')
AddEventHandler('Shops:getMoney', function(price, shopId, NewSource)
	local source = source
	if NewSource ~= nil then
		source = NewSource
    end
    local shop = getShop(shopId, source)
    if not shop.IsSupervisor or shop.Money < price then
        TriggerClientEvent("Shops:NotEnoughShopMoney", source, price)
    else
        TriggerEvent("Inventory:AddMoney", price, source)
        TriggerEvent("Shops:RemoveMoney", price, shopId)
        TriggerClientEvent("Shops:getMoney:cb", source, price)
    end
end)

RegisterServerEvent('Shops:showOrder')
AddEventHandler('Shops:showOrder', function(shopId)
    TriggerClientEvent("Shops:UpdateMenu:cb", source, getOrder(shopId))
end)

RegisterServerEvent('Shops:ShowItem')
AddEventHandler('Shops:ShowItem', function(args)
    TriggerClientEvent("Shops:UpdateMenu:cb", source, getItem(args))
end)

RegisterServerEvent('Shops:OrderItem')
AddEventHandler('Shops:OrderItem', function(orderId, item, quantity)
    local source = source
    if item.Ordered == nil then
        MySQL.Sync.execute(orderNewItemRequest,{["@OrderId"] = orderId, ["@ItemId"] = item.Id,["@Quantity"] = quantity, ["@Price"] = item.Price})
    else
        MySQL.Sync.execute(updateOrderItemRequest,{["@OrderId"] = orderId, ["@ItemId"] = item.Id, ["@Quantity"] = quantity})
    end
    TriggerClientEvent("Shops:OrderItem:cb", source, quantity, item.Name)
end)

RegisterServerEvent('Shops:CreateOrder')
AddEventHandler('Shops:CreateOrder', function(shopId)
    local source = source
	MySQL.Sync.execute(createOrderRequest, {["@ShopId"] = shopId, ["@Ref"] = uuid()})

    TriggerClientEvent("Shops:UpdateMenu:cb", source, getShop(shopId, source))
end)

RegisterServerEvent('Shops:FinalizeOrder')
AddEventHandler('Shops:FinalizeOrder', function(orderId, shopId)
    local source = source
	MySQL.Sync.execute(finalizeOrderRequest, {["@OrderId"] = orderId})
    TriggerClientEvent("Shops:UpdateMenu:cb", source, getShop(shopId, source))
end)

RegisterServerEvent('Shops:DeleteOrder')
AddEventHandler('Shops:DeleteOrder', function(orderId, shopId)
    local source = source
	MySQL.Sync.execute(deleteOrderRequest, {["@OrderId"] = orderId})
    TriggerClientEvent("Shops:UpdateMenu:cb", source, getShop(shopId, source))
end)

RegisterServerEvent('Shops:showAddItem')
AddEventHandler('Shops:showAddItem', function(shopId)
    local source = source
    TriggerClientEvent("Shops:UpdateMenu:cb", source, getNotUsedItems(shopId))
end)

local random = math.random
function uuid()
    local template ='xxx-xxx-xxx'
    return string.gsub(template, 'x', function (c)
        local v = random(0, 0xf)
        return string.format('%x', v)
    end)
end
