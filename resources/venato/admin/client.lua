local AdminDataPlayers = {}
local ListPlayer = false
local open = false
local ClientSource = nil
local defaultNotification = { type = "alert", title = "Staff venato", logo = "https://i.ibb.co/mJSFL6z/icons8-error-96px.png" }
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
local state = false
local Skins = {
  { skin = "u_m_m_jesus_01", libelle = "Jésus"},
  { skin = "s_m_m_highsec_01", libelle = "Boris"},
  { skin = "a_m_y_acult_02", libelle = "Le Boucher"},
  { skin = "s_m_m_movprem_01", libelle = "Le Saoudien"},
  { skin = "csb_burgerdrug", libelle = "Burger Man"},
  { skin = "ig_lifeinvad_01", libelle = "Geek"},
  { skin = "s_m_y_prismuscl_01", libelle = "Prisonier"},
  { skin = "ig_old_man2", libelle = "Fermier"},
  { skin = "ig_oneil", libelle = "O Neil"},
  { skin = "ig_ramp_hipster", libelle = "Hipster"},
  { skin = "s_m_m_gaffer_01", libelle = "Ouvrier"},
  { skin = "u_m_m_spyactor", libelle = "James Bond"},
  { skin = "ig_ramp_hic", libelle = "Junkies"},
  { skin = "ig_ramp_gang", libelle = "Vagos"},
  { skin = "ig_ramp_gang", libelle = "Vagos"},
  { skin = "ig_ramp_mex", libelle = "Gang Mexicain"},
  { skin = "	ig_roccopelosi", libelle = "Gang Italien"},
  { skin = "ig_beverly", libelle = "Paparazzi"},
  { skin = "g_m_m_chicold_01", libelle = "Cagoule"},
  { skin = "g_m_y_ballaorig_01", libelle = "Vagos"},
  { skin = "csb_porndudes", libelle = "Acteur Porno"},
  { skin = "csb_cletus", libelle = "Clétus"},
  { skin = "a_m_y_runner_01", libelle = "Sportif"},
  { skin = "a_m_y_breakdance_01", libelle = "Break Dancer"},
  { skin = "a_m_m_tranvest_02", libelle = "Travesti"},
  { skin = "a_m_m_fatlatin_01", libelle = "Le Gros"},
  { skin = "a_m_y_juggalo_01", libelle = "Le Fou"},
  { skin = "a_m_y_surfer_01", libelle = "Surfer"},
  { skin = "ig_tanisha", libelle = "Tanisha (F)"},
  { skin = "ig_kerrymcintosh", libelle = "Kerry McIntosh (F)"},
  { skin = "csb_anita", libelle = "Anita (F)"},
  { skin = "csb_maude", libelle = "La grosse Maude (F)"},
  { skin = "csb_anita", libelle = "Anita (F)"},
  { skin = "ig_mrs_thornhill", libelle = "Vielle Thornill (F)"},
  { skin = "s_f_m_maid_01", libelle = "Femme de ménage (F)"},
  { skin = "ig_maryann", libelle = "Sportive (F)"},
  { skin = "g_f_y_vagos_01", libelle = "Vagos (F)"},
  { skin = "g_f_y_ballas_01", libelle = "Ballas (F)"},
  { skin = "a_f_y_bevhills_02", libelle = "Riche (F)"},
  { skin = "a_f_y_fitness_01", libelle = "Yoga (F)"},
  { skin = "a_f_y_tourist_01", libelle = "Touriste (F)"},
  { skin = "a_f_m_fatcult_01", libelle = "Folle (F)"},
}

