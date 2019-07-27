-- ============= --
--  DB requests  --
-- ============= --
ShopRequests = {}

-- Get all shops enabled
ShopRequests.getShops = "SELECT * FROM shops WHERE Enabled=1"
-- Get shop with id '@Id'
ShopRequests.getShop = "SELECT s.Id, s.Name, s.Renamed, s.Money, s.Supervised, s.InventoryId, s.ColorMenu, s .ImageMenu " ..
  "FROM shops s " ..
  "WHERE s.Id=@Id"
-- Get all stocks of shop with id '@Id'
ShopRequests.getShopItems = "SELECT it.id, it.libelle, c.Price, c.Quantity, c.Id as ContentId " ..
  "FROM shops s " ..
  "INNER JOIN shop_inventory i ON s.InventoryId = i.Id " ..
  "INNER JOIN shop_content c ON i.Id = c.InventoryId " ..
  "INNER JOIN items it on c.ItemId = it.id " ..
  "WHERE s.Id=@Id"

-- Get all orders of shop with id '@Id'
ShopRequests.getShopOrders = "SELECT o.Id, o.Ref, o.Started, o.Signed, o.Finalized " ..
  "FROM shops s " ..
  "INNER JOIN shop_orders o ON s.Id = o.ShopId " ..
  "WHERE s.Id=@Id " ..
  "ORDER BY o.Id DESC "
-- Get order with id '@OrderId'
ShopRequests.getShopOrder = "SELECT o.Id, o.Ref, o.Signed, o.Started, o.Finalized " ..
  "FROM shop_orders o " ..
  "WHERE o.Id=@OrderId"
-- Get all manager of shop with id '@Id'
ShopRequests.getManagers = "SELECT u.id, u.identifier, u.nom " ..
  "FROM shops s " ..
  "INNER JOIN shop_manager m ON s.Id = m.ShopId " ..
  "INNER JOIN users u ON u.Id = m.ManagerId " ..
  "WHERE s.Id=@Id"

-- Get item in the stock with id '@Id'
ShopRequests.getContentItem = "SELECT c.Quantity, c.Price, c.ItemId, it.poid, it.libelle " ..
  "FROM shop_content c " ..
  "INNER JOIN items it on c.ItemId = it.id " ..
  "WHERE c.Id=@Id"
-- Get item in the stock with "@ItemId" and "@ShopId"
ShopRequests.getStockItem = "SELECT it.id, it.libelle, c.Quantity, c.Price, c.Id as ContentId " ..
  "FROM shops s " ..
  "INNER JOIN shop_inventory i ON s.InventoryID = i.Id " ..
  "INNER JOIN shop_content c ON i.Id = c.InventoryId " ..
  "INNER JOIN items it on c.ItemId = it.id " ..
  "WHERE it.id=@ItemId and s.Id=@ShopId"
-- Get all items in the order with id '@OrderId'
ShopRequests.getOrderItems = "SELECT oc.Id, it.id as ItemId, it.libelle, c.Quantity, c.Price, oc.Quantity as Ordered " ..
  "FROM shop_orders o " ..
  "INNER JOIN shops s ON o.ShopID = s.Id " ..
  "INNER JOIN shop_inventory i ON s.InventoryId = i.Id " ..
  "INNER JOIN shop_content c ON i.Id = c.InventoryId " ..
  "INNER JOIN items it on c.ItemId = it.id " ..
  "LEFT JOIN shop_orders_content oc ON o.Id = oc.ShopOrderId and it.id = oc.ItemId " ..
  "WHERE o.Id=@OrderId"
-- Get remaining quantity of an item in stock with '@ContentId'
ShopRequests.getQuantityItemByContentId = "SELECT Quantity FROM shop_content WHERE Id=@ContentId"
-- Get orders count contains an item with '@ContentId'
ShopRequests.getOrdersCountWithContentId = "SELECT COUNT(*) as OrdersCount " ..
  "FROM shop_content c " ..
  "INNER JOIN shop_orders_content oc ON oc.ItemId = c.ItemId " ..
  "INNER JOIN shop_orders o ON o.Id = oc.ShopOrderId " ..
  "INNER JOIN shops s ON s.Id = o.ShopId and s.InventoryId = c.InventoryId " ..
  "WHERE c.Id=@ContentId"
