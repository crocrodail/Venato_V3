--[[
  Menu pages for interactions with users

  @author Astymeus
  @date 2019-07-11
  @version 1.0
--]]
Shops = {}
ShopPages = {}

-- ========== --
-- Draw Pages --
-- ========== --

function Shops.drawPage(content)
  ConfigShop.menuOpen = true

  TriggerEvent('Menu:Clear')
  TriggerEvent('Menu:Open')

  -- Search in registered pages the current one
  -- and if found, show it with content in parameters
  if ShopPages[ConfigShop.page] ~= nil then ShopPages[ConfigShop.page](content) end

  TriggerEvent('Menu:CreateMenu')
end

-- CLIENT --
function ShopPages.client(shop)
  ConfigShop.currentOrderId = nil
  local shopName_ = shop.Renamed or shop.Name or "Shop"
  TriggerEvent('Menu:Title', shopName_)
  local subTitle = "Stocks"
  TriggerEvent('Menu:Init', shopName_, subTitle, shop.ColorMenu, shop.ImageMenu)

  ConfigShop.currentInventoryId = shop.InventoryId
  if shop.Supervised == 1 then
    subTitle = subTitle .. " supervised by: "
    for index, manager in ipairs(shop.Managers) do
      if index > 1 then subTitle = subTitle .. "," end
      subTitle = subTitle .. manager.Name
    end
  end
  TriggerEvent('Menu:SubTitle', subTitle)

  if shop.IsSupervisor then
    TriggerEvent('Menu:AddButton2', "Administration", "goTo", table.pack("admin",
      "Shops:ShowInventory", ConfigShop.currentShopId), "", "https://i.ibb.co/cQmJ84r/icons8-administrative-tools-96px.png")
  end

  for _, item in ipairs(shop.Items) do
    local textButton = itemToString(item)
    TriggerEvent('Menu:AddShopButton', item.Name, "buyItem", item, item.Picture, formatQte(item.Quantity), item.Price)
  end
  
end

-- ADMIN --
function ShopPages.admin(shop)
  if not shop.IsSupervisor then
    goToClientPage()
  end

  TriggerEvent('Menu:Title', ConfigShop.textInColor('white', "Administration"))
  TriggerEvent('Menu:SubTitle', "Caisse: " .. ConfigShop.textInColor('orange', shop.Money .. "€"))

  TriggerEvent('Menu:AddButton2', ConfigShop.textInColor('red', "Retour"), "goTo",
    table.pack("client", "Shops:ShowInventory", ConfigShop.currentShopId), "", "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png")
  TriggerEvent('Menu:AddButton2', "Récuperer caisse", "getMoney", "", "", "https://i.ibb.co/Y3fwFnQ/icons8-request-money-96px-1.png")
  TriggerEvent('Menu:AddButton2', "Créer commande", "createOrder", "", "", "https://i.ibb.co/48yLQfj/icons8-bill-96px.png")

  for _, order in ipairs(shop.Orders) do
    local textButton = orderToString(order)
    TriggerEvent('Menu:AddShopButton', textButton, "goTo", table.pack("order", "Shops:showOrder", order.Id),"https://i.ibb.co/dgKX7bR/icons8-purchase-order-96px.png", orderStatusToString(order), nil)
  end

  for _, item in ipairs(shop.Items) do
    local textButton = itemToString(item)
    TriggerEvent('Menu:AddShopButton', item.Name, "goTo",
    table.pack("adminItem", "Shops:showAdminItem", ConfigShop.currentShopId, item), item.Picture, formatQte(item.Quantity), item.Price)
  end
  
  TriggerEvent('Menu:AddButton2', ConfigShop.textInColor('red', "Retour"), "goTo",
    table.pack("client", "Shops:ShowInventory", ConfigShop.currentShopId), "", "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png")
end