function openvenatoadmin()
  Menu.clearMenu()
  Menu.open()
  AdminShowPlayerInfo = nil
  TriggerEvent('Menu:Init', "", "La vitamine c mais ne dira rien", "#F9A82599", "https://cdn.discordapp.com/attachments/618546482135433226/618546497373339653/20181216224111_1.jpg")
  Menu.addButton("<span class='red--text'>Fermer</span>", "AdminCloseMenu")
  if AdminDataPlayers[ClientSource].Group == "Admin" or AdminDataPlayers[ClientSource].Group == "Modo" then    
    Menu.addButton2("Liste des joueurs", "AdminListPlayer", nil, '', 'https://i.ibb.co/BnCn29r/icons8-groups-96px.png')
    Menu.addButton2("Envoyer un message aux joueurs", "AdminSendMsg", nil, '', 'https://i.ibb.co/DK24L07/icons8-sms-96px-1.png')
  end
  if AdminDataPlayers[ClientSource].Group == "Admin" then
    Menu.addButton2("Spawn Voiture", "AdminSpawnVehicle", nil, '', 'https://i.ibb.co/Gv2Wyhq/icons8-car-96px-1.png')
    Menu.addButton2("DeSpawn Voiture", "AdminDespawnVoiture", nil, '', 'https://i.ibb.co/NjbvdGS/icons8-car-theft-96px.png')
    Menu.addButton2("Récupérer les clés du vehicule", "AdminGetClef", nil, '', 'https://i.ibb.co/t4rx1Zh/icons8-car-rental-96px.png')
    Menu.addButton2("Réparer vehicule", "AdminFixVehicle", nil, '', 'https://i.ibb.co/XYrgvR3/icons8-car-service-96px-1.png')
    Menu.addButton2("Jesus Christ", "respawntest", nil, '', 'https://i.ibb.co/f14gXT7/icons8-cross-96px-1.png')
    Menu.addButton2("Revive joueur", "revivevnt", nil, '', 'https://i.ibb.co/FxDQnns/icons8-nurse-male-96px.png')
    Menu.addButton2("Soigner joueur", "healvnt", nil, '', 'https://i.ibb.co/XWzMcZ9/icons8-health-book-96px.png')
    Menu.addButton2("Recharger les coffres", "ReloadCoffre", nil, '', 'https://i.ibb.co/P1r91pg/icons8-safe-96px.png')
    Menu.addButton2("Teleporter sur markeur", "AdminTpMarkeur", nil, '', 'https://i.ibb.co/Pz7Z7XJ/icons8-define-location-96px.png')
    Menu.addButton2("Teleporter sur coordonées", "AdminCustomTP", nil, '', 'https://i.ibb.co/hLVFmYS/icons8-map-pin-96px.png')
    Menu.addButton2("Afficher/Masquer les coordonées", "AdminShowCoord", nil, '', 'https://i.ibb.co/NtmfJDv/icons8-compass-96px.png')
    --Menu.addButton2("Mode cheat : ~b~"..cheatmode, "cheatemode", nil, '', '')
    Menu.addButton2("NoClip", "AdminNoClip", nil, '', 'https://i.ibb.co/ZhdSG5H/icons8-ghost-96px.png')
    Menu.addButton2("Invisible", 'AdminInvisible' , nil, '', 'https://i.ibb.co/LJ8sxgW/icons8-access-for-blind-96px-1.png')
    Menu.addButton2("Show/unShow blips" , "AdminBlipsOption", nil, '', 'https://i.ibb.co/wMLT4jf/icons8-map-marker-96px.png')
    Menu.addButton2("Ne pas Utiliser pls !!!!! Créer véhicule  !!!!!!!!!!", 'createVeh' , nil, '', 'https://i.ibb.co/jRsrTDn/icons8-weigh-station-96px.png')
    if AdminDataPlayers[ClientSource].SteamId == 'steam:110000108378030' or AdminDataPlayers[ClientSource].SteamId == 'steam:1100001034bfc93' then
      Menu.addButton2("Etat véhicule", 'vehicleState' , nil, '', 'https://i.ibb.co/d54p3zs/icons8-show-property-96px.png')
      Menu.addButton2("Abîmer véhicule", 'damageVeh' , nil, '', 'https://i.ibb.co/4RdJS47/icons8-baseball-96px.png')
    end
    if AdminDataPlayers[ClientSource].SteamId == 'steam:110000108378030' or AdminDataPlayers[ClientSource].SteamId == 'steam:1100001034bfc93' or AdminDataPlayers[ClientSource].SteamId == 'steam:110000112d6a726' then  
      Menu.addButton2("Changer de skin", "SkinMenu", nil, '', 'https://i.ibb.co/MVXCCvc/icons8-anonymous-mask-96px.png')
    end
    Menu.CreateMenu()
  end
end

function revivevnt()
  local ClosePlayer, distance = venato.ClosePlayer()
  if ClosePlayer ~= 0 and ClosePlayer ~= nil and distance < 4 then
    TriggerServerEvent("vnt:resurect", ClosePlayer)
  else
    venato.notifyError("Il n'y a personne à proximité.")
  end  
end