-- Get item in the order with "@Id" and "@ShopId"
ShopRequests.getOrderItem = "SELECT oc.Id, it.id as ItemId, it.libelle, c.Quantity, c.Price, oc.Quantity as Ordered, oc.Price as OrderPrice " ..
  "FROM shops s " ..
  "INNER JOIN shop_inventory i ON s.InventoryID = i.Id " ..
  "INNER JOIN shop_content c ON i.Id = c.InventoryId " ..
  "INNER JOIN items it on c.ItemId = it.id " ..
  "LEFT JOIN shop_orders o ON s.Id = o.ShopId " ..
  "LEFT JOIN shop_orders_content oc ON o.Id = oc.ShopOrderId and it.id = oc.ItemId " ..
  "WHERE it.id=@Id and s.Id=@ShopId"
-- Get all available items
ShopRequests.getAllItems = "SELECT it.id, it.libelle, it.price FROM items it"

-- Add item in stock
ShopRequests.addItem = "INSERT shop_content (InventoryId, ItemId, Price, Quantity) VALUES (@InventoryId, @ItemId, @Price, @Quantity)"
-- Decrease the amount of an item in stock
ShopRequests.removeQuantityItem = "UPDATE shop_content SET Quantity = Quantity - @Quantity WHERE Id=@Id"
-- Update the price of an item in stock
ShopRequests.updatePriceItem = "UPDATE shop_content SET Price = @Price WHERE Id=@Id"

-- Increase the money of the shop
ShopRequests.addMoney = "UPDATE shops SET Money = Money + @Price WHERE Id=@Id"
-- Decrease the money of the shop
ShopRequests.removeMoney = "UPDATE shops SET Money = Money - @Price WHERE Id=@Id"

-- Add an item in an order
ShopRequests.orderNewItem = "INSERT INTO shop_orders_content (ShopOrderId, ItemId, Quantity, Price) VALUES (@OrderId, @ItemId, @Quantity, @Price)"
-- Update the amount of an item in an order
ShopRequests.updateQuantityOrderItem = "UPDATE shop_orders_content SET Quantity=@Quantity WHERE ShopOrderId=@OrderId and ItemId=@ItemId"

-- Create a new order
ShopRequests.createOrder = "INSERT INTO shop_orders (ShopId, Ref) VALUES (@ShopId, @Ref)"
-- Finalize an order
ShopRequests.finalizeOrder = "UPDATE shop_orders SET Finalized=1 WHERE Id=@OrderId"
-- Delete an order
ShopRequests.deleteOrder = "DELETE FROM shop_orders WHERE Id=@OrderId"

-- Remove an item of the stock
ShopRequests.removeItemFromStock = "DELETE FROM shop_content WHERE Id=@Id"
-- Remove an item of the order
ShopRequests.removeItemFromOrder = "DELETE FROM shop_orders_content WHERE Id=@Id"

ShopRequests.getCurrentPlayerMoney = "SELECT Money FROM users WHERE identifier = @SteamId"

-- ============= --
-- DB functions  --
-- ============= --
ShopDbFunctions = {}

function getIdentifiant(id)
  for _, v in ipairs(id) do
    return v
  end
end

function getSteamID(source)
  local identifiers = GetPlayerIdentifiers(source)
  local player = getIdentifiant(identifiers)
  return player
end

function ShopDbFunctions.getShops(source)
  local shops = {}
  local result = MySQL.Sync.fetchAll(ShopRequests.getShops, {})
  for _, shop in ipairs(result) do
    if shop.Supervised then
      shop.Managers, shop.IsSupervisor = ShopDbFunctions.getManagers(shop.Id, source)
    end
    table.insert(shops, shop)
  end

  return shops
end

function ShopDbFunctions.getManagers(shopId, source)
  local managers = {}
  local isSupervisor = false

  local steamId = getSteamID(source)
  local resultManagers = MySQL.Sync.fetchAll(ShopRequests.getManagers, { ["@Id"] = shopId })
  for _, item in ipairs(resultManagers) do
    table.insert(
      managers,
      {
        ["Id"] = item.id,
        ["Name"] = item.nom,
        ["Identifier"] = item.identifier
      }
    )
    isSupervisor = isSupervisor or steamId == item.identifier
  end

  return managers, isSupervisor
end

