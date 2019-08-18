
local ambulancierIsInService = false
TimeToRespawn = 0
local AdminCheatIsOn = false

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
	x=-486.4365,
	y=-331.8929,
	z=34.3611,
    h=262.1448,
    OverPowered=20.0,
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
x=267.49099,
y=-1363.909912,
z=23.537790,
distanceBetweenCoords=1,
distanceMarker=2,
},

["Garage d\'entreprise"] = {
id=50,
	x=-496.3586,
	y=-336.0274,
	z=33.5016,
distanceBetweenCoords=2,
distanceMarker=2
},

["Heliport"] = {
id=43,
x=-439.2455,
y=-321.4538,
z=77.1681,
distanceBetweenCoords=2,
distanceMarker=2
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
local function drawHelpJobAmbulancier()
    local lines = {
        { text = '~o~Information Ambulancier', isTitle = true, isCenter = true},
        { text = '~g~Vous devez sauver les citoyens dans le coma.', isCenter = true, addY = 0.04},
        { text = ' - Prenez votre service et récupérez votre véhicule dans un garage.'},
        { text = ' - Lorsque qu\'un appel est lancé, prenez l\'appel et dirrigez-vous pour sauvez une vie.'},
        { text = ' - Une fois sur place, analysez la situation et agissez dans la mesure du possible.'},
        { text = ' - Prévenez le centre d\'appels que la mission est terminée.'},
        { text = ' - Prenez ou attendez le prochain appel.', addY = 0.04},
        { text = '~b~ Vos véhicules :', size = 0.4, addY = 0.04 },
        { text = '~g~L\'ambulance ~w~Rapide et maniable, permet d\'intervenir à courte et moyenne distance'},
        { text = '~g~L\'helicopter ~w~Plus rapide pour les longue distances.', addY = 0.04},
        { text = '~d~Si vous trouvez des problèmes, utilisez le forum pour nous les signalers.', isCenter = true, addY = 0.06},
        { text = '~b~Merci & Bonne route', isCenter = true},
    }
    DrawRect(0.5, 0.5, 0.48, 0.5, 0,0,0, 225)
    local y = 0.31 - 0.025
    local defaultAddY = 0.025
    local addY = 0.025
    for _, line in pairs(lines) do
        y = y + addY
        local caddY = defaultAddY
        local x = 0.275
        local defaultSize = 0.32
        local defaultFont = 8
        if line.isTitle == true then
            defaultFont = 1
            defaultSize = 0.8
            caddY = 0.06
        end
        SetTextFont(line.font or defaultFont)
        SetTextScale(0.0,line.size or defaultSize)
        SetTextCentre(line.isCenter == true)
        if line.isCenter == true then
            x = 0.5
        end
        SetTextDropShadow(0, 0, 0, 0, 0)
        SetTextEdge(0, 0, 0, 0, 0)
        SetTextColour(255, 255, 255, 255)
        SetTextEntry("STRING")
        AddTextComponentString(line.text)
        DrawText(x, y)
        addY = line.addY or caddY
    end
    SetTextComponentFormat("STRING")
    AddTextComponentString('~INPUT_CELLPHONE_CANCEL~ ~g~Ferme l\'aide')
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)

end

function Chat(t)
	TriggerEvent("chatMessage", 'AMBU', { 0, 255, 255}, "" .. tostring(t))
end