function vehicleState()
  local current = GetPlayersLastVehicle(GetPlayerPed(-1), true)
  local vehicleNotification = {
    title = "Garage",
    type = "alert",
    logo = "https://i.ibb.co/wpxH8B1/icons8-parking-96px.png",
    timeout = 3000
  }  
  local nbWheel = GetVehicleNumberOfWheels(current)
  local nbDoor = GetNumberOfVehicleDoors(current)

  local message =  "AreAllVehicleWindowsIntact : "..venato.DisplayBool(AreAllVehicleWindowsIntact(current)).."<br/>"
  message = message.. "AreVehicleWingsIntact : "..venato.DisplayBool(AreVehicleWingsIntact(current)).."<br/>"
  message = message.. "GetIsLeftVehicleHeadlightDamaged : "..venato.DisplayBool(GetIsLeftVehicleHeadlightDamaged(current)).."<br/>"
  message = message.. "GetIsRightVehicleHeadlightDamaged : "..venato.DisplayBool(GetIsRightVehicleHeadlightDamaged(current)).."<br/>"
  message = message.. "GetVehicleBodyHealth : "..GetVehicleBodyHealth(current).."<br/>"
  message = message.. "GetVehicleBodyHealth2 : "..GetVehicleBodyHealth_2(current).."<br/>"
  message = message.. "GetVehicleCauseOfDestruction : "..GetVehicleCauseOfDestruction(current).."<br/>"
  message = message.. "GetVehicleDeformationAtPos 0: "..GetVehicleDeformationAtPos(current,0,0,0).."<br/>"
  message = message.. "GetVehicleDeformationAtPos 1: "..GetVehicleDeformationAtPos(current,1,1,1).."<br/>"
  message = message.. "GetVehicleDeformationAtPos -1: "..GetVehicleDeformationAtPos(current,-1,-1,-1).."<br/>"
  message = message.. "GetVehicleDeformationAtPos 2: "..GetVehicleDeformationAtPos(current,2,2,2).."<br/>"
  message = message.. "GetVehicleDirtLevel : "..GetVehicleDirtLevel(current).."<br/>"
  message = message.. "GetVehicleEngineHealth : "..GetVehicleEngineHealth(current).."<br/>"
  for i=0, 6 do
    message = message.. "GetVehicleWheelHealth "..i.." : "..GetVehicleWheelHealth(current, i).."<br/>"
  end
  for i=0, 6 do
    message = message.. "IsVehicleDoorDamaged "..i.." : "..venato.DisplayBool(IsVehicleDoorDamaged(current, i)).."<br/>"
  end
  for i=0, 6 do
    message = message.. "IsVehicleWindowIntact "..i.." : "..venato.DisplayBool(IsVehicleWindowIntact(current, i)).."<br/>"
  end
  message = message.. "GetVehicleOilLevel : "..GetVehicleOilLevel(current).."<br/>"
  

  -- message = message.. "GetVehicleCauseOfDestruction : "..GetVehicleCauseOfDestruction(current).."<br/>"
  -- message = message.. "GetVehicleCauseOfDestruction : "..GetVehicleCauseOfDestruction(current).."<br/>"
  -- message = message.. "GetVehicleCauseOfDestruction : "..GetVehicleCauseOfDestruction(current).."<br/>"
  -- message = message.. "GetVehicleCauseOfDestruction : "..GetVehicleCauseOfDestruction(current).."<br/>"
  -- message = message.. "GetVehicleCauseOfDestruction : "..GetVehicleCauseOfDestruction(current).."<br/>"
  -- message = message.. "GetVehicleCauseOfDestruction : "..GetVehicleCauseOfDestruction(current).."<br/>"
  -- message = message.. "GetVehicleCauseOfDestruction : "..GetVehicleCauseOfDestruction(current).."<br/>"
  vehicleNotification.message = message
  venato.notify(vehicleNotification)
end

function damageVeh()
  local current = GetPlayersLastVehicle(GetPlayerPed(-1), true)
  -- local coords = GetEntityCoords(current)
  -- local nbWheel = GetVehicleNumberOfWheels(current)
  -- local nbDoor = GetNumberOfVehicleDoors(current)
  for i=0, 9 do    
    SmashVehicleWindow(current, i)      
  end  
  for i=0, 9 do    
    SetVehicleDoorBroken(current, i)      
  end 
  for i=0, 9 do    
    SetVehicleTyreBurst(current, i, true, 0.0)      
  end    
end

function healvnt()
  local ClosePlayer, distance = venato.ClosePlayer()
  if ClosePlayer ~= 0 and ClosePlayer ~= nil and distance < 4 then
    TriggerServerEvent("vnt:heal", ClosePlayer)
  else
    venato.notifyError("Il n'y a personne à proximité.")
  end
