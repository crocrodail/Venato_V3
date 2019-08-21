--[[
  Client entry point for delivery job events

  @author Astymeus
  @date 2019-07-28
  @version 1.0
--]]

-- ==================== --
-- Callback from Server --
-- ==================== --

RegisterNetEvent("DeliveryJob:getWarehouses:cb")

AddEventHandler("DeliveryJob:getWarehouses:cb", function(warehouses)
  DeliveryJobConfig.warehouses = warehouses
end)
