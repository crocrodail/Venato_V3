Venato = {}
PedPlayer = nil


function none()
  local a = ""
end

function Venato.playAnim(data)
  local flag = data.flag or 0
  local ped = data.ped or GetPlayerPed(-1)
  local timeout = data.timeout or 0
  if data.useLib then
      RequestAnimDict(data.lib)
      while not HasAnimDictLoaded(data.lib) do
      Citizen.Wait(0)
      end

      TaskPlayAnim(ped,data.lib, data.anim ,8.0, 8.0, -1, flag, 1, false, false, false )

  elseif not data.useLib then
      TaskStartScenarioInPlace(ped, data.anim, 0, false)
  end
  Citizen.Wait(timeout)
end

function Venato.HasJob(jobId)
  return DataUser ~= nil and DataUser.Jobs ~= nil and DataUser.Jobs[jobId] ~= nil;
end

function Venato.addBlip(x, y, z, timeout, blip, color)
  local currentBlip= AddBlipForCoord(x, y, z)
  SetBlipSprite(currentBlip, blip)
  SetBlipColour(currentBlip, color)
  SetBlipAsShortRange(currentBlip, false)
  Citizen.Wait(timeout)
  RemoveBlip(currentBlip)
end

function Venato.notifyError(msg)
	local data = {
		logo = "https://img.icons8.com/color/48/000000/high-priority.png",
		type = "error",
		title = "Erreur",
		message = msg,
	}
	Venato.notify(data)
end


function Venato.disableAction(disabled)
  FreezeEntityPosition(GetPlayerPed(-1), disabled)
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

  TriggerEvent("Hud:Update", {
    action = "notify",
    message = notif.message,
    type = notif.type,
    timeout = notif.timeout,
    logo = notif.logo,
    title = notif.title,
    event = notif.event,
    titleFont = notif.titleFont,
    descriptionFont = notif.descriptionFont,
    color= notif.color
  })
end

function Venato.Text3D(x, y, z, text, font, fontSize)
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
  AddTextEntry('FMMC_KEY_TIP12', TextEntrynote)
  DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP12", "", defaultText or "", "", "", "", maxlength or 20)
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
  local ply = Venato.GetPlayerPed()
  local plyCoords = GetEntityCoords(ply, 0)
  for index, value in ipairs(players) do
    local target = GetPlayerPed(value)
    if (target ~= ply) then
      local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
      local distance = GetDistanceBetweenCoords(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"],
        plyCoords["y"], plyCoords["z"], true)
      if (closestDistance == -1 or closestDistance > distance) then
        closestPlayer = value
        closestDistance = distance
      end
    end
  end
  return GetPlayerServerId(closestPlayer), closestDistance, closestPlayer
end

function Venato.GetPlayerPed()
  if PedPlayer == nil then
    PedPlayer = GetPlayerPed(-1)
  end
	return  GetPlayerPed(-1)
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
  SetEntityAsMissionEntity(objet, true, false)
  SetModelAsNoLongerNeeded(model)
  return objet
end

function Venato.CreateVehicle(modelName, coords, heading, cb)
  local model = modelName
  if tonumber(modelName) == nil then
   model = GetHashKey(modelName)
  end
	Citizen.CreateThread(function()
		if not HasModelLoaded(model) then
			RequestModel(model)
			while not HasModelLoaded(model) do
				Citizen.Wait(100)
			end
		end
		local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)
		local id = NetworkGetNetworkIdFromEntity(vehicle)
    SetNetworkIdExistsOnAllMachines(id, true)
		SetNetworkIdCanMigrate(id, true)
		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetModelAsNoLongerNeeded(model)
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)
    SetVehicleExplodesOnHighExplosionDamage(vehicle, false)
		while not HasCollisionLoadedAroundEntity(vehicle) do
			RequestCollisionAtCoord(coords.x, coords.y, coords.z)
			Citizen.Wait(100)
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
  TriggerEvent("chatMessage", source or 'Message', { 0, 255, 255 }, "" .. tostring(str))
end

function comma_value(amount)
  local formatted = amount
  while true do
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k == 0) then
      break
    end
  end
  return formatted
end

function Venato.Round(val, decimal)
  if (decimal) then
    return math.floor((val * 10 ^ decimal) + 0.5) / (10 ^ decimal)
  else
    return math.floor(val + 0.5)
  end
end

function Venato.FormatMoney(amount, decimal, prefix, neg_prefix)
  if amount < 99 then
    return amount
  else
    local str_amount, formatted, famount, remain
    decimal = decimal or 2  -- default 2 decimal places
    neg_prefix = neg_prefix or "-" -- default negative sign
    famount = math.abs(Venato.Round(amount, decimal))
    famount = math.floor(famount)
    remain = Venato.Round(math.abs(amount) - famount, decimal)
    formatted = comma_value(famount)
    if (decimal > 0) then
      remain = string.sub(tostring(remain), 3)
      formatted = formatted .. "." .. remain ..
        string.rep("0", decimal - string.len(remain))
    end
    formatted = (prefix or "") .. formatted
    if (amount < 0) then
      if (neg_prefix == "()") then
        formatted = "(" .. formatted .. ")"
      else
        formatted = neg_prefix .. formatted
      end
    end
    return formatted
  end
end

function Venato.MoneyToPoid(money)
  return Venato.Round(money * 0.000075, 1)
end

function Venato.CloseVehicle()
  if (IsPedInAnyVehicle(Venato.GetPlayerPed(), true) == false) then
    local x, y, z = table.unpack(GetEntityCoords(Venato.GetPlayerPed(), true))
    local clostestvehicle = GetClosestVehicle(x, y, z, 4.000, 0, 127)
    if clostestvehicle ~= 0 then
      return clostestvehicle
    else
      local pos = GetEntityCoords(Venato.GetPlayerPed())
      local entityWorld = GetOffsetFromEntityInWorldCoords(Venato.GetPlayerPed(), 0.0, 3.0, 0.0)
      local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10,
        Venato.GetPlayerPed(), 0)
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

function Venato.dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"'
      end
      s = s .. '[' .. k .. '] = ' .. Venato.dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end
