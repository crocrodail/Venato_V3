local AdminDataPlayers = {}
local ListPlayer = false
local open = false
local ClientSource = nil
local defaultNotification = { type = "alert", title = "Staff Venato", logo = "https://img.icons8.com/dusk/64/000000/for-beginner.png" }
local cheatmode = "Off"
local wp = false
local xtppers = "0.0"
local ytppers = "0.0"
local ztppers = "0.0"
local AdminBlipsBool = false
local AdminShowCoordBool = false
local indexToShow = nil
local indexToSpectate = nil
local LastCoords = {}
local state = false
local cam = nil
local AdminShowPlayerInfo = nil
local HeadId = {}
local InSpectatorMode = false
local noclip = false
local noclip_pos
local heading = 0
local visible = true
local DataAdmin = nil

function ResetDefaultNotification()
  defaultNotification = { type = "alert", title = "Staff Venato", logo = "https://img.icons8.com/dusk/64/000000/for-beginner.png" }
end

function openVenatoadmin()
  Menu.clearMenu()
  Menu.open()
  AdminShowPlayerInfo = nil
  print(AdminDataPlayers[ClientSource].Group)
  if AdminDataPlayers[ClientSource].Group == "Admin" or AdminDataPlayers[ClientSource].Group == "Modo" then
    Menu.setTitle("Venato Admin Menu")
    Menu.setSubtitle("~b~La vitamine c mais ne dira rien ")
    Menu.addButton("~r~Fermer", "AdminCloseMenu", nil)
    Menu.addButton("Liste des joueurs", "AdminListPlayer", nil)
    Menu.addButton("Envoyer un message aux joueurs", "AdminSendMsg", nil)
  end
  if AdminDataPlayers[ClientSource].Group == "Admin" then
    Menu.addButton("Spawn Voiture", "AdminSpawnVehicle", nil)
    Menu.addButton("DeSpawn Voiture", "AdminDespawnVoiture", nil)
    Menu.addButton("Récupérer les clef du vehicule", "AdminGetClef", nil)
    Menu.addButton("Réparer vehicule", "AdminFixVehicle", nil)
    Menu.addButton("Jesus Christ", "respawntest", nil)
    Menu.addButton("Revive joueur", "revivevnt", nil) -- non attribuer
    Menu.addButton("heal joueur", "healvnt", nil)
    Menu.addButton("Teleporte sur markeur", "AdminTpMarkeur", nil)
    Menu.addButton("Teleporte sur Coordonées", "AdminCustomTP", nil)
    Menu.addButton("Afficher/Masquer les coordonées", "AdminShowCoord", nil)
    --Menu.addButton("Mode cheat : ~b~"..cheatmode, "cheatemode", nil)
  if AdminDataPlayers[ClientSource].SteamId == 'steam:110000108378030' then
  	Menu.addButton("Show/unShow blips" , "AdminBlipsOption", nil)
    Menu.addButton("noClip", "AdminNoClip", nil)
    Menu.addButton("invisible", 'AdminInvisible' , nil)
    Menu.addButton("create Veh", 'createVeh' , nil)
  end
end
end

function revivevnt()
  local ClosePlayer, distance = Venato.ClosePlayer()
  if ClosePlayer ~= 0 and ClosePlayer ~= nil and distance < 4 then
    TriggerServerEvent("vnt:resurect", ClosePlayer)
  else
    Venato.notifyError("Il n'y a personne à proximité.")
  end
end

function healvnt()
  local ClosePlayer, distance = Venato.ClosePlayer()
  if ClosePlayer ~= 0 and ClosePlayer ~= nil and distance < 4 then
    TriggerServerEvent("vnt:heal", ClosePlayer)
  else
    Venato.notifyError("Il n'y a personne à proximité.")
  end
end

function AdminInvisible(value)
  if value ~= nil then
    SetEntityVisible(Venato.GetPlayerPed(), value, nil)
  else
    visible = not visible
    if visible then
      SetEntityVisible(Venato.GetPlayerPed(), true, nil)
    else
      SetEntityVisible(Venato.GetPlayerPed(), false, nil)
    end
  end
