venato = {}
PedPlayer = nil

KeysFunction = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["LEFT"] = 33, ["RIGHT"] = 35, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118, ["RIGHTMOUSE"] = 25, ["INPUT_CONTEXT"] = 51
}


function none()
  local a = ""
end

function venato.groundMarker(x, y, z)
  DrawMarker(27,x, y, z+0.1,0,0,0,0,1,0,1.9,1.9,1.9,0,150,255,200,0,true,0,0)
end


function venato.playAnim(data)
  local flag = data.flag or 0
  local ped = data.ped or PlayerPedId()
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

function venato.stopAnim(data)
  StopAnimTask(GetPlayerPed(-1), data.lib ,data.anim, 1.0)
end

function venato.HasJob(jobId)
  return DataUser ~= nil and DataUser.Jobs ~= nil and DataUser.Jobs[jobId] ~= nil;
end

function venato.HasItem(itemId)
  return DataUser ~= nil and DataUser.Inventaire ~= nil and DataUser.Inventaire[itemId] ~= nil;
end

function venato.HowManyItem(itemId)
  if(DataUser == nil or DataUser.Inventaire == nil or DataUser.Inventaire[itemId] == nil) then 
    return 0;
  end
  return DataUser.Inventaire[itemId].quantity;
end

function venato.DisplayBool(value)
  return value and 'true' or 'false'
end

function venato.addBlip(x, y, z, timeout, blip, color)
  local currentBlip= AddBlipForCoord(x, y, z)
  SetBlipSprite(currentBlip, blip)
  SetBlipColour(currentBlip, color)
  SetBlipAsShortRange(currentBlip, false)
  Citizen.Wait(timeout)
  RemoveBlip(currentBlip)
end

function venato.notifyError(msg)
	local data = {
		logo = "https://img.icons8.com/color/48/000000/high-priority.png",
		type = "error",
		title = "Erreur",
		message = msg,
	}
	venato.notify(data)
end


function venato.disableAction(disabled)
  FreezeEntityPosition(GetPlayerPed(-1), disabled)
end

function venato.notify(notif)
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

function venato.Text3D(x, y, z, text, font, fontSize)
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

function venato.InteractTxt(text)
  SetTextComponentFormat("STRING")
  AddTextComponentString(text)
  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function venato.OpenKeyboard(title, defaultText, maxlength, TextEntrynote)
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

function venato.ClosePlayer()
  local players = GetPlayers()
  local closestDistance = -1
  local closestPlayer = -1
  local ply = venato.GetPlayerPed()
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

function venato.GetPlayerPed()
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

function venato.CreateObject(objet, x, y, z)
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

function venato.CreateVehicle(modelName, coords, heading, cb)
  local model = modelName
  if tonumber(modelName) == nil then
   model = GetHashKey(modelName)
  end

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

  return vehicle
end

function venato.DeleteCar(entity)
	Citizen.InvokeNative( 0xAE3CBE5BF394C9C9, Citizen.PointerValueIntInitialized( entity ) )
end

function venato.ConvertUrl(url)
  local urlstep1 = string.gsub(url, "/", "_")
  local urlstep2 = string.gsub(urlstep1, ":", "ù")
  local finalUrl = string.gsub(urlstep1, "%.", "!")
  return finalUrl
end

function venato.ChatMessage(str, source)
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

function venato.Round(val, decimal)
  if (decimal) then
    return math.floor((val * 10 ^ decimal) + 0.5) / (10 ^ decimal)
  else
    return math.floor(val + 0.5)
  end
end

function venato.FormatMoney(amount, decimal, prefix, neg_prefix)
  if amount < 99 then
    return amount
  else
    local str_amount, formatted, famount, remain
    decimal = decimal or 2  -- default 2 decimal places
    neg_prefix = neg_prefix or "-" -- default negative sign
    famount = math.abs(venato.Round(amount, decimal))
    famount = math.floor(famount)
    remain = venato.Round(math.abs(amount) - famount, decimal)
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

