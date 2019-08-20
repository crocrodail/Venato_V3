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
DeliveryJobConfig.serviceLocation = { ["x"] = -423.96, ["y"] = -2789.39, ["z"] = 6.27 }
DeliveryJobConfig.blips = {}
DeliveryJobConfig.boxes = {}

DeliveryJobConfig.BOX_KEY = "prop_box_wood05a"
DeliveryJobConfig.MINI_BOX_KEY = "prop_apple_box_01"
DeliveryJobConfig.TRUNK_KEY = "mule"
DeliveryJobConfig.FORKLIFT_KEY = "forklift"

DeliveryJobConfig.trunk = nil
DeliveryJobConfig.forklift = nil
DeliveryJobConfig.box = nil
DeliveryJobConfig.AllObject = {}

DeliveryJobConfig.boxOnForklift = false
DeliveryJobConfig.boxOnTrunk = false
DeliveryJobConfig.boxCoord = {}
DeliveryJobConfig.globalBox = nil
DeliveryJobConfig.trunkCoord = {}
DeliveryJobConfig.globalTrunk = nil

DeliveryJobConfig.currentStep = nil

DeliveryJobConfig.defaultDropLocations = {
  ["Commissariat"] = { ["Name"] = "Commissariat",
                       ["x"] = 408.553, ["y"] = -980.211, ["z"] = 28.8 }
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
  ["trunk"] = { ["x"] = -396.412, ["y"] = -2835.64, ["z"] = 6.0, ["heading"] = 315.49 },
  ["forklift"] = { ["x"] = -403.13, ["y"] = -2842.22, ["z"] = 6.0, ["heading"] = 315.49 },
  ["box"] = { ["x"] = -400.73, ["y"] = -2839.92, ["z"] = 5.1, ["heading"] = 130.0 }
}