end

function AdminNoClip()
  noclip_pos = GetEntityCoords(Venato.GetPlayerPed(), false)
  noclip = not noclip
end

Citizen.CreateThread(function()
	 while true do
		Citizen.Wait(0)
		  if noclip then
			  SetEntityCoordsNoOffset(Venato.GetPlayerPed(),  noclip_pos.x,  noclip_pos.y,  noclip_pos.z,  0, 0, 0)
			if(IsControlPressed(1,  34))then
				heading = heading + 1.5
				if(heading > 360)then
					heading = 0
				end
				SetEntityHeading(Venato.GetPlayerPed(),  heading)
			end
			if(IsControlPressed(1,  9))then
				heading = heading - 1.5
				if(heading < 0)then
					heading = 360
				end
				SetEntityHeading(Venato.GetPlayerPed(),  heading)
			end
			if(IsControlPressed(1,  8))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(Venato.GetPlayerPed(), 0.0, 1.0, 0.0)
			end
			if(IsControlPressed(1,  32))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(Venato.GetPlayerPed(), 0.0, -1.0, 0.0)
			end

			if(IsControlPressed(1,  27))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(Venato.GetPlayerPed(), 0.0, 0.0, 1.0)
			end
			if(IsControlPressed(1,  173))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(Venato.GetPlayerPed(), 0.0, 0.0, -1.0)
			end
		end
	end
end)

function createVeh()
	local current = GetPlayersLastVehicle(GetPlayerPed(-1), true)
	if DoesEntityExist(current) then
		local model = GetEntityModel(current)
  	local plate = GetVehicleNumberPlateText(current)
		local name = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(current)))
		local currentVhl = {}
		currentVhl.primary_red, currentVhl.primary_green, currentVhl.primary_blue   = GetVehicleCustomPrimaryColour(current);
		currentVhl.secondary_red, currentVhl.secondary_green, currentVhl.secondary_blue = GetVehicleCustomSecondaryColour(current);
		currentVhl.primary_type = GetVehicleModColor_1(current,0,0)
		currentVhl.secondary_type = GetVehicleModColor_2(current,0,0)
		currentVhl.extra ,currentVhl.wheelcolor = GetVehicleExtraColours(current);
		TriggerServerEvent('dev:CreateVehiculeInDB',model,plate,name,currentVhl)
	end
end

function respawntest()
  local coord = GetEntityCoords(Venato.GetPlayerPed(), false)
  local heading = GetEntityHeading(Venato.GetPlayerPed())
  FreezeEntityPosition(Venato.GetPlayerPed(), false)
  NetworkResurrectLocalPlayer(coord.x, coord.y, coord.z, heading, true, true, false)
  ClearPedTasksImmediately(Venato.GetPlayerPed())
  Venato.resurect()
  TriggerServerEvent("Death:health", false)
  LiveFreezeNeed(false)
  fCanCancelOrStartAnim(true)
end

function AdminShowCoord()
  if AdminShowCoordBool == false then
    AdminShowCoordBool = true
  else
    AdminShowCoordBool = false
  end
end

function AdminBlipsOption()
  if AdminBlipsBool == false then
    AdminBlipsBool = true
  else
    AdminBlipsBool = false
    for k, v in pairs(AdminDataPlayers) do
      local Player = v.PlayerIdClient
      if NetworkIsPlayerActive(Player) and GetPlayerPed(Player) ~= Venato.GetPlayerPed() then
        local ped = GetPlayerPed(Player)
        local blip = GetBlipFromEntity(ped)
        if DoesBlipExist(blip) then
          -- Removes blip
          RemoveBlip(blip)
        end
        if HeadId ~= nil then
          if IsMpGamerTagActive(HeadId[Player]) then
            RemoveMpGamerTag(HeadId[Player])
          end
        end
      end
    end
  end
end

