-- ============= --
-- Server Events --
-- ============= --

RegisterServerEvent("Shops:LoadShops")
RegisterServerEvent("Shops:ShowInventory")
RegisterServerEvent("Shops:TestBuy")
RegisterServerEvent("Shops:RemoveItem")
RegisterServerEvent("Shops:AddMoney")
RegisterServerEvent("Shops:RemoveMoney")
RegisterServerEvent("Shops:getMoney")
RegisterServerEvent("Shops:showOrder")
RegisterServerEvent("Shops:ShowItem")
RegisterServerEvent("Shops:OrderItem")
RegisterServerEvent("Shops:CreateOrder")
RegisterServerEvent("Shops:FinalizeOrder")
RegisterServerEvent("Shops:DeleteOrder")
RegisterServerEvent("Shops:showAddItem")
RegisterServerEvent("Shops:showAdminItem")
RegisterServerEvent("Shops:AddItemToShop")
RegisterServerEvent("Shops:ChangePriceItem")
RegisterServerEvent("Shops:removeItemFromStock")

function getSource(source, newSource)
  return newSource or source
end

AddEventHandler("Shops:LoadShops", function(newSource)
  local source = getSource(source, newSource)
  TriggerClientEvent("Shops:LoadShops:cb", source, ShopDbFunctions.getShops())
end)

AddEventHandler("Shops:ShowInventory", function(shopId, newSource)
  local source = getSource(source, newSource)
  TriggerClientEvent("Shops:UpdateMenu:cb", source, ShopDbFunctions.getShop(shopId, source))
end)

AddEventHandler("Shops:TestBuy", function(ContentId, shopId, quantity, newSource)
  local source = getSource(source, newSource)

  content = ShopDbFunctions.getContentItem(ContentId)
  if content == nil then return end

  local _quantity = quantity or 1
  local totalPrice = _quantity * content.Price
  local totalPoid = _quantity * content.poid

  local steamId = ShopsTools.getSteamID(source)
  currentPlayerMoney = ShopDbFunctions.getCurrentPlayerMoney(steamId)
  if totalPrice > currentPlayerMoney then
    TriggerClientEvent("Shops:NotEnoughMoney", source, content.libelle)
  elseif content.Quantity >= 0 and content.Quantity < _quantity then
    TriggerClientEvent("Shops:NotEnoughQuantity", source, content.libelle)
  elseif PoidMax < (DataPlayers[source].Poid + totalPoid) then
    TriggerClientEvent("Shops:TooHeavy", source, content.libelle)
  else
    TriggerEvent("Inventory:AddItem", _quantity, content.ItemId, source)
    if content.Quantity > 0 then
      TriggerEvent("Shops:RemoveItem", _quantity, ContentId)
    end

    TriggerEvent("Inventory:RemoveMoney", totalPrice, source)
    TriggerEvent("Shops:AddMoney", totalPrice, shopId)
    TriggerClientEvent("Shops:TestBuy:cb", source, content.libelle)
  end
end)

AddEventHandler("Shops:RemoveItem", function(quantity, contentId, newSource)
  local source = getSource(source, newSource)
  ShopDbFunctions.decreaseQuantityItem(contentId, quantity)
end)

AddEventHandler("Shops:AddMoney", function(price, shopId, newSource)
  local source = getSource(source, newSource)
  ShopDbFunctions.increaseShopMoney(shopId, price)
end)

AddEventHandler("Shops:RemoveMoney", function(price, shopId, newSource)
  local source = getSource(source, newSource)
  ShopDbFunctions.decreaseShopMoney(shopId, price)
end)

AddEventHandler("Shops:getMoney", function(shopId, newSource)
  local source = getSource(source, newSource)
  local shop = ShopDbFunctions.getShop(shopId, source)
  if not shop.IsSupervisor then
    TriggerClientEvent("Shops:NotEnoughShopMoney", source, shop.Money)
  else
    price = shop.Money
    TriggerEvent("Inventory:AddMoney", price, source)
    TriggerEvent("Shops:RemoveMoney", price, shopId)
    TriggerClientEvent("Shops:getMoney:cb", source, price)
  end
end)

AddEventHandler("Shops:showOrder", function(orderId, newSource)
  local source = getSource(source, newSource)
  TriggerClientEvent("Shops:UpdateMenu:cb", source, ShopDbFunctions.getOrder(orderId))
end)

AddEventHandler("Shops:ShowItem", function(shopId, item, newSource)
  local source = getSource(source, newSource)
  TriggerClientEvent("Shops:UpdateMenu:cb", source, ShopDbFunctions.getOrderItem(shopId, item.Id))
end)

AddEventHandler("Shops:OrderItem", function(orderId, item, quantity, newSource)
  local source = getSource(source, newSource)
  if item.Ordered == nil then
    ShopDbFunctions.orderNewItem(orderId, item.Id, quantity, item.Price)
  else
    ShopDbFunctions.updateQuantityOrderItem(orderId, item.Id, quantity)
  end
  TriggerClientEvent("Shops:OrderItem:cb", source, quantity, item.Name)
end)

AddEventHandler("Shops:CreateOrder", function(shopId, newSource)
  local source = getSource(source, newSource)
  ShopDbFunctions.createOrder(shopId)
  TriggerClientEvent("Shops:UpdateMenu:cb", source, ShopDbFunctions.getShop(shopId, source))
end)

AddEventHandler("Shops:FinalizeOrder", function(orderId, shopId, newSource)
  local source = getSource(source, newSource)
  ShopDbFunctions.finalizeOrder(orderId)
  TriggerClientEvent("Shops:UpdateMenu:cb", source, ShopDbFunctions.getShop(shopId, source))
end)

AddEventHandler("Shops:DeleteOrder", function(orderId, shopId, newSource)
  local source = getSource(source, newSource)
  ShopDbFunctions.deleteOrder(orderId)
  TriggerClientEvent("Shops:UpdateMenu:cb", source, ShopDbFunctions.getShop(shopId, source))
end)

AddEventHandler("Shops:showAddItem", function(shopId, newSource)
  local source = getSource(source, newSource)
  TriggerClientEvent("Shops:UpdateMenu:cb", source, ShopDbFunctions.getNotUsedItems(shopId))
end)

AddEventHandler("Shops:showAdminItem", function(shopId, item, newSource)
  local source = getSource(source, newSource)
  TriggerClientEvent("Shops:UpdateMenu:cb", source, ShopDbFunctions.getStockItem(shopId, item.Id))
end)

AddEventHandler("Shops:AddItemToShop", function(inventoryId, orderId, item, newSource)
  local source = getSource(source, newSource)
  ShopDbFunctions.addItemToShop(inventoryId, orderId, item)
  TriggerClientEvent("Shops:AddItemToShop:cb", source, item)
end)

AddEventHandler("Shops:ChangePriceItem", function(item, price, newSource)
  local source = getSource(source, newSource)
  ShopDbFunctions.updatePriceItem(item.ContentId, price)
  TriggerClientEvent("Shops:ChangePriceItem:cb", source, item, price)
end)

AddEventHandler("Shops:removeItemFromStock", function(item, newSource)
  local source = getSource(source, newSource)
  Quantity = ShopDbFunctions.getQuantityItemByContentId(item.ContentId)

  if Quantity ~= 0 then
    TriggerClientEvent("Shops:StockNotEmpty", source, item)
  else
    ShopDbFunctions.removeItemFromStock(item.ContentId)
    TriggerClientEvent("Shops:removeItemFromStock:cb", source, item)
  end
end)
