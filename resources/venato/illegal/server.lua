local defaultNotification = {
    type = "alert",
    title ="Illegal",
    logo = "https://i.ibb.co/PxrBpGQ/icons8-pills-96px.png"
  }

RegisterServerEvent('illegal:farm')
AddEventHandler('illegal:farm', function(drugId)
    local source = source
    local drugItem = drugs[drugId]
    TriggerEvent("Inventory:AddItem", drugItem.farm.give_qte, drugItem.farm.item_id, source)
    defaultNotification.message = "Vous avez reçu " .. drugItem.farm.give_qte .. drugItem.farm.give_message..".";
    Venato.notify(source, defaultNotification)
end)

RegisterServerEvent('illegal:transform')
AddEventHandler('illegal:transform', function(drugId)
    local source = source
    local drugItem = drugs[drugId]
    if(Venato.CheckItem(drugItem.farm.item_id, source) < drugItem.transform.transform_qte) then
        defaultNotification.message = "Vous n'avez pas assez de " .. drugItem.farm.give_message .. " à transformer."
    else
        TriggerEvent("Inventory:RemoveItem", drugItem.transform.transform_qte, drugItem.transform.origin_item_id, source)
        TriggerEvent("Inventory:AddItem", drugItem.transform.transform_qte, drugItem.transform.product_item_id, source)
        defaultNotification.message = "Vous avez reçu " .. drugItem.transform.transform_qte .. drugItem.transform.transform_message .. "."      
    end
    Venato.notify(source, defaultNotification)
end)

RegisterServerEvent('illegal:sell')
AddEventHandler('illegal:sell', function(drugId)
    local source = source
    local drugItem = drugs[drugId]
    if(Venato.CheckItem(drugItem.sell.item_id, source) < drugItem.sell.sell_qte) then
        defaultNotification.message = "Vous n'avez pas assez de " .. drugItem.transform.transform_message .. " à vendre."
    else
        TriggerEvent("Inventory:RemoveItem", drugItem.sell.sell_qte, drugItem.sell.item_id, source)
        TriggerEvent('Inventory:AddMoney', drugItem.sell.sell_price, source)
        defaultNotification.message = "Vous avez vendu " .. drugItem.sell.sell_qte .. drugItem.transform.transform_message .. ".<br/> Vous avez reçu <span class='green--text'>"..drugItem.sell.sell_price.." €</span>"
    end
    Venato.notify(source, defaultNotification)
end)