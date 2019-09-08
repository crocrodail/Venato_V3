--[[
  Client entry point for delivery job events

  @author Astymeus
  @date 2019-07-28
  @version 1.0
--]]

RegisterNetEvent("DeliveryJob:getWarehouses")
RegisterNetEvent("DeliveryJob:finishMission")
RegisterNetEvent("DeliveryJob:takeMission")
RegisterNetEvent("DeliveryJob:takeMissionPrecise")
RegisterNetEvent("DeliveryJob:abortMission")

function getSource(source, newSource)
  return newSource or source
end

AddEventHandler("DeliveryJob:getWarehouses", function(newSource)
  local source = getSource(source, newSource)
  TriggerClientEvent("DeliveryJob:getWarehouses:cb", source, DeliveryJobDbFunctions.getWarehouses())
end)

AddEventHandler("DeliveryJob:finishMission", function(orderId, shop, newSource)
  local source = getSource(source, newSource)
  if shop then
    DeliveryJobDbFunctions.finishOrder(orderId)
  end
  TriggerClientEvent("DeliveryJob:finishMission:cb", source, DeliveryJobDbFunctions.newMissionCheck(source))
end)

AddEventHandler("DeliveryJob:takeMission", function(newSource)
  local source = getSource(source, newSource)

  local maxDefaultMission = #DeliveryJobConfig.defaultMissions
  local mission = DeliveryJobConfig.defaultMissions[math.random(maxDefaultMission)]
  local order = DeliveryJobConfig.defaultOrders[mission.orderId]
  local destination = DeliveryJobConfig.defaultDropLocations[mission.targetId]

  local player_order = DeliveryJobDbFunctions.getPlayerOrder()
  if player_order ~= nil then
    TriggerEvent("Venato:dump", { "Command:", player_order })
    DeliveryJobDbFunctions.startOrder(source, player_order.Id)
    mission = { ["targetId"] = player_order.ShopId, ["orderId"] = player_order.Id, ["maxDuration"] = -1, ["shop"] = true }
    order = player_order.order
    destination = player_order.destination
  else
    TriggerEvent("Venato:dump", { "Default:", mission })
  end

  TriggerClientEvent("DeliveryJob:takeMission:cb", source, mission, order, destination)
end)

AddEventHandler("DeliveryJob:takeMissionPrecise", function(number, newSource)
  local source = getSource(source, newSource)
  local number = number
  local mission = DeliveryJobConfig.defaultMissions[number]
  local order = DeliveryJobConfig.defaultOrders[mission.orderId]
  local destination = DeliveryJobConfig.defaultDropLocations[mission.targetId]
  local player_order = DeliveryJobDbFunctions.getPlayerOrder()
  if player_order ~= nil then
    TriggerEvent("Venato:dump", { "Command:", player_order })
    DeliveryJobDbFunctions.startOrder(source, player_order.Id)
    mission = { ["targetId"] = player_order.ShopId, ["orderId"] = player_order.Id, ["maxDuration"] = -1, ["shop"] = true }
    order = player_order.order
    destination = player_order.destination
  else
    TriggerEvent("Venato:dump", { "Default:", mission })
  end

  TriggerClientEvent("DeliveryJob:takeMission:cb", source, mission, order, destination)
end)

AddEventHandler("DeliveryJob:abortMission", function(orderId)
  DeliveryJobDbFunctions.abortOrder(orderId)
end)
