# platypus_V3

## function

###client

```lua
platypus.callServer(eventName, arg) -- need to be on thread, only one arg
platypus.GetDataPlayer() -- return Data of player
platypus.CloseVehicle() -- get closet vehicle 
platypus.ChatMessage(str, source)
platypus.DeleteCar(entity)
platypus.CreateVehicle(modelName, coords, heading, cb) 
platypus.CreateObject(objet, x, y, z)
platypus.ClosePlayer()
platypus.OpenKeyboard(title, defaultText, maxlength, TextEntrynote)
platypus.InteractTxt(text)
platypus.Text3D(x, y, z, text, font, fontSize)
platypus.addBlip(x, y, z, timeout, blip, color)
platypus.playAnim(data) --data.lib, data.anim
platypus.stopAnim(data)

```

###server

```lua
GetDataPlayers()
getSteamID(source)
platypus.paymentCB(source, amount, isPolice)
platypus.CheckItem(itemId, source)


```

## INVENTORY

Add item :
```lua
TriggerEvent('Inventory:AddItem', qty, id, optional Source)
```
Set Item :
```lua
TriggerEvent('Inventory:SetItem', qty, id, optional Source)
```

Add Money :
```lua
TriggerEvent('Inventory:AddMoney', qty, optional Source)
```
Remove Money :
```lua
TriggerEvent('Inventory:RemoveMoney', qty, optional Source)
```
Set Money :
```lua
TriggerEvent('Inventory:SetMoney', qty, optional Source)
```

##  MENU

```lua
Menu.setTitle("")
Menu.setSubtitle( "")
showPageInfo = false | true     -- affiche le nombre de bouton
Menu.clearMenu()    -- supprime tout les boutons
Menu.open() | true   -- affiche le menu
Menu.addButton(string1, string2, parametre, hover)   --string1 = text du bouton ,  string2 = fonction a execute , parametre = parametre de la dite fonction , hover = function executer lors du survol du bouton
Menu.addButton2(string1, string2, parametre, hover)   --l'équivalent au 1 mais ne s'affiche pas tout seul, il attent "Menu.CreateMenu()" pour s'afficher
Menu.CreateMenu()   -- Affiche les bouton "Menu.addButton2"
```

## notif 

```lua
local defaultNotification = {
 title= "YOURtitle",
 type = "alert", --  danger, error, alert, info, success, warning
 logo = "https://yourURL.png",
 message = "YourText",
 timeout = time
}
platypus.notify(defaultNotification)

platypus.notifyError(msg)

# function utile

platypus.Text3D(x,y,z, text, font, fontSize)                                   # Text flottant ingame
platypus.InteractTxt(text)                                                     # Text aide affiché en haut a gauche
result = platypus.OpenKeyboard(title, defaultText, maxlength, TextEntrynote)   # console d'ecriture
target, distance = platypus.ClosePlayer()                                      # return source du joueur le plus proche et ça distance
objet = platypus.CreateObject(objet, x, y, z)                                  # Crée un prop et return son id
platypus.CreateVehicle(modelName, coords, heading, function())                 # Crée un vehicule et retourne l'id du vehicule dans l'arg de la fonction
platypus.DeleteCar(entity)                                                     # Delete une voiture
vehicle = platypus.CloseVehicle()                                              # return le vehicule le plus proche
