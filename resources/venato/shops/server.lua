-- ######## CONFIG ##############
local PoidMax = 20 -- Kg
-- ##############################

local getShopsRequest = "SELECT * FROM shops WHERE Enabled=1"
local getShopRequest = "SELECT s.Id, s.Name, s.Renamed, s.Money, s.Supervised, s.InventoryId FROM shops s WHERE s.Id=@Id"
local getShopItemsRequest = "SELECT it.id, it.libelle, c.Price, c.Quantity, c.Id as ContentId FROM shops s INNER JOIN shop_inventory i ON s.InventoryId = i.Id INNER JOIN shop_content c ON i.Id = c.InventoryId INNER JOIN items it on c.ItemId = it.id WHERE s.Id=@Id"
local getShopOrdersRequest = "SELECT o.Id, o.Ref, o.Started, o.Signed, o.Finalized FROM shops s INNER JOIN shop_orders o ON s.Id = o.ShopId WHERE s.Id=@Id ORDER BY o.Id DESC "
local getShopOrderRequest = "SELECT o.Id, o.Ref, o.Signed, o.Started, o.Finalized FROM shop_orders o WHERE o.Id=@OrderId"
local getManagersRequest = "SELECT u.id, u.identifier, u.nom FROM shops s INNER JOIN shop_manager m ON s.Id = m.ShopId INNER JOIN users u ON u.Id = m.ManagerId WHERE s.Id=@Id"
local getContentItemRequest = "SELECT c.Quantity, c.Price, c.ItemId, it.poid, it.libelle FROM shop_content c INNER JOIN items it on c.ItemId = it.id WHERE c.Id=@Id"
local getOrderItemsRequest = "SELECT it.id, it.libelle, c.Quantity, c.Price, oc.Quantity as Ordered FROM shop_orders o INNER JOIN shops s ON o.ShopID = s.Id INNER JOIN shop_inventory i ON s.InventoryId = i.Id INNER JOIN shop_content c ON i.Id = c.InventoryId INNER JOIN items it on c.ItemId = it.id LEFT JOIN shop_orders_content oc ON o.Id = oc.ShopOrderId and it.id = oc.ItemId WHERE o.Id=@OrderId"
local getStockItemRequest = "SELECT it.id, it.libelle, c.Quantity, c.Price, c.Id as ContentId FROM shops s INNER JOIN shop_inventory i ON s.InventoryID = i.Id INNER JOIN shop_content c ON i.Id = c.InventoryId INNER JOIN items it on c.ItemId = it.id WHERE it.id=@ItemId and s.Id=@ShopId"
local getQuantityItemByContentIdRequest = "SELECT c.Quantity FROM shop_content c WHERE c.Id=@ContentId"
local getOrderItemRequest = "SELECT it.id, it.libelle, c.Quantity, c.Price, oc.Quantity as Ordered, oc.Price as OrderPrice FROM shops s INNER JOIN shop_inventory i ON s.InventoryID = i.Id INNER JOIN shop_content c ON i.Id = c.InventoryId INNER JOIN items it on c.ItemId = it.id LEFT JOIN shop_orders o ON s.Id = o.ShopId LEFT JOIN shop_orders_content oc ON o.Id = oc.ShopOrderId and it.id = oc.ItemId WHERE it.id=@ItemId and s.Id=@ShopId"
local getAllItemsRequest = "SELECT it.id, it.libelle, it.price FROM items it"

local addItemRequest = "INSERT shop_content (InventoryId, ItemId, Price, Quantity) VALUES (@InventoryId, @ItemId, @Price, @Quantity)"
local removeQuantityItemRequest = "UPDATE shop_content SET Quantity = Quantity - @Quantity WHERE Id=@Id"
local updatePriceItemRequest = "UPDATE shop_content SET Price = @Price WHERE Id=@Id"

local addMoneyRequest = "UPDATE shops SET Money = Money + @Price WHERE Id=@Id"
local removeMoneyRequest = "UPDATE shops SET Money = Money - @Price WHERE Id=@Id"

