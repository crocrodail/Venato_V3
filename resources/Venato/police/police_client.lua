 isCop = false
 gillet = false
 gilletfluo = false
 mancheLong = false
 kepi = false
 lunette = false
 ceinture = false
 ped = nil
 uniforclassic = false

isCopInService = false
controlWeapon = true
rank = "inconnu"
local checkpoints = {}
local existingVeh = nil
local isAlreadyDead = false
local allServiceCops = {}
local blipsCops = {}

local blacklistedWeapons = {
	"WEAPON_UNARMED",
	"WEAPON_STUNGUN",
	"WEAPON_KNIFE",
	"WEAPON_KNUCKLE",
	"WEAPON_NIGHTSTICK",
	"WEAPON_HAMMER",
	"WEAPON_BAT",
	"WEAPON_GOLFCLUB",
	"WEAPON_CROWBAR",
	"WEAPON_BOTTLE",
	"WEAPON_DAGGER",
	"WEAPON_HATCHET",
	"WEAPON_MACHETE",
	"WEAPON_FLASHLIGHT",
	"WEAPON_SWITCHBLADE",
	"WEAPON_FIREEXTINGUISHER",
	"WEAPON_PETROLCAN",
	"WEAPON_SNOWBALL",
	"WEAPON_FLARE",
  "WEAPON_BALL",
  101631238,
  883325847
}

local function sendnotif(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0,1)
end

local takingService = {
  --{x=850.156677246094, y=-1283.92004394531, z=28.0047378540039},
  {x=457.956909179688, y=-992.72314453125, z=30.6895866394043},
  {x=-449.594482421875, y=6016.66845703125, z=31.7163963317871},
  {x=142.513473510742, y=-769.184692382813, z=45.7520217895508},
}

local stationGarage = {
	{x=452.115966796875, y=-1018.10681152344, z=28.4786586761475},
	{x=1867.1923, y=3691.2719, z=3300.7599},
}


RegisterNetEvent('police:receiveIsCop')
AddEventHandler('police:receiveIsCop', function(result)
	Citizen.Trace('isCopisCopisCopisCopisCopisCopisCop')
	if(result == "inconnu") then
		isCop = false
	else
		isCop = true
		rank = result
	end
end)

RegisterNetEvent('police:nowCop')
AddEventHandler('police:nowCop', function()
	isCop = true
end)

RegisterNetEvent('police:noLongerCop')
AddEventHandler('police:noLongerCop', function()
	isCop = true
	isCopInService = true

	local playerPed = PlayerPedId()

	TriggerServerEvent("skin_customization:SpawnPlayer")
	SetPedComponentVariation(PlayerPedId(), 9, 0, 1, 2)
	SetPedComponentVariation(PlayerPedId(), 10, 0, 0, 2)
	RemoveAllPedWeapons(playerPed)
	Citizen.Wait(2000)
	TriggerServerEvent('weaponshop:GiveWeaponsToPlayer')

	if(existingVeh ~= nil) then
		SetEntityAsMissionEntity(existingVeh, true, true)
    TriggerServerEvent('ivt:deleteVeh', GetVehicleNumberPlateText(existingVeh))
		Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(existingVeh))
		existingVeh = nil
	end
  ServiceOff()
end)


function restart_server()
	SetTimeout(1000, function()
		restart_server()
	end)
end
restart_server()


RegisterNetEvent('police:dropIllegalItem')
AddEventHandler('police:dropIllegalItem', function(id,qty)
	TriggerEvent("player:looseItem", tonumber(id),tonumber(qty))
	TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "La Police vous a fouillé")
end)

RegisterNetEvent('police:unseatme')
AddEventHandler('police:unseatme', function(t)
	local ped = PlayerPedId()
	ClearPedTasksImmediately(ped)
	plyPos = GetEntityCoords(ped,  true)
	local xnew = plyPos.x+2
	local ynew = plyPos.y+2

	SetEntityCoords(PlayerPedId(), xnew, ynew, plyPos.z)
end)

RegisterNetEvent('police:forcedEnteringVeh')
AddEventHandler('police:forcedEnteringVeh', function()
  local pos = GetEntityCoords(PlayerPedId())
  local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)
  local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
  local a, b, c, d, vehicleHandle = GetRaycastResult(rayHandle)
  SetPedIntoVehicle(PlayerPedId(), vehicleHandle, 1)
end)

RegisterNetEvent('police:resultAllCopsInService')
AddEventHandler('police:resultAllCopsInService', function(array)
	allServiceCops = array
	enableCopBlips()
end)

function POLICE_openTextInputadmin(title, defaultText, maxlength)
	local TextEntry = "Message"
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

function POLICE_sendmsg()
  local pw = POLICE_openTextInputadmin('', '', 500)
	if pw == nil or pw == '' then
	   TriggerServerEvent('police:failmsg')
  else
	   TriggerServerEvent('police:msggranded', pw)
  end
end

