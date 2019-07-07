Venato = {}

RegisterNetEvent("Venato:displaytext")
AddEventHandler("Venato:displaytext", function(text, time)
  ClearPrints()
  SetTextEntry_2("STRING")
  AddTextComponentString(text)
  DrawSubtitleTimed(time, 1)
end)

RegisterNetEvent("Venato:notify")
AddEventHandler("Venato:notify", function(message)
  Venato.notify(message)
end)

function Venato.notify(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentSubstringPlayerName(message)
	DrawNotification(false, false)
end

function Venato.Text3D(x,y,z, text)
	SetDrawOrigin(x, y, z, 0);
	SetTextFont(0)
	SetTextProportional(0)
	SetTextScale(0.0, 0.4)
	SetTextColour(200, 200, 200, 240)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(2, 0, 0, 0, 150)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(0.0, 0.0)
	ClearDrawOrigin()
end

function Venato.InteractTxt(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function Venato.OpenKeyboard(title, defaultText, maxlength, TextEntrynote)
	local TextEntry = TextEntrynote
	AddTextEntry('FMMC_MPM_NA', TextEntry)
	DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", defaultText or "", "", "", "", maxlength or 20)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        return GetOnscreenKeyboardResult()
    end
	return nil
end

function Venato.ClosePlayer()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = GetPlayerPed(-1)
	local plyCoords = GetEntityCoords(ply, 0)
	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = GetDistanceBetweenCoords(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
			if(closestDistance == -1 or closestDistance > distance) then
				closestPlayer = value
				closestDistance = distance
			end
		end
	end
	return GetPlayerServerId(closestPlayer), closestDistance
end

function GetPlayers()
    local players = {}
    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end
    return players
end

function Venato.Round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function Venato.CreateObject(objet, x, y, z)
    local model = GetHashKey(objet)
    RequestModel(model)
    while not HasModelLoaded(model) do
      Citizen.Wait(100)
    end
    local objet = CreateObject(model, x, y, z, true, false, false)
    PlaceObjectOnGroundProperly(object)
    return objet
end

function Venato.ConvertUrl(url)
  local urlstep1 = string.gsub(url, "/", "_")
  local urlstep2 = string.gsub(urlstep1, ":", "ù")
  local finalUrl = string.gsub(urlstep1, "%.", "!")
  return finalUrl
end

function Venato.ChatMessage(str, source)
	TriggerEvent("chatMessage", source or 'Message', { 0, 255, 255}, "" .. tostring(str))
end