local orderNewItemRequest = "INSERT INTO shop_orders_content (ShopOrderId, ItemId, Quantity, Price) VALUES (@OrderId, @ItemId, @Quantity, @Price)"
local updateQuantityOrderItemRequest = "UPDATE shop_orders_content SET Quantity=@Quantity WHERE ShopOrderId=@OrderId and ItemId=@ItemId"

local createOrderRequest = "INSERT INTO shop_orders (ShopId, Ref) VALUES (@ShopId, @Ref)"
local finalizeOrderRequest = "UPDATE shop_orders SET Finalized=1 WHERE Id=@OrderId"
local deleteOrderRequest = "DELETE FROM shop_orders WHERE Id=@OrderId"

local removeItemFromStockRequest = "DELETE FROM shop_content WHERE Id=@Id"

RegisterServerEvent("Shops:LoadShops")
AddEventHandler(
  "Shops:LoadShops",
  function(newSource)
    local source = source
    if newSource ~= nil then
      source = newSource
    end
    TriggerClientEvent("Shops:LoadShops:cb", source, getShops())
  end
)

function getShops()
  local result = MySQL.Sync.fetchAll(getShopsRequest, {})
  return result or {}
end

function getManagers(shopId, source)
  local managers = {}
  local isSupervisor = false

  local steamId = getSteamID(source)
  local resultManagers = MySQL.Sync.fetchAll(getManagersRequest, { ["@Id"] = shopId })
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

function getShop(shopId, source)
  local shop = {}
  shop.IsSupervisor = false
  shop.Items = {}
  shop.Orders = {}
  shop.Managers = {}
  local result = MySQL.Sync.fetchAll(getShopRequest, { ["@Id"] = shopId })
  for _, item in ipairs(result) do
    shop.Id = item.Id
    shop.Name = item.Name
    shop.Renamed = item.Renamed
    shop.Money = item.Money
    shop.Supervised = item.Supervised
    shop.InventoryId = item.InventoryId
  end

  result = MySQL.Sync.fetchAll(getShopItemsRequest, { ["@Id"] = shopId })
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

  result = MySQL.Sync.fetchAll(getShopOrdersRequest, { ["@Id"] = shopId })
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
    shop.Managers, shop.IsSupervisor = getManagers(shopId, source)
  end

  return shop
end

function getOrder(orderId)
  local order = {}
  order.Items = {}

  local result = MySQL.Sync.fetchAll(getShopOrderRequest, { ["@OrderId"] = orderId })
  for _, item in ipairs(result) do
    order["Id"] = item.Id
    order["Ref"] = item.Ref
    order["Signed"] = item.Signed
    order["Started"] = item.Started
    order["Finalized"] = item.Finalized
  end

  result = MySQL.Sync.fetchAll(getOrderItemsRequest, { ["@OrderId"] = orderId })
  for _, item in ipairs(result) do
    table.insert(
      order.Items,
      {
        ["Id"] = item.id,
        ["Name"] = item.libelle,
        ["Quantity"] = item.Quantity,
        ["Price"] = item.Price,
        ["Ordered"] = item.Ordered
      }
    )
  end

  return order
end

function getStockItem(shopId, itemId)
  local item_ = {}
  local result = MySQL.Sync.fetchAll(
    getStockItemRequest,
    {
      ["@ItemId"] = itemId,
      ["@ShopId"] = shopId
    }
  )
  for _, item in ipairs(result) do
    item_["Id"] = item.id
    item_["Name"] = item.libelle
    item_["Quantity"] = item.Quantity
    item_["Price"] = item.Price
    item_["ContentId"] = item.ContentId
  end

  return item_
end

function getQuantityItemByContentId(contentId)
  local result = MySQL.Sync.fetchAll(
    getQuantityItemByContentIdRequest,
    {
      ["@ContentId"] = contentId
    }
  )
  for _, item in ipairs(result) do
    return item.Quantity
  end
  return -1
end

function getOrderItem(shopId, itemId)
  local item_ = {}
  local result = MySQL.Sync.fetchAll(
    getOrderItemRequest,
    {
      ["@ItemId"] = itemId,
      ["@ShopId"] = shopId
    }
  )
  for _, item in ipairs(result) do
    item_["Id"] = item.id
    item_["ShopId"] = item.ShopId
    item_["Name"] = item.libelle
    item_["Quantity"] = item.Quantity
    item_["Price"] = item.Price
    item_["Ordered"] = item.Ordered
    item_["OrderPrice"] = item.OrderPrice or 0
  end

  return item_
