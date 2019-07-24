--[[
  Config entry point for delivery job

  @author Astymeus
  @date 2019-07-24
  @version 1.0
--]]
DeliveryJobConfig = {}
DeliveryJobConfig.enabled = true

DeliveryJobConfig.defaultDropLocations = {
  [1] = { ["Name"] = "Commissariat",
          ["posX"] = 408.553, ["posY"] = -980.211, ["posZ"] = 28.8 }
}
DeliveryJobConfig.defaultOrders = {
  [1] = {
    [1] = { ["itemId"] = 1, ["quantity"] = 5 },
    [2] = { ["itemId"] = 2, ["quantity"] = 10 },
    [2] = { ["itemId"] = 3, ["quantity"] = 25 }
  }
}
DeliveryJobConfig.defaultMissions = {
  { ["targetId"] = 1, ["orderId"] = 1, ["maxDuration"] = -1 }
}
