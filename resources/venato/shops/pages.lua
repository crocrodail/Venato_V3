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

  Menu.clearMenu()
  Menu.open()

  -- Search in registered pages the current one
  -- and if found, show it with content in parameters
  if ShopPages[ConfigShop.page] ~= nil then ShopPages[ConfigShop.page](content) end
end

-- CLIENT --
function ShopPages.client(shop)
  ConfigShop.currentOrderId = nil
  local shopName_ = shop.Renamed or shop.Name or "Shop"
  Menu.setTitle(shopName_)
  local subTitle = "Stocks"

  ConfigShop.currentInventoryId = shop.InventoryId
  if shop.Supervised == 1 then
    subTitle = subTitle .. " supervised by: "
    for index, manager in ipairs(shop.Managers) do
      if index > 1 then subTitle = subTitle .. "," end
      subTitle = subTitle .. manager.Name
    end
  end
  Menu.setSubtitle(subTitle)

  if shop.IsSupervisor then
    Menu.addButton(ConfigShop.textInYellowColor("Administration →"), "goTo", table.pack("admin",
      "Shops:ShowInventory", ConfigShop.currentShopId))
  end

  for _, item in ipairs(shop.Items) do
    local textButton = itemToString(item)
    Menu.addButton(textButton, "buyItem", item)
  end
end

-- ADMIN --
function ShopPages.admin(shop)
  if not shop.IsSupervisor then
    goToClientPage()
  end

  Menu.setTitle(ConfigShop.textInYellowColor("Administration"))
  Menu.setSubtitle("caisse: " .. shop.Money .. "€")

  Menu.addButton(ConfigShop.textInYellowColor("↩ Stocks"), "goTo",
    table.pack("client", "Shops:ShowInventory", ConfigShop.currentShopId))
  Menu.addButton(ConfigShop.textInBlueColor("Récuperer caisse →"), "getMoney")
  Menu.addButton(ConfigShop.textInBlueColor("Créer commande →"), "createOrder")

  for _, order in ipairs(shop.Orders) do
    local textButton = orderToString(order)

    Menu.addButton(textButton, "goTo", table.pack("order", "Shops:showOrder", order.Id))
  end

  for _, item in ipairs(shop.Items) do
    local textButton = itemToString(item)
    Menu.addButton(textButton, "goTo", table.pack("adminItem", "Shops:showAdminItem", ConfigShop.currentShopId, item))
  end
end

-- ORDER --
function ShopPages.order(order)
  ConfigShop.currentOrderId = order.Id
  Menu.setTitle(ConfigShop.textInYellowColor("Commande: " .. order.Ref))
  Menu.setSubtitle("Selectionne un produit pour le modifier")

  Menu.addButton(ConfigShop.textInYellowColor("↩ Administration"), "goTo",
    table.pack("admin", "Shops:ShowInventory", ConfigShop.currentShopId))
  Menu.addButton(ConfigShop.textInBlueColor("Ajouter un produit"), "goTo",
    table.pack("addItem", "Shops:showAddItem", ConfigShop.currentShopId))
  Menu.addButton(ConfigShop.textInBlueColor("Supprimer commande"), "deleteOrder")
  if order.Finalized ~= 1 and #order.Items > 0 then
    Menu.addButton(ConfigShop.textInBlueColor("Finaliser commande"), "finalizeOrder")
  end

  for _, item in ipairs(order.Items) do
    local textButton = itemToString(item)
    Menu.addButton(textButton, "goTo",
      table.pack("orderItem", "Shops:ShowItem", ConfigShop.currentShopId, item))
  end
end

function ShopPages.orderItem(item)
  menuTitle = item.Name
  if item.Ordered == 0 then
    menuTitle = menuTitle .. ConfigShop.textInGrayColor(" (pas de commande)")
  else
    menuTitle = menuTitle .. ConfigShop.textInBlueColor(" (+" .. item.Ordered .. ")")
  end
  Menu.setTitle(menuTitle)

  Menu.setSubtitle("Actions")
  Menu.addButton(ConfigShop.textInYellowColor("↩ Commande"), "goTo",
    table.pack("order", "Shops:showOrder", ConfigShop.currentOrderId))
  Menu.addButton("Définir la quantité", "orderItem", item)
  Menu.addButton("Retirer de la commande", "removeItemFromOrder", item)