-- ORDER --
function ShopPages.order(order)
  ConfigShop.currentOrderId = order.Id
  TriggerEvent('Menu:Title', "Commande: <small>" .. order.Ref .. "</small>")
  TriggerEvent('Menu:SubTitle', "Selectionne un produit pour le modifier")

  TriggerEvent('Menu:AddButton2', ConfigShop.textInColor('red', "Retour"), "goTo",
    table.pack("admin", "Shops:ShowInventory", ConfigShop.currentShopId), "", "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png")

  TriggerEvent('Menu:AddButton2', "Ajouter un produit", "goTo",
    table.pack("addItem", "Shops:showAddItem", ConfigShop.currentShopId), "", "https://i.ibb.co/NWMhJF9/icons8-plus-96px.png")

  TriggerEvent('Menu:AddButton2', "Supprimer commande", "deleteOrder", "", "", "https://i.ibb.co/Vg1fxzB/icons8-remove-book-96px-1.png")

  if order.Finalized ~= 1 and #order.Items > 0 then
    TriggerEvent('Menu:AddButton2', "Finaliser commande", "finalizeOrder", "", "", "https://i.ibb.co/df5S2VV/icons8-check-file-96px.png")
  end

  for _, item in ipairs(order.Items) do
    TriggerEvent('Menu:AddShopButton', item.Name, "goTo", table.pack("orderItem", "Shops:ShowItem", ConfigShop.currentShopId, item), item.Picture, formatQte(item.Quantity)..formatOrdered(item.Ordered), item.Price)
  end
  
  TriggerEvent('Menu:AddButton2', ConfigShop.textInColor('red', "Retour"), "goTo",
    table.pack("admin", "Shops:ShowInventory", ConfigShop.currentShopId), "", "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png")
end

function ShopPages.orderItem(item)
  menuTitle = item.Name
  if item.Ordered == nil then
    --  nothing to do
  elseif item.Ordered == 0 then
    menuTitle = menuTitle .. ConfigShop.textInColor('grey', " (pas de commande)")
  else
    menuTitle = menuTitle .. ConfigShop.textInColor('blue', " (+" .. item.Ordered .. ")")
  end
  TriggerEvent('Menu:Title', menuTitle)

  TriggerEvent('Menu:SubTitle', "Actions")
  TriggerEvent('Menu:AddButton2', ConfigShop.textInColor('red', "Retour"), "goTo",table.pack("order", "Shops:showOrder", ConfigShop.currentOrderId), "", "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png")
  TriggerEvent('Menu:AddButton2', "Définir la quantité", "orderItem", item, "", "https://i.ibb.co/grvhJmy/icons8-add-shopping-cart-96px.png")
  if item.Id ~= nil then
    TriggerEvent('Menu:AddButton2', "Retirer de la commande", "removeItemFromOrder", item, "", "https://i.ibb.co/qk2MtcN/icons8-buy-96px.png")
  end
end

function ShopPages.adminItem(item)
  TriggerEvent('Menu:Title', item.Name)
  TriggerEvent('Menu:SubTitle', "info: " .. itemToString(item))

  TriggerEvent('Menu:AddButton2', ConfigShop.textInColor('red', "Retour"), "goTo",table.pack("admin", "Shops:ShowInventory", ConfigShop.currentShopId), "", "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png")
  
  TriggerEvent('Menu:AddButton2', "Modifier prix", "setPrice", item, '', "https://i.ibb.co/k1c1MCS/icons8-price-tag-usd-96px.png")
  TriggerEvent('Menu:AddButton2', "Retirer du stock", "removeItemFromStock", item, "", "https://i.ibb.co/d5skfBK/icons8-return-purchase-96px-1.png")
end

function ShopPages.addItem(items)
  TriggerEvent('Menu:Title', "Ajouter un produit")
  TriggerEvent('Menu:SubTitle', "Sélectionne le produit à ajouter")

  TriggerEvent('Menu:AddButton2', ConfigShop.textInColor('red', "Retour"), "goTo",  table.pack("order", "Shops:showOrder", ConfigShop.currentOrderId), "", "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png")

  for _, item in ipairs(items) do
    local textButton = itemToString(item)
    print(item.Picture)
    TriggerEvent('Menu:AddShopButton', item.Name, "addItemToStock", item, item.Picture, "", item.Price)
  end
  
  TriggerEvent('Menu:AddButton2', ConfigShop.textInColor('red', "Retour"), "goTo",  table.pack("order", "Shops:showOrder", ConfigShop.currentOrderId), "", "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png")
end

-- ===== --
-- Tools --
-- ===== --