function AdminCustomTP()
  Menu.setTitle("Venato Admin Menu")
  Menu.setSubtitle("~b~La vitamine c mais ne dira rien")
  Menu.clearMenu()
  Menu.addButton("~r~Retour", "openVenatoadmin", nil)
  Menu.addButton("Modifier les Coordonées", "coordtp", nil)
  Menu.addButton("Teleporte sur ~g~" .. tonumber(xtppers) .. " ~s~|~g~ " .. tonumber(ytppers) .. " ~s~|~g~ " .. tonumber(ztppers),
    "AdminTpCustomCoord", nil)
end

function AdminTpCustomCoord()
  SetEntityCoords(Venato.GetPlayerPed(), tonumber(xtppers) + 0.001, tonumber(ytppers) + 0.001, tonumber(ztppers) + 0.001)
end

function coordtp()
  local coord = xtppers .. " , " .. ytppers .. " , " .. ztppers
  local pw = Venato.OpenKeyboard('', coord, 50, "Customs Coordonées")
  local quant = 0
  if pw ~= "0.0,0.0,0.0" and pw ~= "" and pw ~= nil then
    str, sep = pw .. ',0', ","
    fields = {}
    str:gsub("([^" .. sep .. "]*)" .. sep, function(c)
      table.insert(fields, c)
    end)
    for i, v in ipairs(fields) do
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
  local vehicle = GetVehiclePedIsUsing(Venato.GetPlayerPed())
  if tonumber(vehicle) == 0 then
    vehicle = Venato.CloseVehicle()
    SetVehicleFixed(vehicle)
    SetVehicleFuelLevel(vehicle, 100.0)
    SetVehicleBodyHealth(vehicle, 1000.0)
    SetVehicleEngineHealth(vehicle, 1000.0)
    SetVehicleDirtLevel(vehicle, 0.0)
    SetVehicleLights(vehicle, 0)
    SetVehicleBurnout(vehicle, false)
    Citizen.InvokeNative(0x1FD09E7390A74D54, vehicle, 0)
  else
    SetVehicleFixed(vehicle)
    SetVehicleFuelLevel(vehicle, 100.0)
    SetVehicleBodyHealth(vehicle, 1000.0)
    SetVehicleEngineHealth(vehicle, 1000.0)
    SetVehicleDirtLevel(vehicle, 0.0)
    SetVehicleLights(vehicle, 0)
    SetVehicleBurnout(vehicle, false)
    Citizen.InvokeNative(0x1FD09E7390A74D54, vehicle, 0)
  end
end

function AdminGetClef()
  local vehicle = GetVehiclePedIsUsing(Venato.GetPlayerPed())
  if tonumber(vehicle) == 0 then
    vehicle = Venato.CloseVehicle()
    TriggerEvent('lock:addVeh', GetVehicleNumberPlateText(vehicle),
      GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
  else
    TriggerEvent('lock:addVeh', GetVehicleNumberPlateText(vehicle),
      GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
  end
end

function AdminDespawnVoiture()
  local vehicle = GetVehiclePedIsUsing(Venato.GetPlayerPed())
  if tonumber(vehicle) == 0 then
    vehicle = Venato.CloseVehicle()
    Venato.DeleteCar(vehicle)
  else
    Venato.DeleteCar(vehicle)
  end
end

function AdminSpawnVehicle()
  local name = Venato.OpenKeyboard('', '', 20, "Modèle du vehicule")
  if name ~= nil and name ~= '' and name ~= ' ' and IsModelValid(GetHashKey(string.upper(name))) ~= false then
    Venato.CreateVehicle(string.upper(name), GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()),
      function(vehicle)
        SetVehicleNumberPlateText(vehicle, "ADMIN" .. math.random(100, 999))
        SetPedIntoVehicle(GetPlayerPed(GetPlayerFromServerId(ClientSource)), vehicle, -1)
        TriggerEvent('lock:addVeh', GetVehicleNumberPlateText(vehicle),
          GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
      end)
  else
    Venato.notifyError("Ce vehicule n'existe pas")
  end
end

function AdminSendMsg()
  local msg = Venato.OpenKeyboard('', '', 1000, "Message à Envoyer")
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
  Menu.clearMenu()
  DataUser = dataPlayers[1]
  AdminDataPlayers = dataPlayers
  ClientSource = DataSource
  openVenatoadmin()
end)

function AdminListPlayer()
  Menu.clearMenu()
  ListPlayer = true
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "openVenatoadmin", nil)
  for k, v in pairs(AdminDataPlayers) do
    Menu.addButton("[~r~" .. k .. "~s~] " .. v.Prenom .. " " .. v.Nom .. " (~y~" .. v.Pseudo .. "~s~)",
      "AdminPlayerOption", k, "AdminShowPlayerInfoo")
  end
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "openVenatoadmin", nil)
end

