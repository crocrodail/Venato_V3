# Venato_V3

Doc :

DataPlayers[source].SteamId           #return SteamId
DataPlayers[source].Source						#return Source
DataPlayers[source].Group							#return Group
DataPlayers[source].Nom								#return Nom
DataPlayers[source].Prenom
DataPlayers[source].Job
DataPlayers[source].Bank
DataPlayers[source].Money
DataPlayers[source].Position
DataPlayers[source].Sexe
DataPlayers[source].Taille
DataPlayers[source].Health
DataPlayers[source].Food
DataPlayers[source].Water
DataPlayers[source].Need
DataPlayers[source].Sool
DataPlayers[source].PhoneNumber
DataPlayers[source].Pseudo
DataPlayers[source].Poid
DataPlayers[source].Inventaire
DataPlayers[source].PoidMax


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
Venato.notify(defaultNotification)

Venato.notifyError(msg)

### function utile ###

Venato.Text3D(x,y,z, text, font, fontSize)                                   # Text flottant ingame
Venato.InteractTxt(text)                                                     # Text aide affiché en haut a gauche
result = Venato.OpenKeyboard(title, defaultText, maxlength, TextEntrynote)   # console d'ecriture
target, distance = Venato.ClosePlayer()                                      # return source du joueur le plus proche et ça distance
objet = Venato.CreateObject(objet, x, y, z)                                  # Crée un prop et return son id
Venato.CreateVehicle(modelName, coords, heading, function())                 # Crée un vehicule et retourne l'id du vehicule dans l'arg de la fonction
Venato.DeleteCar(entity)                                                     # Delete une voiture
vehicle = Venato.CloseVehicle()                                              # return le vehicule le plus proche