function POLICE_removeOrPlaceCone()
  local mePed = PlayerPedId()
  local pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 1.5, 0)
  local cone = GetClosestObjectOfType( pos.x, pos.y, pos.z, 1.0, GetHashKey("prop_roadcone02a"), false, false, false)
  if cone ~= 0 then
    DeleteObject(cone)
  else
    local object = platypus.CreateObject("prop_roadcone02a", pos.x, pos.y, pos.z)
    SetEntityRotation(objet, GetEntityRotation(platypus.GetPlayerPed()))
    PlaceObjectOnGroundProperly(object)
    SetEntityDynamic(object , true)
    SetEntityInvincible(object , false)
    SetEntityCanBeDamaged(object , true)
    SetEntityHealth(object , 1000)
    SetEntityHasGravity(object , true)
    SetEntityAsMissionEntity(object, true, true)
    SetEntityLoadCollisionFlag(object , true)
    SetEntityRecordsCollisions(object , true)
  end
end

function POLICE_removeOrPlaceBarrier()
  local mePed = PlayerPedId()
  local pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 1.5, 0)
  local barriere = GetClosestObjectOfType( pos.x, pos.y, pos.z, 1.0, GetHashKey("prop_barrier_work05"), false, false, false)

  if barriere ~= 0 then
    DeleteObject(barriere)
  else
    local object = platypus.CreateObject("prop_barrier_work05", pos.x, pos.y, pos.z)
    local rot = GetEntityRotation(platypus.GetPlayerPed())
    SetEntityRotation(objet, rot.x, rot.y, rot.z)
    PlaceObjectOnGroundProperly(object)
    SetEntityDynamic(object , true)
    SetEntityInvincible(object , false)
    SetEntityCanBeDamaged(object , true)
    SetEntityHealth(object , 1000)
    SetEntityHasGravity(object , true)
    SetEntityAsMissionEntity(object, true, true)
    SetEntityLoadCollisionFlag(object , true)
    SetEntityRecordsCollisions(object , true)
  end
end

function POLICE_removeOrPlaceHerse()
  local mePed = PlayerPedId()
  local pos = GetOffsetFromEntityInWorldCoords(mePed, 0.0, 0.2, 0.0)
  local hashHerse = GetHashKey("P_ld_stinger_s")
  local herse = GetClosestObjectOfType( pos.x, pos.y, pos.z, 1.0, GetHashKey("p_ld_stinger_s"), false, false, false)
  if herse ~= 0 then
    DeleteObject(herse)
    herse = 0
  else
  local object = platypus.CreateObject("p_ld_stinger_s", pos.x, pos.y, pos.z)
  local rot = GetEntityRotation(platypus.GetPlayerPed())
  SetEntityRotation(objet, rot.x, rot.y, rot.z)
  FreezeEntityPosition(object, true)
	PlaceObjectOnGroundProperly(object)
	SetEntityDynamic(object , true)
	SetEntityInvincible(object , false)
	SetEntityCanBeDamaged(object , true)
	SetEntityHealth(object , 1000)
	SetEntityHasGravity(object , true)
	SetEntityAsMissionEntity(object, true, true)
	SetEntityLoadCollisionFlag(object , true)
  SetEntityRecordsCollisions(object , true)
  end
end

function enableCopBlips()

	for k, existingBlip in pairs(blipsCops) do
        RemoveBlip(existingBlip)
    end
	blipsCops = {}

	local localIdCops = {}
	for id = 0, 64 do
		if(NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= PlayerPedId()) then
			for i,c in pairs(allServiceCops) do
				if(i == GetPlayerServerId(id)) then
					localIdCops[id] = c
					break
				end
			end
		end
	end

	for id, c in pairs(localIdCops) do
		local ped = GetPlayerPed(id)
		local blip = GetBlipFromEntity(ped)

		if not DoesBlipExist( blip ) then

			blip = AddBlipForEntity( ped )
			SetBlipSprite( blip, 1 )
			Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true )
			HideNumberOnBlip( blip )
			SetBlipNameToPlayerName( blip, id )

			SetBlipScale( blip,  0.85 )
			SetBlipAlpha( blip, 255 )

			table.insert(blipsCops, blip)
		else

			blipSprite = GetBlipSprite( blip )

			HideNumberOnBlip( blip )
			if blipSprite ~= 1 then
				SetBlipSprite( blip, 1 )
				Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true )
			end

			Citizen.Trace("Name : "..GetPlayerName(id))
			SetBlipNameToPlayerName( blip, id )
			SetBlipScale( blip,  0.85 )
			SetBlipAlpha( blip, 255 )

			table.insert(blipsCops, blip)
		end
	end
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

function GetClosestPlayer()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = PlayerPedId()
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

	return closestPlayer, closestDistance
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function getIsInService()
	return isCopInService
end