end

function AdminInvisible(value)
  if value ~= nil then
    SetEntityVisible(venato.GetPlayerPed(), value, nil)
    NetworkSetEntityInvisibleToNetwork(venato.GetPlayerPed(), value)
  else
    visible = not visible
    if visible then
      NetworkSetEntityInvisibleToNetwork(venato.GetPlayerPed(), true)
      SetEntityVisible(venato.GetPlayerPed(), true, nil)
    else

    NetworkSetEntityInvisibleToNetwork(venato.GetPlayerPed(), false)
      SetEntityVisible(venato.GetPlayerPed(), false, nil)
    end
  end
end

function AdminNoClip()
  noclip_pos = GetEntityCoords(venato.GetPlayerPed(), false)
  noclip = not noclip
end

Citizen.CreateThread(function()
	 while true do
		Citizen.Wait(0)
		  if noclip then
			  SetEntityCoordsNoOffset(venato.GetPlayerPed(),  noclip_pos.x,  noclip_pos.y,  noclip_pos.z,  0, 0, 0)
			if(IsControlPressed(1,  34))then
				heading = heading + 1.5
				if(heading > 360)then
					heading = 0
				end
				SetEntityHeading(venato.GetPlayerPed(),  heading)
			end
			if(IsControlPressed(1,  9))then
				heading = heading - 1.5
				if(heading < 0)then
					heading = 360
				end
				SetEntityHeading(venato.GetPlayerPed(),  heading)
			end
			if(IsControlPressed(1,  8))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(venato.GetPlayerPed(), 0.0, 1.0, 0.0)
			end
			if(IsControlPressed(1,  32))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(venato.GetPlayerPed(), 0.0, -1.0, 0.0)
			end

			if(IsControlPressed(1,  27))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(venato.GetPlayerPed(), 0.0, 0.0, 1.0)
			end
			if(IsControlPressed(1,  173))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(venato.GetPlayerPed(), 0.0, 0.0, -1.0)
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
  local coord = GetEntityCoords(venato.GetPlayerPed(), false)
  local heading = GetEntityHeading(venato.GetPlayerPed())
  FreezeEntityPosition(venato.GetPlayerPed(), false)
  NetworkResurrectLocalPlayer(coord.x, coord.y, coord.z, heading, true, true, false)
  ClearPedTasksImmediately(venato.GetPlayerPed())
  venato.resurect()
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
      if NetworkIsPlayerActive(Player) and GetPlayerPed(Player) ~= venato.GetPlayerPed() then
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
  Menu.clearMenu()
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "openvenatoadmin", nil)
  Menu.addButton("Modifier les coordonées", "coordtp", nil)
  Menu.addButton("Teleporte sur <span class='green--text'>" .. tonumber(xtppers) .. "</span>|<span class='green--text'> " .. tonumber(ytppers) .. " </span>|<span class='green--text'> " .. tonumber(ztppers),"AdminTpCustomCoord", nil)
end

function AdminTpCustomCoord()
  SetEntityCoords(venato.GetPlayerPed(), tonumber(xtppers) + 0.001, tonumber(ytppers) + 0.001, tonumber(ztppers) + 0.001)
end