function venato.MoneyToPoid(money)
  return venato.Round(money * 0.000075, 1)
end

function venato.CloseVehicle()
  if (IsPedInAnyVehicle(venato.GetPlayerPed(), true) == false) then
    local x, y, z = table.unpack(GetEntityCoords(venato.GetPlayerPed(), true))
    local clostestvehicle = GetClosestVehicle(x, y, z, 4.000, 0, 127)
    if clostestvehicle ~= 0 then
      return clostestvehicle
    else
      local pos = GetEntityCoords(venato.GetPlayerPed())
      local entityWorld = GetOffsetFromEntityInWorldCoords(venato.GetPlayerPed(), 0.0, 3.0, 0.0)
      local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10,
        venato.GetPlayerPed(), 0)
      local a, b, c, d, result = GetRaycastResult(rayHandle)
      return result
    end
  else
    return nil
  end
end

function venato.ScaleForm(request)
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

function venato.getRandomFromArray(array)  
  local randomNumber = math.random(0, #array)
  print(venato.dump(array[randomNumber]))
  return array[randomNumber]
end

function venato.dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"'
      end
      s = s .. '[' .. k .. '] = ' .. venato.dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

controlDisabled = false

function venato.DisableAllControlActions(disable)  
  FreezeEntityPosition(venato.GetPlayerPed(), disable)
  controlDisabled = disable
end

Citizen.CreateThread(function()
  Citizen.Wait(1000)
  while true do    
		Citizen.Wait(1)
    if controlDisabled then
      for index, key in pairs(KeysFunction) do
        DisableControlAction(0, KeysFunction[index], true)
        DisableControlAction(1, KeysFunction[index], true)
        DisableControlAction(2, KeysFunction[index], true)
      end
      DisableControlAction(0, 24, true) -- Attack
      DisablePlayerFiring(venato.GetPlayerPed(), true) -- Disable weapon firing
      DisableControlAction(0, 142, true) -- MeleeAttackAlternate
      DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
    end
  end
end)

-- CRAFT
function venato.Craft(recipeItemsArray, resultItemsArray, animLib, animName, animTimeout) 
  for itemId, recipeItem in pairs(recipeItemsArray) do
    if(venato.HowManyItem(itemId) < tonumber(recipeItem)) then
      venato.notifyError("Vous n'avez pas les ingrédients nécessaires à la réalisation de cette recette.")
      return;
    end    
  end

  for itemId, recipeItem in pairs(recipeItemsArray) do
    TriggerServerEvent("Inventory:RemoveItem", tonumber(recipeItem), tonumber(itemId))   
  end

  if(not animTimeout) then
    animTimeout = 0
  end

  venato.DisableAllControlActions(true)
  venato.playAnim({
    useLib = true,
    flag = 48,
    lib = animLib, --"missheistfbisetup1",
    anim = animName, --"unlock_enter_janitor",
    timeout = animTimeout--3333
  })
  venato.DisableAllControlActions(false)

  for itemId, resultItem in pairs(resultItemsArray) do
		TriggerServerEvent('Inventory:AddItem', tonumber(resultItem), tonumber(itemId))
  end
  
  venato.notify({
		title = "Recette",
		type = "alert",
		logo = "https://i.ibb.co/7RcGVMt/icons8-handle-with-care-48px-1.png",
    timeout = 900,
    message = "Recette terminée"
	})
end
function venato.callServer(eventName, arg)
  local response = nil
  TriggerServerEvent(eventName, arg)
  RegisterNetEvent(eventName..":cb")
  AddEventHandler(eventName..":cb", function(cb)
    response = cb
  end)
  while response == nil do
    Citizen.Wait(10)
  end
  return response
end

function venato.getDataPlayer()
  local response = nil
  TriggerServerEvent("venato:GetDataPlayer")
  RegisterNetEvent("venato:GetDataPlayer:cb")
  AddEventHandler("venato:GetDataPlayer:cb", function(cb)
    response = cb
  end)
  while response == nil do
    Citizen.Wait(10)
  end
  return response
end
