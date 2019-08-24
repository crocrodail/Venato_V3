ambulancierIsInService = false
local AdminCheatIsOn = false
local TimeToRespawn = 0

local spawnAmbulancierVehicleChoix = {}
local KEY_ENTER = 18
local KEY_UP = 96 -- N+
local KEY_DOWN = 97 -- N-
local KEY_CLOSE = 177
local ambulancier_nbMissionEnAttenteText = '-- Aucune Info --'
local ambulancier_BlipMecano = {}
local ambulancier_showHelp = false
local listMissionsAmbulancier = {}
local currentMissionAmbulancier = nil
local ambulance_call_accept = 0
local ambulance_nbAmbulanceInService = 0
local ambulance_nbAmbulanceDispo = 0

----
local ambulancier_blipsTemp
local ambulancier_markerBool = false
local existingVeh = nil

isAmbulancier = false

local TEXTAMBUL = {
    SpawnVehicleImpossible = '~R~ Impossible, aucune place disponible.',
    InfoAmbulancierNoAppel = '~g~Aucun appel en attente.',
    InfoAmbulancierNbAppel = '~w~ Appel en attente...',
    NoPatientFound = '~b~ Aucun(e) patient(e) à proximité.',
    CALL_INFO_NO_PERSONNEL = '~r~Aucun ambulanciers en service...',
    CALL_INFO_ALL_BUSY = '~o~Tous nos ambulanciers sont occupés ou absents...',
    CALL_INFO_WAIT = '~b~Votre appel est sur attente...',
    CALL_INFO_OK = '~g~Un ambulancier va arriver...',

    CALL_RECU = 'Confirmation\nVotre appel a été enregistré.',
    CALL_ACCEPT = 'Votre appel a été accepté, un ambulancier est en route.',
    CALL_CANCEL = 'L\'ambulancier vient d\'abandonné votre appel.',
    CALL_FINI = 'Votre appel a été résolu.',
    CALL_EN_COURS = 'Vous avez déjà une demande en cours...',

    MISSION_NEW = 'Un nouveau patient(e) a été signalé(e), il/elle a été ajouté(e) dans votre liste de mission.',
    MISSION_ACCEPT = 'Mission acceptée, mettez vous en route !',
    MISSION_ANNULE = 'Votre patient(e) s\'est décommandé...',
    MISSION_CONCURENCE = 'Vous étes plusieurs sur le coup.',
    MISSION_INCONNU = 'Cette mission n\'est plus d\'actualité.',
    MISSION_EN_COURS = 'Cette mission est déjà en cours de traitement.'
}
-- restart ambu
ambulancier_platesuffix="Ambul" --Suffix de la plaque d'imat
ambulancier_car = {
	x=-488.4365,
	y=-342.8523,
	z=34.3645,
	h=261.860,
OverPowered=15.0,
}

ambulancier_emer = { --sotir voiture
	x=-54.4365,
	y=-1107.8929,
	z=26.3611,
    h=262.1448,
    OverPowered=1.0,
}

ambulancier_helico = {
x=-450.8135,
y=-305.3313,
z=78.1682,
h=20.0718,
OverPowered=1.0,
}

ambulancier_blips = {
["Urgences"] = {
id=61,
x=1148.584,
y=-1590.365,
z=3.945,
distanceBetweenCoords=1,
distanceMarker=1,
},

["Garage d\'entreprise"] = {
id=50,
	x=-496.3586,
	y=-336.0274,
	z=33.5016,
distanceBetweenCoords=2,
distanceMarker=1
},

["Heliport"] = {
id=43,
x=-439.2455,
y=-321.4538,
z=77.1681,
distanceBetweenCoords=2,
distanceMarker=1
}
}
ambulancier_sortie={
x=-447.8419,
y=-332.5049,
z=34.5019
}

