local AdminDataPlayers = {}
local ListPlayer = false
local open = false

function openVenatoadmin()
	Menu.clearMenu()
	Menu.setTitle("Venato Admin Menu")
  Menu.setSubtitle( "~b~La vitamine c mais ne dira rien ")
	Menu.addButton("~r~Fermer", "AdminCloseMenu", nil)
	Menu.addButton("Liste des joueurs", "AdminListPlayer", nil)
	Menu.addButton("Envoyer un message aux joueurs", "sendmsg", nil)
  if AdminSuper == 10 then
    Menu.addButton("Spawn Voiture", "spawnvoiture", nil)
    Menu.addButton("DeSpawn Voiture", "despawnVoiture", nil)
    Menu.addButton("Récupérer les clef du vehicule", "getclef", nil)
    Menu.addButton("Réparer vehicule", "fixvehicle", nil)
    Menu.addButton("Jesus Christ", "jesusResur", nil)
		Menu.addButton("Revive joueur", "revivePlayerClot", nil)
    Menu.addButton("Teleporte sur markeur", "tptowaypoint", nil)
		Menu.addButton("Teleporte sur Coordonées", "customtp", nil)
    Menu.addButton("Mode cheat : ~b~"..cheatmode, "cheatemode", nil)
		if userInfo[getSource()] ~= nil then
			if userInfo[getSource()].identifier == 'steam:110000108378030' then
    		Menu.addButton("Blips : ~b~"..infoblips, "blipslun", nil)
			end
		end
  end
end

function AdminListPlayer()
	TriggerServerEvent("Admin:CallDataUsers")
end

RegisterNetEvent("Admin:CallDataUsers:cb")
AddEventHandler("Admin:CallDataUsers:cb", function(dataPlayers)
	Menu.clearMenu()
	AdminDataPlayers = dataPlayers
	ListPlayer = true
	Menu.addButton("~r~↩ Retour", "openVenatoadmin", nil)
	for k,v in pairs(AdminDataPlayers) do
		Menu.addButton("[~r~"..k.."~s~] "..v.Prenom.." "..v.Nom.." (~y~"..v.Pseudo.."~s~)", "AdminPlayerOption", k)
	end
	Menu.addButton("~r~↩ Retour", "openVenatoadmin", nil)
end)




function AdminCloseMenu()
	Menu.close()
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlReleased(1, Keys["5"]) and IsControlReleased(1, Keys["G"]) and GetLastInputMethod(2) and open == true then
			open = false
		end
		if IsControlPressed(1, Keys["5"]) and IsControlPressed(1, Keys["G"]) and GetLastInputMethod(2) and open == false then
			open = true
			if Menu.hidden == true then
				openVenatoadmin()
				Menu.open()
			else
				Menu.close()
			end
		end
		if ListPlayer then
			if Menu.hidden then
				ListPlayer = false
			end
			if Menu.GUI[Menu.selection +1]["args"] ~= nil then
				ShowInfoClient(Menu.GUI[Menu.selection +1]["args"])
			end
		end
	end
end)

function ShowInfoClient(index)
	local offsetX = 0.87
	local offsetY = 0.911
	DrawRect(offsetX, offsetY, 0.23, 0.8, 0, 0, 0, 215)
	printTxt("dsvcsdvds",0.8, 0.51)
	printTxt("dsvcfdfdsdvds",0.8, 0.49)

end

function printTxt(text, x,y)
	SetTextFont(4)
	SetTextScale(0.0,0.5)
	SetTextCentre(true)
	SetTextDropShadow(0, 0, 0, 0, 0)
	SetTextEdge(0, 0, 0, 0, 0)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end
