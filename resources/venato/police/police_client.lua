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
local rank = "inconnu"
local checkpoints = {}
local existingVeh = nil
local handCuffed = false
local isAlreadyDead = false
local allServiceCops = {}
local blipsCops = {}
Citizen.Trace('poloci')

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

AddEventHandler("playerSpawned", function()
	TriggerServerEvent("police:checkIsCop")
	GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("GADGET_PARACHUTE"), 150, true, true)
end)

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

	local playerPed = GetPlayerPed(-1)

	TriggerServerEvent("skin_customization:SpawnPlayer")
	SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 1, 2)
	SetPedComponentVariation(GetPlayerPed(-1), 10, 0, 0, 2)
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

RegisterNetEvent('police:getArrested')
AddEventHandler('police:getArrested', function()
		handCuffed = not handCuffed
		if(handCuffed) then
			TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "vous êtes menoté")
		else
			TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "LIBRE !")
		end
end)

function restart_server()
	SetTimeout(1000, function()
		TriggerEvent('police:HRP')
		restart_server()
	end)
end
restart_server()

RegisterNetEvent('police:HRP')
AddEventHandler('police:HRP', function()
	if(handCuffedHRP) then
		TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "vous êtes menoté")
	end
end)


RegisterNetEvent('police:getArrestedHRP')
AddEventHandler('police:getArrestedHRP', function()
		handCuffedHRP = not handCuffedHRP
		if(handCuffedHRP) then
		TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "vous êtes menoté")
		else
			TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "LIBRE !")
		end
end)



-- RegisterNetEvent('police:payFines')
-- AddEventHandler('police:payFines', function(amount, reason)
	-- --TriggerServerEvent('bank:withdrawAmende', amount)
	-- TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "You paid a $"..amount.." fine for" .. reason )
-- end)

RegisterNetEvent('police:dropIllegalItem')
AddEventHandler('police:dropIllegalItem', function(id,qty)
	TriggerEvent("player:looseItem", tonumber(id),tonumber(qty))
	TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "La Police vous a fouillé")
end)

RegisterNetEvent('police:unseatme')
AddEventHandler('police:unseatme', function(t)
	local ped = GetPlayerPed(t)
	ClearPedTasksImmediately(ped)
	plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
	local xnew = plyPos.x+2
	local ynew = plyPos.y+2

	SetEntityCoords(GetPlayerPed(-1), xnew, ynew, plyPos.z)
end)

RegisterNetEvent('police:forcedEnteringVeh')
AddEventHandler('police:forcedEnteringVeh', function(veh)
	if(handCuffed) then
		local pos = GetEntityCoords(GetPlayerPed(-1))
		local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)

		local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
		local a, b, c, d, vehicleHandle = GetRaycastResult(rayHandle)

		if vehicleHandle ~= nil then
			SetPedIntoVehicle(GetPlayerPed(-1), vehicleHandle, 1)
		end
	end
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
  local mePed = GetPlayerPed(-1)
  local pos = GetOffsetFromEntityInWorldCoords(mePed, 0.0, 0.2, 0.0)
  local cone = GetClosestObjectOfType( pos.x, pos.y, pos.z, 1.0, GetHashKey("prop_roadcone02a"), false, false, false)
  if cone ~= 0 then
    -- ... /!\
    NetworkRequestControlOfEntity(cone)
    Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(cone))
    Citizen.InvokeNative(0x539E0AE3E6634B9F, Citizen.PointerValueIntInitialized(cone))
    DeleteObject(cone)
    SetEntityCoords(cone, -2000.0, -2000.0, -2000.0)
  else
    local h = GetEntityHeading(mePed)
    local object = CreateObject("prop_roadcone02a", pos.x, pos.y, pos.z, GetEntityHeading(mePed), true, false)
	local id = NetworkGetNetworkIdFromEntity(object)
	SetNetworkIdCanMigrate(id, true)
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
  local mePed = GetPlayerPed(-1)
  local pos = GetOffsetFromEntityInWorldCoords(mePed, 0.0, 0.2, 0.0)
  local barriere = GetClosestObjectOfType( pos.x, pos.y, pos.z, 1.0, GetHashKey("prop_barrier_work05"), false, false, false)
  if barriere ~= 0 then
    -- ... /!\
    NetworkRequestControlOfEntity(barriere)
    Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(barriere))
    Citizen.InvokeNative(0x539E0AE3E6634B9F, Citizen.PointerValueIntInitialized(barriere))
    DeleteObject(barriere)
    SetEntityCoords(barriere, -2000.0, -2000.0, -2000.0)
  else
    local h = GetEntityHeading(mePed)
    local object = CreateObject("prop_barrier_work05", pos.x, pos.y, pos.z, GetEntityHeading(mePed), true, false)
	local id = NetworkGetNetworkIdFromEntity(object)
	SetNetworkIdCanMigrate(id, true)
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
  local mePed = GetPlayerPed(-1)
  local pos = GetOffsetFromEntityInWorldCoords(mePed, 0.0, 0.2, 0.0)
  local herse = GetClosestObjectOfType( pos.x, pos.y, pos.z, 1.0, GetHashKey("p_ld_stinger_s"), false, false, false)
  if herse ~= 0 then
    -- ... /!\
    NetworkRequestControlOfEntity(herse)
    Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(herse))
    Citizen.InvokeNative(0x539E0AE3E6634B9F, Citizen.PointerValueIntInitialized(herse))
    DeleteObject(herse)
    SetEntityCoords(herse, -2000.0, -2000.0, -2000.0)
  else
    local h = GetEntityHeading(mePed)
	local object = CreateObject("p_ld_stinger_s", pos.x, pos.y, pos.z, GetEntityHeading(mePed)   -90.0 , true, false)
	local id = NetworkGetNetworkIdFromEntity(object)
	SetNetworkIdCanMigrate(id, true)
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
		if(NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= GetPlayerPed(-1)) then
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
		local ply = GetPlayerPed(-1)
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
		local ply = GetPlayerPed(-1)
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