function coordtp()
  local coord = xtppers .. " , " .. ytppers .. " , " .. ztppers
  local pw = venato.OpenKeyboard('', coord, 50, "Customs Coordonées")
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
  venato.notifyError("Coordonées erroné !")
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
  local vehicle = GetVehiclePedIsUsing(venato.GetPlayerPed())
  if tonumber(vehicle) == 0 then
    vehicle = venato.CloseVehicle()
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
  local vehicle = GetVehiclePedIsUsing(venato.GetPlayerPed())
  if tonumber(vehicle) == 0 then
    vehicle = venato.CloseVehicle()
    TriggerEvent('lock:addVeh', GetVehicleNumberPlateText(vehicle),
      GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
  else
    TriggerEvent('lock:addVeh', GetVehicleNumberPlateText(vehicle),
      GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
  end
end

function AdminDespawnVoiture()
  local vehicle = GetVehiclePedIsUsing(venato.GetPlayerPed())
  if tonumber(vehicle) == 0 then
    vehicle = venato.CloseVehicle()
    venato.DeleteCar(vehicle)
  else
    venato.DeleteCar(vehicle)
  end
end

function AdminSpawnVehicle()
  local name = venato.OpenKeyboard('', '', 20, "Modèle du vehicule")
  if name ~= nil and name ~= '' and name ~= ' ' and IsModelValid(GetHashKey(string.upper(name))) ~= false then
    venato.CreateVehicle(string.upper(name), GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()),
      function(vehicle)
        SetVehicleNumberPlateText(vehicle, "ADMIN" .. math.random(100, 999))
        SetPedIntoVehicle(GetPlayerPed(GetPlayerFromServerId(ClientSource)), vehicle, -1)
        TriggerEvent('lock:addVeh', GetVehicleNumberPlateText(vehicle),
          GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
      end)
  else
    venato.notifyError("Ce vehicule n'existe pas")
  end
end

function AdminSendMsg()
  local msg = venato.OpenKeyboard('', '', 1000, "Message à Envoyer")
  if msg == nil or msg == '' or msg == ' ' then
    defaultNotification.message = "Le message est erroné !"
    defaultNotification.type = "error"
    venato.notify(defaultNotification)
  else
    defaultNotification.message = msg
    defaultNotification.timeout = 20000
    defaultNotification.type = "warning"
    TriggerServerEvent("AdminVnT:sendMsG", defaultNotification)
  end
end

RegisterNetEvent("Admin:CallDataUsers:cb")
AddEventHandler("Admin:CallDataUsers:cb", function(dataPlayers, DataSource)
  Menu.clearMenu()
  AdminDataPlayers = dataPlayers
  ClientSource = DataSource
  openvenatoadmin()
end)

function AdminListPlayer()
  Menu.clearMenu()
  ListPlayer = true
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "openvenatoadmin", nil)
  for k, v in pairs(AdminDataPlayers) do
    Menu.addButton("[<span class='red--text'>" .. k .. "</span>] " .. v.Prenom .. " " .. v.Nom .. " (<span class='yellow--text'>" .. v.Pseudo .. "</span>)","AdminPlayerOption", k, "AdminShowPlayerInfoo")
  end
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "openvenatoadmin", nil)
end

function SkinMenu()
  Menu.clearMenu()
  ListPlayer = true
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "openvenatoadmin", nil)
  for k, v in pairs(Skins) do
    Menu.addButton("" .. v.libelle .. "","ChangeSkin", v.skin, nil)
  end
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "openvenatoadmin", nil)
end

function ChangeSkin(skin)
  RequestModel(skin)
  while not HasModelLoaded(skin) do
      RequestModel(skin)
      Wait(0)
  end
  SetPlayerModel(PlayerId(), skin)
  SetModelAsNoLongerNeeded(skin)
  -- SetPedHeadBlendData(playerPed, 0, 0, skin, 0, 0, skin, 1.0, 1.0, 1.0, true)
  SetPedDefaultComponentVariation(venato.GetPlayerPed())
  SetPedComponentVariation(venato.GetPlayerPed(), 2, 0, 0, 0)
end

function AdminPlayerOption(index)
  indexToShow = index
  Menu.clearMenu()
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "AdminListPlayer", nil)
  Menu.addButton("Spectate (Voyeur :3)", "AdminSpectate", nil)
  Menu.addButton("Kick (Pour le lol)", "AdminActionOnPlayer", "kick")
  Menu.addButton("Ban (Parceque c'est cool)", "AdminActionOnPlayer", "ban")
  Menu.addButton("Freeze", "AdminFreeze", nil)
  Menu.addButton("Toi --> elle", "Admintptoelle", nil)
  Menu.addButton("Toi <-- elle", "Admintptome", nil)
  if DataUser.Group == "Admin" then
  -- Menu.addButton("Give dans la poche", "none", nil)
  -- Menu.addButton("Give en bank", "none", nil)
  -- Menu.addButton("Set dans la poche", "none", nil)
  -- Menu.addButton("Set en bank", "none", nil)
end
end

function ReloadCoffre()
  TriggerServerEvent("Coffre:ReloadCoffre")
end

function AdminActionOnPlayer(action)
  local result = venato.OpenKeyboard('', "", 100, "Raison:")
  if result ~= "" and result ~= nil then
    TriggerServerEvent("Admin:ActionOnPlayer", action, indexToShow, result)
  else
    venato.notifyError("Il y a un problème sur la Raison renseigné (le joueur n'a pas subit la sanction du coup)")
  end
end

function AdminSetBank()
  local result = venato.OpenKeyboard('', "", 10, "Nombre")
  if result ~= "" and result ~= nil then
    TriggerServerEvent('Bank:SetBankMoney', result)
  else
    venato.notifyError("Il y a un problème sur la somme renseigné")
  end