function isNearTakeService()
	for i = 1, #takingService do
		local ply = PlayerPedId()
		local plyCoords = GetEntityCoords(ply, 0)
		local distance = GetDistanceBetweenCoords(takingService[i].x, takingService[i].y, takingService[i].z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
		if(distance < 30) then
			DrawMarker(1, takingService[i].x, takingService[i].y, takingService[i].z-1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 155, 255, 200, 0, 0, 2, 0, 0, 0, 0)
		end
		if(distance < 2) then
			return true
		end
	end
end

function isNearArmurie()
  if (isCopInService) then
		local ply = PlayerPedId()
		local plyCoords = GetEntityCoords(ply, 0)
		local distance = GetDistanceBetweenCoords(459.57223510742, -979.94390869141, 30.689588546753, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
		if(distance < 30) then
			DrawMarker(1, 459.57223510742, -979.94390869141, 30.689588546753-1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 155, 255, 200, 0, 0, 2, 0, 0, 0, 0)
		end
		if(distance < 2) then
			return true
		end
  end
end

function isNearStationGarage()
	for i = 1, #stationGarage do
		local ply = PlayerPedId()
		local plyCoords = GetEntityCoords(ply, 0)
		local distance = GetDistanceBetweenCoords(stationGarage[i].x, stationGarage[i].y, stationGarage[i].z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
		if(distance < 30) then
			DrawMarker(1, stationGarage[i].x, stationGarage[i].y, stationGarage[i].z-1, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 0, 155, 255, 200, 0, 0, 2, 0, 0, 0, 0)
		end
		if(distance < 2) then
			return true
		end
	end
end

function ServiceOn()
	isCopInService = true
  TriggerServerEvent("police:takeService")
  TriggerEvent('Menu:Close')
  menuPoliceVestiaire()
end

function ServiceOff()
	isCopInService = false
  TriggerServerEvent("police:setService",false)
	TriggerServerEvent("police:breakService")
	allServiceCops = {}

	for k, existingBlip in pairs(blipsCops) do
        RemoveBlip(existingBlip)
    end
  blipsCops = {}
  civil()
  TriggerEvent('Menu:Close')
end

function getPowerFromRole(rank)
  local power = 0

  if rank == "Cadet" then
    power = 1
  end

  if rank == "Agent" then
    power = 2
  end

  if rank == "Sergent" then
    power = 3
  end

  if rank == "Sergent-Chef" then
    power = 4
  end

  if rank == "Lieutnant" then
    power = 5
  end

  if rank == "Capitaine" then
    power = 6
  end

  return power

end

function menuPoliceVestiaire()
  TriggerEvent('Menu:Clear')
  TriggerEvent('Menu:Init', "Vestaire", "<small>"..rank.."</small>", '#1565C099', "https://i.ibb.co/mRx92ph/police-vestiaire.jpg")
  if isCopInService then

    local power = getPowerFromRole(rank)

    TriggerEvent('Menu:AddButton2', "<span class='red--text'>Quitter son service</span>", "ServiceOff", "", "", "https://i.ibb.co/c393rDv/icons8-export-96px.png")

    TriggerEvent('Menu:AddButton2', "Equiper tenue standard", "cadetunif", "", "", "https://i.ibb.co/K7Cv1Sx/icons8-police-badge-96px.png")

    if power >= 2 then --Agent
      TriggerEvent('Menu:AddButton2', "Equiper tenue de civil", "civil", "", "", "https://i.ibb.co/P5NBmM1/icons8-t-shirt-96px.png")
      TriggerEvent('Menu:AddButton2', "Equiper tenue de SWAT", "swat", "", "", "https://i.ibb.co/K7Cv1Sx/icons8-police-badge-96px.png")

      if power >= 3 then --Sergent et Sergent-Chef

        if power >= 5 then --Lieutnant
          TriggerEvent('Menu:AddButton2', "Equiper tenue de ville", "villesuit", "", "", "https://i.ibb.co/K7Cv1Sx/icons8-police-badge-96px.png")

          if power >= 6 then -- Capitaine
            TriggerEvent('Menu:AddButton2', "Equiper tenue de capitaine", "capitaine", "", "", "https://i.ibb.co/K7Cv1Sx/icons8-police-badge-96px.png")
          end
        end
      end
    end

    if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) and uniforclassic then
      TriggerEvent('Menu:AddButton2', "Manche longue/Manche courte", "uniformbasic", "", "", "https://i.ibb.co/2MBSRpY/icons8-jumper-96px.png")
    end

    TriggerEvent('Menu:AddButton2', "Equiper / Retirer un gillet fluo", "gilletfluos", "", "", "https://i.ibb.co/19Sn2kk/yellow-jacket.png")
    TriggerEvent('Menu:AddButton2', "Equiper / Retirer un gillet pare-balle", "gillets", "", "", "https://i.ibb.co/jv1v2ty/bullet-proof-jacket.png")


    if power >= 1 then --Agent
      TriggerEvent('Menu:AddButton2', "Equiper / Retirer une ceinture", "ceintures", "", "", "https://i.ibb.co/hFspMWG/icons8-mens-belt-96px.png")
      TriggerEvent('Menu:AddButton2', "Equiper / Retirer un képi", "kepis", "", "", "https://i.ibb.co/1n2X8rb/icons8-air-pilot-hat-96px-1.png")

      if power >= 3 then --Sergent, Sergent-Chef, Lieutnant, Capitaine
        TriggerEvent('Menu:AddButton2', "Equiper / Retirer des lunettes", "lunettes", "", "", "https://i.ibb.co/KyNMhgv/icons8-sun-glasses-96px.png")
      end
    end

  else
    TriggerEvent('Menu:AddButton2', "Prendre son service", "ServiceOn", "", "", "https://i.ibb.co/KXZKdCh/icons8-police-station-96px-1.png")
  end

  TriggerEvent('Menu:CreateMenu')
  TriggerEvent('Menu:Open')
end

function standardEquip()
  GiveWeaponToPed(PlayerPedId(), "WEAPON_STUNGUN", 1)
  GiveWeaponToPed(PlayerPedId(), "WEAPON_NIGHTSTICK", 1)
  GiveWeaponToPed(PlayerPedId(), "WEAPON_FLASHLIGHT", 1)
  GiveWeaponToPed(PlayerPedId(), "WEAPON_FLARE", 10)
  GiveWeaponToPed(PlayerPedId(), "WEAPON_SMOKEGRENADE", 10)
  GiveWeaponToPed(PlayerPedId(), "GADGET_PARACHUTE", 150)
  TriggerEvent('Menu:Close')
  --TriggerServerEvent("project:armeActu")
end

function calibre50()
  GiveWeaponToPed(PlayerPedId(), "WEAPON_PISTOL50", 30)
  TriggerEvent('Menu:Close')
  --TriggerServerEvent("project:armeActu")
end

function shotgun()
  GiveWeaponToPed(PlayerPedId(), "WEAPON_PUMPSHOTGUN", 30)
  TriggerEvent('Menu:Close')
  --TriggerServerEvent("project:armeActu")
end

function assault()
  GiveWeaponToPed(PlayerPedId(), "WEAPON_BULLPUPRIFLE", 60)
  TriggerEvent('Menu:Close')
  --TriggerServerEvent("project:armeActu")
end

function sniper()
  GiveWeaponToPed(PlayerPedId(), "WEAPON_MarksmanRifle", 60)
  TriggerEvent('Menu:Close')
  --TriggerServerEvent("project:armeActu")
end

function dropWeapons()
  RemoveAllPedWeapons(PlayerPedId(),false)
end

RegisterNetEvent("gui:getsac")
AddEventHandler("gui:getsac", function(THEWEAPONPERSO)
  WEAPONPERSO = {}
  WEAPONPERSO = THEWEAPONPERSO
  weaponpersoo()
end)

function weaponpersoo()
  ClearMenu()
  MenuTitle = "Mes armes"
  MenuDescription = "~b~Choisissez l'arme a ravitailler."
  for Crocrolebgdu612, value in pairs(WEAPONPERSO) do
    arg2 = {Crocrolebgdu612, value.balles}
    Menu.addButton("~b~"..value.libelle.." : ~r~"..value.balles.."~b~ Balles", "reloadded", arg2)
  end
end

function reloadded(a)
  ClearMenu()
  MenuDescription = "~b~Nombre de balles à ajouter."
  local arme = a[1]
  local balles = a[2]
  Menu.addButton("~g~10 balles", "ravi", {arme, balles, 10})
  Menu.addButton("~g~30 balles", "ravi", {arme, balles, 30})
  Menu.addButton("~g~50 balles", "ravi", {arme, balles, 50})
  Menu.addButton("~g~100 balles", "ravi", {arme, balles, 100})
end

function ravi(a)
SetPedAmmo(PlayerPedId(),a[1],math.ceil(a[2]+a[3]))
--TriggerServerEvent("project:armeActu")
end

function spawnveh(namevehicul)
	  local vehicule = namevehicul
		local myPed = PlayerPedId()
		local player = PlayerId()
		local vehicle = GetHashKey(vehicule)
    if vehicle ~= nil then
		RequestModel(vehicle)
		while not HasModelLoaded(vehicle) do
			Wait(1)
		end
		local plate = math.random(100, 900)
    local LastPosX, LastPosY, LastPosZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
    local LastPosH = GetEntityHeading(PlayerPedId())
		existingVeh = CreateVehicle(vehicle,1874.3009033203, 3690.2387695313, 33.523826599121,182.77638244629, true, false)
		SetModelAsNoLongerNeeded(vehicle)
		SetEntityVisible(existingVeh, false, 0)
	--	DetachVehicleWindscreen(existingVeh)
		Citizen.Wait(250)
		AttachEntityToEntity(existingVeh, GetVehiclePedIsIn(PlayerPedId(), false), -1, AttachX, AttachY, AttachZ, 0.0, 0.0, 0.0, true, true, true, true, 1, true)
		SetVehicleExplodesOnHighExplosionDamage(existingVeh, false)
		SetEntityVisible(existingVeh, true, 0)
		SetPedIntoVehicle(PlayerPedId(), existingVeh, -1)
		SetVehicleFixed(existingVeh)
		SetVehicleDirtLevel(existingVeh, 0.0)
		SetVehicleLights(existingVeh, 0)
		SetVehicleBurnout(existingVeh, false)
		Citizen.InvokeNative(0x1FD09E7390A74D54, existingVeh, 0)

		SetVehicleHasBeenOwnedByPlayer(existingVeh,true)
		local id = NetworkGetNetworkIdFromEntity(existingVeh)
		SetNetworkIdCanMigrate(id, true)
		SetEntityInvincible(existingVeh, false)
		SetVehicleOnGroundProperly(existingVeh)
		if namevehicul == "cargobob2" then
			SetVehicleNumberPlateText(existingVeh, "CROCRODA")
		else
      local plate = math.random(100, 900)
			SetVehicleNumberPlateText(existingVeh, "LSPD"..plate.." ")
    end
		SetEntityAsMissionEntity(existingVeh, true, true)
		plate = GetVehicleNumberPlateText(existingVeh)
        TriggerEvent('lock:addVeh', plate, GetDisplayNameFromVehicleModel(GetEntityModel(existingVeh)))

	    SetVehicleEnginePowerMultiplier(existingVeh, 50.01)
		TriggerServerEvent("ls:refreshid",plate,existingVeh)
		veh = existingVeh

		--SetModelAsNoLongerNeeded(vehicle)
		Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(existingVeh))
  else
    print('ok baby')
  end
end

function armur()
  TriggerEvent('Menu:Clear')
  TriggerEvent('Menu:Init', "Armurerie", "<small>"..rank.."</small>", '#1565C099', "http://media-cdn.tripadvisor.com/media/photo-s/03/45/be/05/american-shooters.jpg")

  TriggerEvent('Menu:AddButton2', "Equipement standard", "standardEquip", "", "", "")
  local power = getPowerFromRole(rank)

  if power >= 2 then --Agent
    TriggerEvent('Menu:AddButton2', "Pistolet calibre 50", "calibre50", "", "", "")
    if power >= 3 then
      TriggerEvent('Menu:AddButton2', "Fusil d'assaut", "assault", "", "", "")
      if power >= 4 then
        TriggerEvent('Menu:AddButton2', "Fusil à pompe", "shotgun", "", "", "")
        if power >= 6 then
          TriggerEvent('Menu:AddButton2', "Fusil de précision", "sniper", "", "", "")
        end
      end
    end
  end
  TriggerEvent('Menu:AddButton2', "Poser le matériel", "dropWeapons", "", "", "")

  TriggerEvent('Menu:CreateMenu')
  TriggerEvent('Menu:Open')
end

nopee = true
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        --if(not isCop) then
          if IsPedShooting(platypus.GetPlayerPed()) and not platypus.HasJob(2) then      
            for i,v in ipairs(blacklistedWeapons) do
        			if GetSelectedPedWeapon(platypus.GetPlayerPed()) == v then
        				isBlacklistedWeapon = true
        			end
    			  end
            local random = math.random(1,10)
            if(random == 5) then
              local isBlacklistedWeapon = false
              for i,v in ipairs(blacklistedWeapons) do
                if GetSelectedPedWeapon(platypus.GetPlayerPed()) == v then
                  isBlacklistedWeapon = true
                end
              end
              
              if not isBlacklistedWeapon then
                local x,y,z = table.unpack(GetEntityCoords(platypus.GetPlayerPed(),true))
                print(GetSelectedPedWeapon(platypus.GetPlayerPed()))
                TriggerServerEvent("police:shootfired", {x, y, z})
              end
              isBlacklistedWeapon = false
            end
          end
        --end
        if(isCop) then
          if(isNearArmurie()) then
    				DisplayHelpText("Appuyer sur ~INPUT_CONTEXT~ pour ouvrir l'armurerie",0,1,0.5,0.8,0.6,255,255,255,255) -- ~g~E~s~
    				if IsControlJustPressed(1,51) then
              armur()
    				end
    			end

          if(isNearTakeService()) then
            DisplayHelpText('Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le vestiaire',0,1,0.5,0.8,0.6,255,255,255,255) -- ~g~E~s~
            if IsControlJustPressed(1,51) then
              ped = PlayerPedId()
              menuPoliceVestiaire()
            end
          end

          if(isCopInService) then
            if IsControlJustPressed(1,166) then
              openMenuPoliceGeneral(rank)
            end
          end

          if(isCopInService) then
            if(isNearStationGarage()) then
              if(IsPedInAnyVehicle( PlayerPedId(), false )) then --existingVeh
                DisplayHelpText('Appuyer sur ~INPUT_CONTEXT~ pour ranger votre vehicule',0,1,0.5,0.8,0.6,255,255,255,255)
              else
                DisplayHelpText('Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le garage de police',0,1,0.5,0.8,0.6,255,255,255,255)
              end

              if IsControlJustPressed(1,51) then
                if(IsPedInAnyVehicle( PlayerPedId(), false )) then
                  policevehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                  SetEntityAsMissionEntity(policevehicle, true, true)
                  TriggerServerEvent('ivt:deleteVeh', GetVehicleNumberPlateText(policevehicle))
                  Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(policevehicle))
                  policevehicle = nil
                else
                  TriggerEvent('Menu:Clear')
                  TriggerEvent('Menu:Init', "Garage LSPD", "<small>"..rank.."</small>", '#1565C099', "https://img.bfmtv.com/i/992/0/065a/5e0199a40500e2bda037db3fd63b.jpeg")
                  local power = getPowerFromRole(rank)
                  TriggerEvent('Menu:AddButton2', "Cadet - Buffalo", "POLICE_SpanwVehicleCar", { type = "Car", model = "police2"}, "", "")
                  TriggerEvent('Menu:AddButton2', "Moto", "POLICE_SpanwVehicleCar", { type = "Car", model = "policeb"}, "", "")
                  TriggerEvent('Menu:AddButton2', "Transporter", "POLICE_SpanwVehicleCar", { type = "Car", model = "policet"}, "", "")
                  TriggerEvent('Menu:AddButton2', "Bus", "POLICE_SpanwVehicleCar", { type = "Car", model = "pbus"}, "", "")
                  TriggerEvent('Menu:AddButton2', "Blinde", "POLICE_SpanwVehicleCar", { type = "Car", model = "riot"}, "", "")
                  if power >= 2 then --Agent
                    TriggerEvent('Menu:AddButton2', "Agent - Cruiser", "POLICE_SpanwVehicleCar", { type = "Car", model = "police3"}, "", "")
                    TriggerEvent('Menu:AddButton2', "4x4 - Chevrolet K905", "POLICE_SpanwVehicleCar", { type = "Car", model = "police6"}, "", "")
                    TriggerEvent('Menu:AddButton2', "4x4 - Interceptor II", "POLICE_SpanwVehicleCar", { type = "Car", model = "police13"}, "", "")
                    TriggerEvent('Menu:AddButton2', "Banalisé - Fourgon", "POLICE_SpanwVehicleCar", { type = "Car", model = "speedo"}, "", "")
                    if power >= 3 then
                      TriggerEvent('Menu:AddButton2', "Sergent - Ford", "POLICE_SpanwVehicleCar", { type = "Car", model = "police14"}, "", "")
                      if power >= 4 then
                        TriggerEvent('Menu:AddButton2', "Sergent Chef - Dodge", "POLICE_SpanwVehicleCar", { type = "Car", model = "police12"}, "", "")
                        if power >= 5 then
                          TriggerEvent('Menu:AddButton2', "Banalisé - Voiture", "POLICE_SpanwVehicleCar", { type = "Car", model = "police4"}, "", "")
                          TriggerEvent('Menu:AddButton2', "Banalisé - Felon", "POLICE_SpanwVehicleCar", { type = "Car", model = "policefelon"}, "", "")
                          TriggerEvent('Menu:AddButton2', "Lieutenant - Granger", "POLICE_SpanwVehicleCar", { type = "Car", model = "fbi2"}, "", "")
                          TriggerEvent('Menu:AddButton2', "Lieutenant - Mclaren", "POLICE_SpanwVehicleCar", { type = "Car", model = "polmp4"}, "", "")
                          TriggerEvent('Menu:AddButton2', "Lieutenant - Porshe", "POLICE_SpanwVehicleCar", { type = "Car", model = "pol718"}, "", "")
                          TriggerEvent('Menu:AddButton2', "Lieutenant - Oracle II", "POLICE_SpanwVehicleCar", { type = "Car", model = "oracle2"}, "", "")
                          if power >= 6 then
                            TriggerEvent('Menu:AddButton2', "Capitaine - Ferrari", "POLICE_SpanwVehicleCar", { type = "Car", model = "polf430"}, "", "")
                            TriggerEvent('Menu:AddButton2', "Capitaine - Aventador", "POLICE_SpanwVehicleCar", { type = "Car", model = "polaventa"}, "", "")
                            TriggerEvent('Menu:AddButton2', "Capitaine - Chiron", "POLICE_SpanwVehicleCar", { type = "Car", model = "polchiron"}, "", "")
                          end
                        end
                      end
                    end
                  end
                  TriggerEvent('Menu:CreateMenu')
                  TriggerEvent('Menu:Open')
                end
              end
            end
        end
    end
  end