function ShopDbFunctions.getShop(shopId, source)
  local shop = {}
  shop.IsSupervisor = false
  shop.Items = {}
  shop.Orders = {}
  shop.Managers = {}
  local result = MySQL.Sync.fetchAll(ShopRequests.getShop, { ["@Id"] = shopId })
  for _, item in ipairs(result) do
    shop.Id = item.Id
    shop.Name = item.Name
    shop.Renamed = item.Renamed
    shop.Money = item.Money
    shop.Supervised = item.Supervised
    shop.InventoryId = item.InventoryId
    shop.ColorMenu = item.ColorMenu
    shop.ImageMenu = item.ImageMenu
  end

  result = MySQL.Sync.fetchAll(ShopRequests.getShopItems, { ["@Id"] = shopId })
  for _, item in ipairs(result) do
    table.insert(
      shop.Items,
      {
        ["Id"] = item.id,
        ["Name"] = item.libelle,
        ["Price"] = item.Price,
        ["Quantity"] = item.Quantity,
        ["ContentId"] = item.ContentId
      }
    )
  end

  result = MySQL.Sync.fetchAll(ShopRequests.getShopOrders, { ["@Id"] = shopId })
  for _, item in ipairs(result) do
    table.insert(
      shop.Orders,
      {
        ["Id"] = item.Id,
        ["Ref"] = item.Ref,
        ["Started"] = item.Started,
        ["Signed"] = item.Signed,
        ["Finalized"] = item.Finalized
      }
    )
  end

  if shop.Supervised then
    shop.Managers, shop.IsSupervisor = ShopDbFunctions.getManagers(shopId, source)
  end

  return shop
end

function ShopDbFunctions.getOrder(orderId)
  local order = {}
  order.Items = {}

  local result = MySQL.Sync.fetchAll(ShopRequests.getShopOrder, { ["@OrderId"] = orderId })
  for _, item in ipairs(result) do
    order["Id"] = item.Id
    order["Ref"] = item.Ref
    order["Signed"] = item.Signed
    order["Started"] = item.Started
    order["Finalized"] = item.Finalized
  end

  result = MySQL.Sync.fetchAll(ShopRequests.getOrderItems, { ["@OrderId"] = orderId })
  for _, item in ipairs(result) do
    table.insert(
      order.Items,
      {
        ["Id"] = item.Id,
        ["ItemId"] = item.ItemId,
        ["Name"] = item.libelle,
        ["Quantity"] = item.Quantity,
        ["Price"] = item.Price,
        ["Ordered"] = item.Ordered
      }
    )
  end

  return order
end

function ShopDbFunctions.getStockItem(shopId, itemId)
  local item_ = {}
  local result = MySQL.Sync.fetchAll(ShopRequests.getStockItem, { ["@ItemId"] = itemId, ["@ShopId"] = shopId })
  for _, item in ipairs(result) do
    item_["Id"] = item.id
    item_["Name"] = item.libelle
    item_["Quantity"] = item.Quantity
    item_["Price"] = item.Price
    item_["ContentId"] = item.ContentId
  end

  return item_
end

function ShopDbFunctions.getQuantityItemByContentId(contentId)
  local result = MySQL.Sync.fetchAll(ShopRequests.getQuantityItemByContentId, { ["@ContentId"] = contentId })
  for _, item in ipairs(result) do
    return item.Quantity
  end
  return -1
end

function ShopDbFunctions.getOrdersCountWithContentId(contentId)
  local result = MySQL.Sync.fetchAll(ShopRequests.getOrdersCountWithContentId, { ["@ContentId"] = contentId })
  for _, item in ipairs(result) do
    return item.OrdersCount
  end
  return -1
end

function ShopDbFunctions.getOrderItem(shopId, itemId)
  local item_ = {}
  local result = MySQL.Sync.fetchAll(ShopRequests.getOrderItem, { ["@Id"] = itemId, ["@ShopId"] = shopId })
  for _, item in ipairs(result) do
    item_["Id"] = item.Id
    item_["ItemId"] = item.ItemId
    item_["ShopId"] = item.ShopId
    item_["Name"] = item.libelle
    item_["Quantity"] = item.Quantity
    item_["Price"] = item.Price
    item_["Ordered"] = item.Ordered
    item_["OrderPrice"] = item.OrderPrice or 0
  end

  return item_
end

function ShopDbFunctions.getAllItems()
  local items = {}
  local result = MySQL.Sync.fetchAll(ShopRequests.getAllItems)
  for _, item in ipairs(result) do
    table.insert(
      items,
      {
        ["Id"] = item.id,
        ["Name"] = item.libelle,
        ["Price"] = item.price
      }
    )
  end

  return items
end

