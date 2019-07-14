local AdminDataPlayers = {}
local ListPlayer = false
local open = false
local ClientSource = nil
local defaultNotification = {type = "alert", title ="Staff Venato",logo = "https://img.icons8.com/dusk/64/000000/for-beginner.png"}
local cheatmode = "Off"
local wp = false
local xtppers = "0.0"
local ytppers = "0.0"
local ztppers = "0.0"
local AdminBlips = false
local AdminBlipsString = "Blips : ~b~Off"
local AdminShowCoordString = "Afficher les coordonées : ~b~Off"

function ResetDefaultNotification()
  defaultNotification = {type = "alert", title ="Staff Venato",logo = "https://img.icons8.com/dusk/64/000000/for-beginner.png"}
end

function openVenatoadmin()
	ClearMenu()
	MenuTitle = "Venato Admin Menu"
  showPageInfo = true
  MenuDescription = "~b~La vitamine c mais ne dira rien "
	Menu.addButton("~r~Fermer", "AdminCloseMenu", nil)
	Menu.addButton("Liste des joueurs", "AdminListPlayer", nil)
	Menu.addButton("Envoyer un message aux joueurs", "AdminSendMsg", nil)
  Menu.addButton("Spawn Voiture", "AdminSpawnVehicle", nil)
  Menu.addButton("DeSpawn Voiture", "AdminDespawnVoiture", nil)
  Menu.addButton("Récupérer les clef du vehicule", "AdminGetClef", nil)
  Menu.addButton("Réparer vehicule", "AdminFixVehicle", nil)
  Menu.addButton("Jesus Christ ~r~(Non attribuer)", "none", nil) --  non attribuer (revive)
	Menu.addButton("Revive joueur ~r~(Non attribuer)", "none", nil) -- non attribuer
  Menu.addButton("Teleporte sur markeur", "AdminTpMarkeur", nil)
	Menu.addButton("Teleporte sur Coordonées", "AdminCustomTP", nil)
  Menu.addButton( AdminShowCoordString , "AdminShowCoord", nil)
  --Menu.addButton("Mode cheat : ~b~"..cheatmode, "cheatemode", nil)
	if AdminDataPlayers[ClientSource].SteamId == 'steam:110000108378030' then
  	Menu.addButton(AdminBlipsString , "AdminBlipsOption", nil)
	end
end

function AdminShowCoord()
  if AdminShowCoordString == "Afficher les coordonées : ~b~Off" then
    AdminShowCoordString = "Afficher les coordonées : ~b~On"
    Menu.GUI[Menu.selection +1]["name"] = AdminShowCoordString
  else
    AdminShowCoordString = "Afficher les coordonées : ~b~Off"
    Menu.GUI[Menu.selection +1]["name"] = AdminShowCoordString
  end
end

function AdminBlipsOption()
  if AdminBlips == false then
    AdminBlips = true
    AdminBlipsString = "Blips : ~b~On"
    Menu.GUI[Menu.selection +1]["name"] = AdminBlipsString
  else
    AdminBlips = false
    AdminBlipsString = "Blips : ~b~Off"
    Menu.GUI[Menu.selection +1]["name"] = AdminBlipsString
    for k,v in pairs(AdminDataPlayers) do
      local Player = GetPlayerFromServerId(v.Source)
      if NetworkIsPlayerActive(Player) and GetPlayerPed(Player) ~= GetPlayerPed(-1) then
        local ped = GetPlayerPed(Player)
        local blip = GetBlipFromEntity(ped)
        if DoesBlipExist(blip) then -- Removes blip
          RemoveBlip(blip)
        end
        if IsMpGamerTagActive(HeadId[Player]) then
          RemoveMpGamerTag(HeadId[Player])
        end
      end
    end
  end
end

function AdminCustomTP()
	MenuTitle = "Venato Admin Menu"
	MenuDescription = "~b~La vitamine c mais ne dira rien "
	ClearMenu()
	Menu.addButton("~r~Retour", "openVenatoadmin", nil)
	Menu.addButton("Modifier les Coordonées", "coordtp", nil)
	Menu.addButton("Teleporte sur ~g~"..tonumber(xtppers).." ~s~|~g~ "..tonumber(ytppers).." ~s~|~g~ "..tonumber(ztppers), "AdminTpCustomCoord", nil)