function isNearsheriffservice()
		local ply = GetPlayerPed(-1)
		local plyCoords = GetEntityCoords(ply, 0)
		local distance = GetDistanceBetweenCoords(1857.2152099609, 3688.8889160156, 34.267040252686, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
		if(distance < 30) then
			DrawMarker(1, 1857.2152099609, 3688.8889160156, 34.267040252686-1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 155, 255, 200, 0, 0, 2, 0, 0, 0, 0)
		end
		if(distance < 2) then
			return true
		end
end

function isNearsheriffgarage()
if (isCopInService) then
		local ply = GetPlayerPed(-1)
		local plyCoords = GetEntityCoords(ply, 0)
		local distance = GetDistanceBetweenCoords(1867.1923, 3691.2719, 33.7599, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
		if(distance < 30) then
			DrawMarker(1, 1867.1923, 3691.2719, 33.7599-1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 155, 255, 200, 0, 0, 2, 0, 0, 0, 0)
		end
		if(distance < 2) then
			return true
		end
  end
end

function isNearStationGarage()
	for i = 1, #stationGarage do
		local ply = GetPlayerPed(-1)
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
	--TriggerServerEvent("jobssystem:jobs", 2)
	TriggerServerEvent("police:takeService")
end

function ServiceOff()
	isCopInService = false
  Menu.hidden = true
  TriggerServerEvent("police:setService",false)
	--TriggerServerEvent("jobssystem:jobs", 7)
	TriggerServerEvent("police:breakService")
	allServiceCops = {}

	for k, existingBlip in pairs(blipsCops) do
        RemoveBlip(existingBlip)
    end
	blipsCops = {}
end

doorList = {

    --[1] = { ["objName"] = "v_ilev_ph_gendoor004", ["x"]= 449.69815063477, ["y"]= -986.46911621094,["z"]= 30.689594268799,["locked"]= true},
    --[3] = { ["objName"] = "v_ilev_ph_gendoor002", ["x"]= 447.23818969727, ["y"]= -980.63006591797,["z"]= 30.689598083496,["locked"]= true},
    [1] = { ["objName"] = "v_ilev_ph_gendoor005", ["x"]= 443.97, ["y"]= -989.033,["z"]= 30.6896,["locked"]= true},
    [2] = { ["objName"] = "v_ilev_ph_gendoor005", ["x"]= 445.37, ["y"]= -988.705,["z"]= 30.6896,["locked"]= true},
    [3] = { ["objName"] = "v_ilev_ph_cellgate", ["x"]= 463.815, ["y"]= -992.686,["z"]= 24.9149,["locked"]= true},
    [4] = { ["objName"] = "v_ilev_ph_cellgate", ["x"]= 462.381, ["y"]= -993.651,["z"]= 24.9149,["locked"]= true},
    [5] = { ["objName"] = "v_ilev_ph_cellgate", ["x"]= 462.331, ["y"]= -998.152,["z"]= 24.9149,["locked"]= true},
    [6] = { ["objName"] = "v_ilev_ph_cellgate", ["x"]= 462.704, ["y"]= -1001.92,["z"]= 24.9149,["locked"]= true},
    [7] = { ["objName"] = "v_ilev_gtdoor", ["x"]= 464.1342, ["y"]= -1003.5145,["z"]= 24.9148,["locked"]= false},
    [8] = { ["objName"] = "v_ilev_gtdoor02", ["x"]= 464.3087, ["y"]= -983.9446,["z"]= 43.6918,["locked"]= true},
		[9] = { ["objName"] = "v_ilev_arm_secdoor", ["x"]= 452.61877441406, ["y"]= -982.7021484375,["z"]= 30.689598083496,["locked"]= true},
    --[10] = { ["objName"] = "v_ilev_rc_door2", ["x"]= 451.98, ["y"]= -987.266,["z"]= 30.69,["locked"]= true},
    [10] = { ["objName"] = "v_ilev_rc_door2", ["x"]= 468.1539, ["y"]= -1014.6710,["z"]= 26.3864,["locked"]= true},
		[11] = { ["objName"] = "v_ilev_rc_door2", ["x"]= 469.3743, ["y"]= -1014.5759,["z"]= 26.3864,["locked"]= true},

		--[16] = { ["objName"] = "v_ilev_ph_door01", ["x"]= 435.3226, ["y"]= -982.5680,["z"]= 30.6896,["locked"]= false},
		--[17] = { ["objName"] = "v_ilev_ph_door02", ["x"]= 435.4028, ["y"]= -980.8831,["z"]= 30.6896,["locked"]= false},

}


RegisterNetEvent('door:state')
AddEventHandler('door:state', function(id, isLocked)
    if type(doorList[id]) ~= nil then -- Check if door exists
        doorList[id]["locked"] = isLocked -- Change state of door
        local closeDoor = GetClosestObjectOfType(doorList[id]["x"], doorList[id]["y"], doorList[id]["z"], 1.0, GetHashKey(doorList[id]["objName"]), false, false, false)
        FreezeEntityPosition(closeDoor, doorList[id]["locked"])
    end

end)



Citizen.CreateThread(function()
    while true do
  Citizen.Wait(10)
 --if (isCop) then
        for i = 1, #doorList do
            local playerCoords = GetEntityCoords( GetPlayerPed(-1) )
            local closeDoor = GetClosestObjectOfType(doorList[i]["x"], doorList[i]["y"], doorList[i]["z"], 1.0, GetHashKey(doorList[i]["objName"]), false, false, false)

            local objectCoordsDraw = GetEntityCoords( closeDoor )
            local playerDistance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, doorList[i]["x"], doorList[i]["y"], doorList[i]["z"], true)

            if(playerDistance < 1) and (isCop) then

                if doorList[i]["locked"] == true then
                    DisplayHelpText("Appuyer sur ~INPUT_PICKUP~ pour ~b~ouvrir la porte",1, 1, 0.5, 0.8, 0.9, 255, 255, 255, 255)
                else
                     DisplayHelpText("Appuyer sur ~INPUT_PICKUP~ pour ~r~fermer la porte",1, 1, 0.5, 0.8, 0.9, 255, 255, 255, 255)
                end

                -- Press E key
                if IsControlJustPressed(1,51) then
                    if doorList[i]["locked"] == true then
                        TriggerServerEvent("door:update", i, false)
                    else
                        TriggerServerEvent("door:update", i, true)
                    end
                end
            else
                FreezeEntityPosition(closeDoor, doorList[i]["locked"])
            end
        end

  --    end
    end
end)


function menupolicecamere()
  ClearMenu()
  ServiceOn()
  TriggerServerEvent("police:setService",true)
  showPageInfo = true
    Menu.addButton("~r~Quitter son service", "ServiceOff", nil)
  if(rank == "Cadet") then
    MenuDescription = "~b~Cadet      "
    Menu.addButton("~g~Equiper tenue standard", "cadetunif", nil)
    if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) and uniforclassic then
        Menu.addButton("Manche longue/Manche courte", "uniformbasic", nil)
    end
    Menu.addButton("Equiper / Retirer un gillet fluo", "gillets", nil)
    Menu.addButton("Equiper / Retirer un gillet par balle", "gilletfluos", nil)

  elseif(rank == "Agent") then
    MenuDescription = "~b~Agent      "
    Menu.addButton("~g~Equiper tenue standard", "cadetunif", nil)
    Menu.addButton("~b~Equiper tenue de civil", "civil", nil)
    Menu.addButton("~b~Equiper tenue de moto", "motounif", nil)
    Menu.addButton("~b~Equiper tenue de SWAT", "swat", nil)
    if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) and uniforclassic then
      Menu.addButton("Manche longue/Manche courte", "uniformbasic", nil)
    end
    Menu.addButton("Equiper / Retirer un gillet fluo", "gillets", nil)
    Menu.addButton("Equiper / Retirer un gillet par balle", "gilletfluos", nil)
    Menu.addButton("Equiper / Retirer une ceinture", "ceintures", nil)
    Menu.addButton("Equiper / Retirer un képi", "kepis", nil)

  elseif(rank == "Sergent") then
    MenuDescription = "~b~Sergent      "
    Menu.addButton("~g~Equiper tenue standard", "cadetunif", nil)
    Menu.addButton("~b~Equiper tenue K-9", "k9unif", nil)
    Menu.addButton("~b~Equiper tenue de civil", "civil", nil)
    Menu.addButton("~b~Equiper tenue de moto", "motounif", nil)
    Menu.addButton("~r~Equiper tenue de SWAT", "swat", nil)
    if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) and uniforclassic then
        Menu.addButton("Manche longue/Manche courte", "uniformbasic", nil)
    end
    Menu.addButton("Equiper / Retirer un gillet fluo", "gillets", nil)
    Menu.addButton("Equiper / Retirer un gillet par balle", "gilletfluos", nil)
    Menu.addButton("Equiper / Retirer une ceinture", "ceintures", nil)
    Menu.addButton("Equiper / Retirer un képi", "kepis", nil)
    Menu.addButton("Equiper / Retirer des lunette", "lunettes", nil)


  elseif(rank == "Sergent-Chef") then
    MenuDescription = "~b~Sergent-Chef      "
    Menu.addButton("~g~Equiper tenue standard", "cadetunif", nil)
    Menu.addButton("~b~Equiper tenue K-9", "k9unif", nil)
    Menu.addButton("~b~Equiper tenue de civil", "civil", nil)
    Menu.addButton("~b~Equiper tenue de moto", "motounif", nil)
    Menu.addButton("~r~Equiper tenue de SWAT", "swat", nil)
    if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) and uniforclassic then
        Menu.addButton("Manche longue/Manche courte", "uniformbasic", nil)
    end
    Menu.addButton("Equiper / Retirer un gillet fluo", "gillets", nil)
    Menu.addButton("Equiper / Retirer un gillet par balle", "gilletfluos", nil)
    Menu.addButton("Equiper / Retirer une ceinture", "ceintures", nil)
    Menu.addButton("Equiper / Retirer un képi", "kepis", nil)
    Menu.addButton("Equiper / Retirer des lunette", "lunettes", nil)


  elseif(rank == "Lieutenant") then
    MenuDescription = "~b~Lieutenant      "
    Menu.addButton("~g~Equiper tenue standard", "cadetunif", nil)
    Menu.addButton("~b~Equiper tenue K-9", "k9unif", nil)
    Menu.addButton("~b~Equiper tenue de ville", "villesuit", nil)
    Menu.addButton("~b~Equiper tenue de civil", "civil", nil)
    Menu.addButton("~b~Equiper tenue de moto", "motounif", nil)
    Menu.addButton("~r~Equiper tenue de SWAT", "swat", nil)
    if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) and uniforclassic then
        Menu.addButton("Manche longue/Manche courte", "uniformbasic", nil)
    end
    Menu.addButton("Equiper / Retirer un gillet fluo", "gillets", nil)
    Menu.addButton("Equiper / Retirer un gillet par balle", "gilletfluos", nil)
    Menu.addButton("Equiper / Retirer une ceinture", "ceintures", nil)
    Menu.addButton("Equiper / Retirer un képi", "kepis", nil)
    Menu.addButton("Equiper / Retirer des lunette", "lunettes", nil)


  elseif(rank == "Capitaine") then
    MenuDescription = "~b~Capitaine      "
    Menu.addButton("~g~Equiper tenue de capitaine", "capitaine", nil)
    Menu.addButton("~b~Equiper tenue standard", "cadetunif", nil)
    Menu.addButton("~b~Equiper tenue K-9", "k9unif", nil)
    Menu.addButton("~b~Equiper tenue de ville", "villesuit", nil)
    Menu.addButton("~b~Equiper tenue de civil", "civil", nil)
    Menu.addButton("~b~Equiper tenue de moto", "motounif", nil)
    Menu.addButton("~r~Equiper tenue de SWAT", "swat", nil)
    if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) and uniforclassic then
        Menu.addButton("Manche longue/Manche courte", "uniformbasic", nil)
    end
    Menu.addButton("Equiper / Retirer un gillet fluo", "gillets", nil)
    Menu.addButton("Equiper / Retirer un gillet par balle", "gilletfluos", nil)
    Menu.addButton("Equiper / Retirer une ceinture", "ceintures", nil)
    Menu.addButton("Equiper / Retirer un képi", "kepis", nil)
    Menu.addButton("Equiper / Retirer des lunette", "lunettes", nil)
  else
    MenuChoixPoliceServiceCadet()
  end
