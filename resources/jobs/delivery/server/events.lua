--[[
  Client entry point for delivery job events

  @author Astymeus
  @date 2019-07-28
  @version 1.0
--]]

RegisterNetEvent("DeliveryJob:getWarehouses")
RegisterNetEvent("DeliveryJob:finishMission")

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