end

function ShopPages.adminItem(item)
  Menu.setTitle(item.Name)
  Menu.setSubtitle("info: " .. itemToString(item))

  Menu.addButton(ConfigShop.textInYellowColor("↩ Administration"), "goTo",
    table.pack("admin", "Shops:ShowInventory", ConfigShop.currentShopId))
  Menu.addButton("Modifier prix", "setPrice", item)
  Menu.addButton("Retirer du stock", "removeItemFromStock", item)
end

function ShopPages.addItem(items)
  Menu.setTitle("Ajouter un produit")
  Menu.setSubtitle("Sélectionne le produit à ajouter")

  Menu.addButton(ConfigShop.textInYellowColor("↩ Commande"), "goTo",
    table.pack("order", "Shops:showOrder", ConfigShop.currentOrderId))

  for _, item in ipairs(items) do
    local textButton = itemToString(item)
    Menu.addButton(textButton, "addItemToStock", item)
  end
end

-- ===== --
-- Tools --
-- ===== --

function itemToString(item)
  local s = item.Name

  if item.Price ~= nil then
    s = s .. ConfigShop.textInOrangeColor(" " .. item.Price .. "€")
  end

  if item.Quantity == nil then
    -- nothing todo
  elseif item.Quantity == 0 then
    s = s .. ConfigShop.textInRedColor(" rupture")
  elseif item.Quantity > 0 then
    s = s .. ConfigShop.textInGreenColor(" " .. item.Quantity .. " en stock")
  else
    s = s .. ConfigShop.textInGreenColor(" stock illimité")
  end

  if item.Ordered == nil then
    -- nothing todo
  elseif item.Ordered == 0 then
    s = s .. ConfigShop.textInGrayColor(" (pas de commande)")
  elseif item.Ordered > 0 then
    s = s .. ConfigShop.textInBlueColor(" (+" .. item.Ordered .. ")")
  end

  return s
end

function orderToString(order)
  local s = "Commande " .. order.Ref
  if order.Signed == 1 then
    s = s .. ConfigShop.textInGreenColor(" signée")
  elseif order.Started == 1 then
    s = s .. ConfigShop.textInYellowColor(" livraison en cours")
  elseif order.Finalized == 0 then
    s = s .. ConfigShop.textInOrangeColor(" à finaliser")
  else
    s = s .. ConfigShop.textInGrayColor(" en attente")
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
  local nb = Venato.OpenKeyboard(
    "",
    "" .. (item.Ordered or 0),
    10,
    "Combien voulez-vous de '" .. item.Name .. "' à " .. item.Price .. "€/unité"
  )
  if tonumber(nb) ~= nil and tonumber(nb) >= 0 then
    TriggerServerEvent("Shops:OrderItem", ConfigShop.currentOrderId, item, tonumber(nb))
  else
    ConfigShop.shopsNotification.message = ConfigShop.textInRedColor("Une erreur dans le nombre saisi.")
    Venato.notify(ConfigShop.shopsNotification)
  end
end

function setPrice(item)
  local nb = Venato.OpenKeyboard(
    "",
    "" .. (item.Price or 0),
    10,
    "Quel prix voulez-vous pour '" .. item.Name .. "'"
  )
  if tonumber(nb) ~= nil and tonumber(nb) >= 0 then
    TriggerServerEvent("Shops:ChangePriceItem", item, tonumber(nb))
  else
    ConfigShop.shopsNotification.message = ConfigShop.textInRedColor("Une erreur dans le nombre saisi.")
    Venato.notify(ConfigShop.shopsNotification)
  end
end

function removeItemFromOrder(item)
  ConfigShop.shopsNotification.message = ConfigShop.textInOrangeColor("Pas encore implémenté ...")
  Venato.notify(ConfigShop.shopsNotification)
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