end)

---------------------------------------------------------------------------------------
-------------------------------SPAWN HELI AND CHECK DEATH------------------------------
---------------------------------------------------------------------------------------
local alreadyDead = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if(isCop) then
			if(isCopInService) then

				-- if(IsPlayerDead(PlayerId())) then
					-- if(alreadyDead == false) then
						-- ServiceOff()
						-- alreadyDead = true
					-- end
				-- else
					-- alreadyDead = false
				-- end

				DrawMarker(1,449.113,-981.084,42.691,0,0,0,0,0,0,2.0,2.0,2.0,0,155,255,200,0,0,0,0)

				if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 449.113,-981.084,43.691, true ) < 5 then
					if(IsPedInAnyVehicle( PlayerPedId(), false )) then
						DisplayHelpText('Appuyer sur ~INPUT_CONTEXT~ pour ranger votre helicopter',0,1,0.5,0.8,0.6,255,255,255,255)
					else
						DisplayHelpText('Appuyer sur ~INPUT_CONTEXT~ pour prendre vote helicopter',0,1,0.5,0.8,0.6,255,255,255,255)
					end

					if IsControlJustPressed(1,51)  then
						if(IsPedInAnyVehicle( PlayerPedId(), false )) then
							SetEntityAsMissionEntity(existingVeh, true, true)
              TriggerServerEvent('ivt:deleteVeh', GetVehicleNumberPlateText(existingVeh))
							Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(existingVeh))
							existingVeh = nil
						else
							local car = GetHashKey("polmav")
							local ply = PlayerPedId()
							local plyCoords = GetEntityCoords(ply, 0)

							RequestModel(car)
							while not HasModelLoaded(car) do
									Citizen.Wait(0)
							end

							existingVeh = CreateVehicle(car, plyCoords["x"], plyCoords["y"], plyCoords["z"], 180.0, true, false)
							SetVehicleLivery(existingVeh, 0)
							local id = NetworkGetNetworkIdFromEntity(existingVeh)
							SetNetworkIdCanMigrate(id, true)
							TaskWarpPedIntoVehicle(ply, existingVeh, -1)
              plate = GetVehicleNumberPlateText(existingVeh)
              TriggerEvent('lock:addVeh', plate, GetDisplayNameFromVehicleModel(GetEntityModel(existingVeh)))

						end
					end
				end
			end
		end
    end
