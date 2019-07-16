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
Menu.addButton(string1, string2, parametre)   #string1 = text du bouton ,  string2 = fonction a execute , parametre = parametre de la dite fonction
