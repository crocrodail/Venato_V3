# platypus_V3

Doc :

DataPlayers[tonumber(source)].SteamId           #return SteamId
DataPlayers[tonumber(source)].Source						#return Source
DataPlayers[tonumber(source)].Group							#return Group
DataPlayers[tonumber(source)].Nom								#return Nom
DataPlayers[tonumber(source)].Prenom
DataPlayers[tonumber(source)].Job
DataPlayers[tonumber(source)].Bank
DataPlayers[tonumber(source)].Money
DataPlayers[tonumber(source)].Position
DataPlayers[tonumber(source)].Sexe
DataPlayers[tonumber(source)].Taille
DataPlayers[tonumber(source)].Health
DataPlayers[tonumber(source)].Food
DataPlayers[tonumber(source)].Water
DataPlayers[tonumber(source)].Need
DataPlayers[tonumber(source)].Sool
DataPlayers[tonumber(source)].PhoneNumber
DataPlayers[tonumber(source)].Pseudo
DataPlayers[tonumber(source)].Poid
DataPlayers[tonumber(source)].Inventaire
DataPlayers[tonumber(source)].PoidMax


### INVENTORY ###

Add item :

TriggerEvent('Inventory:AddItem', qty, id, optional Source)

Set Item :

TriggerEvent('Inventory:SetItem', qty, id, optional Source)


Add Money :

TriggerEvent('Inventory:AddMoney', qty, optional Source)

Remove Money :

TriggerEvent('Inventory:RemoveMoney', qty, optional Source)

Set Money :

TriggerEvent('Inventory:SetMoney', qty, optional Source)


###  MENU  ###

Menu.setTitle("")
Menu.setSubtitle( "")
showPageInfo = false | true     # affiche le nombre de bouton
Menu.clearMenu()    # supprime tout les boutons
Menu.open() | true   # affiche le menu
Menu.addButton(string1, string2, parametre, hover)   #string1 = text du bouton ,  string2 = fonction a execute , parametre = parametre de la dite fonction , hover = function executer lors du survol du bouton
Menu.addButton2(string1, string2, parametre, hover)   #l'équivalent au 1 mais ne s'affiche pas tout seul, il attent "Menu.CreateMenu()" pour s'afficher
Menu.CreateMenu()   # Affiche les bouton "Menu.addButton2"
### notif ###

local defaultNotification = {
 title= "YOURtitle",
 type = "alert", --  danger, error, alert, info, success, warning
 logo = "https://yourURL.png",
 message = "YourText",
 timeout = time
}
platypus.notify(defaultNotification)

platypus.notifyError(msg)

### function utile ###

platypus.Text3D(x,y,z, text, font, fontSize)                                   # Text flottant ingame
platypus.InteractTxt(text)                                                     # Text aide affiché en haut a gauche
result = platypus.OpenKeyboard(title, defaultText, maxlength, TextEntrynote)   # console d'ecriture
target, distance = platypus.ClosePlayer()                                      # return source du joueur le plus proche et ça distance
objet = platypus.CreateObject(objet, x, y, z)                                  # Crée un prop et return son id
platypus.CreateVehicle(modelName, coords, heading, function())                 # Crée un vehicule et retourne l'id du vehicule dans l'arg de la fonction
platypus.DeleteCar(entity)                                                     # Delete une voiture
vehicle = platypus.CloseVehicle()                                              # return le vehicule le plus proche
