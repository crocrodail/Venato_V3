# venato_V3

## function

###client

```lua
venato.callServer(eventName, arg) -- need to be on thread, only one arg
venato.GetDataPlayer() -- return Data of player
venato.CloseVehicle() -- get closet vehicle 
venato.ChatMessage(str, source)
venato.DeleteCar(entity)
venato.CreateVehicle(modelName, coords, heading, cb) 
venato.CreateObject(objet, x, y, z)
venato.ClosePlayer()
venato.OpenKeyboard(title, defaultText, maxlength, TextEntrynote)
venato.InteractTxt(text)
venato.Text3D(x, y, z, text, font, fontSize)
venato.addBlip(x, y, z, timeout, blip, color)
venato.playAnim(data) --data.lib, data.anim
venato.stopAnim(data)
venato.groundMarker(x, y, z)

```

###server

```lua
GetDataPlayers()
getSteamID(source)
venato.paymentCB(source, amount, isPolice)
venato.CheckItem(itemId, source)


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
venato.notify(defaultNotification)

venato.notifyError(msg)

# function utile

venato.Text3D(x,y,z, text, font, fontSize)                                   # Text flottant ingame
venato.InteractTxt(text)                                                     # Text aide affiché en haut a gauche
result = venato.OpenKeyboard(title, defaultText, maxlength, TextEntrynote)   # console d'ecriture
target, distance = venato.ClosePlayer()                                      # return source du joueur le plus proche et ça distance
objet = venato.CreateObject(objet, x, y, z)                                  # Crée un prop et return son id
venato.CreateVehicle(modelName, coords, heading, function())                 # Crée un vehicule et retourne l'id du vehicule dans l'arg de la fonction
venato.DeleteCar(entity)                                                     # Delete une voiture
vehicle = venato.CloseVehicle()                                              # return le vehicule le plus proche