end

function standardEquip()
TriggerServerEvent("weaponshop:giveWeapond", "WEAPON_STUNGUN","nope")
TriggerServerEvent("weaponshop:giveWeapond", "WEAPON_NIGHTSTICK","nope")
TriggerServerEvent("weaponshop:giveWeapond", "WEAPON_FLASHLIGHT","nope")
TriggerServerEvent("weaponshop:giveWeapond", "WEAPON_FLARE",10)
TriggerServerEvent("weaponshop:giveWeapond", "WEAPON_SMOKEGRENADE",10)
TriggerServerEvent("weaponshop:giveWeapond", "GADGET_PARACHUTE",150)
TriggerServerEvent("project:armeActu")
end

function calibre50()
  TriggerServerEvent("weaponshop:giveWeapond", "WEAPON_PISTOL50",30)
  TriggerServerEvent("project:armeActu")
end

function shotgun()
  TriggerServerEvent("weaponshop:giveWeapond", "WEAPON_PUMPSHOTGUN",30)
  TriggerServerEvent("project:armeActu")
end
function assault()
  TriggerServerEvent("weaponshop:giveWeapond","WEAPON_BULLPUPRIFLE",60)
  TriggerServerEvent("project:armeActu")
end
function sniper()
  TriggerServerEvent("weaponshop:giveWeapond", "WEAPON_MarksmanRifle",30)
  TriggerServerEvent("project:armeActu")
