--[[
  Client entry point for delivery job events

  @author Astymeus
  @date 2019-07-28
  @version 1.0
--]]

RegisterNetEvent("DeliveryJob:getWarehouses")
RegisterNetEvent("DeliveryJob:finishMission")
RegisterNetEvent("DeliveryJob:takeMission")

function getSource(source, newSource)
  return newSource or source
end

AddEventHandler("DeliveryJob:getWarehouses", function(newSource)
  local source = getSource(source, newSource)
  TriggerClientEvent("DeliveryJob:getWarehouses:cb", source, DeliveryJobDbFunctions.getWarehouses())
end)

AddEventHandler("DeliveryJob:finishMission", function(newSource)
  local source = getSource(source, newSource)
  TriggerClientEvent("DeliveryJob:finishMission:cb", source, DeliveryJobDbFunctions.newMissionCheck(source))
end)

AddEventHandler("DeliveryJob:takeMission", function(newSource)
  local source = getSource(source, newSource)

  local maxDefaultMission = #DeliveryJobConfig.defaultMissions
  local mission = DeliveryJobConfig.defaultMissions[math.random(maxDefaultMission)]
  local order = DeliveryJobConfig.defaultOrders[DeliveryJobConfig.mission.orderId]
  local destination = DeliveryJobConfig.defaultDropLocations[DeliveryJobConfig.mission.targetId]

  local player_order = DeliveryJobDbFunctions.getPlayerOrder()
  if player_order then

  end

  TriggerClientEvent("DeliveryJob:takeMission:cb", source, mission, order, destination)
end)