function ShopDbFunctions.getUsedItems(shopId)
  local items = {}
  local result = MySQL.Sync.fetchAll(ShopRequests.getShopItems, { ["@Id"] = shopId })
  for _, item in ipairs(result) do
    table.insert(items, { ["Id"] = item.id, ["Name"] = item.libelle })
  end

  return items
end

function ShopDbFunctions.getNotUsedItems(shopId)
  local items = {}
  local allItems = ShopDbFunctions.getAllItems()
  local usedItems = ShopDbFunctions.getUsedItems(shopId)

  for _, item in ipairs(allItems) do
    local isUsed = false
    for _, usedItem in ipairs(usedItems) do
      if item.Id == usedItem.Id then
        isUsed = true
        break
      end
    end
    if isUsed ~= true then
      table.insert(items, item)
    end
  end

  return items
end

function ShopDbFunctions.getContentItem(ContentId)
  return MySQL.Sync.fetchAll(ShopRequests.getContentItem, { ["@Id"] = ContentId })[1]
end

function ShopDbFunctions.removeItemFromStock(ContentId)
  MySQL.Sync.execute(ShopRequests.removeItemFromStock, { ["@Id"] = ContentId })
end

function ShopDbFunctions.removeItemFromOrder(OrderContentId)
  MySQL.Sync.execute(ShopRequests.removeItemFromOrder, { ["@Id"] = OrderContentId })
end

function ShopDbFunctions.decreaseQuantityItem(contentId, quantity)
  MySQL.Async.execute(ShopRequests.removeQuantityItem, { ["@Quantity"] = quantity, ["@Id"] = contentId })
end

function ShopDbFunctions.increaseShopMoney(shopId, price)
  MySQL.Async.execute(ShopRequests.addMoney, { ["@Price"] = price, ["@Id"] = shopId })
end
function ShopDbFunctions.decreaseShopMoney(shopId, price)
  MySQL.Async.execute(ShopRequests.removeMoney, { ["@Price"] = price, ["@Id"] = shopId })
end

function ShopDbFunctions.orderNewItem(orderId, itemId, quantity, price)
  MySQL.Sync.execute(ShopRequests.orderNewItem,
    { ["@OrderId"] = orderId, ["@ItemId"] = itemId, ["@Quantity"] = quantity, ["@Price"] = price })
end
function ShopDbFunctions.updateQuantityOrderItem(orderId, itemId, quantity)
  MySQL.Sync.execute(ShopRequests.updateQuantityOrderItem,
    { ["@OrderId"] = orderId, ["@ItemId"] = itemId, ["@Quantity"] = quantity })
end

local random = math.random
function uuid()
  local template = "xxx-xxx-xxx"
  return string.gsub(
    template,
    "x",
    function(c)
      local v = random(0, 0xf)
      return string.format("%x", v)
    end
  )
end

function ShopDbFunctions.createOrder(shopId)
  MySQL.Sync.execute(ShopRequests.createOrder, { ["@ShopId"] = shopId, ["@Ref"] = uuid() })
end

function ShopDbFunctions.finalizeOrder(orderId)
  MySQL.Sync.execute(ShopRequests.finalizeOrder, { ["@OrderId"] = orderId })
end

function ShopDbFunctions.deleteOrder(orderId)
  MySQL.Sync.execute(ShopRequests.deleteOrder, { ["@OrderId"] = orderId })
end

function ShopDbFunctions.addItemToShop(inventoryId, orderId, item)
  -- First add item to stock without quantity
  MySQL.Sync.execute(ShopRequests.addItem,
    { ["@InventoryId"] = inventoryId, ["@ItemId"] = item.Id, ["@Quantity"] = 0, ["@Price"] = item.Price })
  -- Then add it to the order
  MySQL.Sync.execute(ShopRequests.orderNewItem,
    { ["@OrderId"] = orderId, ["@ItemId"] = item.Id, ["@Quantity"] = 0, ["@Price"] = item.Price })
end

function ShopDbFunctions.updatePriceItem(contentId, price)
  MySQL.Sync.execute(ShopRequests.updatePriceItem, { ["@Id"] = contentId, ["@Price"] = price })
end

function ShopDbFunctions.getCurrentPlayerMoney(streamId)
  local result = MySQL.Sync.fetchAll(ShopRequests.getCurrentPlayerMoney, { ["@SteamId"] = streamId })
  for _, item in ipairs(result) do
    return item.Money
  end
  return -1
end
