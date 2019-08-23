--[[
  Client entry point for delivery job events

  @author Astymeus
  @date 2019-07-28
  @version 1.0
--]]

RegisterNetEvent("DeliveryJob:getWarehouses")

AddEventHandler("DeliveryJob:getWarehouses", function()
  TriggerClientEvent("DeliveryJob:getWarehouses:cb", source, DeliveryJobDbFunctions.getWarehouses())
end)
