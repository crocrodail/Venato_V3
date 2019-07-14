Venato = {}

function none()
	local a = ""
end

RegisterNetEvent("Venato:notify")
AddEventHandler("Venato:notify", function(notif)
  Venato.notify(notif)
end)

RegisterNetEvent("Venato:notifyError")
AddEventHandler("Venato:notifyError", function(msg)
  Venato.notifyError(msg)
end)

function Venato.notifyError(msg)
	local data = {
		logo = "https://img.icons8.com/color/48/000000/high-priority.png",
		type = "error",
		title = "Erreur",
		message = msg,
	}
	Venato.notify(data)
end

function Venato.notify(notif)
  if not notif.message then
    return
  end
  if not notif.type then
    notif.type = 'alert'
  end
  if not notif.timeout then
    notif.timeout = 3500
  end
  TriggerEvent("Hud:Update",{
    action = "notify",
    message = notif.message,
    type = notif.type,
    timeout = notif.timeout,
    logo = notif.logo,
    title = notif.title
  })
end

function Venato.Text3D(x,y,z, text, font, fontSize)
	if not font then
		font = 0
	end
	if not fontSize then
		fontSize = 0.4
	end
	SetDrawOrigin(x, y, z, 0);
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(0.0, fontSize)
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

function Venato.GetPlayerPedFromSource(source)
	local targetPlayerId = GetPlayerFromServerId(source)
  return GetPlayerPed(targetPlayerId)
end

function Venato.GetPlayerPed()
	return GetPlayerPed(-1)
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

function Venato.CreateVehicle(modelName, coords, heading, cb)
	local model = GetHashKey(modelName)
	Citizen.CreateThread(function()
		if not HasModelLoaded(model) then
			RequestModel(model)
			while not HasModelLoaded(model) do
				Citizen.Wait(1)
			end
		end
		local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)
		local id = NetworkGetNetworkIdFromEntity(vehicle)
		SetNetworkIdCanMigrate(id, true)
		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetModelAsNoLongerNeeded(model)
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)
		while not HasCollisionLoadedAroundEntity(vehicle) do
			RequestCollisionAtCoord(coords.x, coords.y, coords.z)
			Citizen.Wait(0)
		end
		SetVehRadioStation(vehicle, 'OFF')
		if cb ~= nil then
			cb(vehicle)
		end
	end)
end

function Venato.DeleteCar(entity)
	Citizen.InvokeNative( 0xAE3CBE5BF394C9C9, Citizen.PointerValueIntInitialized( entity ) )
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

function comma_value(amount)
  local formatted = amount
  while true do
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end

function Venato.Round(val, decimal)
  if (decimal) then
    return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
  else
    return math.floor(val+0.5)
  end
end

function Venato.FormatMoney(amount, decimal, prefix, neg_prefix)
  if amount < 99 then
    return amount
  else
  	local str_amount,  formatted, famount, remain
  	decimal = decimal or 2  -- default 2 decimal places
  	neg_prefix = neg_prefix or "-" -- default negative sign
  	famount = math.abs(Venato.Round(amount,decimal))
	  famount = math.floor(famount)
  	remain = Venato.Round(math.abs(amount) - famount, decimal)
  	formatted = comma_value(famount)
  	if (decimal > 0) then
    	remain = string.sub(tostring(remain),3)
    	formatted = formatted .. "." .. remain ..
      string.rep("0", decimal - string.len(remain))
  	end
  	formatted = (prefix or "") .. formatted
  	if (amount<0) then
    	if (neg_prefix=="()") then
      	formatted = "("..formatted ..")"
    	else
      	formatted = neg_prefix .. formatted
    	end
  	end
  	return formatted
	end
end

function Venato.MoneyToPoid(money)
	return Venato.Round(money*0.000075,1)
end

function Venato.CloseVehicle()
  if (IsPedInAnyVehicle(GetPlayerPed(-1), true) == false) then
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
    local clostestvehicle = GetClosestVehicle(x, y, z, 4.000, 0, 127)
    if clostestvehicle ~= 0 then
      return clostestvehicle
    else
      local pos = GetEntityCoords(GetPlayerPed(-1))
      local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 3.0, 0.0)
      local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
      local a, b, c, d, result = GetRaycastResult(rayHandle)
      return result
    end
  else
    return nil
  end
end