end)

RegisterNetEvent('police:changeControlspawnwp')
AddEventHandler('police:changeControlspawnwp', function(a)
	controlWeapon = a
end)

Citizen.CreateThread(function()
	for i = 1, 12 do
		Citizen.InvokeNative(0xDC0F817884CDD856, i, false)
	end
end)

function swat()
	uniforclassic = false
  SetPedArmour(ped, 100)
	local props = {}
	local components ={}
	if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then
	   props = {
      { 0, 75, 0 }, -- casque
      { 1, -1, 0 }, -- lunette
      { 2, -1, 0 }, -- ecouteur
      { 3, 3, 0 } -- montre
    }
    components = {
      { 1, 52, 0 }, -- masque
      { 3, 96, 0 }, -- gant/bras
      { 4, 31, 0 }, -- pantalon
      { 5, 0 , 0 }, -- parachute
      { 6, 25, 0 }, --chaussure
			{ 7, 110, 0 }, --acssessoir
      { 8, 15, 0 }, -- ceinture/t-shirt
      { 9, 15, 0 }, -- armur
      { 10, 3, 0 }, -- emblème
      { 11, 49, 0 } -- chemise/pull/veste
    }
	else -- femme
		props = {
      { 0, 74, 0 }, -- casque
      { 1, -1, 0 }, -- lunette
      { 2, 0, 0 }, -- ecouteur
      { 3, 3, 0 } -- montre
    }
    components = {
      { 1, 57, 0 }, -- masque
      { 3, 111, 0 }, -- gant/bras
      { 4, 30, 0 }, -- pantalon
      { 5, 0, 0 }, -- parachute
      { 6, 25, 0 }, --chaussure
			{ 7, 81, 0 }, --acssessoir
      { 8, 15, 0 }, -- ceinture/t-shirt
      { 9, 17, 0 }, -- armur
      { 10, 11, 0 }, -- emblème
      { 11, 42, 0 } -- chemise/pull/veste
    }
	end

  SetComponent(components)
  SetProps(props)