end

function AdminTpCustomCoord()
  SetEntityCoords(GetPlayerPed(-1), tonumber(xtppers)+0.001, tonumber(ytppers)+0.001, tonumber(ztppers)+0.001)
end

function coordtp()
  local coord = xtppers.." , "..ytppers.." , "..ztppers
	local pw = Venato.OpenKeyboard('', coord, 50,"Customs Coordonées")
	local quant = 0
	if pw ~= "0.0,0.0,0.0" and pw ~= "" and pw ~= nil then
	  str, sep = pw..',0', ","
    fields = {}
    str:gsub("([^"..sep.."]*)"..sep, function(c)
      table.insert(fields, c)
    end)
    for i,v in ipairs(fields) do
			if i == 1 then
				xtppers = v
			elseif i == 2 then
				ytppers = v
			elseif i == 3 then
				ztppers = v
			end
			 quant = i
    end
		if quant ~= 3 then
			failcustomcoord()
		end
		if tonumber(xtppers) ~= nil and tonumber(ytppers) ~= nil and tonumber(ztppers) ~= nil then
		  AdminCustomTP()
		else
			failcustomcoord()
		end
	else
		failcustomcoord()
	end
end

function failcustomcoord()
	xtppers = 0.0
	ytppers = 0.0
	ztppers = 0.0
  Venato.notifyError("Coordonées erroné !")
	AdminCustomTP()
end

function AdminTpMarkeur()
  if DoesBlipExist(GetFirstBlipInfoId(8)) then
    local blipIterator = GetBlipInfoIdIterator(8)
    local blip = GetFirstBlipInfoId(8, blipIterator)
    WaypointCoords = Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ResultAsVector())
    wp = true
  end
end

function getGroundZ(x, y, z)
  local result, groundZ = GetGroundZFor_3dCoord(x + 0.0, y + 0.0, z + 0.0, Citizen.ReturnResultAnyway())
  return groundZ
end

function AdminFixVehicle()
  local vehicle = GetVehiclePedIsUsing(GetPlayerPed(-1))
  if tonumber(vehicle) == 0 then
    vehicle = Venato.CloseVehicle()
    SetVehicleFuelLevel(vehicle, 1000.0)
    SetVehicleBodyHealth(vehicle, 1000.0)
    SetVehicleEngineHealth(vehicle, 1000.0)
    SetVehicleFixed(vehicle)
    SetVehicleDirtLevel(vehicle, 0.0)
    SetVehicleLights(vehicle, 0)
    SetVehicleBurnout(vehicle, false)
    Citizen.InvokeNative(0x1FD09E7390A74D54, vehicle, 0)
  else
    SetVehicleFuelLevel(vehicle, 1000.0)
    SetVehicleBodyHealth(vehicle, 1000.0)
    SetVehicleEngineHealth(vehicle, 1000.0)
    SetVehicleFixed(vehicle)
    SetVehicleDirtLevel(vehicle, 0.0)
    SetVehicleLights(vehicle, 0)
    SetVehicleBurnout(vehicle, false)
    Citizen.InvokeNative(0x1FD09E7390A74D54, vehicle, 0)
  end
end

