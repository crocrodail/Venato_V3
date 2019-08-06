--[[
  Config entry point for delivery job

  @author Astymeus
  @date 2019-07-24
  @version 1.0
--]]
JobsConfig.jobs[14] = {
  ["name"] = "Livreur",
  ["Class"] = "DeliveryJob"
}

DeliveryJobConfig = {}
DeliveryJobConfig.enabled = true
DeliveryJobConfig.trunk = nil
DeliveryJobConfig.serviceLocation = { ["x"] = -1546.95, ["y"] = -560.99, ["z"] = 33.72 }

DeliveryJobConfig.isInMission = false
DeliveryJobConfig.isTrunkReady = false
DeliveryJobConfig.isTrunkLoaded = false
DeliveryJobConfig.isGoodDelivered = false

DeliveryJobConfig.defaultDropLocations = {
  ["Commissariat"] = { ["Name"] = "Commissariat",
                       ["posX"] = 408.553, ["posY"] = -980.211, ["posZ"] = 28.8 }
}
DeliveryJobConfig.defaultOrders = {
  ["Munitions"] = {
    { ["itemId"] = 1, ["quantity"] = 5 },
    { ["itemId"] = 2, ["quantity"] = 10 },
    { ["itemId"] = 3, ["quantity"] = 25 }
  }
}
DeliveryJobConfig.defaultMissions = {
  { ["targetId"] = "Commissariat", ["orderId"] = "Munitions", ["maxDuration"] = -1 }
}

DeliveryJobConfig.warehouses = {
  ["Fruits"] = {
    positionFrom = { ["x"] = -1546.95, ["y"] = -560.99, ["z"] = 33.72, ["nom"] = "Entrer dans l'entrepôt" },
    positionTo = { ["x"] = 1105.11, ["y"] = -3099.35, ["z"] = -39.10, ["nom"] = "Sortir de l'entrepôt" }
  },
  ["Juice"] = {
    positionFrom = { ["x"] = 496.17, ["y"] = -638.62, ["z"] = 25.03, ["nom"] = "Entrer dans l'entrepôt" },
    positionTo = { ["x"] = 1072.94, ["y"] = -3102.60, ["z"] = -39.00, ["nom"] = "Sortir de l'entrepôt" }
  },
  ["Misc"] = {
    positionFrom = { ['x'] = 913.99, ['y'] = -1273.46, ['z'] = 27.09, ["nom"] = "Entrer dans l'entrepôt" },
    positionTo = { ["x"] = 1026.86, ["y"] = -3101.61, ["z"] = -39.00, ["nom"] = "Sortir de l'entrepôt" }
  }
}

DeliveryJobConfig.trunkDrops = {
  { ["posX"] = -1523.38, ["posY"] = -550.78, ["posZ"] = 32.35, ["heading"] = 212.2 },
  { ["posX"] = 905.34, ["posY"] = -1222.15, ["posZ"] = 24.50, ["heading"] = 180.58 },
  { ["posX"] = 504.996, ["posY"] = -610.303, ["posZ"] = 24.751, ["heading"] = 261.976 },
}
