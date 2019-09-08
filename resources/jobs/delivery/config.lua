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
DeliveryJobConfig.serviceLocation = { ["x"] = -423.96, ["y"] = -2789.39, ["z"] = 6.0 -0.9 }
DeliveryJobConfig.chosemission = { ["x"] = -439.96, ["y"] = -2785.39, ["z"] = 6.0 -0.9}
DeliveryJobConfig.takebox = { ["x"] = -319.96, ["y"] = -2426.39, ["z"] = 6.0 -0.9}
DeliveryJobConfig.blips = {}
DeliveryJobConfig.gpsroute = {}
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
  ["trunk"] = { ["x"] = -444.412, ["y"] = -2791.64, ["z"] = 6.0, ["heading"] = 39.49 },
  ["forklift"] = {
    [1] = {["x"] = -1532.13, ["y"] = -578.22, ["z"] = 33.627, ["heading"] = 315.49 },
    [2] = {["x"] = 503.13, ["y"] = -644.22, ["z"] = 24.747, ["heading"] = 353.49 },
    [3] = {["x"] = 2688.13, ["y"] = 3456.22, ["z"] = 55.776, ["heading"] = 250.49 },
  },
  ["box"] = { ["x"] = -314.96, ["y"] = -2433.39, ["z"] = 5.1, ["heading"] = 150.0 }
}

-- DEFAULT MISSIONS !

DeliveryJobConfig.defaultDropLocations = {
  ["Commissariat"] = { ["Name"] = "Commissariat",
                       ["x"] = 492.553, ["y"] = -1002.211, ["z"] = 27.828 },
  ["Hopital"] = { ["Name"] = "Hopital",
                       ["x"] = 1161.94, ["y"] = -1496.04, ["z"] = 34.70 },
  ["Bar"] = { ["Name"] = "Tequi-la-la",
                       ["x"] = -460.93, ["y"] = 302.32, ["z"] = 83.18 },
   ["test"] = { ["Name"] = "test",
                      ["x"] = 492.553, ["y"] = -1002.211, ["z"] = 27.828 },
}

DeliveryJobConfig.defaultOrders = {
  ["Munitions"] = {
    { ["id"] = 35, ["name"] = "Munitions", ["quantity"] = 500 },
    { ["id"] = 6, ["name"] = "Bouteille d'eau", ["quantity"] = 150 },
    { ["id"] = 101, ["name"] = "Donuts", ["quantity"] = 200 },
    { ["id"] = 104, ["name"] = "Chips", ["quantity"] = 15 },
    { ["id"] = 211, ["name"] = "Mégaphone", ["quantity"] = 10 },
    { ["id"] = 210, ["name"] = "Jumelles", ["quantity"] = 10 },
    { ["id"] = 673, ["name"] = "bipeur", ["quantity"] = 5 },
    { ["id"] = 305, ["name"] = "Caisse de bière", ["quantity"] = 50 },
  },
  ["Soins"] = {
    { ["id"] = 204, ["name"] = "Anti-douleur", ["quantity"] = 1000 },
    { ["id"] = 116, ["name"] = "Jus de fruits", ["quantity"] = 200 },
    { ["id"] = 659, ["name"] = "Olives", ["quantity"] = 30 },
    { ["id"] = 668, ["name"] = "Pizza", ["quantity"] = 25 },
    { ["id"] = 675, ["name"] = "Défibrilateur", ["quantity"] = 300 }
  },
  ["Bar"] = {
    { ["id"] = 107, ["name"] = "Whisky", ["quantity"] = 500 },
    { ["id"] = 108, ["name"] = "Bière IPA", ["quantity"] = 430 },
    { ["id"] = 109, ["name"] = "Bière LÂGER", ["quantity"] = 510 },
    { ["id"] = 110, ["name"] = "Bière STOUT", ["quantity"] = 150 },
    { ["id"] = 113, ["name"] = "Cocktail du chef", ["quantity"] = 1000 },
    { ["id"] = 112, ["name"] = "Fish and Chips", ["quantity"] = 320 },
    { ["id"] = 133, ["name"] = "Tacos", ["quantity"] = 115 }
  },
  ["test"] = {
    { ["id"] = 107, ["name"] = "Whisky", ["quantity"] = 500 },
  }
}

DeliveryJobConfig.defaultMissions = {
  { ["targetId"] = "Commissariat", ["orderId"] = "Munitions", ["maxDuration"] = -1 },
  { ["targetId"] = "Hopital", ["orderId"] = "Soins", ["maxDuration"] = -1 },
  { ["targetId"] = "Bar", ["orderId"] = "Bar", ["maxDuration"] = -1 },
  { ["targetId"] = "test", ["orderId"] = "test", ["maxDuration"] = -1 }
}