function AdminPlayerOption(index)
  indexToShow = index
  Menu.setTitle("Venato Admin Menu Player")
  Menu.clearMenu()
  Menu.addButton("Retour", "AdminListPlayer", nil)
  Menu.addButton("Spectate (Voyeur :3)", "AdminSpectate", nil)
  Menu.addButton("Kick (Pour le lol)", "AdminActionOnPlayer", "kick")
  Menu.addButton("Ban (Parceque c'est cool)", "AdminActionOnPlayer", "ban")
  Menu.addButton("Freeze", "AdminFreeze", nil)
  Menu.addButton("Toi --> elle", "Admintptoelle", nil)
  Menu.addButton("Toi <-- elle", "Admintptome", nil)
  if DataUser.Group == "Admin" then
  Menu.addButton("Give dans la poche", "AdminGivePoche", nil)
  Menu.addButton("Give en bank", "AdminGiveBank", nil)
  Menu.addButton("Set dans la poche", "AdminSetPoche", nil)
  Menu.addButton("Set en bank", "AdminSetBank", nil)
end
end

function AdminActionOnPlayer(action)
  local result = Venato.OpenKeyboard('', "", 100, "Raison:")
  if result ~= "" and result ~= nil then
    TriggerServerEvent("Admin:ActionOnPlayer", action, indexToShow, result)
  else
    Venato.notifyError("Il y a un problème sur la Raison renseigné (le joueur n'a pas subit la sanction du coup)")
  end
end

function AdminSetBank()
  local result = Venato.OpenKeyboard('', "", 10, "Nombre")
  if result ~= "" and result ~= nil then
    TriggerServerEvent('Bank:SetBankMoney', result)
  else
    Venato.notifyError("Il y a un problème sur la somme renseigné")
  end
end

function AdminSetPoche()
  local result = Venato.OpenKeyboard('', "", 10, "Nombre")
  if result ~= "" and result ~= nil then
    TriggerServerEvent('Inventory:SetMoney', result)
  else
    Venato.notifyError("Il y a un problème sur la somme renseigné")
  end
end

function AdminGiveBank()
  local result = Venato.OpenKeyboard('', "", 10, "Nombre")
  if result ~= "" and result ~= nil then
    TriggerServerEvent('Bank:AddBankMoney', result)
  else
    Venato.notifyError("Il y a un problème sur la somme renseigné")
  end
end

function AdminGivePoche()
  local result = Venato.OpenKeyboard('', "", 10, "Nombre")
  if result ~= "" and result ~= nil then
    TriggerServerEvent('Inventory:AddMoney', result)
  else
    Venato.notifyError("Il y a un problème sur la somme renseigné")
  end
end

function Admintptome()
  local targetPed = GetPlayerPed(GetPlayerFromServerId(indexToShow))
  local ped = Venato.GetPlayerPed()
  local Coord = GetEntityCoords(ped)
  SetEntityCoords(Targetped, Coord.x, Coord.y, Coord.z)
end

function Admintptoelle()
  local targetPed = GetPlayerPed(GetPlayerFromServerId(indexToShow))
  local ped = Venato.GetPlayerPed()
  local TargetCoord = GetEntityCoords(Targetped)
  SetEntityCoords(ped, TargetCoord.x, TargetCoord.y, TargetCoord.z)
end

function AdminFreeze()
  FreezeEntityPosition(GetPlayerPed(AdminDataPlayers[indexToShow].PlayerIdClient), true)
  -- if state == true then
  --   if not IsEntityVisible(ped) then
  --     SetEntityVisible(ped, true)
  --   end
  --   if not IsPedInAnyVehicle(ped) then
  --     SetEntityCollision(ped, true)
  --   end
  --   FreezeEntityPosition(ped, false)
  --   state = false
  -- else
  --   SetEntityCollision(ped, false)
  --   FreezeEntityPosition(ped, true)
  --   state = true
  --   if not IsPedFatallyInjured(ped) then
  --     ClearPedTasksImmediately(ped)
  --   end
  -- end
