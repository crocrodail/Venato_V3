--[[
  Config entry point for delivery job

  @author Astymeus
  @date 2019-07-24
  @version 1.0
--]]
Keys = { ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18, ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182, ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81, ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178, ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173, ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118, ["RIGHTMOUSE"] = 25, ["INPUT_CONTEXT"] = 51 }

DeliveryJobConfig = {}
DeliveryJobConfig.enabled = true
DeliveryJobConfig.trunk = nil

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
    positionTo = { ["x"] = 1026.86, ["y"] = -3101.61, ["z"] = -39.00, ["nom"] = "Sortir de l'entrepôt" }
  },
  ["Juice"] = {
    positionFrom = { ["x"] = 408.55, ["y"] = -980.21, ["z"] = 28.80, ["nom"] = "Entrer dans l'entrepôt" },
    positionTo = { ["x"] = 1026.86, ["y"] = -3101.61, ["z"] = -39.00, ["nom"] = "Sortir de l'entrepôt" }
  },
  ["Misc"] = {
    positionFrom = { ['x'] = 913.99, ['y'] = -1273.46, ['z'] = 27.09, ["nom"] = "Entrer dans l'entrepôt" },
    positionTo = { ["x"] = 1026.86, ["y"] = -3101.61, ["z"] = -39.00, ["nom"] = "Sortir de l'entrepôt" }
  }
}

DeliveryJobConfig.trunkDrops = {
  { ["posX"] = -1523.38, ["posY"] = -550.78, ["posZ"] = 32.35, ["heading"] = 212.2 },
  { ["posX"] = 905.34, ["posY"] = -1222.15, ["posZ"] = 24.50, ["heading"] = 180.58 },
  { ["posX"] = -1518.05, ["posY"] = -547.20, ["posZ"] = 32.23, ["heading"] = 212.2 },
}