end
function fumi()
  TriggerServerEvent("weaponshop:giveWeapond", "WEAPON_GrenadeLauncherSmoke",10)
  TriggerServerEvent("project:armeActu")
end
function ammo()
    TriggerServerEvent("item:weapond")
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
SetPedAmmo(GetPlayerPed(-1),a[1],math.ceil(a[2]+a[3]))
TriggerServerEvent("project:armeActu")
Menu.hidden = true
end

function sheriffunif()
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
      { 3, 4, 0 }, -- gant/bras
      { 4, 25, 0 }, -- pantalon
      { 5, 48, 0 }, -- parachute
      { 6, 51, 0 }, --chaussure
			{ 7, 8, 0 }, --acssessoir
      { 8, 15, 0 }, -- ceinture/t-shirt
      { 9, 13, 0 }, -- armur
      { 10, 0, 0 }, -- emblème
      { 11, 24, 0 } -- chemise/pull/veste
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
      { 4, 41, 1 }, -- pantalon
      { 5, 48, 0 }, -- parachute
      { 6, 52, 0 }, --chaussure
			{ 7, 8, 0 }, --acssessoir
      { 8, 6, 0 }, -- ceinture/t-shirt
      { 9, 14, 0 }, -- armur
      { 10, 0, 0 }, -- emblème
      { 11, 110, 0 } -- chemise/pull/veste
    }

	end

	for _, comp in ipairs(components) do
		 SetPedComponentVariation(ped, comp[1], comp[2], comp[3], 0)
	end

	for _, comp in ipairs(props) do
			if comp[2] == -1 then
					ClearPedProp(ped, comp[1])
			else
					SetPedPropIndex(ped, comp[1], comp[2] , comp[3] , true)
			end
	end
