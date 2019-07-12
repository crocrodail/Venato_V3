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

-- CLIENT --
function ShopPages.client(shop)
    ConfigShop.menuOpen = true
  
    ClearMenu()
    Menu.hidden = false
  
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
      Menu.addButton("Administration →", "goToAdministrationPage")
    end
  
    showProducts(shop)
  
  end
  
-- ADMIN --
function ShopPages.admin(shop)
    if not shop.IsSupervisor then
        goToClientPage()
    end

    ConfigShop.menuOpen = true
    ClearMenu()
    Menu.hidden = false

    local color = "~y~"
        MenuTitle = color.."Administration"
        MenuDescription = "caisse: "..shop.Money.."€"

    Menu.addButton("↩ Stocks", "goToClientPage")
    Menu.addButton("Passer commande →", "goToOrderPage")
    Menu.addButton("Récuperer caisse →", "getMoney", {['Id']=shop.Id, ['Money']=shop.Money})
end

-- ORDER --
function ShopPages.order(shop)
    if not shop.IsSupervisor then
        goToClientPage()
    end

    ConfigShop.menuOpen = true
    ClearMenu()
    Menu.hidden = false

    local color = "~y~"
    local shopName_ = shop.Renamed or shop.Name or "Shop"
        MenuTitle = color.."Commande"
        MenuDescription = "Selectionne sur un produit pour le modifier"

    Menu.addButton("↩ Administration", "goToAdministrationPage")
    Menu.addButton("TODO: Ajouter un produit", "addItemToStock")

    showProducts(shop, true)

end

-- ===== --
-- Tools --
-- ===== --

function showProducts(shop, isOrder)
  isOrder = isOrder or false
  for _, item in ipairs(shop.Items) do
    local textButton = "~s~"..item.Name.." ~o~"..item.Price.."€~s~"
    if item.Quantity == 0 then
      textButton = textButton.." ~r~Rupture"
    elseif item.Quantity > 0 then
      textButton = "~s~"..textButton.." ~g~"..item.Quantity.." en stock"
    else
      textButton = "~s~"..textButton.."~g~ stock illimité"
    end

    local action = isOrder and 'orderItem' or 'buyItem'

    Menu.addButton(textButton, action, {["item"]=item, ["shopId"]=shop.Id})
  end
end

-- ============== --
-- Buttons action --
-- ============== --

function buyItem(args)
    TriggerServerEvent("Shops:TestBuy", args.item, args.shopId)
  end
  
  function orderItem(args)
    Venato.notify("~o~Pas encore implémenté ...")
  end
  
  function goToClientPage()
    ConfigShop.page="client"
    TriggerServerEvent("Shops:ShowInventory", ConfigShop.currentId)
  end
  
  function goToAdministrationPage()
    ConfigShop.page="admin"
    TriggerServerEvent("Shops:ShowInventory", ConfigShop.currentId)
  end
  
  function goToOrderPage()
    ConfigShop.page="order"
    TriggerServerEvent("Shops:ShowInventory", ConfigShop.currentId)
  end
  
  function getMoney(shop)
    TriggerServerEvent("Shops:getMoney", shop.Money, ConfigShop.currentId)
  end
  
  function addItemToStock()
    Venato.notify("~o~Pas encore implémenté ...")
  end
  
  function removeItemFromStock()
    Venato.notify("~o~Pas encore implémenté ...")
  end