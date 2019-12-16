local x = 20.0 -- Portée par défaut à la connexion
local y = 2.0 -- Portée +/-
local timer = 0
NetworkSetTalkerProximity(x)

AddEventHandler('onClientMapStart', function()
	NetworkSetTalkerProximity(x)
end)

-- Réglages par une touche : Chuchoter -> parler -> crier
local portevoix = 10.0

Citizen.CreateThread(function()
	while true do
			Citizen.Wait(1000)
			if(timer > 0)then
				timer = timer - 1
			end
			NetworkSetTalkerProximity(portevoix)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if timer > 0 then
		local posPlayer = GetEntityCoords(PlayerPedId())
		DrawMarker(1, posPlayer.x, posPlayer.y, posPlayer.z - 1, 0, 0, 0, 0, 0, 0, portevoix * 2, portevoix * 2, 0.8001, 0, 75, 255, 165, 0,0, 0,0)
	end
	end
end)--[]]

function Texte(_texte, showtime)
    ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(_texte)
	DrawSubtitleTimed(showtime, 1)
end

RegisterNetEvent("Tokovoip:switchdistance")
AddEventHandler("Tokovoip:switchdistance", function()
	timer = 0
	if portevoix <= 2.0 then
		portevoix = 10.0
			NetworkSetTalkerProximity(portevoix)
	Texte("Vous parlez à haute voix (~g~".. portevoix .."~s~m)", 5000)
	elseif portevoix == 10.0 then
		portevoix = 26.0
			NetworkSetTalkerProximity(portevoix)
	Texte("Vous criez (~g~".. portevoix .."~s~m)", 5000)
	elseif portevoix >= 26.0 then
		portevoix = 2.0
			NetworkSetTalkerProximity(portevoix)
	Texte("Vous chuchotez (~g~".. portevoix .."~s~m)", 5000)
	end
timer = 10
end)

RegisterNetEvent("gcvocal:megaphone")
AddEventHandler("gcvocal:megaphone", function()
	timer = 0
	portevoix = 60.0
	Texte("Vous parlez très fort (~g~".. portevoix .."~s~m)", 5000)
timer = 10
end)

RegisterNetEvent("gcvocal:10m")
AddEventHandler("gcvocal:10m", function()
	portevoix = 10.0
	NetworkSetTalkerProximity(portevoix)
  timer = 10
end)

RegisterNetEvent("gcvocal:26m")
AddEventHandler("gcvocal:26m", function()
	portevoix = 26.0
	NetworkSetTalkerProximity(portevoix)
	timer = 10
end)

RegisterNetEvent("gcvocal:2m")
AddEventHandler("gcvocal:2m", function()
	portevoix = 2.0
	NetworkSetTalkerProximity(portevoix)
	timer = 10
end)