end

function kepisSheriff()
  if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then -- homme
    if kepi then
      SetPedPropIndex(ped, 0, 13, 1, true)
      kepi = false
    else
      ClearPedProp(ped, 0)
      kepi = true
    end
  else -- Femme
    if kepi then
      SetPedPropIndex(ped, 0, 13, 1, true)
      kepi = false
    else
      ClearPedProp(ped, 0)
      kepi = true
    end
  end
end

function gilletfluosSheriff()
  if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then -- homme
    if gilletfluo then
      SetPedComponentVariation(ped, 9, 13, 0, 0)
      SetPedArmour(ped, 0)
      gilletfluo = false
    else
      SetPedComponentVariation(ped, 9, 12, 1, 0)
      SetPedArmour(ped, 100)
      gilletfluo = true
    end
  else -- Femme
		if gillet then
      SetPedComponentVariation(ped, 9, 14, 0, 0)
      SetPedArmour(ped, 0)
      gillet = false
    else
      SetPedComponentVariation(ped, 9, 29, 1, 0)
      SetPedArmour(ped, 100)
      gillet = true
    end
  end
end

function gilletsSheriff()
  if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then
    if gillet then
      SetPedComponentVariation(ped, 9, 13, 0, 0)
      gillet = false
    else
      SetPedComponentVariation(ped, 9, 18, 3, 0)
      gillet = true
    end
  else
		if gilletfluo then
      SetPedComponentVariation(ped, 9, 14, 0, 0)
      gilletfluo = false
    else
      SetPedComponentVariation(ped, 9, 19, 3, 0)
      gilletfluo = true
    end
  end
end
function spawnveh(namevehicul)
	  local vehicule = namevehicul
		local myPed = GetPlayerPed(-1)
		local player = PlayerId()
		local vehicle = GetHashKey(vehicule)
    if vehicle ~= nil then
		RequestModel(vehicle)
		while not HasModelLoaded(vehicle) do
			Wait(1)
		end
		local plate = math.random(100, 900)
    local LastPosX, LastPosY, LastPosZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    local LastPosH = GetEntityHeading(GetPlayerPed(-1))
		existingVeh = CreateVehicle(vehicle,1874.3009033203, 3690.2387695313, 33.523826599121,182.77638244629, true, false)
		SetModelAsNoLongerNeeded(vehicle)
		SetEntityVisible(existingVeh, false, 0)
	--	DetachVehicleWindscreen(existingVeh)
		Citizen.Wait(250)
		AttachEntityToEntity(existingVeh, GetVehiclePedIsIn(GetPlayerPed(-1), false), -1, AttachX, AttachY, AttachZ, 0.0, 0.0, 0.0, true, true, true, true, 1, true)
		SetVehicleExplodesOnHighExplosionDamage(existingVeh, false)
		SetEntityVisible(existingVeh, true, 0)
		SetPedIntoVehicle(GetPlayerPed(-1), existingVeh, -1)
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
  Menu.hidden = false
  ClearMenu()
  MenuTitle = "Armurerie"
  TriggerEvent('player:receiveItem',210,1)
  TriggerEvent('player:receiveItem',211,1)
  Menu.addButton("~b~Equipement standard", "standardEquip", nil)
    MenuDescription = "~b~Cadet      "
  if(rank == "Agent") then
      MenuDescription = "~b~Agent      "
    Menu.addButton("~g~Pistolet calibre 50", "calibre50", nil)
    Menu.addButton("~r~Fusil d'assaut", "assault", nil)
  elseif (rank == "Sergent") then
      MenuDescription = "~b~Sergent      "
    Menu.addButton("~g~Pistolet calibre 50", "calibre50", nil)
    Menu.addButton("~g~ShotGun", "shotgun", nil)
    Menu.addButton("~r~Fusil d'assaut", "assault", nil)
  elseif (rank == "Sergent-Chef") then
      MenuDescription = "~b~Sergent-Chef      "
    Menu.addButton("~g~Pistolet calibre 50", "calibre50", nil)
    Menu.addButton("~g~ShotGun", "shotgun", nil)
    Menu.addButton("~g~Fusil d'assaut", "assault", nil)
  elseif (rank == "Lieutenant") then
      MenuDescription = "~b~Lieutenant      "
    Menu.addButton("~g~pistolet calibre 50", "calibre50", nil)
    Menu.addButton("~g~ShotGun", "shotgun", nil)
    Menu.addButton("~g~Fusil d'assaut", "assault", nil)
    Menu.addButton("~g~Fusil de précision", "sniper", nil)
  elseif (rank == "Capitaine") then
      MenuDescription = "~b~Capitaine      "
    Menu.addButton("~g~pistolet calibre 50", "calibre50", nil)
    Menu.addButton("~g~ShotGun", "shotgun", nil)
    Menu.addButton("~g~Fusil d'assaut", "assault", nil)
    Menu.addButton("~g~Fusil de précision", "sniper", nil)