--====================================================================================
--  Gestion de prise et d'abandon de service
--====================================================================================
local function showBlipAmbulancier()
    for key, item in pairs(ambulancier_blips) do
		item.blip = AddBlipForCoord(item.x, item.y, item.z)
		SetBlipSprite(item.blip, item.id)
		SetBlipAsShortRange(item.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(key)
		EndTextCommandSetBlipName(item.blip)
	end
	ambulancier_blipsTemp = ambulancier_blips
end
local function removeBlipAmbulancier()
    ambulancier_markerBool = false
	for _, item in pairs(ambulancier_blips) do
			RemoveBlip(item.blip)
	end
end

function spawnVehicule(pos, type)
  deleteVehicle()
  RequestModel(type)
  while not HasModelLoaded(type) do
    Wait(100)
  end
  local plate = math.random(1000, 9000)
  Venato.CreateVehicle(string.upper(type), {pos.x, pos.y, pos.z}, pos.h, function(vehicle)
    myVehiculeEntity = vehicle
		if type == "polmav" then
			SetVehicleLivery(myVehiculeEntity, 1)
		elseif type == "ambulance" or type == "blazer2" or type == "fbi2" or type == "lguard" or type == "rsb_mbsprinter" then
		    SetVehicleEnginePowerMultiplier(myVehiculeEntity, 50.03)
		else
		    SetVehicleEnginePowerMultiplier(myVehiculeEntity, pos.OverPowered)
		end
    SetVehicleNumberPlateText(myVehiculeEntity, "Amb"..plate)
    SetVehicleOnGroundProperly(myVehiculeEntity)
		plate = GetVehicleNumberPlateText(myVehiculeEntity)
    TriggerEvent('lock:addVeh', plate, GetDisplayNameFromVehicleModel(GetEntityModel(myVehiculeEntity)))

  end)
end

function invokeVehicle(data)
    if data.type == 1 then
        spawnVehicule(ambulancier_car, "ambulance")
    elseif data.type == 2 then
        spawnVehicule(ambulancier_helico, "polmav")
	elseif data.type == 3 then
        spawnVehicule(ambulancier_emer, "dodgesamu")
	elseif data.type == 4 then
        spawnVehicule(ambulancier_emer, "blazer2")
  elseif data.type == 5 then
        spawnVehicule(ambulancier_emer, "romero")
  elseif data.type == 6 then
        spawnVehicule(ambulancier_emer, "fbi2")
  elseif data.type == 7 then
        spawnVehicule(ambulancier_emer, "rsb_mbsprinter")
  elseif data.type == -1 then
        deleteVehicle()
    end
end

stethoscopeequip = false
casquetequip = false
helicocas = false

function Docteur()
  local ped = GetPlayerPed(-1)
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
      { 3, 88, 0 }, -- gant/bras
      { 4, 24, 0 }, -- pantalon
      { 5, 0, 0 }, -- parachute
      { 6, 77, 0 }, --chaussure
			{ 7, 0, 0 }, --acssessoir
      { 8, 10, 5 }, -- ceinture/t-shirt
      { 9, 13, 0 }, -- armur
      { 10, 0, 0 }, -- emblème
      { 11, 23, 3 } -- chemise/pull/veste
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
      { 3, 101, 1 }, -- gant/bras
      { 4, 52, 2 }, -- pantalon
      { 5, 0, 0 }, -- parachute
      { 6, 29, 0 }, --chaussure
			{ 7, 0, 0 }, --acssessoir
      { 8, 101, 0 }, -- ceinture/t-shirt
      { 9, 14, 0 }, -- armur
      { 10, 0, 0 }, -- emblème
      { 11, 7, 1 } -- chemise/pull/veste
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

function Ambulancierf()
  local ped = GetPlayerPed(-1)
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
      { 3, 92, 0 }, -- gant/bras
      { 4, 24, 5 }, -- pantalon
      { 5, 0, 0 }, -- parachute
      { 6, 77, 0 }, --chaussure
			{ 7, 0, 0 }, --acssessoir
      { 8, 15, 0 }, -- ceinture/t-shirt
      { 9, 13, 0 }, -- armur
      { 10, 0, 0 }, -- emblème
      { 11, 13, 3 } -- chemise/pull/veste
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
      { 3, 98, 1 }, -- gant/bras
      { 4, 50, 2 }, -- pantalon
      { 5, 0, 0 }, -- parachute
      { 6, 57, 2 }, --chaussure
			{ 7, 0, 0 }, --acssessoir
      { 8, 159, 0 }, -- ceinture/t-shirt
      { 9, 14, 0 }, -- armur
      { 10, 0, 0 }, -- emblème
      { 11, 258, 0 } -- chemise/pull/veste
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

function stethoscope()
  local ped = GetPlayerPed(-1)
  if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then -- homme
    if stethoscopeequip then
        SetPedComponentVariation(ped, 7, 0, 0, 0)
      stethoscopeequip = false
    else
        SetPedComponentVariation(ped, 7, 126, 0, 0)
      stethoscopeequip = true
    end
  else -- Femme
    if stethoscopeequip then
      SetPedComponentVariation(ped, 7, 0, 0, 0)
      stethoscopeequip = false
    else
        SetPedComponentVariation(ped, 7, 96, 0, 0)
      stethoscopeequip = true
    end
  end
end

function casquet()
  local ped = GetPlayerPed(-1)
  if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then -- homme
    if not casquetequip then
      SetPedPropIndex(ped, 0, 122 , 0 , true)
      casquetequip = true
    else
      ClearPedProp(ped, 0)
      casquetequip = false
    end
  else -- Femme
    if not casquetequip then
	  	SetPedPropIndex(ped, 0, 121 , 0 , true)
      casquetequip = true
    else
      ClearPedProp(ped, 0)
      casquetequip = false
    end
  end
end

function AmbuOnService()
  ambulancierIsInService = true
  ambulancier_showHelp = true
  TriggerServerEvent('ambulancier:requestMission')
  TriggerServerEvent('ambulancier:takeService')
  Menu.close()
  toogleServiceAmbulancier()
end

function leaveserv()
  ambulancierIsInService = false
  TriggerServerEvent('ambulancier:endService')
  Menu.close()
  toogleServiceAmbulancier()
end

local function gestionServiceAmbulancier()

    if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), ambulancier_blips["Urgences"].x, ambulancier_blips["Urgences"].y, ambulancier_blips["Urgences"].z, true) <= ambulancier_blips["Urgences"].distanceMarker + 15 then
      DrawMarker(1, ambulancier_blips["Urgences"].x, ambulancier_blips["Urgences"].y, ambulancier_blips["Urgences"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
    end
    if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), ambulancier_blips["Urgences"].x, ambulancier_blips["Urgences"].y, ambulancier_blips["Urgences"].z, true) <= ambulancier_blips["Urgences"].distanceMarker+1 then
      DrawMarker(1, ambulancier_blips["Urgences"].x, ambulancier_blips["Urgences"].y, ambulancier_blips["Urgences"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
        ClearPrints()
        SetTextEntry_2("STRING")
        if ambulancierIsInService then
            AddTextComponentString("Appuyez sur ~g~E~s~ pour quitter le ~b~service actif")
        else
            AddTextComponentString("Appuyez sur ~g~E~s~ pour rentrer en ~b~service actif")
        end
        DrawSubtitleTimed(2000, 1)
        if IsControlJustPressed(1, 38) then
            toogleServiceAmbulancier()
        end
    end

    if ambulancierIsInService then
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), ambulancier_blips["Garage d\'entreprise"].x, ambulancier_blips["Garage d\'entreprise"].y, ambulancier_blips["Garage d\'entreprise"].z, true) <= ambulancier_blips["Garage d\'entreprise"].distanceMarker + 15 then
          DrawMarker(1, ambulancier_blips["Garage d\'entreprise"].x, ambulancier_blips["Garage d\'entreprise"].y, ambulancier_blips["Garage d\'entreprise"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
        end
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), ambulancier_blips["Garage d\'entreprise"].x, ambulancier_blips["Garage d\'entreprise"].y, ambulancier_blips["Garage d\'entreprise"].z, true) <= ambulancier_blips["Garage d\'entreprise"].distanceMarker then
          DrawMarker(1, ambulancier_blips["Garage d\'entreprise"].x, ambulancier_blips["Garage d\'entreprise"].y, ambulancier_blips["Garage d\'entreprise"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
            ClearPrints()
            SetTextEntry_2("STRING")
            AddTextComponentString("Appuyez sur ~g~ENTREE~s~ pour faire sortir/ranger votre ~b~vehicule")
            DrawSubtitleTimed(2000, 1)
            if IsControlJustPressed(1, KEY_ENTER) then
                openMenuChoixVehicleAmbulancier()
            end
        end
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), ambulancier_blips["Heliport"].x, ambulancier_blips["Heliport"].y, ambulancier_blips["Heliport"].z, true) <= ambulancier_blips["Heliport"].distanceMarker+15 then
          DrawMarker(1, ambulancier_blips["Heliport"].x, ambulancier_blips["Heliport"].y, ambulancier_blips["Heliport"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
        end
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), ambulancier_blips["Heliport"].x, ambulancier_blips["Heliport"].y, ambulancier_blips["Heliport"].z, true) <= ambulancier_blips["Heliport"].distanceMarker then
          DrawMarker(1, ambulancier_blips["Heliport"].x, ambulancier_blips["Heliport"].y, ambulancier_blips["Heliport"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
            ClearPrints()
            SetTextEntry_2("STRING")
            AddTextComponentString("Appuyez sur ~g~ENTREE~s~ pour faire appairaitre/ranger votre ~b~vehicule")
            DrawSubtitleTimed(2000, 1)
            if IsControlJustPressed(1, KEY_ENTER) then
                openMenuChoixHelicoAmbulancier()
            end
        end
    end
end

function Ambu_removeOrPlaceCone()
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

function Ambu_removeOrPlaceBarrier()
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

--====================================================================================
-- Vehicule gestion
--====================================================================================
function notif(message)
		SetNotificationTextEntry("STRING")
		AddTextComponentString(message)
		DrawNotification(false, false)
end
--restart metiers
function jobsSystemAmbulancier()

    if currentMissionAmbulancier == nil then
        return
    end
    RemoveBlip(ambulancier_blip_currentMission)
    local patientPed = GetPlayerPed(GetPlayerFromServerId(currentMissionAmbulancier.id));
     local posPatient = currentMissionAmbulancier.positionBackUp
    if patientPed ~= nil and patientPed~= 0 and patientPed ~= GetPlayerPed(-1) then
        posPatient = GetEntityCoords(patientPed)
    end

    ambulancier_blip_currentMission = AddBlipForCoord(posPatient.x, posPatient.y, posPatient.z)
	SetBlipAsShortRange(ambulancier_blip_currentMission, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Urgence")
	EndTextCommandSetBlipName(ambulancier_blip_currentMission)
    local mypos = GetEntityCoords(GetPlayerPed(-1))
    local dist = GetDistanceBetweenCoords(mypos,posPatient.x, posPatient.y, posPatient.z, false)
	if dist < 13.0 then
        DrawMarker(1,posPatient.x, posPatient.y, 0.0 , 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 350.0, 0, 155, 255, 64, 0, 0, 0, 0)
    end
    if dist < 3.0 then
        if tostring(currentMissionAmbulancier.type) == "Coma" then
            notif('Appuyez sur ENTREE pour réanimer le joueur')
            if (IsControlJustReleased(1, KEY_ENTER)) then
                TaskStartScenarioInPlace(GetPlayerPed(-1), 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
                Citizen.Wait(8000)
                ClearPedTasks(GetPlayerPed(-1));
                TriggerServerEvent('ambulancier:rescueHim', currentMissionAmbulancier.id)
                finishMissionAmbulancier()
                --break
            end
        elseif tostring(currentMissionAmbulancier.type) == "Demande" then
                finishMissionAmbulancier()
        end
    end
end

function startMissionAmbulancier(missions)
    currentMissionAmbulancier = missions
    local posPatient = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(currentMissionAmbulancier.id)))
    SetNewWaypoint(posPatient.x, posPatient.y)

end
function finishMissionAmbulancier()
    TriggerServerEvent('ambulancier:FinishMission', currentMissionAmbulancier.id)
    RemoveBlip(ambulancier_blip_currentMission)
    currentMissionAmbulancier = nil
end
--
function showInfoClientAmbulancier()
    if ambulance_call_accept ~= 0 then

        local offsetX = 0.87
        local offsetY = 0.911
        DrawRect(offsetX, offsetY, 0.23, 0.035, 0, 0, 0, 215)

        SetTextFont(1)
        SetTextScale(0.0,0.5)
        SetTextCentre(true)
        SetTextDropShadow(0, 0, 0, 0, 0)
        SetTextEdge(0, 0, 0, 0, 0)
        SetTextColour(255, 255, 255, 255)
        SetTextEntry("STRING")
        if ambulance_call_accept == 1 then
            AddTextComponentString(TEXTAMBUL.CALL_INFO_OK)
        else
            if ambulance_nbAmbulanceInService == 0 then
                AddTextComponentString(TEXTAMBUL.CALL_INFO_NO_PERSONNEL)
            elseif ambulance_nbAmbulanceDispo == 0 then
                AddTextComponentString(TEXTAMBUL.CALL_INFO_ALL_BUSY)
            else
                AddTextComponentString(TEXTAMBUL.CALL_INFO_WAIT)
            end
        end
        DrawText(offsetX, offsetY - 0.015 )
    end
end

function showInfoJobsAmbulancier()
    local offsetX = 0.9
    local offsetY = 0.845
    DrawRect(offsetX, offsetY, 0.15, 0.07, 0, 0, 0, 215)

    SetTextFont(1)
    SetTextScale(0.0,0.5)
    SetTextCentre(true)
    SetTextDropShadow(0, 0, 0, 0, 0)
    SetTextEdge(0, 0, 0, 0, 0)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    AddTextComponentString('~o~Ambulancier Info')
    DrawText(offsetX, offsetY - 0.03)

    SetTextFont(1)
    SetTextScale(0.0,0.5)
    SetTextCentre(false)
    SetTextDropShadow(0, 0, 0, 0, 0)
    SetTextEdge(0, 0, 0, 0, 0)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")

    AddTextComponentString(ambulancier_nbMissionEnAttenteText)
    DrawText(offsetX - 0.065, offsetY -0.002)
end

function deleteVehicle()
    if myVehiculeEntity ~= nil then
        local plateOfVehicule = GetVehicleNumberPlateText(myVehiculeEntity)
        DeleteVehicle(myVehiculeEntity)
        myVehiculeEntity = nil
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
    		if IsControlJustPressed(1, 177) then
    			Menu.close()
    		end
    		if IsControlJustPressed(1, 311) then
    			Menu.close()
    		end

        if isAmbulancier then
            gestionServiceAmbulancier()
            jobsSystemAmbulancier()
            if ambulancierIsInService then
                showInfoJobsAmbulancier()
            end
            if IsControlJustPressed(1, Keys['F5']) then
              if ambulancierIsInService then
                  TriggerServerEvent('ambulancier:requestMission')
                  openMenuGeneralAmbulancier()
              else
                  Venato.notifyError("Vous devais etre en service pour accedez au menu")
              end
        		end
        end
        if ambulancier_showHelp == true then
            --drawHelpJobAmbulancier()
            if IsControlJustPressed(0, KEY_CLOSE) and  GetLastInputMethod(2) then
                ambulancier_showHelp = false
            end
        end
        if ambulance_call_accept ~= 0 then
            showInfoClientAmbulancier()
        end
    end
end)

RegisterNetEvent('Job:startAmbulancier')
AddEventHandler('Job:startAmbulancier', function (boolean)
	isAmbulancier = boolean
	ambulancierIsInService = false
    if isAmbulancier then
        showBlipAmbulancier()
    else
        removeBlipAmbulancier()
    end
end)

RegisterNetEvent('ambulancier:deleteBlips')
AddEventHandler('ambulancier:deleteBlips', function ()
    isAmbulancier = false
	TriggerServerEvent('ambulancier:endService')
    TriggerServerEvent("skin_customization:SpawnPlayer")
    removeBlipAmbulancier()
end)


--====
function acceptMissionAmbulancier(data)
    local mission = data.mission
    TriggerServerEvent('ambulancier:AcceptMission', mission.id)
end

function needAmbulance(type)
        local pos = GetEntityCoords(GetPlayerPed(-1))
        TriggerServerEvent('ambulancier:Call', type, {x = pos.x, y = pos.y, z = pos.z})
end

--====================================================================================
-- Serveur - Client Trigger
-- restart depanneur
--====================================================================================

function notifIcon(icon, type, sender, title, text)


        SetNotificationTextEntry("STRING");
        if TEXTAMBUL[text] ~= nil then
            text = TEXTAMBUL[text]
        end
        AddTextComponentString(text);
        SetNotificationMessage(icon, icon, true, type, sender, title, text);
        DrawNotification(false, true);

end

RegisterNetEvent("ambulancier:PersonnelMessage")
AddEventHandler("ambulancier:PersonnelMessage",function(message)
    if ambulancierIsInService then
        notifIcon("CHAR_CALL911", 1, "Urgence Info", false, message)
    end
end)

RegisterNetEvent("ambulancier:ClientMessage")
AddEventHandler("ambulancier:ClientMessage",function(message)
    notifIcon("CHAR_CALL911", 1, "Urgence", false, message)
end)





function updateMenuMissionAmbulancier()
    local items = {
    }

    for _,m in pairs(listMissionsAmbulancier) do
        -- Citizen.Trace('item mission')
        local item = {
            Title = 'Mission ' .. m.id .. " ["..m.type.."]" ,
            mission = m,
            Function = acceptMissionAmbulancier
        }
        if #m.acceptBy ~= 0 then
            item.Title = item.Title .. " (En cours)"..  "["..m.type.."]"
        end
        items[m] = item
    end
    if currentMissionAmbulancier ~= nil then
        --table.insert(items, {['Title'] = 'Terminer la mission', ['Function'] = finishMissionAmbulancier})
        currentMissionAmbulancierNotNil = true
    end
    updateMenuAmbu(items,currentMissionAmbulancierNotNil)
end


RegisterNetEvent('ambulancier:MissionAccept')
AddEventHandler('ambulancier:MissionAccept', function (mission)
    startMissionAmbulancier(mission)
end)

RegisterNetEvent('ambulancier:MissionChange')
AddEventHandler('ambulancier:MissionChange', function (missions)
    if not ambulancierIsInService then
        return
    end
    listMissionsAmbulancier = missions
    -- if currentMissionAmbulancier ~= nil then
         local nbMissionEnAttente = 0
    --     local find = false
         for _,m in pairs(listMissionsAmbulancier) do
      --       if m.id == currentMissionAmbulancier.id then
      --           find = true
       --      end
             if #m.acceptBy == 0 then
               nbMissionEnAttente = nbMissionEnAttente + 1
             end
        end
        if nbMissionEnAttente == 0 then
             ambulancier_nbMissionEnAttenteText = TEXTAMBUL.InfoAmbulancierNoAppel
         else
            ambulancier_nbMissionEnAttenteText = '~g~ ' .. nbMissionEnAttente .. ' ' .. TEXTAMBUL.InfoAmbulancierNbAppel
         end
    --     Citizen.Trace('ok')
    --     if not find then
    --         currentMissionAmbulancier = nil
    --         notifIcon("CHAR_CALL911", 1, "Mecano", false, TEXTAMBUL.MissionCancel)
    --         if currentBlip ~= nil then
    --             RemoveBlip(currentBlip)
    --         end
    --     end
    -- end
    updateMenuMissionAmbulancier()
end)

RegisterNetEvent('ambulancier:callStatus')
AddEventHandler('ambulancier:callStatus',function(status)
    ambulance_call_accept = status
end)

RegisterNetEvent('ambulancier:personnelChange')
AddEventHandler('ambulancier:personnelChange',function(nbPersonnel, nbDispo)
    --Citizen.Trace('nbPersonnel : ' .. nbPersonnel .. ' dispo' .. nbDispo)
    ambulance_nbAmbulanceInService = nbPersonnel
    ambulance_nbAmbulanceDispo = nbDispo
end)

RegisterNetEvent('ambulancier:cancelCall')
AddEventHandler('ambulancier:cancelCall',function(data)
    TriggerServerEvent('ambulancier:cancelCall')
end)

RegisterNetEvent('ambulancier:HealMe')
AddEventHandler('ambulancier:HealMe',
function (idToHeal)
    if idToHeal == PlayerId() then
        SetEntityHealth(GetPlayerPed(-1), GetPedMaxHealth(GetPlayerPed(-1)))
    end
end)

RegisterNetEvent('ambulancier:Heal')
AddEventHandler('ambulancier:Heal',
function()
        local closestPlayer, closestDistance = Venato.ClosePlayer()
        if closestDistance < 2.0 and closestDistance ~= -1 then
          TaskStartScenarioInPlace(GetPlayerPed(-1), 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
          Citizen.Wait(8000)
          ClearPedTasks(GetPlayerPed(-1));
          TriggerServerEvent('ambulancier:healHim',closestPlayer)
        else
          Venato.notifyError(TEXTAMBUL.NoPatientFound)
        end
end)

RegisterNetEvent('ambulancier:Heal2')
AddEventHandler('ambulancier:Heal2',
function()
        local closestPlayer, closestDistance, a = Venato.ClosePlayer()
        if closestDistance < 2.0 and closestDistance ~= -1 then
          TriggerServerEvent('ambulancier:Reanimation', closestPlayer, GetEntityCoords(a, true), GetEntityHeading(a))
        else
            Venato.notifyError(TEXTAMBUL.NoPatientFound)
        end
end)

RegisterNetEvent('ambulancier:getBlassure')
AddEventHandler('ambulancier:getBlassure',
function()
        local closestPlayer, closestDistance = Venato.ClosePlayer()
        if closestDistance < 2.0 and closestDistance ~= -1 then
            TriggerServerEvent('ambulancier:GetInTableTheBlassure', closestPlayer)
        else
            Venato.notifyError(TEXTAMBUL.NoPatientFound)
        end
end)

RegisterNetEvent('ambulancier:MakePay')
AddEventHandler('ambulancier:MakePay', function()
        local closestPlayer, closestDistance = Venato.ClosePlayer()
        if closestDistance < 2.0 and closestDistance ~= -1 then
            local price = Venato.OpenKeyboard('', '0', 10,"Montant du paiement")
            if montant ~= "" and tonumber(montant) ~= nil and tonumber(montant) ~= 0 then
        			TriggerServerEvent("ambulancier:Makepayement", ClosePlayer, montant)
        		else
        			Venato.notifyError("Le montant indiqué est erroné.")
        		end
        else
            Venato.notifyError("Pas de joueur proche!")
        end
end)
--====================================================================================
-- ADD Blip for All Player
--====================================================================================

--Citizen.Trace("Mecano load")
TriggerServerEvent('ambulancier:requestPersonnel')
