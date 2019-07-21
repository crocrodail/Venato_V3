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
    TriggerEvent('Menu:AddButton2', ConfigShop.textInColor('yellow', "Administration →"), "goTo", table.pack("admin",
      "Shops:ShowInventory", ConfigShop.currentShopId), nil)
  end

  for _, item in ipairs(shop.Items) do
    local textButton = itemToString(item)
    TriggerEvent('Menu:AddButton2', textButton, "buyItem", item, nil)
  end
end

-- ADMIN --
function ShopPages.admin(shop)
  if not shop.IsSupervisor then
    goToClientPage()
  end

  TriggerEvent('Menu:Title', ConfigShop.textInColor('yellow', "Administration"))
  TriggerEvent('Menu:SubTitle', "Caisse: " .. ConfigShop.textInColor('orange', shop.Money .. "€"))

  TriggerEvent('Menu:AddButton2', ConfigShop.textInColor('yellow', "↩ Stocks"), "goTo",
    table.pack("client", "Shops:ShowInventory", ConfigShop.currentShopId), nil)
  TriggerEvent('Menu:AddButton2', ConfigShop.textInColor('blue', "Récuperer caisse →"), "getMoney", nil)
  TriggerEvent('Menu:AddButton2', ConfigShop.textInColor('blue', "Créer commande →"), "createOrder", nil)

  for _, order in ipairs(shop.Orders) do
    local textButton = orderToString(order)

    TriggerEvent('Menu:AddButton2', textButton, "goTo", table.pack("order", "Shops:showOrder", order.Id), nil)
  end

  for _, item in ipairs(shop.Items) do
    local textButton = itemToString(item)
    TriggerEvent('Menu:AddButton2', textButton, "goTo",
      table.pack("adminItem", "Shops:showAdminItem", ConfigShop.currentShopId, item), nil)
  end
end

-- ORDER --
function ShopPages.order(order)
  ConfigShop.currentOrderId = order.Id
  TriggerEvent('Menu:Title', ConfigShop.textInColor('yellow', "Commande: " .. order.Ref))
  TriggerEvent('Menu:SubTitle', "Selectionne un produit pour le modifier")

  TriggerEvent('Menu:AddButton2', ConfigShop.textInColor('yellow', "↩ Administration"), "goTo",
    table.pack("admin", "Shops:ShowInventory", ConfigShop.currentShopId), nil)
  TriggerEvent('Menu:AddButton2', ConfigShop.textInColor('blue', "Ajouter un produit"), "goTo",
    table.pack("addItem", "Shops:showAddItem", ConfigShop.currentShopId), nil)
  TriggerEvent('Menu:AddButton2', ConfigShop.textInColor('blue', "Supprimer commande"), "deleteOrder", nil)
  if order.Finalized ~= 1 and #order.Items > 0 then
    TriggerEvent('Menu:AddButton2', ConfigShop.textInColor('blue', "Finaliser commande"), "finalizeOrder", nil)
  end

  for _, item in ipairs(order.Items) do
    local textButton = itemToString(item)
    TriggerEvent('Menu:AddButton2', textButton, "goTo",
      table.pack("orderItem", "Shops:ShowItem", ConfigShop.currentShopId, item), nil)
  end
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
  TriggerEvent('Menu:AddButton2', ConfigShop.textInColor('yellow', "↩ Commande"), "goTo",
    table.pack("order", "Shops:showOrder", ConfigShop.currentOrderId), nil)
  TriggerEvent('Menu:AddButton2', "Définir la quantité", "orderItem", item, nil)
  if item.Id ~= nil then
    TriggerEvent('Menu:AddButton2', "Retirer de la commande", "removeItemFromOrder", item, nil)
  end
end

function ShopPages.adminItem(item)
  TriggerEvent('Menu:Title', item.Name)
  TriggerEvent('Menu:SubTitle', "info: " .. itemToString(item))

  TriggerEvent('Menu:AddButton2', ConfigShop.textInColor('yellow', "↩ Administration"), "goTo",
    table.pack("admin", "Shops:ShowInventory", ConfigShop.currentShopId), nil)
  TriggerEvent('Menu:AddButton2', "Modifier prix", "setPrice", item, nil)
  TriggerEvent('Menu:AddButton2', "Retirer du stock", "removeItemFromStock", item, nil)
end

function ShopPages.addItem(items)
  TriggerEvent('Menu:Title', "Ajouter un produit")
  TriggerEvent('Menu:SubTitle', "Sélectionne le produit à ajouter")

  TriggerEvent('Menu:AddButton2', ConfigShop.textInColor('yellow', "↩ Commande"), "goTo",
    table.pack("order", "Shops:showOrder", ConfigShop.currentOrderId), nil)

  for _, item in ipairs(items) do
    local textButton = itemToString(item)
    TriggerEvent('Menu:AddButton2', textButton, "addItemToStock", item, nil)
  end
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
  local s = "Commande " .. order.Ref
  if order.Signed == 1 then
    s = s .. ConfigShop.textInColor('green', " signée")
  elseif order.Started == 1 then
    s = s .. ConfigShop.textInColor('yellow', " livraison en cours")
  elseif order.Finalized == 0 then
    s = s .. ConfigShop.textInColor('orange', " à finaliser")
  else
    s = s .. ConfigShop.textInColor('grey', " en attente")
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
  local nb = ShopsTools.OpenKeyboard("", "" .. (item.Ordered or 0), 10,
    "Combien voulez-vous de '" .. item.Name .. "' à " .. item.Price .. "€/unité")
  if tonumber(nb) ~= nil and tonumber(nb) >= 0 then
    TriggerServerEvent("Shops:OrderItem", ConfigShop.currentOrderId, item, tonumber(nb))
  else
    ConfigShop.shopsNotification.message = ConfigShop.textInColor('red', "Une erreur dans le nombre saisi.")
    TriggerEvent("Venato:notify", ConfigShop.shopsNotification)
  end
end

function setPrice(item)
  local nb = ShopsTools.OpenKeyboard("", "" .. (item.Price or 0), 10,
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