end

function civil()

	local props = {
    { 0, -1, 0 }, -- casque
    { 1, -1, 0 }, -- lunette
    { 2, -1, 0 }, -- ecouteur
    { 3, 3, 0 } -- montre
  }

  local components = {
    { 1, 0, 0 }, -- masque
  }

  platypus.LoadClothes()

  SetComponent(components)
  SetProps(props)

end

function capitaine()
	uniforclassic = false

	local props = {
	 { 0, -1, 0 }, -- casque
	 { 1, -1, 0 }, -- lunette
	 { 2, -1, 0 }, -- ecouteur
	 { 3, 3, 0 } -- montre
 }

 local components = {
	 { 1, 0, 0 }, -- masque
	 { 3, 12, 0 }, -- gant/bras
	 { 4, 10, 0 }, -- pantalon
	 { 5, 0, 0 }, -- parachute
	 { 6, 10, 0 }, --chaussure
	 { 7, 10, 1 }, --acssessoir
	 { 8, 10, 0 }, -- ceinture/t-shirt
   { 9, 13, 0 }, -- armur
	 { 10, 0, 0 }, -- emblème
	 { 11, 4, 0 } -- chemise/pull/veste
 }

 SetComponent(components)
 SetProps(props)
end

function villesuit()
	uniforclassic = false

	local props = {}
	local components ={}
	if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then
	   props = {
      { 0, -1, 0 }, -- casque
      { 1, -1, 0 }, -- lunette
      { 2, 0, 0 }, -- ecouteur
      { 3, 3, 0 } -- montre
    }
    components = {
      { 1, 0, 0 }, -- masque
      { 3, 12, 0 }, -- gant/bras
      { 4, 10, 0 }, -- pantalon
      { 5, 0, 0 }, -- parachute
      { 6, 10, 0 }, --chaussure
      { 7, 0, 0 }, --acssessoir
      { 8, 10, 0 }, -- ceinture/t-shirt
      { 9, 13, 0 }, -- armur
      { 10, 0, 0 }, -- emblème
      { 11, 4, 0 } -- chemise/pull/veste
    }
	else -- femme
		props = {
      { 0, -1, 0 }, -- casque
      { 1, -1, 0 }, -- lunette
      { 2, 0, 0 }, -- ecouteur
      { 3, 3, 0 } -- montre
    }
    components = {
      { 1, 0, 0 }, -- masque
      { 3, 7, 0 }, -- gant/bras
      { 4, 6, 0 }, -- pantalon
      { 5, 0, 0 }, -- parachute
      { 6, 29, 0 }, --chaussure
			{ 7, 22, 10 }, --acssessoir
      { 8, 38, 0 }, -- ceinture/t-shirt
      { 9, 16, 0 }, -- armur
      { 10, 3, 0 }, -- emblème
      { 11, 24, 0 } -- chemise/pull/veste
    }
	end

  SetComponent(components)
  SetProps(props)
