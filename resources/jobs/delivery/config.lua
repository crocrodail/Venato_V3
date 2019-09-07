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
DeliveryJobConfig.TAKENBOX_KEY = "prop_cs_rub_box_02"
DeliveryJobConfig.TRUNK_KEY = "mule"
DeliveryJobConfig.FORKLIFT_KEY = "forklift"

DeliveryJobConfig.trunk = nil
DeliveryJobConfig.forklift = nil
DeliveryJobConfig.box = nil
DeliveryJobConfig.handbox = nil
DeliveryJobConfig.AllObject = {}

DeliveryJobConfig.boxOnForklift = false
DeliveryJobConfig.boxOnTrunk = false
DeliveryJobConfig.carryBoxWithHand = false
DeliveryJobConfig.boxCoord = {}
DeliveryJobConfig.globalBox = nil
DeliveryJobConfig.trunkCoord = {}
DeliveryJobConfig.globalTrunk = nil

DeliveryJobConfig.mission = nil
DeliveryJobConfig.order = nil
DeliveryJobConfig.orderComplete = false
DeliveryJobConfig.destination = nil
DeliveryJobConfig.currentStep = nil
DeliveryJobConfig.itemsTaken = {}
DeliveryJobConfig.itemsTrunk = {}

DeliveryJobConfig.warehouses = {}
DeliveryJobConfig.inWarehouse = false

DeliveryJobConfig.trunkDrops = {
  ["trunk"] = { ["x"] = -396.412, ["y"] = -2835.64, ["z"] = 6.0, ["heading"] = 315.49 },
  ["forklift"] = { ["x"] = -403.13, ["y"] = -2842.22, ["z"] = 6.0, ["heading"] = 315.49 },
  ["box"] = { ["x"] = -400.73, ["y"] = -2839.92, ["z"] = 5.1, ["heading"] = 130.0 }
}

-- DEFAULT MISSIONS !

DeliveryJobConfig.defaultDropLocations = {
  ["Commissariat"] = { ["Name"] = "Commissariat",
                       ["x"] = 408.553, ["y"] = -980.211, ["z"] = 28.8 },
  ["Hopital"] = { ["Name"] = "Hopital",
                       ["x"] = 1161.94, ["y"] = -1496.04, ["z"] = 34.70 },
  ["Bar"] = { ["Name"] = "Tequi-la-la",
                       ["x"] = -460.93, ["y"] = 302.32, ["z"] = 83.18 }
}

DeliveryJobConfig.defaultOrders = {
  ["Munitions"] = {
    { ["id"] = 35, ["name"] = "Munitions", ["quantity"] = 50 },
    { ["id"] = 6, ["name"] = "Bouteille d'eau", ["quantity"] = 15 },
    { ["id"] = 104, ["name"] = "Chips", ["quantity"] = 15 }
  },
  ["Soins"] = {
    { ["id"] = 204, ["name"] = "Anti-douleur", ["quantity"] = 50 },
    { ["id"] = 116, ["name"] = "Jus de fruits", ["quantity"] = 20 },
    { ["id"] = 659, ["name"] = "Olives", ["quantity"] = 30 },
    { ["id"] = 668, ["name"] = "Pizza", ["quantity"] = 25 }
  },
  ["Bar"] = {
    { ["id"] = 107, ["name"] = "Whisky", ["quantity"] = 5 },
    { ["id"] = 108, ["name"] = "Bière IPA", ["quantity"] = 30 },
    { ["id"] = 109, ["name"] = "Bière LÂGER", ["quantity"] = 10 },
    { ["id"] = 110, ["name"] = "Bière STOUT", ["quantity"] = 15 },
    { ["id"] = 113, ["name"] = "Cocktail du chef", ["quantity"] = 5 },
    { ["id"] = 112, ["name"] = "Fish and Chips", ["quantity"] = 20 },
    { ["id"] = 133, ["name"] = "Tacos", ["quantity"] = 15 }
  }
}

DeliveryJobConfig.defaultMissions = {
  { ["targetId"] = "Commissariat", ["orderId"] = "Munitions", ["maxDuration"] = -1 },
  { ["targetId"] = "Hopital", ["orderId"] = "Soins", ["maxDuration"] = -1 },
  { ["targetId"] = "Bar", ["orderId"] = "Bar", ["maxDuration"] = -1 }
}