--    Menu.addButton("~g~Lance fumigène", "fumi", nil)
  end
  Menu.addButton("~r~Ajouter des balles", "ammo", nil)
end
nopee = true
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if(isCop) then
            Menu.renderGUI()
          if IsControlJustPressed(1, 170) then
      			Menu.hidden = true
      		end
      		if IsControlJustPressed(1, 177) then
      			Menu.hidden = true
      		end
      		if IsControlJustPressed(1, 311) then
      			Menu.hidden = true
      		end
      		if IsControlJustPressed(1, 166) then
      			Menu.hidden = true
      		end
          if(isNearArmurie()) then

    				DisplayHelpText("Appuyer sur ~INPUT_CONTEXT~ pour ouvrir l'armurerie",0,1,0.5,0.8,0.6,255,255,255,255) -- ~g~E~s~
    				if IsControlJustPressed(1,51) then
              Menu.hidden = false
              ClearMenu()
              MenuTitle = "Armurerie"
              TriggerEvent('player:receiveItem',210,1)
          		TriggerEvent('player:receiveItem',211,1)
              Menu.addButton("~b~Equipement standard", "standardEquip", nil)
                MenuDescription = "~b~Cadet      "
              if(rank == "Agent") then
                  MenuDescription = "~b~Agent      "
                Menu.addButton("~g~Pistolet calibre 50", "calibre50", nil)
              elseif (rank == "Sergent") then
                  MenuDescription = "~b~Sergent      "
                Menu.addButton("~g~Pistolet calibre 50", "calibre50", nil)
                Menu.addButton("~g~ShotGun", "shotgun", nil)
              elseif (rank == "Sergent-Chef") then
                  MenuDescription = "~b~Sergent-Chef      "
                Menu.addButton("~g~Pistolet calibre 50", "calibre50", nil)
                Menu.addButton("~g~ShotGun", "shotgun", nil)
                Menu.addButton("~g~Fusil d'assaut", "assault", nil)
              elseif (rank == "Lieutenant") then
                  MenuDescription = "~b~Lieutenant      "
                Menu.addButton("~g~pistolet calibre 50", "calibre50", nil)
                Menu.addButton("~g~ShotGun", "shotgun", nil)
                Menu.addButton("~g~Fusil d'assaut", "assault", nil)
                Menu.addButton("~g~Fusil de précision", "sniper", nil)
              elseif (rank == "Capitaine") then
                  MenuDescription = "~b~Capitaine      "
                Menu.addButton("~g~pistolet calibre 50", "calibre50", nil)
                Menu.addButton("~g~ShotGun", "shotgun", nil)
                Menu.addButton("~g~Fusil d'assaut", "assault", nil)
                Menu.addButton("~g~Fusil de précision", "sniper", nil)
            --    Menu.addButton("~g~Lance fumigène", "fumi", nil)
              end
              Menu.addButton("~r~Ajouter des balles", "ammo", nil)
    				end
    			end

          if(isNearsheriffservice() and nopee) then

    				DisplayHelpText('Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le vestiaire',0,1,0.5,0.8,0.6,255,255,255,255) -- ~g~E~s~
    				if IsControlJustPressed(1,51) then
              Menu.hidden = false
              ped = GetPlayerPed(-1)
              ClearMenu()
              MenuTitle = "Vestiaire"
              ServiceOn()
              MenuDescription = "~b~Sherrif      "
              Menu.addButton("~b~Equiper tenue standard", "sheriffunif", nil)
              Menu.addButton("~b~Equiper tenue de civil", "civil", nil)
              Menu.addButton("~r~Armurerie", "armur", nil)
              Menu.addButton("Equiper / Retirer un gillet fluo", "gilletsSheriff", nil)
              Menu.addButton("Equiper / Retirer un gillet par balle", "gilletfluosSheriff", nil)
              Menu.addButton("Equiper / Retirer une ceinture", "ceintures", nil)
              Menu.addButton("Equiper / Retirer un Chapeau", "kepisSheriff", nil)
              Menu.addButton("Equiper / Retirer des lunette", "lunettes", nil)
    				end
    			end


			if(isNearsheriffgarage() and nopee) then

				DisplayHelpText('Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le garage',0,1,0.5,0.8,0.6,255,255,255,255) -- ~g~E~s~
				if IsControlJustPressed(1,51) then
          Menu.hidden = false
          ClearMenu()
          ped = GetPlayerPed(-1)
          MenuTitle = "Vestiaire"
          MenuDescription = "~b~Sherrif      "
          Menu.addButton("~b~Sheriff Cruiser", "spawnveh", "sheriff")
          Menu.addButton("~b~Sheriff SUV", "spawnveh", "sheriff2")
				end
			end

      if(isNearTakeService()) then

				DisplayHelpText('Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le vestiaire',0,1,0.5,0.8,0.6,255,255,255,255) -- ~g~E~s~
				if IsControlJustPressed(1,51) then
          Menu.hidden = false
          ped = GetPlayerPed(-1)
          MenuTitle = "Vestiaire"
          menupolicecamere()
				end
			end
			if(isCopInService) then
				if IsControlJustPressed(1,166) then
					openMenuPoliceGeneral()
				end
			end

			if(isCopInService) then
				if(isNearStationGarage()) then
					if(policevehicle ~= nil) then --existingVeh
						DisplayHelpText('Appuyer sur ~INPUT_CONTEXT~ pour ranger votre vehicule',0,1,0.5,0.8,0.6,255,255,255,255)
					else
						DisplayHelpText('Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le garage de police',0,1,0.5,0.8,0.6,255,255,255,255)
					end

					if IsControlJustPressed(1,51) then
						if(policevehicle ~= nil) then
							SetEntityAsMissionEntity(policevehicle, true, true)
              TriggerServerEvent('ivt:deleteVeh', GetVehicleNumberPlateText(policevehicle))
							Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(policevehicle))
							policevehicle = nil
						else
							--OpenVeh()
							--MenuChoixPoliceVehicleCar()
							if(rank == "Cadet") then
								MenuChoixPoliceVehicleCarCadet()
							elseif(rank == "Agent") then
								MenuChoixPoliceVehicleCarAgent()
							elseif(rank == "Sergent") then
								MenuChoixPoliceVehicleCarSergent()
							elseif(rank == "Sergent-Chef") then
								MenuChoixPoliceVehicleCarSergentChef()
							elseif(rank == "Lieutenant") then
								MenuChoixPoliceVehicleCarLieutenant()
							elseif(rank == "Capitaine") then
								MenuChoixPoliceVehicleCarCapitaine()
							else
								MenuChoixPoliceVehicleCarCadet()
							end
							local ply = GetPlayerPed(-1)
							local plyCoords = GetEntityCoords(ply, 0)
							local distance = GetDistanceBetweenCoords(stationGarage[2].x, stationGarage[2].y, stationGarage[2].z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
							if(distance < 30) then
								DrawMarker(1, stationGarage[2].x, stationGarage[2].y, stationGarage[2].z-1, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 0, 155, 255, 200, 0, 0, 2, 0, 0, 0, 0)
							end
							if(distance < 2) then
                if(rank == "Cadet") then
  								MenuChoixPoliceVehicleCarCadet()
  							elseif(rank == "Agent") then
  								MenuChoixPoliceVehicleCarAgent()
  							elseif(rank == "Sergent") then
  								MenuChoixPoliceVehicleCarSergent()
  							elseif(rank == "Sergent-Chef") then
  								MenuChoixPoliceVehicleCarSergentChef()
  							elseif(rank == "Lieutenant") then
  								MenuChoixPoliceVehicleCarLieutenant()
  							elseif(rank == "Capitaine") then
  								MenuChoixPoliceVehicleCarCapitaine()
  							else
  								MenuChoixPoliceVehicleCarCadet()
  							end
              end

						end
					end
				end


			end
		else
			if (handCuffed == true) then
			  RequestAnimDict('mp_arresting')

			  while not HasAnimDictLoaded('mp_arresting') do
				Citizen.Wait(0)
			  end

			  local myPed = PlayerPedId()
			  local animation = 'idle'
			  local flags = 16

			  TaskPlayAnim(myPed, 'mp_arresting', animation, 8.0, -8, -1, flags, 0, 0, 0, 0)
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

				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 449.113,-981.084,43.691, true ) < 5 then
					if(existingVeh ~= nil) then
						DisplayHelpText('Appuyer sur ~INPUT_CONTEXT~ pour ranger votre helicopter',0,1,0.5,0.8,0.6,255,255,255,255)
					else
						DisplayHelpText('Appuyer sur ~INPUT_CONTEXT~ pour prendre vote helicopter',0,1,0.5,0.8,0.6,255,255,255,255)
					end

					if IsControlJustPressed(1,51)  then
						if(existingVeh ~= nil) then
							SetEntityAsMissionEntity(existingVeh, true, true)
              TriggerServerEvent('ivt:deleteVeh', GetVehicleNumberPlateText(existingVeh))
							Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(existingVeh))
							existingVeh = nil
						else
							local car = GetHashKey("polmav")
							local ply = GetPlayerPed(-1)
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
      { 5, 48, 0 }, -- parachute
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

	for _, comp in ipairs(components) do
		 SetPedComponentVariation(ped, comp[1], comp[2], comp[3], 0)
	end

	for _, comp in ipairs(props) do
			if comp[2] == -1 then
					ClearPedProp(ped, comp[1])
			else
					SetPedPropIndex(ped, comp[1], comp[2] , comp[3] , true)
			end
	end
