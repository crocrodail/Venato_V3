-- ==================== --
-- Callback from Server --
-- ==================== --

RegisterNetEvent("Shops:UpdateMenu:cb")
RegisterNetEvent("Shops:getMoney:cb")
RegisterNetEvent("Shops:TestBuy:cb")
RegisterNetEvent("Shops:TestBuyPro:cb")
RegisterNetEvent("Shops:NotEnoughMoney")
RegisterNetEvent("Shops:NotEnoughShopMoney")
RegisterNetEvent("Shops:NotEnoughQuantity")
RegisterNetEvent("Shops:TooHeavy")
RegisterNetEvent("Shops:StockNotEmpty")
RegisterNetEvent("Shops:OrderContainsItem")
RegisterNetEvent("Shops:OrderItem:cb")
RegisterNetEvent("Shops:AddItemToShop:cb")
RegisterNetEvent("Shops:ChangePriceItem:cb")
RegisterNetEvent("Shops:removeItemFromStock:cb")
RegisterNetEvent("Shops:removeItemFromOrder:cb")

AddEventHandler("Shops:UpdateMenu:cb", Shops.drawPage)

AddEventHandler("Shops:getMoney:cb", function(Price)
  msg = "Vous avez bien récupéré " .. Price .. "€."
  ConfigShop.shopsNotification.message = ConfigShop.textInColor('green', msg)
  TriggerEvent("venato:notify", ConfigShop.shopsNotification)
  TriggerServerEvent("Shops:ShowInventory", ConfigShop.currentShopId)
end)

AddEventHandler("Shops:TestBuy:cb", function(Name)
  msg = "Vous avez bien acheté " .. Name .. "."
  ConfigShop.shopsNotification.message = ConfigShop.textInColor('green', msg)
  TriggerEvent("venato:notify", ConfigShop.shopsNotification)
  TriggerServerEvent("Shops:ShowInventory", ConfigShop.currentShopId)
end)

AddEventHandler("Shops:TestBuyPro:cb", function(Name)
  msg = "Vous avez bien acheté " .. Name .. "."
  ConfigShop.shopsNotification.message = ConfigShop.textInColor('green', msg)
  TriggerEvent("venato:notify", ConfigShop.shopsNotification)
end)

AddEventHandler("Shops:NotEnoughMoney", function(Name)
  msg = "Vous n'avez pas assez d'argent pour acheter " .. Name .. "."
  ConfigShop.shopsNotification.message = ConfigShop.textInColor('red', msg)
  TriggerEvent("venato:notify", ConfigShop.shopsNotification)
  TriggerServerEvent("Shops:ShowInventory", ConfigShop.currentShopId)
end)

AddEventHandler("Shops:NotEnoughShopMoney", function(Price)
  msg = "Le magasin n'a pas assez d'argent pour récupérer " .. Price .. "€."
  ConfigShop.shopsNotification.message = ConfigShop.textInColor('red', msg)
  TriggerEvent("venato:notify", ConfigShop.shopsNotification)
  TriggerServerEvent("Shops:ShowInventory", ConfigShop.currentShopId)
end)

AddEventHandler("Shops:NotEnoughQuantity", function(Name)
  msg = "Il n'y a plus assez de " .. Name .. " en stock."
  ConfigShop.shopsNotification.message = ConfigShop.textInColor('red', msg)
  TriggerEvent("venato:notify", ConfigShop.shopsNotification)
  TriggerServerEvent("Shops:ShowInventory", ConfigShop.currentShopId)
end)

AddEventHandler("Shops:TooHeavy", function(Name)
  msg = "Vous avez trop d'objets pour acheter " .. Name .. "."
  ConfigShop.shopsNotification.message = ConfigShop.textInColor('red', msg)
  TriggerEvent("venato:notify", ConfigShop.shopsNotification)
  TriggerServerEvent("Shops:ShowInventory", ConfigShop.currentShopId)
end)

AddEventHandler("Shops:StockNotEmpty", function(item)
  msg = "Vous devez videz le stock de " .. item.Name .. " avant de le retirer de l'inventaire."
  ConfigShop.shopsNotification.message = ConfigShop.textInColor('red', msg)
  TriggerEvent("venato:notify", ConfigShop.shopsNotification)
  ConfigShop.page = "adminItem"
  TriggerServerEvent("Shops:showAdminItem", ConfigShop.currentShopId, item)
end)

AddEventHandler("Shops:OrderContainsItem", function(item)
  msg = "Impossible, au moins une commande contient cette article (" .. item.Name .. ")."
  ConfigShop.shopsNotification.message = ConfigShop.textInColor('red', msg)
  TriggerEvent("venato:notify", ConfigShop.shopsNotification)
  ConfigShop.page = "adminItem"
  TriggerServerEvent("Shops:showAdminItem", ConfigShop.currentShopId, item)
end)

AddEventHandler("Shops:OrderItem:cb", function(Quantity, Name)
  msg = "Vous avez bien commandé pour " .. Quantity .. ": " .. Name .. "."
  ConfigShop.shopsNotification.message = ConfigShop.textInColor('green', msg)
  TriggerEvent("venato:notify", ConfigShop.shopsNotification)
  ConfigShop.page = "order"
  TriggerServerEvent("Shops:showOrder", ConfigShop.currentOrderId)
end)

AddEventHandler("Shops:AddItemToShop:cb", function(item)
  msg = "Vous avez bien ajouté " .. item.Name .. "."
  ConfigShop.shopsNotification.message = ConfigShop.textInColor('green', msg)
  TriggerEvent("venato:notify", ConfigShop.shopsNotification)
  ConfigShop.page = "order"
  TriggerServerEvent("Shops:showOrder", ConfigShop.currentOrderId)
end)

AddEventHandler("Shops:ChangePriceItem:cb", function(item, price)
  msg = "Vous avez bien changé le prix de " .. item.Name .. " à " .. price .. "."
  ConfigShop.shopsNotification.message = ConfigShop.textInColor('green', msg)
  TriggerEvent("venato:notify", ConfigShop.shopsNotification)
  ConfigShop.page = "adminItem"
  TriggerServerEvent("Shops:showAdminItem", ConfigShop.currentShopId, item)
end)

AddEventHandler("Shops:removeItemFromStock:cb", function(item)
  msg = "Vous avez bien retiré " .. item.Name .. " du stock."
  ConfigShop.shopsNotification.message = ConfigShop.textInColor('green', msg)
  TriggerEvent("venato:notify", ConfigShop.shopsNotification)
  ConfigShop.page = "admin"
  TriggerServerEvent("Shops:ShowInventory", ConfigShop.currentShopId)
end)

AddEventHandler("Shops:removeItemFromOrder:cb", function(item)
  msg = "Vous avez bien retiré " .. item.Name .. " de la commande."
  ConfigShop.shopsNotification.message = ConfigShop.textInColor('green', msg)
  TriggerEvent("venato:notify", ConfigShop.shopsNotification)
  ConfigShop.page = "order"
  TriggerServerEvent("Shops:showOrder", ConfigShop.currentOrderId)
end)
