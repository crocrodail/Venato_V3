--[[
  Config variables for shops

  @author Astymeus
  @date 2019-07-11
  @version 1.0
--]]
ConfigShop = {}
ConfigShop.EnableShops = true
ConfigShop.page = "client"
ConfigShop.menuOpen = false
ConfigShop.currentShopId = nil
ConfigShop.currentOrderId = nil
ConfigShop.currentInventoryId = nil
ConfigShop.inShopMarker = false

ConfigShop.shopsNotification = {
  title = "Magasin",
  logo = "https://img.icons8.com/nolan/96/000000/online-store.png"
}

function ConfigShop.textInRedColor(msg)
  return ("<span class='red--text'>" .. msg .. "</span>")
end

function ConfigShop.textInGreenColor(msg)
  return ("<span class='green--text'>" .. msg .. "</span>")
end

function ConfigShop.textInOrangeColor(msg)
  return ("<span class='orange--text'>" .. msg .. "</span>")
end