function spawnVehicule(pos, type)
    deleteVehicle()
    local vehi = GetClosestVehicle(pos.x, pos.y, pos.z, 2.0, 0, 70)
    if vehi == 0 then
        RequestModel(type)
        while not HasModelLoaded(type) do
            Wait(1)
        end
        local plate = math.random(1000, 9000)
        myVehiculeEntity = CreateVehicle(type, pos.x, pos.y, pos.z, pos.h , true, true)
		if type == "polmav" then
			SetVehicleLivery(myVehiculeEntity, 1)
		elseif type == "ambulance" or type == "blazer2" or type == "fbi2" or type == "lguard" or type == "rsb_mbsprinter" then
		SetVehicleEnginePowerMultiplier(myVehiculeEntity, 50.03)
		else
		SetVehicleEnginePowerMultiplier(myVehiculeEntity, pos.OverPowered)
		end


        SetVehicleNumberPlateText(myVehiculeEntity, "Amb"..plate)
        SetVehicleOnGroundProperly(myVehiculeEntity)

		SetEntityAsMissionEntity(myVehiculeEntity, true, true)
		plate = GetVehicleNumberPlateText(myVehiculeEntity)
    TriggerEvent('lock:addVeh', plate, GetDisplayNameFromVehicleModel(GetEntityModel(myVehiculeEntity)))
    TriggerServerEvent("vnt:saveVeh", myVehiculeEntity)
		TriggerServerEvent("ls:refreshid",plate,myVehiculeEntity)

        local ObjectId = NetworkGetNetworkIdFromEntity(myVehiculeEntity)
        SetNetworkIdExistsOnAllMachines(ObjectId, true)

        local p = GetEntityCoords(myVehiculeEntity, 0)
        local h = GetEntityHeading(myVehiculeEntity)
        SetModelAsNoLongerNeeded(type)
        return
    end
    -- Citizen.Trace('impossible')
    notifIcon("CHAR_CALL911", 1, "Urgence", false, TEXTAMBUL.SpawnVehicleImpossible)
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

function toogleServiceAmbulancier()
  if not ambulancierIsInService then
    TriggerEvent("ambu:service")
  end
    ped = GetPlayerPed(-1)
    Menu.hidden = false
    ambulancierIsInService = true
    Citizen.Trace("toogleServiceAmbulancier")
    MenuTitle = "LSMC"
    MenuDescription = "~b~Choix des tenues  "
  	ClearMenu()
    Menu.addButton("~r~Quitter son service", "leaveserv", nil)
  	Menu.addButton("Tenue ~b~Infirmier", "Infirmier", nil)
  	Menu.addButton("Tenue ~b~Ambulancier", "Ambulancierf", nil)
  	Menu.addButton("Tenue ~b~Docteur", "Docteur", nil)
  	Menu.addButton("~o~Equiper un stethoscope", "stethoscope", nil)
  	Menu.addButton("~o~Equiper une casquet", "casquet", nil)
    Menu.addButton("~o~Equiper casque", "helicop", nil)
    TriggerServerEvent('ambulancier:takeService')
    TriggerServerEvent('ambulancier:requestMission')
    ambulancier_showHelp = true
end

stethoscopeequip = false
casquetequip = false
helicocas = false

function Docteur()
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
      { 5, 48, 0 }, -- parachute
      { 6, 10, 0 }, --chaussure
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
      { 5, 48, 0 }, -- parachute
      { 6, 8, 0 }, --chaussure
			{ 7, 0, 0 }, --acssessoir
      { 8, 87, 0 }, -- ceinture/t-shirt
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

function Infirmier()
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
     { 5, 48, 0 }, -- parachute
     { 6, 8, 0 }, --chaussure
     { 7, 0, 0 }, --acssessoir
     { 8, 20, 1 }, -- ceinture/t-shirt
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
      { 3, 98, 0 }, -- gant/bras
      { 4, 50, 2 }, -- pantalon
      { 5, 0, 0 }, -- parachute
      { 6, 72, 0 }, --chaussure
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

function helicop()
  if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then -- homme
    if helicocas then
        ClearPedProp(ped, comp[1])
      helicocas = false
    else
        SetPedPropIndex(ped, 0, 79, 0 , true)
      helicocas = true
    end
  else -- Femme
    if helicocas then
      ClearPedProp(ped, comp[1])
      helicocas = false
    else
        SetPedPropIndex(ped, 0, 19 , 0 , true)
      helicocas = true
    end
  end
end

function casquet()
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


function leaveserv()
  if ambulancierIsInService then
    TriggerEvent("ambu:service")
  end
  ambulancierIsInService = false
  TriggerServerEvent('ambulancier:endService')
  TriggerServerEvent("skin_customization:SpawnPlayer")
end