end

function AdminSpectate()
  if InSpectatorMode == false then
    LastCoords = GetEntityCoords(Venato.GetPlayerPed())
    TargetSpectate = indexToShow
    InSpectatorMode = true
    Citizen.CreateThread(function()
      if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
      end
      SetCamActive(cam,  true)
      RenderScriptCams(true,  false,  0,  true,  true)
      InSpectatorMode = true
      AdminInvisible(true)
    end)
  else
    InSpectatorMode = false
      TargetSpectate  = nil
      AdminInvisible(false)
      local playerPed = Venato.GetPlayerPed()
      SetCamActive(cam,  false)
      RenderScriptCams(false,  false,  0,  true,  true)
      SetEntityCollision(playerPed,  true,  true)
      SetEntityVisible(playerPed,  true)
      SetEntityCoords(playerPed, LastCoords.x, LastCoords.y, LastCoords.z)
  end
end

function AdminCloseMenu()
  Menu.close()
end

Citizen.CreateThread(function()
  HeadId = {}
  while true do
    Citizen.Wait(0)
    if AdminBlipsBool then
      for k, v in pairs(AdminDataPlayers) do
        local Player = v.PlayerIdClient
        if NetworkIsPlayerActive(Player) and GetPlayerPed(Player) ~= Venato.GetPlayerPed() then
          local ped = GetPlayerPed(GetPlayerFromServerId(v.Source))
          local blip = GetBlipFromEntity(ped)
          HeadId[Player] = CreateMpGamerTag(ped, v.Prenom .. " " .. v.Nom .. " (" .. v.Pseudo .. ")", false, false, "", false)
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
              if vehClass == 15 then
                -- Helicopters
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
              if blipSprite ~= 1 then
                -- default blip
                SetBlipSprite(blip, 1)
                ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
              end
            end
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.Prenom .. " " .. v.Nom .. " (" .. v.Pseudo .. ")")
      			EndTextCommandSetBlipName(blip)
            SetBlipScale(blip, 0.85) -- set scale
            if IsPauseMenuActive() then
              SetBlipAlpha(blip, 255)
            else
              local x1, y1 = table.unpack(GetEntityCoords(Venato.GetPlayerPed(), true))
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
  end
end)