function itemToString(item)
  local s = item.Name

  if item.Price ~= nil then
    s = s .. ConfigShop.textInColor('orange', " " .. item.Price .. "€")
  end

  if item.Quantity == nil then
    -- nothing todo
  elseif item.Quantity == 0 then
    s = s .. ConfigShop.textInColor('red', " rupture")
  elseif item.Quantity > 0 then
    s = s .. ConfigShop.textInColor('green', " " .. item.Quantity .. " en stock")
  else
    s = s .. ConfigShop.textInColor('green', " stock illimité")
  end

  if item.Ordered == nil then
    -- nothing todo
  elseif item.Ordered == 0 then
    s = s .. ConfigShop.textInColor('grey', " (pas de commande)")
  elseif item.Ordered > 0 then
    s = s .. ConfigShop.textInColor('blue', " (+" .. item.Ordered .. ")")
  end

  return s
end

function orderToString(order)
  return "Commande " .. order.Ref 
end

function orderStatusToString(order)
  s = ""
  if order.Signed == 1 then
    s = s .. ConfigShop.textInColor('green', "Signée")
  elseif order.Started == 1 then
    s = s .. ConfigShop.textInColor('yellow', "Livraison en cours")
  elseif order.Finalized == 0 then
    s = s .. ConfigShop.textInColor('orange', "A finaliser")
  else
    s = s .. ConfigShop.textInColor('grey', "En attente")
  end
  return s
end

-- ============== --
-- Buttons action --
-- ============== --

function goTo(args)
  ConfigShop.page = args[1]
  TriggerServerEvent(table.unpack(args, 2))
end

function buyItem(item)
  TriggerServerEvent("Shops:TestBuy", item.ContentId, ConfigShop.currentShopId)
end

function getMoney()
  TriggerServerEvent("Shops:getMoney", ConfigShop.currentShopId)
end

function removeItemFromStock(item)
  TriggerServerEvent("Shops:removeItemFromStock", item)
end

function orderItem(item)
  local nb = ShopsTools.OpenKeyboard("", "" .. (item.Ordered or ''), 10,
    "Combien voulez-vous de '" .. item.Name .. "' à " .. item.Price .. "€/unité")
  if tonumber(nb) ~= nil and tonumber(nb) >= 0 then
    TriggerServerEvent("Shops:OrderItem", ConfigShop.currentOrderId, item, tonumber(nb))
  else
    ConfigShop.shopsNotification.message = ConfigShop.textInColor('red', "Une erreur dans le nombre saisi.")
    TriggerEvent("Venato:notify", ConfigShop.shopsNotification)
  end
end

function setPrice(item)
  local nb = ShopsTools.OpenKeyboard("", "" .. (item.Price or ''), 10,
    "Quel prix voulez-vous pour '" .. item.Name .. "'")
  if tonumber(nb) ~= nil and tonumber(nb) >= 0 then
    TriggerServerEvent("Shops:ChangePriceItem", item, tonumber(nb))
  else
    ConfigShop.shopsNotification.message = ConfigShop.textInColor('red', "Une erreur dans le nombre saisi.")
    TriggerEvent("Venato:notify", ConfigShop.shopsNotification)
  end
end

function removeItemFromOrder(item)
  TriggerServerEvent("Shops:removeItemFromOrder", item)
end

function addItemToStock(item)
  TriggerServerEvent("Shops:AddItemToShop", ConfigShop.currentInventoryId, ConfigShop.currentOrderId, item)
end

function createOrder()
  TriggerServerEvent("Shops:CreateOrder", ConfigShop.currentShopId)
end

function deleteOrder()
  ConfigShop.page = "admin"
  TriggerServerEvent("Shops:DeleteOrder", ConfigShop.currentOrderId, ConfigShop.currentShopId)
end

function finalizeOrder()
  ConfigShop.page = "admin"
  TriggerServerEvent("Shops:FinalizeOrder", ConfigShop.currentOrderId, ConfigShop.currentShopId)
end

function formatQte(quantity)
  if quantity == nil then
    return ""
  elseif quantity == 0 then
    return ConfigShop.textInColor('red', "Rupture de stock")
  elseif quantity > 0 then
    return "Stock : " .. ConfigShop.textInColor('deep-orange', quantity.."")
  else
    return "Stock : " .. ConfigShop.textInColor('amber', "illimité")
  end
end

function formatOrdered(ordered)
  if ordered == nil then
    return ""
  elseif ordered == 0 then
    return ConfigShop.textInColor('grey', " (pas de commande)")
  else
    return ConfigShop.textInColor('blue', " (+" .. ordered .. ")")
  end
end