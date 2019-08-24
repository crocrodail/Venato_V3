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
RegisterNetEvent("DeliveryJob:finishMission:cb")

AddEventHandler("DeliveryJob:getWarehouses:cb", function(warehouses)
  DeliveryJobConfig.warehouses = warehouses
end)

AddEventHandler("DeliveryJob:finishMission:cb", function(newCheck)
  JobsConfig.jobsNotification.message = "<span class='green--text'>Livraison réussi, votre chèque de " .. newCheck .. " vous attends à l'entreprise</span"
  Venato.notify(JobsConfig.jobsNotification)
end)
