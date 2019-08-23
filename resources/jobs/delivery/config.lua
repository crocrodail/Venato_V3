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

DeliveryJobConfig.mission = nil
DeliveryJobConfig.currentStep = nil
DeliveryJobConfig.itemsTaken = {}
DeliveryJobConfig.itemsTrunk = {}

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

DeliveryJobConfig.warehouses = {}
DeliveryJobConfig.inWarehouse = false

DeliveryJobConfig.trunkDrops = {
  ["trunk"] = { ["x"] = -396.412, ["y"] = -2835.64, ["z"] = 6.0, ["heading"] = 315.49 },
  ["forklift"] = { ["x"] = -403.13, ["y"] = -2842.22, ["z"] = 6.0, ["heading"] = 315.49 },
  ["box"] = { ["x"] = -400.73, ["y"] = -2839.92, ["z"] = 5.1, ["heading"] = 130.0 }
}