local function gestionServiceAmbulancier()

    if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), ambulancier_blips["Urgences"].x, ambulancier_blips["Urgences"].y, ambulancier_blips["Urgences"].z, true) <= ambulancier_blips["Urgences"].distanceMarker then
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
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), ambulancier_blips["Garage d\'entreprise"].x, ambulancier_blips["Garage d\'entreprise"].y, ambulancier_blips["Garage d\'entreprise"].z, true) <= ambulancier_blips["Garage d\'entreprise"].distanceMarker+5 then
            DrawMarker(1, ambulancier_blips["Garage d\'entreprise"].x, ambulancier_blips["Garage d\'entreprise"].y, ambulancier_blips["Garage d\'entreprise"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
            ClearPrints()
            SetTextEntry_2("STRING")
            AddTextComponentString("Appuyez sur ~g~ENTREE~s~ pour faire sortir/ranger votre ~b~vehicule")
            DrawSubtitleTimed(2000, 1)
            if IsControlJustPressed(1, KEY_ENTER) then
                openMenuChoixVehicleAmbulancier()
            end
        end
         if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), ambulancier_blips["Heliport"].x, ambulancier_blips["Heliport"].y, ambulancier_blips["Heliport"].z, true) <= ambulancier_blips["Heliport"].distanceMarker+5 then
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
        TriggerServerEvent('ivt:deleteVeh', plateOfVehicule)
        DeleteVehicle(myVehiculeEntity)
        myVehiculeEntity = nil
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        -- local mypos = GetEntityCoords(GetPlayerPed(-1))

        -- DrawMarker(1,mypos.x, mypos.y, 0.0 , 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 250.0, 0, 155, 255, 64, 0, 0, 0, 0)
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

        if isAmbulancier then
            gestionServiceAmbulancier()
            jobsSystemAmbulancier()
            if ambulancierIsInService then
                showInfoJobsAmbulancier()
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