function AdminGetClef()
  local vehicle = GetVehiclePedIsUsing(GetPlayerPed(-1))
  if tonumber(vehicle) == 0 then
    vehicle = Venato.CloseVehicle()
    TriggerEvent('lock:addVeh', GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
  else
    TriggerEvent('lock:addVeh', GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
  end
end

function AdminDespawnVoiture()
  local vehicle = GetVehiclePedIsUsing(GetPlayerPed(-1))
  if tonumber(vehicle) == 0 then
    vehicle = Venato.CloseVehicle()
    Venato.DeleteCar(vehicle)
  else
    Venato.DeleteCar(vehicle)
  end
end

function AdminSpawnVehicle()
  local name = Venato.OpenKeyboard('', '', 20,"Modèle du vehicule")
  if name ~= nil and name ~= '' and name ~= ' ' and IsModelValid(GetHashKey(string.upper(name))) ~= false then
    Venato.CreateVehicle(string.upper(name), GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()), function(vehicle)
      SetVehicleNumberPlateText(vehicle, "ADMIN".. math.random(100, 999))
      SetPedIntoVehicle(GetPlayerPed(GetPlayerFromServerId(ClientSource)), vehicle, -1)
      TriggerEvent('lock:addVeh', GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
    end)
  else
    Venato.notifyError("Ce vehicule n'existe pas")
  end
end

function AdminSendMsg()
	local msg = Venato.OpenKeyboard('', '', 1000,"Message à Envoyer")
	if msg == nil or msg == '' or msg == ' ' then
		defaultNotification.message = "Le message est éroné !"
		defaultNotification.type = "error"
		Venato.notify(defaultNotification)
    ResetDefaultNotification()
	else
		defaultNotification.message = msg
		defaultNotification.timeout = 20000
		defaultNotification.type = "warning"
		TriggerServerEvent("AdminVnT:sendMsG", defaultNotification)
    ResetDefaultNotification()
	end
end

RegisterNetEvent("Admin:CallDataUsers:cb")
AddEventHandler("Admin:CallDataUsers:cb", function(dataPlayers, DataSource)
	ClearMenu()
	AdminDataPlayers = dataPlayers
	ClientSource = DataSource
	openVenatoadmin()
end)

function AdminListPlayer()
	ClearMenu()
	ListPlayer = true
	Menu.addButton("~r~↩ Retour", "openVenatoadmin", nil)
	for k,v in pairs(AdminDataPlayers) do
		Menu.addButton("[~r~"..k.."~s~] "..v.Prenom.." "..v.Nom.." (~y~"..v.Pseudo.."~s~)", "AdminPlayerOption", k)
	end
	Menu.addButton("~r~↩ Retour", "openVenatoadmin", nil)
end

function AdminCloseMenu()
	Menu.hidden = true
end

Citizen.CreateThread(function()
  local HeadId = {}
  while AdminBlips do
    Citizen.Wait(0)
    for k,v in pairs(AdminDataPlayers) do
      local Player = GetPlayerFromServerId(v.Source)
      if NetworkIsPlayerActive(Player) and GetPlayerPed(Player) ~= GetPlayerPed(-1) then
        local ped = GetPlayerPed(GetPlayerFromServerId(v.Source))
        local blip = GetBlipFromEntity(ped)
        HeadId[Player] = CreateMpGamerTag(ped,v.Prenom.." "..v.Nom.." ("..v.Pseudo..")", false, false, "", false)
        if NetworkIsPlayerTalking(Player) then
          SetMpGamerTagVisibility(HeadId[Player], 9, true)
        else
          SetMpGamerTagVisibility(HeadId[Player], 9, false)
        end
        if not DoesBlipExist(blip) then
          blip = AddBlipForEntity(ped)
          SetBlipSprite(blip, 1)
          ShowHeadingIndicatorOnBlip(blip, true)
        else
          local veh = GetVehiclePedIsIn(ped, false)
          local blipSprite = GetBlipSprite(blip)
          local vehClass = GetVehicleClass(veh)
          local vehModel = GetEntityModel(veh)
          if veh ~= 0 then
            if vehClass == 15 then -- Helicopters
              if blipSprite ~= 422 then
                SetBlipSprite(blip, 422)
                ShowHeadingIndicatorOnBlip(blip, false)
              end
            elseif vehClass == 16 then
              if blipSprite ~= 307 then
                SetBlipSprite(blip, 307)
                ShowHeadingIndicatorOnBlip(blip, false)
              end
            elseif tonumber(v.IdJob) == 2 then
              if blipSprite ~= 56 then
                SetBlipSprite(blip, 56)
                ShowHeadingIndicatorOnBlip(blip, false)
              end
            else
              if blipSprite ~= 326 then
                SetBlipSprite(blip, 326)
                ShowHeadingIndicatorOnBlip(blip, false)
              end
            end
            local passengers = GetVehicleNumberOfPassengers(veh)
            if passengers then
              if not IsVehicleSeatFree(veh, -1) then
                passengers = passengers + 1
              end
              ShowNumberOnBlip(blip, passengers)
            else
              HideNumberOnBlip(blip)
            end
            SetBlipRotation(blip, math.ceil(GetEntityHeading(veh)))
          else
            HideNumberOnBlip(blip)
            if blipSprite ~= 1 then -- default blip
              SetBlipSprite(blip, 1)
              ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
            end
          end
          SetBlipNameToPlayerName(blip, Player) -- update blip name
          SetBlipScale(blip,  0.85) -- set scale
          if IsPauseMenuActive() then
            SetBlipAlpha( blip, 255 )
          else
            local x1, y1 = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
            local x2, y2 = table.unpack(GetEntityCoords(GetPlayerPed(Player), true))
            local distance = (math.floor(math.abs(math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))) / -1)) + 900
            if distance < 0 then
              distance = 0
            elseif distance > 255 then
              distance = 255
            end
            SetBlipAlpha(blip, distance)
          end
        end
      end
    end
  end
end)

