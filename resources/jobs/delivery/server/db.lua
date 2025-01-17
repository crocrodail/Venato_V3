--[[
  Server entry point for delivery DB requests

  @author Astymeus
  @date 2019-07-28
  @version 1.0
--]]

-- ============= --
--  DB requests  --
-- ============= --
DeliveryJobRequests = {}

DeliveryJobRequests.getWarehouses = "SELECT * FROM warehouses"
DeliveryJobRequests.getWarehouseItems = "SELECT id, libelle, price, pricepro, Picture FROM items WHERE warehouseId=@Id"
DeliveryJobRequests.getOrders = "SELECT o.Id as OrderId, " ..
  "s.Id as ShopId, s.Name as ShopName, s.PositionX as ShopX, s.PositionY as ShopY, s.PositionZ as ShopZ " ..
  "FROM shop_orders o " ..
  "LEFT JOIN shops s ON s.Id = o.ShopId " ..
  "JOIN shop_orders_content c ON o.Id = c.ShopOrderId " ..
  "LEFT JOIN items i ON i.id = c.ItemId " ..
  "WHERE o.Started=0 AND o.Finalized=1"
DeliveryJobRequests.getPlayerOrder = "SELECT o.Id as OrderId, " ..
  "c.Id as OrderContentId, c.ItemId as ItemId, c.Quantity as ItemQuantity, i.libelle as ItemName " ..
  "FROM shop_orders o " ..
  "JOIN shop_orders_content c ON o.Id = c.ShopOrderId " ..
  "LEFT JOIN items i ON i.id = c.ItemId " ..
  "WHERE o.Id=@OrderId"

DeliveryJobRequests.newMissionCheck = "UPDATE users SET salaryCheck = salaryCheck + @newCheck WHERE identifier=@Id"

DeliveryJobRequests.startOrder = "UPDATE shop_orders SET Started = 1, DeliveryManId=@DeliveryManId WHERE Id=@OrderId"
DeliveryJobRequests.abortOrder = "UPDATE shop_orders SET Started = 0, DeliveryManId=null WHERE Id=@OrderId"
DeliveryJobRequests.finishOrder = "UPDATE shop_orders SET DeliveryManId=null WHERE Id=@OrderId"

DeliveryJobRequests.getPlayerId = "SELECT id FROM users WHERE identifier=@Id"

-- ============= --
-- DB functions  --
-- ============= --
DeliveryJobDbFunctions = {}

function getIdentifiant(id)
  for _, v in ipairs(id) do
    return v
  end
end

function getSteamID(source)
  local identifiers = GetPlayerIdentifiers(source)
  return getIdentifiant(identifiers)
end

function DeliveryJobDbFunctions.getWarehouseItems(warehouseId)
  return MySQL.Sync.fetchAll(DeliveryJobRequests.getWarehouseItems, { ["@Id"] = warehouseId })
end

function DeliveryJobDbFunctions.getWarehouses()
  local warehouses = {}
  local result = MySQL.Sync.fetchAll(DeliveryJobRequests.getWarehouses)
  for _, warehouse in ipairs(result) do
    warehouses[warehouse.name] = {
      id = warehouse.id,
      positionFrom = {
        ["x"] = warehouse.positionFromX,
        ["y"] = warehouse.positionFromY,
        ["z"] = warehouse.positionFromZ,
        ["nom"] = "Entrer dans l'entrepôt"
      },
      positionTo = {
        ["x"] = warehouse.positionToX,
        ["y"] = warehouse.positionToY,
        ["z"] = warehouse.positionToZ,
        ["nom"] = "Sortir de l'entrepôt"
      },
      items = DeliveryJobDbFunctions.getWarehouseItems(warehouse.id)
    }
  end
  return warehouses
end

function DeliveryJobDbFunctions.newMissionCheck(source)
  local newCheck = 8000
  MySQL.Sync.execute(DeliveryJobRequests.newMissionCheck, { ["@newCheck"] = newCheck, ["@Id"] = getSteamID(source) })
  return newCheck
end

function DeliveryJobDbFunctions.getFirstOrder()
  result = MySQL.Sync.fetchAll(DeliveryJobRequests.getOrders)
  if result == nil or #result == 0 then return nil end
  for _, order in ipairs(result) do
    return order
  end
end

function DeliveryJobDbFunctions.getPlayerOrder()
  order = DeliveryJobDbFunctions.getFirstOrder()
  if order == nil then return nil end
  result = MySQL.Sync.fetchAll(DeliveryJobRequests.getPlayerOrder, { ["@OrderId"] = order.OrderId })
  order.Id = order.OrderId
  order.destination = {
    ["Name"] = order.ShopName,
    ["x"] = order.ShopX,
    ["y"] = order.ShopY,
    ["z"] = order.ShopZ,
  }
  order.order = {}
  if result == nil or #result == 0 then return nil end
  for _, order_item in ipairs(result) do
    table.insert(order.order, {
      ["id"] = order_item.ItemId,
      ["name"] = order_item.ItemName,
      ["quantity"] = order_item.ItemQuantity
    })
  end
  return order
end

function DeliveryJobDbFunctions.startOrder(source, orderId)
  local playerId = MySQL.Sync.fetchScalar(DeliveryJobRequests.getPlayerId, { ["@Id"] = getSteamID(source) })
  MySQL.Sync.execute(DeliveryJobRequests.startOrder,
    { ["@DeliveryManId"] = playerId, ["@OrderId"] = orderId })
end
function DeliveryJobDbFunctions.abortOrder(orderId)
  MySQL.Sync.execute(DeliveryJobRequests.abortOrder, { ["@OrderId"] = orderId })
end
function DeliveryJobDbFunctions.finishOrder(orderId)
  MySQL.Sync.execute(DeliveryJobRequests.finishOrder, { ["@OrderId"] = orderId })
end