Citizen.CreateThread(function()
  local zHeigt = 0.0;
  height = 1000.0
  local radius = -3.5;
  local polarAngleDeg = 0;
  local azimuthAngleDeg = 90;
  while true do
    Citizen.Wait(0)
    if wp then
      if IsPedInAnyVehicle(Venato.GetPlayerPed(), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(Venato.GetPlayerPed(), 0),
        -1) == Venato.GetPlayerPed()) then
        entity = GetVehiclePedIsIn(Venato.GetPlayerPed(), 0)
      else
        entity = Venato.GetPlayerPed()
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
    if Menu.hidden then
      AdminShowPlayerInfo = nil
    end
    if IsControlReleased(1, Keys["5"]) and IsControlReleased(1,
      Keys["G"]) and GetLastInputMethod(2) and open == true then
      open = false
    end
    if IsControlPressed(1, Keys["5"]) and IsControlPressed(1,
      Keys["G"]) and GetLastInputMethod(2) and open == false then
      open = true
      if Menu.hidden == true then
        TriggerServerEvent("Admin:CallDataUsers")
      else
        Menu.close()
      end
    end
    if ListPlayer then
      if Menu.hidden then
        ListPlayer = false
      end
      if AdminShowPlayerInfo ~= nil then
        ShowInfoClient(AdminShowPlayerInfo)
      end
    end
    if AdminShowCoordBool then
      ShowInfoCoord()
    end
    if InSpectatorMode then
      local targetPlayerId = GetPlayerFromServerId(TargetSpectate)
      local playerPed      = Venato.GetPlayerPed()
      local targetPed      = GetPlayerPed(targetPlayerId)
      local coords         = GetEntityCoords(targetPed)
      for k, v in pairs(AdminDataPlayers) do
        if v.PlayerIdClient ~= PlayerId() then
          local otherPlayerPed = GetPlayerPed(v.PlayerIdClient)
          SetEntityNoCollisionEntity(playerPed,  otherPlayerPed,  true)
        end
      end
      if IsControlPressed(2, 241) then
        radius = radius + 0.5;
      end
      if IsControlPressed(2, 242) then
        radius = radius - 0.5;
      end
      if radius > -1 then
        radius = -1
      end
      local xMagnitude = GetDisabledControlNormal(0,  1);
      local yMagnitude = GetDisabledControlNormal(0,  2);
      polarAngleDeg = polarAngleDeg + xMagnitude * 10;
      if polarAngleDeg >= 360 then
        polarAngleDeg = 0
      end
      azimuthAngleDeg = azimuthAngleDeg + yMagnitude * 10;
      if azimuthAngleDeg >= 360 then
        azimuthAngleDeg = 0;
      end
      local nextCamLocation = polar3DToWorld3D(coords, radius, polarAngleDeg, azimuthAngleDeg)
      SetCamCoord(cam,  nextCamLocation.x,  nextCamLocation.y,  nextCamLocation.z)
      PointCamAtEntity(cam,  targetPed)
      SetEntityCoords(playerPed,  coords.x, coords.y, coords.z + 10)
    end
  end
end)

function AdminShowPlayerInfoo(source)
  AdminShowPlayerInfo = source
end

function polar3DToWorld3D(entityPosition, radius, polarAngleDeg, azimuthAngleDeg)
  local polarAngleRad = polarAngleDeg * math.pi / 180.0
  local azimuthAngleRad = azimuthAngleDeg * math.pi / 180.0
  local pos = {
    x = entityPosition.x + radius * (math.sin(azimuthAngleRad) * math.cos(polarAngleRad)),
    y = entityPosition.y - radius * (math.sin(azimuthAngleRad) * math.sin(polarAngleRad)),
    z = entityPosition.z - radius * math.cos(azimuthAngleRad)
  }
  return pos
end

function ShowInfoCoord(index)
  local playerPos = GetEntityCoords(PlayerPedId())
  local playerHeading = GetEntityHeading(PlayerPedId())
  DrawRect(0.5, 0.95, 0.22, 0.05, 0, 0, 0, 215)
  printTxt(
    "x = ~b~" .. Venato.Round(playerPos.x, 3) ..
      "~s~, y = ~b~" .. Venato.Round(playerPos.y, 3) ..
      "~s~, z = ~b~" .. Venato.Round(playerPos.z, 3) ..
      "~s~, h = ~b~" .. Venato.Round(playerHeading, 3),
    0.5, 0.933, true)
end

function ShowInfoClient(index)
  DrawRect(0.87, 0.6, 0.23, 0.25, 0, 0, 0, 215)
  printTxt("~b~" .. AdminDataPlayers[index].Prenom .. " " .. AdminDataPlayers[index].Nom .. " (~y~" .. AdminDataPlayers[index].Pseudo .. ")",
    0.87, 0.53, true)
  printTxt("Argent : ~g~" .. AdminDataPlayers[index].Money, 0.77, 0.57)
  printTxt("Banque : ~g~" .. AdminDataPlayers[index].Bank, 0.77, 0.60)
  printTxt("Venato Point : ~o~" .. AdminDataPlayers[index].VenatoPoint, 0.77, 0.63)
  printTxt("Metier : ~g~" .. AdminDataPlayers[index].NameJob, 0.77, 0.66)
end

function printTxt(text, x, y, center)
  local center = center or false
  SetTextFont(4)
  SetTextScale(0.0, 0.5)
  SetTextCentre(center)
  SetTextDropShadow(0, 0, 0, 0, 0)
  SetTextEdge(0, 0, 0, 0, 0)
  SetTextColour(255, 255, 255, 255)
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x, y)
end