end

function civil()
	TriggerServerEvent("skin_customization:SpawnPlayer")
	SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2)	  -- retrait cravate
	SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 0, 2)   -- retrait parballes du swat
	SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0, 0)   -- retrait Mask du swat
	SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 1, 2) -- retour skin joueurs
	SetPedComponentVariation(GetPlayerPed(-1), 10, 0, 0, 2) -- suppression grade
end

function motounif()
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
      { 3, 4, 0 }, -- gant/bras
      { 4, 32, 1 }, -- pantalon
      { 5, 48, 0 }, -- parachute
      { 6, 30, 0 }, --chaussure
			{ 7, 0, 0 }, --acssessoir
      { 8, 15, 0 }, -- ceinture/t-shirt
      { 9, 13, 0 }, -- armur
      { 10, 0, 0 }, -- emblème
      { 11, 52, 3 } -- chemise/pull/veste
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
      { 4, 31, 1 }, -- pantalon
      { 5, 0, 0 }, -- parachute
      { 6, 9, 0 }, --chaussure
			{ 7, 0, 0 }, --acssessoir
      { 8, 2, 0 }, -- ceinture/t-shirt
      { 9, 14, 0 }, -- armur
      { 10, 0, 0 }, -- emblème
      { 11, 36, 0 } -- chemise/pull/veste
    }
	end

	for _, comp in ipairs(components) do
		 SetPedComponentVariation(ped, comp[1], comp[2], comp[3], 0)
	end

	for _, comp in ipairs(props) do
			if comp[2] == -1 then
					ClearPedProp(ped, comp[1])
			else
					SetPedPropIndex(ped, comp[1], comp[2] , comp[3] , true)
			end
	end
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
	 { 9, 24, 0 }, -- armur
	 { 10, 0, 0 }, -- emblème
	 { 11, 4, 0 } -- chemise/pull/veste
 }
 for _, comp in ipairs(components) do
		SetPedComponentVariation(ped, comp[1], comp[2], comp[3], 0)
 end

 for _, comp in ipairs(props) do
		 if comp[2] == -1 then
				 ClearPedProp(ped, comp[1])
		 else
				 SetPedPropIndex(ped, comp[1], comp[2] , comp[3] , true)
		 end
 end