end

function AdminSetPoche()
  local result = venato.OpenKeyboard('', "", 10, "Nombre")
  if result ~= "" and result ~= nil then
    TriggerServerEvent('Inventory:SetMoney', result)
  else
    venato.notifyError("Il y a un problème sur la somme renseigné")
  end
end

function AdminGiveBank()
  local result = venato.OpenKeyboard('', "", 10, "Nombre")
  if result ~= "" and result ~= nil then
    TriggerServerEvent('Bank:Salaire', result, 'Admin')
  else
    venato.notifyError("Il y a un problème sur la somme renseigné")
  end
end

function AdminGivePoche()
  local result = venato.OpenKeyboard('', "", 10, "Nombre")
  if result ~= "" and result ~= nil then
    TriggerServerEvent('Inventory:AddMoney', result)
  else
    venato.notifyError("Il y a un problème sur la somme renseigné")
  end
end

function Admintptoelle()
	TriggerServerEvent("Admin:tptoelle", indexToShow)
end

function Admintptome()
	TriggerServerEvent("Admin:tptome", indexToShow)
end

RegisterNetEvent('Admin:teleportUser')
AddEventHandler('Admin:teleportUser', function(coords)
	SetEntityCoords(GetPlayerPed(-1), coords[1], coords[2], coords[3])
end)

function AdminFreeze()
  TriggerServerEvent("Admin:freeze", indexToShow)
end

RegisterNetEvent('Admin:freezePlayer')
AddEventHandler("Admin:freezePlayer", function()
	local player = PlayerId()
	local ped = GetPlayerPed(-1)
	if state == true then
		if not IsEntityVisible(ped) then
			SetEntityVisible(ped, true)
		end
		if not IsPedInAnyVehicle(ped) then
			SetEntityCollision(ped, true)
		end
		FreezeEntityPosition(ped, false)
		SetPlayerInvincible(player, false)
		state = false
	else
		SetEntityCollision(ped, false)
		FreezeEntityPosition(ped, true)
		SetPlayerInvincible(player, true)
		state = true
		if not IsPedFatallyInjured(ped) then
			ClearPedTasksImmediately(ped)
		end
	end
end)

function AdminSpectate()
  if InSpectatorMode == false then
    LastCoords = GetEntityCoords(venato.GetPlayerPed())
    TargetSpectate = indexToShow
    InSpectatorMode = true
    Citizen.CreateThread(function()
      if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
      end
      SetCamActive(cam,  true)
      RenderScriptCams(true,  false,  0,  true,  true)
      InSpectatorMode = true
      AdminInvisible(false)
    end)
  else
    InSpectatorMode = false
      TargetSpectate  = nil
      AdminInvisible(true)
      local playerPed = venato.GetPlayerPed()
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
        if NetworkIsPlayerActive(Player) and GetPlayerPed(Player) ~= venato.GetPlayerPed() then
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
              local x1, y1 = table.unpack(GetEntityCoords(venato.GetPlayerPed(), true))
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
      if IsPedInAnyVehicle(venato.GetPlayerPed(), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(venato.GetPlayerPed(), 0),
        -1) == venato.GetPlayerPed()) then
        entity = GetVehiclePedIsIn(venato.GetPlayerPed(), 0)
      else
        entity = venato.GetPlayerPed()
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
      local playerPed      = venato.GetPlayerPed()
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
    "x = ~b~" .. venato.Round(playerPos.x, 3) ..
      "~s~, y = ~b~" .. venato.Round(playerPos.y, 3) ..
      "~s~, z = ~b~" .. venato.Round(playerPos.z, 3) ..
      "~s~, h = ~b~" .. venato.Round(playerHeading, 3),
    0.5, 0.933, true)
end

function ShowInfoClient(index)
  DrawRect(0.87, 0.6, 0.23, 0.25, 0, 0, 0, 215)
  printTxt("~b~" .. AdminDataPlayers[index].Prenom .. " " .. AdminDataPlayers[index].Nom .. " (~y~" .. AdminDataPlayers[index].Pseudo .. ")",
    0.87, 0.53, true)
  printTxt("Argent : ~g~" .. AdminDataPlayers[index].Money, 0.77, 0.57)
  printTxt("Banque : ~g~" .. AdminDataPlayers[index].Bank, 0.77, 0.60)
  printTxt("venato Point : ~o~" .. AdminDataPlayers[index].venatoPoint, 0.77, 0.63)
  
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
