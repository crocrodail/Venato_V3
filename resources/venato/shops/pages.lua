--[[
  Menu pages for interactions with users

  @author Astymeus
  @date 2019-07-11
  @version 1.0
--]]

ShopPages = {}

-- ========== --
-- Draw Pages --
-- ========== --

function ShopPages.drawPage(content)
  ConfigShop.menuOpen = true

  ClearMenu()
  Menu.hidden = false
  showPageInfo = true

  if ConfigShop.page == "admin" then
    ShopPages.admin(content)
  elseif ConfigShop.page == "order" then
    ShopPages.order(content)
  elseif ConfigShop.page == "orderItem" then
    ShopPages.orderItem(content)
  else
    ShopPages.client(content)
  end
end

-- CLIENT --
function ShopPages.client(shop)  
    ConfigShop.currentOrderId = nil
    local color = "~s~"
    local shopName_ = shop.Renamed or shop.Name or "Shop"
    MenuTitle = color..""..shopName_
    MenuDescription = "Stocks"

    if shop.Supervisor == 1 then
      MenuDescription = MenuDescription .. " supervised by: "
      for _, manager in ipairs(shop.Managers) do
        MenuDescription = MenuDescription .. " ".. manager.Name
      end
    end

    if shop.IsSupervisor then
      Menu.addButton("~b~Administration →", "goToAdministrationPage")
    end

    showProducts(shop.Items)
  end
  
-- ADMIN --
function ShopPages.admin(shop)
    if not shop.IsSupervisor then
        goToClientPage()
    end

    local color = "~y~"
    MenuTitle = color.."Administration"
    MenuDescription = "caisse: "..shop.Money.."€"

    Menu.addButton("~y~↩ Stocks", "goToClientPage")
    Menu.addButton("~b~Récuperer caisse →", "getMoney", {['Id']=shop.Id, ['Money']=shop.Money})
    Menu.addButton("~b~Créer commande →", "createOrder")

    showOrders(shop.Orders)
end

-- ORDER --
function ShopPages.order(order)
    local color = "~y~"
    MenuTitle = color.."Commande: "..order.Ref
    MenuDescription = "Selectionne un produit pour le modifier"

    Menu.addButton("~y~↩ Administration", "goToAdministrationPage")
    Menu.addButton("~o~TODO:~b~ Ajouter un produit", "addItemToStock")
    Menu.addButton("~b~ Supprimer commande", "deleteOrder")
    if(order.Finalized ~= 1) then
      Menu.addButton("~b~ Finaliser commande", "finalizeOrder")
    end

    showProducts(order.Items, true)
end


function ShopPages.orderItem(item)
  MenuTitle = item.Name

  if item.Ordered == nil or item.Ordered == 0 then
    MenuTitle = MenuTitle.." ~t~(pas de commande)"
  elseif item.Ordered > 0 then
    MenuTitle = MenuTitle.." ~b~(+".. item.Ordered ..")"
  end

	MenuDescription = "Actions"
	Menu.addButton("~y~↩ Commande", "goToOrderPage", ConfigShop.currentOrderId)
	Menu.addButton("Commander", "orderItem", item)
	Menu.addButton("Modifier prix", "setPrice", item)
	Menu.addButton("Retirer", "removeItem", item)
end

-- ===== --
-- Tools --
-- ===== --

function showProducts(items, isOrder)
  isOrder = isOrder or false
  for _, item in ipairs(items) do
    local textButton = itemToString(item, isOrder)
    
    local action = isOrder and 'goToOrderItemPage' or 'buyItem'
    local id = isOrder and item.Id or item.ContentId
    Menu.addButton(textButton, action, {["itemId"]=id, ["shopId"]=ConfigShop.currentShopId})
  end
end

