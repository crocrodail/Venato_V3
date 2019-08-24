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
DeliveryJobRequests.getWarehouseItems = "SELECT id, libelle, Picture FROM items WHERE warehouseId=@Id"
DeliveryJobRequests.newMissionCheck = "UPDATE users SET salaryCheck = salaryCheck + @newCheck WHERE identifier=@Id"

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
  local newCheck = 500
  MySQL.Sync.execute(DeliveryJobRequests.newMissionCheck, { ["@newCheck"] = newCheck, ["@Id"] = getSteamID(source) })
  return newCheck
end