--
RegisterNetEvent('ambulancier:drawMarker')
AddEventHandler('ambulancier:drawMarker', function (boolean)
	isAmbulancier = boolean
	ambulancierIsInService = false
    if isAmbulancier then
        showBlipAmbulancier()
    else
        removeBlipAmbulancier()
    end
end)
RegisterNetEvent('ambulancier:drawBlips')
AddEventHandler('ambulancier:drawBlips', function ()
end)
RegisterNetEvent('ambulancier:marker')
AddEventHandler('ambulancier:marker', function ()
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
        {['Title'] = 'Retour', ['ReturnBtn'] = true }
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
            item.TextColor = {39, 174, 96, 255}
        end
        table.insert(items, item)
    end
    if currentMissionAmbulancier ~= nil then
        table.insert(items, {['Title'] = 'Terminer la mission', ['Function'] = finishMissionAmbulancier})
    end

    table.insert(items, {['Title'] = 'Fermer'})

    menu = {['Title'] = 'Missions en cours',  ['SubMenu'] = {
        ['Title'] = 'Missions en cours', ['Items'] = items
    }}
    updateMenu(menu)
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


local function showMessageInformation(message, duree)
    duree = duree or 2000
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(message)
    DrawSubtitleTimed(duree, 1)
end

RegisterNetEvent('ambulancier:openMenu')
AddEventHandler('ambulancier:openMenu', function()
    if ambulancierIsInService then
        TriggerServerEvent('ambulancier:requestMission')
        openMenuGeneralAmbulancier()
    else
        showMessageInformation("~r~Vous devais etre en service pour accedez au menu")
    end
end)

RegisterNetEvent('ambulancier:callAmbulancier')
AddEventHandler('ambulancier:callAmbulancier',function(data)
    needAmbulance(data.type)
    TimeToRespawn = TimeToRespawn + 60
end)

RegisterNetEvent('respawnamb:callaccept')
AddEventHandler('respawnamb:callaccept',function()
    TimeToRespawn = TimeToRespawn + 600
end)

RegisterNetEvent('ambu:stoptimer')
AddEventHandler('ambu:stoptimer',function()
    TimeToRespawn = 0
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

Citizen.CreateThread(function()
	while true do
			Citizen.Wait(1000)
			if(TimeToRespawn > 0)then
				TimeToRespawn = TimeToRespawn - 1
			end
		Citizen.Wait(0)
	end
end)
local assommePlayer = false
Citizen.CreateThread(function()
	while true do
    if TimeToRespawn > 0 then
			drawTxt(0.88, 1.02, 1.0,1.0,0.4, "Attendez ~r~" .. TimeToRespawn .. "~w~ secondes avant de respawn.", 255, 255, 255, 255)
    elseif IsEntityDead(PlayerPedId()) == 1 and assommePlayer == false then
    --  TriggerServerEvent('sPrint',"Dead")
      if firtdead then
        Citizen.Wait(1000)
        firtdead = false
      else
        drawTxt(0.88, 1.02, 1.0,1.0,0.4, "~g~Appuyez sur ~r~X ~g~pour respawn à l'hospital.", 255, 255, 255, 255)
        if IsControlJustPressed(1, 73) and  GetLastInputMethod(2) then
          TriggerEvent('ambulancier:selfRespawn')
        end
      end
    else
      Citizen.Wait(1000)
      firtdead = true
    end
		Citizen.Wait(0)
	end
end)

RegisterNetEvent("vnt:noncoma")
AddEventHandler("vnt:noncoma", function()
  assommePlayer = true
end)

RegisterNetEvent('vnt:deassomm')
AddEventHandler('vnt:deassomm', function()
  assommePlayer = false
end)

RegisterNetEvent("ambu:mort")
AddEventHandler("ambu:mort", function()
  TimeToRespawn = 300
end)

RegisterNetEvent("venato:cheaton")
AddEventHandler("venato:cheaton", function(bool)
  local bool = bool
  AdminCheatIsOn = bool
--  print("cheatmode "..bool)
end)

RegisterNetEvent('ambulancier:selfRespawn')
AddEventHandler('ambulancier:selfRespawn',function()
  PlayerCanRespawnOrNot()
    --TriggerServerEvent('ambulancier:askSelfRespawn')
end)

function PlayerCanRespawnOrNot()
  if TimeToRespawn == 0 or AdminCheatIsOn == true then
    TriggerServerEvent('ambulancier:askSelfRespawn')
    TriggerEvent('tddeath:askSelfRespawn')
    TimeToRespawn = 0
  else
    TriggerEvent("es_freeroam:notify", "CHAR_MP_STRIPCLUB_PR", 1, "Venato", false, "Vous devez attendre "..TimeToRespawn.." sec pour pouvoir respawn.")
  end
end


function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
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
        local closestPlayer, closestDistance = GetClosestPlayer()
        if closestDistance < 2.0 and closestDistance ~= -1 then
          if GetEntityHealth(GetPlayerPed(closestPlayer)) ~= 0 then
            TaskStartScenarioInPlace(GetPlayerPed(-1), 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
            Citizen.Wait(8000)
            ClearPedTasks(GetPlayerPed(-1));
            TriggerServerEvent('ambulancier:healHim',closestPlayer)
          else
            showMessageInformation("Vous ne pouvez pas faire soin sur une personnes dans le coma.")
          end
        else
            showMessageInformation(TEXTAMBUL.NoPatientFound)
        end
end)

RegisterNetEvent('ambulancier:Heal2')
AddEventHandler('ambulancier:Heal2',
function()
        local closestPlayer, closestDistance = GetClosestPlayer()
        if closestDistance < 2.0 and closestDistance ~= -1 then
            TaskStartScenarioInPlace(GetPlayerPed(-1), 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
            Citizen.Wait(8000)
            ClearPedTasks(GetPlayerPed(-1));
            TriggerServerEvent('ambulancier:rescueserv',GetPlayerServerId(closestPlayer))
        else
            showMessageInformation(TEXTAMBUL.NoPatientFound)
        end
end)

RegisterNetEvent('ambulancier:getBlassure')
AddEventHandler('ambulancier:getBlassure',
function()
        local closestPlayer, closestDistance = GetClosestPlayer()
        if closestDistance < 2.0 and closestDistance ~= -1 then
            TriggerServerEvent('ambulancier:GetInTableTheBlassure',GetPlayerServerId(closestPlayer))
        else
            showMessageInformation(TEXTAMBUL.NoPatientFound)
        end
end)

RegisterNetEvent('facture:amb')
AddEventHandler('facture:amb', function()
        local closestPlayer, closestDistance = GetClosestPlayer()
        if closestDistance < 2.0 and closestDistance ~= -1 then
            TriggerEvent("fact:give", GetPlayerServerId(closestPlayer))
        else
            TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Pas de joueur proche!")
        end
end)
--====================================================================================
-- ADD Blip for All Player
--====================================================================================

--Citizen.Trace("Mecano load")
TriggerServerEvent('ambulancier:requestPersonnel')
