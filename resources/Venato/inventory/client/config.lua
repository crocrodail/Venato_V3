ItemsOnTheGround = {}
MoneyOnTheGround = {}
WeaponOnTheGround = {}

dropMoney = "bkr_prop_moneypack_01a"
dropWeapon = "hei_prop_hei_security_case"
dropItem = "prop_cardbordbox_03a"

papierOpen = 0

defaultNotification = {
  title = "Inventaire",
  type = "alert",
  logo = "https://i.ibb.co/qJ2yMXG/icons8-backpack-96px-1.png"
}

commandHelp = {
  id = "inventoryDrop",
  command = "E",
  icon = "https://i.ibb.co/VgYnKHc/icons8-grab-48px-1.png",
  text = "Récupérer"
}

isCommandAdded = nil
oldCommandAdded = nil

PoidMax = 20 -- Kg