end

function getAllItems()
  local items = {}
  local result = MySQL.Sync.fetchAll(getAllItemsRequest)
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

function getUsedItems(shopId)
  local items = {}
  local result = MySQL.Sync.fetchAll(getShopItemsRequest, { ["@Id"] = shopId })
  for _, item in ipairs(result) do
    table.insert(items, { ["Id"] = item.ItemId, ["Name"] = item.libelle })
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

RegisterServerEvent("Shops:ShowInventory")
AddEventHandler(
  "Shops:ShowInventory",
  function(shopId, newSource)
    local source = source
    if newSource ~= nil then
      source = newSource
    end
    TriggerClientEvent("Shops:UpdateMenu:cb", source, getShop(shopId, source))
  end
)

RegisterServerEvent("Shops:TestBuy")
AddEventHandler(
  "Shops:TestBuy",
  function(ContentId, shopId, quantity, newSource)
    local source = source
    if newSource ~= nil then
      source = newSource
    end
    local result = MySQL.Sync.fetchAll(getContentItemRequest, { ["@Id"] = ContentId })
    if result[1] == nil then
      return
    end
    local content = result[1]

    quantity = quantity or 1
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
  end
)

RegisterServerEvent("Shops:RemoveItem")
AddEventHandler(
  "Shops:RemoveItem",
  function(quantity, contentId, newSource)
    local source = source
    if newSource ~= nil then
      source = newSource
    end
    MySQL.Async.execute(removeQuantityItemRequest, { ["@Quantity"] = quantity, ["@Id"] = contentId })
  end
)

RegisterServerEvent("Shops:AddMoney")
AddEventHandler(
  "Shops:AddMoney",
  function(price, shopId, newSource)
    local source = source
    if newSource ~= nil then
      source = newSource
    end
    MySQL.Async.execute(addMoneyRequest, { ["@Price"] = price, ["@Id"] = shopId })
  end
)

RegisterServerEvent("Shops:RemoveMoney")
AddEventHandler(
  "Shops:RemoveMoney",
  function(price, shopId, newSource)
    local source = source
    if newSource ~= nil then
      source = newSource
    end
    MySQL.Async.execute(removeMoneyRequest, { ["@Price"] = price, ["@Id"] = shopId })
  end
)

RegisterServerEvent("Shops:getMoney")
AddEventHandler(
  "Shops:getMoney",
  function(shopId, newSource)
    local source = source
    if newSource ~= nil then
      source = newSource
    end
    local shop = getShop(shopId, source)
    if not shop.IsSupervisor then
      TriggerClientEvent("Shops:NotEnoughShopMoney", source, shop.Money)
    else
      price = shop.Money
      TriggerEvent("Inventory:AddMoney", price, source)
      TriggerEvent("Shops:RemoveMoney", price, shopId)
      TriggerClientEvent("Shops:getMoney:cb", source, price)
    end
  end
)

RegisterServerEvent("Shops:showOrder")
AddEventHandler(
  "Shops:showOrder",
  function(orderId, newSource)
    local source = source
    if newSource ~= nil then
      source = newSource
    end
    TriggerClientEvent("Shops:UpdateMenu:cb", source, getOrder(orderId))
  end
)

RegisterServerEvent("Shops:ShowItem")
AddEventHandler(
  "Shops:ShowItem",
  function(shopId, item, newSource)
    local source = source
    if newSource ~= nil then
      source = newSource
    end
    TriggerClientEvent("Shops:UpdateMenu:cb", source, getOrderItem(shopId, item.Id))
  end
)

RegisterServerEvent("Shops:OrderItem")
AddEventHandler(
  "Shops:OrderItem",
  function(orderId, item, quantity, newSource)
    local source = source
    if newSource ~= nil then
      source = newSource
    end
    if item.Ordered == nil then
      MySQL.Sync.execute(
        orderNewItemRequest,
        {
          ["@OrderId"] = orderId,
          ["@ItemId"] = item.Id,
          ["@Quantity"] = quantity,
          ["@Price"] = item.Price
        }
      )
    else
      MySQL.Sync.execute(
        updateQuantityOrderItemRequest,
        {
          ["@OrderId"] = orderId,
          ["@ItemId"] = item.Id,
          ["@Quantity"] = quantity
        }
      )
    end
    TriggerClientEvent("Shops:OrderItem:cb", source, quantity, item.Name)
  end
)