Citizen.CreateThread(function()
  local zHeigt = 0.0; height = 1000.0
	while true do
		Citizen.Wait(0)
    if wp then
			if IsPedInAnyVehicle(GetPlayerPed(-1), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), 0), -1) == GetPlayerPed(-1)) then
				entity = GetVehiclePedIsIn(GetPlayerPed(-1), 0)
			else
				entity = GetPlayerPed(-1)
			end
			SetEntityCoords(entity, WaypointCoords.x, WaypointCoords.y, height)
			FreezeEntityPosition(entity, true)
			local Pos = GetEntityCoords(entity, true)
			if zHeigt == 0.0 then
				height = height - 50.0
				SetEntityCoords(entity, Pos.x, Pos.y, height)
				zHeigt = getGroundZ(Pos.x, Pos.y, Pos.z)
			else
				SetEntityCoords(entity, Pos.x, Pos.y, zHeigt)
				FreezeEntityPosition(entity, false)
				wp = false
				height = 1000.0
				zHeigt = 0.0
			end
		end
		if IsControlReleased(1, Keys["5"]) and IsControlReleased(1, Keys["G"]) and GetLastInputMethod(2) and open == true then
			open = false
		end
		if IsControlPressed(1, Keys["5"]) and IsControlPressed(1, Keys["G"]) and GetLastInputMethod(2) and open == false then
			open = true
			if Menu.hidden == true then
				TriggerServerEvent("Admin:CallDataUsers")
				Menu.hidden = false
			else
				Menu.hidden = true
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
    if AdminShowCoordString == "Afficher les coordonées : ~b~On" then
      ShowInfoCoord()
    end
	end
end)

function ShowInfoCoord(index)
  local playerPos = GetEntityCoords(PlayerPedId())
  --Venato.Round(val, decimal)
	DrawRect(0.5, 0.95, 0.2, 0.05, 0, 0, 0, 215)
	printTxt("x = ~b~"..Venato.Round(playerPos.x,3).."~s~ ,   y = ~b~"..Venato.Round(playerPos.y,3).."~s~ ,   z = ~b~"..Venato.Round(playerPos.z,3),0.5, 0.933, true)
end

function ShowInfoClient(index)
	DrawRect(0.87, 0.6, 0.23, 0.25, 0, 0, 0, 215)
	printTxt("~b~"..AdminDataPlayers[index].Prenom.." "..AdminDataPlayers[index].Nom.." (~y~"..AdminDataPlayers[index].Pseudo..")",0.87, 0.53, true)
	printTxt("Argent : ~g~"..AdminDataPlayers[index].Money,0.77, 0.57)
	printTxt("Banque : ~g~"..AdminDataPlayers[index].Bank,0.77, 0.60)
	printTxt("Venato Point : ~o~"..AdminDataPlayers[index].VenatoPoint,0.77, 0.63)
	printTxt("Metier : ~g~"..AdminDataPlayers[index].NameJob,0.77, 0.66)
end

function printTxt(text, x,y, center)
	local center = center or false
	SetTextFont(4)
	SetTextScale(0.0,0.5)
	SetTextCentre(center)
	SetTextDropShadow(0, 0, 0, 0, 0)
	SetTextEdge(0, 0, 0, 0, 0)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end