end

function villesuit()
	uniforclassic = false

	local props = {}
	local components ={}
	if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then
	   props = {
      { 0, -1, 0 }, -- casque
      { 1, -1, 0 }, -- lunette
      { 2, -1, 0 }, -- ecouteur
      { 3, 3, 0 } -- montre
    }
    components = {
      { 1, 0, 0 }, -- masque
      { 3, 12, 0 }, -- gant/bras
      { 4, 10, 3 }, -- pantalon
      { 5, 0, 0 }, -- parachute
      { 6, 10, 0 }, --chaussure
			{ 7, 38, 0 }, --acssessoir
      { 8, 10, 3 }, -- ceinture/t-shirt
      { 9, 24, 0 }, -- armur
      { 10, 0, 0 }, -- emblème
      { 11, 4, 1 } -- chemise/pull/veste
    }
	else -- femme
		props = {
      { 0, -1, 0 }, -- casque
      { 1, -1, 0 }, -- lunette
      { 2, -1, 0 }, -- ecouteur
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
      { 10, 0, 0 }, -- emblème
      { 11, 24, 0 } -- chemise/pull/veste
    }
	end

	for _, comp in ipairs(components) do
		 SetPedComponentVariation(ped, comp[1], comp[2], comp[3], 0)
	end

	for _, comp in ipairs(props) do
			if comp[2] == -1 then
					ClearPedProp(ped, comp[1])
			else
					SetPedPropIndex(ped, comp[1], comp[2] , comp[3] , true)
			end
	end
end

function k9unif()
	uniforclassic = false

	local props = {}
	local components ={}
	if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then
	   props = {
      { 0, 10, 6 }, -- casque
      { 1, -1, 0 }, -- lunette
      { 2, 0, 0 }, -- ecouteur
      { 3, 3, 0 } -- montre
    }
    components = {
      { 1, 11, 2 }, -- masque
      { 3, 0, 0 }, -- gant/bras
      { 4, 52, 1 }, -- pantalon
      { 5, 48, 0 }, -- parachute
      { 6, 24, 0 }, --chaussure
			{ 7, 1, 0 }, --acssessoir
      { 8, 37, 0 }, -- ceinture/t-shirt
      { 9, 13, 0 }, -- armur
      { 10, 8, 0 }, -- emblème
      { 11, 102, 0 } -- chemise/pull/veste
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
      { 4, 54, 1 }, -- pantalon
      { 5, 0, 0 }, -- parachute
      { 6, 25, 0 }, --chaussure
			{ 7, 0, 0 }, --acssessoir
      { 8, 2, 0 }, -- ceinture/t-shirt
      { 9, 14, 0 }, -- armur
      { 10, 7, 0 }, -- emblème
      { 11, 93, 0 } -- chemise/pull/veste
    }
	end

	for _, comp in ipairs(components) do
		 SetPedComponentVariation(ped, comp[1], comp[2], comp[3], 0)
	end

	for _, comp in ipairs(props) do
			if comp[2] == -1 then
					ClearPedProp(ped, comp[1])
			else
					SetPedPropIndex(ped, comp[1], comp[2] , comp[3] , true)
			end
	end
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
      { 5, 48, 0 }, -- parachute
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

	for _, comp in ipairs(components) do
		 SetPedComponentVariation(ped, comp[1], comp[2], comp[3], 0)
	end

	for _, comp in ipairs(props) do
			if comp[2] == -1 then
					ClearPedProp(ped, comp[1])
			else
					SetPedPropIndex(ped, comp[1], comp[2] , comp[3] , true)
			end
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

function gilletfluos()
  if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then -- homme
    if gilletfluo then
      SetPedComponentVariation(ped, 9, 13, 0, 0)
      SetPedArmour(ped, 0)
      gilletfluo = false
    else
      SetPedComponentVariation(ped, 9, 12, 3, 0)
      SetPedArmour(ped, 100)
      gilletfluo = true
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

function gillets()
  if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then
    if gillet then
      SetPedComponentVariation(ped, 9, 13, 0, 0)
      gillet = false
    else
      SetPedComponentVariation(ped, 9, 18, 0, 0)
      gillet = true
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