RegisterServerEvent("Shops:CreateOrder")
AddEventHandler(
  "Shops:CreateOrder",
  function(shopId, newSource)
    local source = source
    if newSource ~= nil then
      source = newSource
    end
    MySQL.Sync.execute(createOrderRequest, { ["@ShopId"] = shopId, ["@Ref"] = uuid() })
    TriggerClientEvent("Shops:UpdateMenu:cb", source, getShop(shopId, source))
  end
)

RegisterServerEvent("Shops:FinalizeOrder")
AddEventHandler(
  "Shops:FinalizeOrder",
  function(orderId, shopId, newSource)
    local source = source
    if newSource ~= nil then
      source = newSource
    end
    MySQL.Sync.execute(finalizeOrderRequest, { ["@OrderId"] = orderId })
    TriggerClientEvent("Shops:UpdateMenu:cb", source, getShop(shopId, source))
  end
)

RegisterServerEvent("Shops:DeleteOrder")
AddEventHandler(
  "Shops:DeleteOrder",
  function(orderId, shopId, newSource)
    local source = source
    if newSource ~= nil then
      source = newSource
    end
    MySQL.Sync.execute(deleteOrderRequest, { ["@OrderId"] = orderId })
    TriggerClientEvent("Shops:UpdateMenu:cb", source, getShop(shopId, source))
  end
)

RegisterServerEvent("Shops:showAddItem")
AddEventHandler(
  "Shops:showAddItem",
  function(shopId, newSource)
    local source = source
    if newSource ~= nil then
      source = newSource
    end
    TriggerClientEvent("Shops:UpdateMenu:cb", source, getNotUsedItems(shopId))
  end
)

RegisterServerEvent("Shops:showAdminItem")
AddEventHandler(
  "Shops:showAdminItem",
  function(shopId, item, newSource)
    local source = source
    if newSource ~= nil then
      source = newSource
    end

    TriggerClientEvent("Shops:UpdateMenu:cb", source, getStockItem(shopId, item.Id))
  end
)

RegisterServerEvent("Shops:AddItemToShop")
AddEventHandler(
  "Shops:AddItemToShop",
  function(inventoryId, orderId, item, newSource)
    local source = source
    if newSource ~= nil then
      source = newSource
    end

    MySQL.Sync.execute(
      addItemRequest,
      { ["@InventoryId"] = inventoryId, ["@ItemId"] = item.Id, ["@Quantity"] = 0, ["@Price"] = item.Price }
    )
    MySQL.Sync.execute(
      orderNewItemRequest,
      { ["@OrderId"] = orderId, ["@ItemId"] = item.Id, ["@Quantity"] = 0, ["@Price"] = item.Price }
    )

    TriggerClientEvent("Shops:AddItemToShop:cb", source, item)
  end
)

RegisterServerEvent("Shops:ChangePriceItem")
AddEventHandler(
  "Shops:ChangePriceItem",
  function(item, price, newSource)
    local source = source
    if newSource ~= nil then
      source = newSource
    end

    MySQL.Sync.execute(
      updatePriceItemRequest,
      { ["@Id"] = item.ContentId, ["@Price"] = price }
    )

    TriggerClientEvent("Shops:ChangePriceItem:cb", source, item, price)
  end
)

RegisterServerEvent("Shops:removeItemFromStock")
AddEventHandler(
  "Shops:removeItemFromStock",
  function(item, newSource)
    local source = source
    if newSource ~= nil then
      source = newSource
    end

    Quantity = getQuantityItemByContentId(item.ContentId)

    if Quantity ~= 0 then
      TriggerClientEvent("Shops:StockNotEmpty", source, item)
    else
      MySQL.Sync.execute(
        removeItemFromStockRequest,
        { ["@Id"] = item.ContentId }
      )

      TriggerClientEvent("Shops:removeItemFromStock:cb", source, item)
    end
  end
)

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