end

function cadetunif()
	uniforclassic = true
	local props = {}
	local components ={}
	if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then
	   props = {
      { 0, -1, 0 }, -- casque
      { 1, -1, 0 }, -- lunette
      { 2, 0, 0 }, -- ecouteur
      { 3, 3, 0 } -- montre
    }
    components = {
      { 1, 11, 2 }, -- masque
      { 3, 0, 0 }, -- gant/bras
      { 4, 35, 0 }, -- pantalon
      { 5, 0, 0 }, -- parachute
      { 6, 51, 0 }, --chaussure
			{ 7, 0, 0 }, --acssessoir
      { 8, 15, 0 }, -- ceinture/t-shirt
      { 9, 13, 0 }, -- armur
      { 10, 0, 0 }, -- emblème
      { 11, 18, 0 } -- chemise/pull/veste
    }
	else -- femme
		props = {
      { 0, -1, 0 }, -- casque
      { 1, -1, 0 }, -- lunette
      { 2, 0, 0 }, -- ecouteur
      { 3, 3, 0 } -- montre
    }
    components = {
      { 1, 11, 2 }, -- masque
      { 3, 14, 0 }, -- gant/bras
      { 4, 34, 0 }, -- pantalon
      { 5, 0, 0 }, -- parachute
      { 6, 52, 0 }, --chaussure
			{ 7, 0, 0 }, --acssessoir
      { 8, 2, 0 }, -- ceinture/t-shirt
      { 9, 14, 0 }, -- armur
      { 10, 0, 0 }, -- emblème
      { 11, 36, 0 } -- chemise/pull/veste
    }

	end

  SetComponent(components)
  SetProps(props)
