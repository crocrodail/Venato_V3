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
RegisterNetEvent("DeliveryJob:takeMission:cb")
RegisterNetEvent("DeliveryJob:isPro")

AddEventHandler("DeliveryJob:getWarehouses:cb", function(warehouses)
  DeliveryJobConfig.warehouses = warehouses
end)

AddEventHandler("DeliveryJob:finishMission:cb", function(newCheck)
  JobsConfig.jobsNotification.timeout = 15000
  JobsConfig.jobsNotification.message = "<span class='green--text'>Livraison réussi, votre chèque de " .. newCheck .. " vous attends à l'entreprise</span"
  Venato.notify(JobsConfig.jobsNotification)
  JobsConfig.jobsNotification.timeout = 3000
end)

AddEventHandler("DeliveryJob:takeMission:cb", function(mission, order, destination)
  DeliveryJobConfig.mission = mission
  DeliveryJobConfig.order = order
  DeliveryJobConfig.destination = destination

  DeliveryJobConfig.currentStep = 1
  Menu.close()
  JobsConfig.isMenuOpen = false
end)


AddEventHandler("DeliveryJob:isPro", function(bool)
  DeliveryJobConfig.isPro = bool
end)