function Venato.ScaleForm(request)
	scaleform = RequestScaleformMovie(request)
	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end
	return scaleform
end

function ButtonMessage(text)
  BeginTextCommandScaleformString("STRING")
  AddTextComponentScaleform(text)
  EndTextCommandScaleformString()
end

function Button(ControlButton)
  N_0xe83a3e3557a56640(ControlButton)
end

function Venato.GetCarShopIntruction()
  scaleform = Venato.ScaleForm("instructional_buttons")
	PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
  PopScaleformMovieFunctionVoid()
  PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
  PushScaleformMovieFunctionParameterInt(1)
  Button(GetControlInstructionalButton(2, 190, true))
  Button(GetControlInstructionalButton(2, 189, true))
  ButtonMessage("Changer la couleur principale")
	PopScaleformMovieFunctionVoid()
  PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
  PushScaleformMovieFunctionParameterInt(0)
  Button(GetControlInstructionalButton(2, 168, true))
  Button(GetControlInstructionalButton(2, 167, true))
  ButtonMessage("Changer la couleur secondaire")
  PopScaleformMovieFunctionVoid()
  PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
  PopScaleformMovieFunctionVoid()
  PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
  PushScaleformMovieFunctionParameterInt(0)
  PushScaleformMovieFunctionParameterInt(0)
  PushScaleformMovieFunctionParameterInt(0)
  PushScaleformMovieFunctionParameterInt(80)
  EndScaleformMovieMethodReturn()
  return scaleform
end


function Venato.GetCarMenuIntruction()
  scaleform = Venato.ScaleForm("instructional_buttons")
  PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
  PopScaleformMovieFunctionVoid()
  PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
  PushScaleformMovieFunctionParameterInt(2)
  Button(GetControlInstructionalButton(2, Keys["Y"], true))
  ButtonMessage("Vérrouiler/Déverrouiller le véhicule (avec les clès)")
  PopScaleformMovieFunctionVoid()

  PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
  PushScaleformMovieFunctionParameterInt(1)
  Button(GetControlInstructionalButton(2, Keys["L"], true))
  ButtonMessage("Ouvrir l'inventaire du coffre")
  PopScaleformMovieFunctionVoid()
  PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
  PushScaleformMovieFunctionParameterInt(0)
  Button(GetControlInstructionalButton(2, Keys["H"], true))
  ButtonMessage("Régler les phares")
  PopScaleformMovieFunctionVoid()
  PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
  PopScaleformMovieFunctionVoid()
  PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
  PushScaleformMovieFunctionParameterInt(0)
  PushScaleformMovieFunctionParameterInt(0)
  PushScaleformMovieFunctionParameterInt(0)
  PushScaleformMovieFunctionParameterInt(80)
  EndScaleformMovieMethodReturn()
  DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
end

function Venato.DisplayInfoVehicle(vehicle)
	scaleform2 = Venato.ScaleForm("mp_car_stats_01")
	PushScaleformMovieFunction(scaleform2, "CLEAR_ALL")
	PopScaleformMovieFunctionVoid()
	PushScaleformMovieFunction(scaleform2, "SET_VEHICLE_INFOR_AND_STATS")
	prix_vp = ""
	prix = ""
  if(not vehicle.vp_only) then
		prix = "Prix : "..formatPrice(vehicle.price).."€"
	end
	if(vehicle.vp_enabled) then
		prix_vp = "Prix VP : "..formatPrice(vehicle.price_vp).."VP"
	end
	PushScaleformMovieFunctionParameterString(prix)
	PushScaleformMovieFunctionParameterString(prix_vp)
	PushScaleformMovieFunctionParameterString("MPCarHUD")
	PushScaleformMovieFunctionParameterString("Annis")
	PushScaleformMovieFunctionParameterString("Vitesse max.")
	PushScaleformMovieFunctionParameterString("Acceleration")
	PushScaleformMovieFunctionParameterString("Freinage")
	PushScaleformMovieFunctionParameterString("Maniabilité")
	PushScaleformMovieFunctionParameterInt(vehicle.speed)
	PushScaleformMovieFunctionParameterInt(vehicle.acceleration)
	PushScaleformMovieFunctionParameterInt(vehicle.braking)
	PushScaleformMovieFunctionParameterInt(vehicle.handling)
	EndScaleformMovieMethodReturn()
	return scaleform2
end