end

function SetProps(props)
  for _, comp in ipairs(props) do
      if comp[2] == -1 then
          ClearPedProp(ped, comp[1])
      else
          SetPedPropIndex(ped, comp[1], comp[2] , comp[3] , true)
      end
  end
end

function SetComponent(components)
  for _, comp in ipairs(components) do
		SetPedComponentVariation(ped, comp[1], comp[2], comp[3], 0)
 end
end

function lunettes()
  if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then -- homme
    if lunette then
      SetPedPropIndex(ped, 1, 5, 5, true)
      lunette = false
    else
      SetPedPropIndex(ped, 1, 0, 0, true)
      lunette = true
    end
  else -- Femme
    if lunette then
      SetPedPropIndex(ped, 1, 11, 0, true)
      lunette = false
    else
      ClearPedProp(ped, 1)
      lunette = true
    end
  end
end

function kepis()
  if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then -- homme
    if kepi then
      SetPedPropIndex(ped, 0, 46, 0, true)
      kepi = false
    else
      ClearPedProp(ped, 0)
      kepi = true
    end
  else -- Femme
    if kepi then
      SetPedPropIndex(ped, 0, 45, 0, true)
      kepi = false
    else
      ClearPedProp(ped, 0)
      kepi = true
    end
  end
end

function uniformbasic()
  if mancheLong then
    SetPedComponentVariation(ped, 11, 18, 0, 0)
		SetPedComponentVariation(ped, 3, 0, 0, 0)
    mancheLong = false
  else
    SetPedComponentVariation(ped, 11, 52, 3, 0)
		SetPedComponentVariation(ped, 3, 1, 0, 0)
    mancheLong = true
  end
end

function ceintures()
  if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then -- homme
    if ceinture then
      SetPedComponentVariation(ped, 8, 15, 0, 0)
      ceinture = false
    else
      SetPedComponentVariation(ped, 8, 39, 0, 0)
      ceinture = true
    end
  else -- Femme
    if ceinture then
      SetPedComponentVariation(ped, 8, 6, 0, 0)
      ceinture = false
    else
      SetPedComponentVariation(ped, 8, 35, 0, 0)
      ceinture = true
    end
  end
end

function gillets()
  if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then -- homme
    if gillet then
      SetPedComponentVariation(ped, 9, 13, 0, 0)
      SetPedArmour(ped, 0)
      gillet = false
    else
      SetPedComponentVariation(ped, 9, 12, 3, 0)
      SetPedArmour(ped, 100)
      gillet = true
    end
  else -- Femme
		if gillet then
      SetPedComponentVariation(ped, 9, 14, 0, 0)
      SetPedArmour(ped, 0)
      gillet = false
    else
      SetPedComponentVariation(ped, 9, 17, 0, 0)
      SetPedArmour(ped, 100)
      gillet = true
    end
  end
end

function gilletfluos()
  if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then
    if gilletfluo then
      SetPedComponentVariation(ped, 9, 13, 0, 0)
      gilletfluo = false
    else
      SetPedComponentVariation(ped, 9, 18, 0, 0)
      gilletfluo = true
    end
  else
		if gilletfluo then
      SetPedComponentVariation(ped, 9, 14, 0, 0)
      gilletfluo = false
    else
      SetPedComponentVariation(ped, 9, 19, 0, 0)
      gilletfluo = true
    end
  end
end

function DrawText3d(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    if onScreen then
        SetTextScale(0.3, 0.3)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

-- Herses
Citizen.CreateThread(function()
  while true do
      Citizen.Wait(0)
      local ped = PlayerPedId()
      local veh = GetVehiclePedIsIn(ped, false)
      local vehCoord = GetEntityCoords(veh)
      local hashHerse = GetHashKey("P_ld_stinger_s")
      if IsPedInAnyVehicle(ped, false) then
          local herse = GetClosestObjectOfType( vehCoord.x, vehCoord.y, vehCoord.z, 1.3, hashHerse, false, false, false)
          if herse ~= 0 then
              POLICE_removeOrPlaceHerse()
              SetVehicleTyreBurst(veh, 0, true, 1000.0)
              SetVehicleTyreBurst(veh, 1, true, 1000.0)
              Citizen.Wait(200)
              SetVehicleTyreBurst(veh, 2, true, 1000.0)
              SetVehicleTyreBurst(veh, 3, true, 1000.0)
              Citizen.Wait(200)
              SetVehicleTyreBurst(veh, 4, true, 1000.0)
              SetVehicleTyreBurst(veh, 5, true, 1000.0)
              SetVehicleTyreBurst(veh, 6, true, 1000.0)
              SetVehicleTyreBurst(veh, 7, true, 1000.0)
          end
      end
  end
end)