function itemToString(item, isOrder)
  local s = "~s~"..item.Name.." ~o~"..item.Price.."€~s~"
  if item.Quantity == 0 then
    s = s.." ~r~Rupture"
  elseif item.Quantity > 0 then
    s = "~s~"..s.." ~g~"..item.Quantity.." en stock"
  else
    s = "~s~"..s.."~g~ stock illimité"
  end

  if isOrder then
    if item.Ordered == nil or item.Ordered == 0 then
      s = s.." ~t~(pas de commande)"
    elseif item.Ordered > 0 then
      s = s.." ~b~(+".. item.Ordered ..")"
    end
  end

  return s
end

function showOrders(orders)
  for _, order in ipairs(orders) do
    local textButton = orderToString(order)
    
    Menu.addButton(textButton, 'goToOrderPage', order.Id)
  end
end

function orderToString(order)
  local s = "~s~"..order.Ref
  if order.Signed == 1 then
    s = s .. " ~g~signée"
  elseif order.Started == 1 then
    s = s .. " ~y~livraison en cours"
  elseif order.Finalized == 0 then
    s = s .. " ~o~à finaliser"
  else
    s = s .. " ~t~en attente"
  end
  return s
end

-- ============== --
-- Buttons action --
-- ============== --
  
  function goToOrderItemPage(args)
    ConfigShop.page="orderItem"
    TriggerServerEvent("Shops:ShowItem", args)
  end
  
  function goToClientPage()
    ConfigShop.page="client"
    TriggerServerEvent("Shops:ShowInventory", ConfigShop.currentShopId)
  end
  
  function goToAdministrationPage()
    ConfigShop.page="admin"
    TriggerServerEvent("Shops:ShowInventory", ConfigShop.currentShopId)
  end
  
  function goToOrderPage(orderId)
    ConfigShop.page="order"
    ConfigShop.currentOrderId = orderId 
    TriggerServerEvent("Shops:showOrder", ConfigShop.currentOrderId)
  end

  function buyItem(args)
    print("buyItem", Venato.dump(args))
    TriggerServerEvent("Shops:TestBuy", args.itemId, args.shopId)
  end
  
  function getMoney(shop)
    TriggerServerEvent("Shops:getMoney", shop.Money, ConfigShop.currentShopId)
  end
  
  function addItemToStock()
    ConfigShop.shopsNotification.message = ConfigShop.textInOrangeColor("Pas encore implémenté ...")
    Venato.notify(ConfigShop.shopsNotification)
  end
  
  function removeItemFromStock()
    ConfigShop.shopsNotification.message = ConfigShop.textInOrangeColor("Pas encore implémenté ...")
    Venato.notify(ConfigShop.shopsNotification)
  end
  
  function orderItem(item)
    local nb = Venato.OpenKeyboard(
      '',
       ""..(item.Ordered or 0),
      10,
      "Combien voulez-vous de '"..item.Name.."' à "..item.Price.."€/unité"
    )
    if tonumber(nb) ~= nil and tonumber(nb) >= 0 then
      TriggerServerEvent("Shops:OrderItem", ConfigShop.currentOrderId, item, tonumber(nb))
    else
      ConfigShop.shopsNotification.message = ConfigShop.textInRedColor("Une erreur dans le nombre choisi.")
      Venato.notify(ConfigShop.shopsNotification)
    end
  end
  
  function setPrice()
    ConfigShop.shopsNotification.message = ConfigShop.textInOrangeColor("Pas encore implémenté ...")
    Venato.notify(ConfigShop.shopsNotification)
  end
  
  function removeItem(item)
    ConfigShop.shopsNotification.message = ConfigShop.textInOrangeColor("Pas encore implémenté ...")
    Venato.notify(ConfigShop.shopsNotification)
  end

  function createOrder()
    TriggerServerEvent("Shops:CreateOrder", ConfigShop.currentShopId)
  end

  function deleteOrder()
    ConfigShop.page="admin"
    TriggerServerEvent("Shops:DeleteOrder", ConfigShop.currentOrderId, ConfigShop.currentShopId)
  end

  function finalizeOrder()
    ConfigShop.page="admin"
    TriggerServerEvent("Shops:FinalizeOrder", ConfigShop.currentOrderId, ConfigShop.currentShopId)
  end
