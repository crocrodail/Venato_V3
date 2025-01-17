local KEY_E = 38
local KEY_CLOSE = 177
local POLICE_currentBlip = nil
local POLICE_listMissions = {}
local POLICE_currentMissions = nil
local POLICE_nbMissionEnAttenteText = '-- Aucune Info --'
local POLICE_BlipMecano = {}
local POLICE_showHelp = false
local POLICE_CALL_ACCEPT_P = 0
local POLICE_nbMecanoisInService = 0
local POLICE_nbMecanoDispo = 0

local defaultNotification = {
    type = "alert",
    title ="LSPD",
    logo = "https://i.ibb.co/K7Cv1Sx/icons8-police-badge-96px.png"
}

local POLICE_TEXT = {
    PrendreService = '~INPUT_PICKUP~ Prendre son service de policier',
    QuitterService = '~INPUT_PICKUP~ Quitter son service de policier',
    SpawnVehicle = '~INPUT_PICKUP~ Récupérer son véhicule de ~b~service',
    SpawnVehicleImpossible = '~R~ Impossible, aucune place disponible',

    Blip = 'Mission en cours',


    MissionCancel = 'Votre mission en cours n\'est plus d\'actualité',
    MissionClientAccept = 'Un policier a pris votre appel.',
    MissionClientCancel = 'Votre policier vous à abandonné.',
    InfoPoliceNoAppel = '~g~Aucun appel en attente...',
    InfoPoliceNbAppel = '~w~ Appel en attente...',
    BlipMecanoService = 'Prise de service',
    BlipMecanoVehicle = 'Prise du véhicule de service',

    CALL_INFO_NO_PERSONNEL = '~b~Votre appel est sur attente...',
    CALL_INFO_ALL_BUSY = '~o~Toutes nos unités sont occupées.',
    CALL_INFO_WAIT = '~b~Votre appel est sur attente...',
    CALL_INFO_OK = '~g~Une unité va arriver sur les lieux de l\'appel...',

    CALL_RECU = 'Confirmation\nVotre appel a été enregistré.',
    CALL_ACCEPT_P = 'Votre appel a été accepté, un Polcier est en route...',
    CALL_CANCEL = 'Le policer vient d\'abandonné votre appel.',
    CALL_FINI = 'Votre appel a été résolu.',
    CALL_EN_COURS = 'Vous avez déjà une demande en cours...',

    MISSION_NEW = 'Une nouvelle alerte a été signalée, elle a été ajoutée dans votre liste de missions.',
    MISSION_ACCEPT = 'Mission acceptée, mettez vous en route.',
    MISSION_ANNULE = 'Votre client s\'est décommandé.',
    MISSION_CONCURENCE = 'Vous étes plusieurs sur le coup.',
    MISSION_INCONNU = 'Cette mission n\'est plus d\'actualité.',
    MISSION_EN_COURS = 'Cette mission est déjà en cours de traitement.'

}

--====================================================================================
--  Utils function
--====================================================================================
local function showMessageInformation(message, duree)
    duree = duree or 2000
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(message)
    DrawSubtitleTimed(duree, 1)
end
--====================================================================================
--  Gestion de prise et d'abandon de service
--====================================================================================


-- local function --onServiceChangePolice()
--     if isCopInService then
--         TriggerServerEvent('police:takeService')
--         TriggerServerEvent('police:requestMission')
--     else
--         -- Restaure Ped
--         TriggerServerEvent('police:endService')
--         TriggerServerEvent("skin_customization:SpawnPlayer")
--     end
-- end


--====================================================================================
-- UserAction restart police
--====================================================================================

	RegisterNetEvent('police:cuff')
	AddEventHandler('police:cuff', function(t)
		if(isCopInService) then
			t, distance = GetClosestPlayer()
			if(distance ~= -1 and distance < 1) then
				TriggerServerEvent("police:cuffGranted", GetPlayerServerId(t))
			else
				TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Aucun joueur à portée !")
			end
		else
			TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Vous n'êtes pas en service !")
		end
	end)

	RegisterNetEvent('police:getArrested')
	AddEventHandler('police:getArrested', function()
		TriggerEvent("anim:cuff")
	end)

	RegisterNetEvent('police:forceEnter')
	AddEventHandler('police:forceEnter', function(id)
		if(isCopInService) then
			t, distance = GetClosestPlayer()
			if(distance ~= -1 and distance < 1) then
				TriggerServerEvent("police:forceEnterAsk", GetPlayerServerId(t))
			else
				TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Aucun joueur menotté à portée !")
			end
		else
			TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Vous n'êtes pas en service !")
		end
	end)


    
RegisterNetEvent("police:shootfired")
AddEventHandler("police:shootfired", function(data)
    defaultNotification.message = "Coups de feu entendu !"
    venato.notify(defaultNotification)
    venato.addBlip(data[1],data[2],data[3],60000,433,1)
end)



--====================================================================================
-- Vehicule gestion
--====================================================================================

function POLICE_showInfoClient()
    if POLICE_CALL_ACCEPT_P ~= 0 then

        local offsetX = 0.87
        local offsetY = 0.785
        DrawRect(offsetX, offsetY, 0.23, 0.035, 0, 0, 0, 215)

        SetTextFont(1)
        SetTextScale(0.0,0.5)
        SetTextCentre(true)
        SetTextDropShadow(0, 0, 0, 0, 0)
        SetTextEdge(0, 0, 0, 0, 0)
        SetTextColour(255, 255, 255, 255)
        SetTextEntry("STRING")
        if POLICE_CALL_ACCEPT_P == 1 then
            AddTextComponentString(POLICE_TEXT.CALL_INFO_OK)
        else
            if POLICE_nbMecanoisInService == 0 then
                AddTextComponentString(POLICE_TEXT.CALL_INFO_NO_PERSONNEL)
            elseif POLICE_nbMecanoDispo == 0 then
                AddTextComponentString(POLICE_TEXT.CALL_INFO_ALL_BUSY)
            else
                AddTextComponentString(POLICE_TEXT.CALL_INFO_WAIT)
            end
        end
        DrawText(offsetX, offsetY - 0.015 )
    end
end

function POLICE_showInfoJobs()
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
    AddTextComponentString('~o~Police Info')
    DrawText(offsetX, offsetY - 0.03)

    SetTextFont(1)
    SetTextScale(0.0,0.5)
    SetTextCentre(false)
    SetTextDropShadow(0, 0, 0, 0, 0)
    SetTextEdge(0, 0, 0, 0, 0)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")

    AddTextComponentString(POLICE_nbMissionEnAttenteText)
    DrawText(offsetX - 0.065, offsetY -0.002)
end



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if isCop then
            --gestionService()

            if isCopInService then
				--TriggerServerEvent('police:setService', true)
                POLICE_showInfoJobs()
			else
				--TriggerServerEvent('police:setService', false)
            end
        end

        if POLICE_CALL_ACCEPT_P ~= 0 then
            POLICE_showInfoClient()
        end
        -- Citizen.Trace('isCop: ' .. (isCop and 'True' or 'False'))
        -- POLICE_showInfoJobs()
    end
end)

--
RegisterNetEvent('police:drawMarker')
AddEventHandler('police:drawMarker', function (boolean)
	isCop = true
end)
RegisterNetEvent('police:drawBlips')
AddEventHandler('police:drawBlips', function ()

end)
RegisterNetEvent('police:marker')
AddEventHandler('police:marker', function ()
end)

RegisterNetEvent('police:deleteBlips')
AddEventHandler('police:deleteBlips', function ()
    isCop = false
	Citizen.Trace("NOMORECOP")
	TriggerServerEvent("police:removeCop")
	TriggerEvent("police:finishService")

	RemoveAllPedWeapons(PlayerPedId(), true)
end)

--====================================================================================
-- Call System
--====================================================================================

-- Notification
function notifIcon(icon, type, sender, title, text)
	Citizen.CreateThread(function()
        if POLICE_TEXT[text] ~= nil then
            text = POLICE_TEXT[text]
        end
        defaultNotification.message = text
        venato.notify(defaultNotification)
	end)
end

RegisterNetEvent("police:PersonnelMessage")
AddEventHandler("police:PersonnelMessage",function(message)
    if isCopInService then
        notifIcon("CHAR_BLANK_ENTRY", 1, "Police Info", false, message)
    end
end)

RegisterNetEvent("police:recepMsg")
AddEventHandler("police:recepMsg",function(message)
    if isCopInService then
        --notifIcon("CHAR_CALL911", 1, "Police Info", false, message)
        defaultNotification.message = message
        defaultNotification.timeout = 60000
        venato.notify(defaultNotification)
        defaultNotification.timeout = 3500
    end
end)

RegisterNetEvent("police:ClientMessage")
AddEventHandler("police:ClientMessage",function(message)
    notifIcon("CHAR_BLANK_ENTRY", 1, "Police", false, message)
end)

--
function acceptMissionPolice(data)
    local mission = data.mission
    TriggerServerEvent('police:AcceptMission', mission.id)
    openMenuPoliceGeneral()
end

function finishCurrentMissionPolice()
    TriggerServerEvent('police:FinishMission', POLICE_currentMissions.id)
    POLICE_currentMissions = nil
    if POLICE_currentBlip ~= nil then
        RemoveBlip(POLICE_currentBlip)
        openMenuPoliceGeneral()
    end
end

function updateMenuMissionPolice()
  local items = {
  }
  local POLICE_currentMissionnotnil
    for _,m in pairs(POLICE_listMissions) do
        local item = {
            Title = '' .. m.id .. ' - ' .. m.type,
            mission = m,
            Function = "acceptMissionPolice"
        }
        if #m.acceptBy ~= 0 then
            item.Title = item.Title .. ' (' .. #m.acceptBy ..' Unité)'
        end
        items[m] = item
    end
    if POLICE_currentMissions ~= nil then
        POLICE_currentMissionnotnil = true
      else
        POLICE_currentMissionnotnil = false
    end
    updateMenuMissionPoliceeee(items,POLICE_currentMissionnotnil)
end

function callPolice(type)
    local myPed = PlayerPedId()
    local myCoord = GetEntityCoords(myPed)
    TriggerServerEvent('police:Call', myCoord.x, myCoord.y, myCoord.z, type)
end

RegisterNetEvent('police:MissionAccept')
AddEventHandler('police:MissionAccept', function (mission)
    POLICE_currentMissions = mission
    SetNewWaypoint(mission.pos[1], mission.pos[2])
    POLICE_currentBlip = AddBlipForCoord(mission.pos[1], mission.pos[2], mission.pos[3])
    SetBlipSprite(POLICE_currentBlip, 58)
    SetBlipColour(POLICE_currentBlip, 5)
    SetBlipAsShortRange(POLICE_currentBlip, true)
    --SetBlipFlashes(POLICE_currentBlip,1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(POLICE_TEXT.Blip)
	EndTextCommandSetBlipName(POLICE_currentBlip)
    SetBlipAsMissionCreatorBlip(POLICE_currentBlip, true)

end)

RegisterNetEvent('police:MissionCancel')
AddEventHandler('police:MissionCancel', function ()
    POLICE_currentMissions = nil
    if POLICE_currentBlip ~= nil then
        RemoveBlip(POLICE_currentBlip)
    end
end)

RegisterNetEvent('police:MissionChange')
AddEventHandler('police:MissionChange', function (missions)
    if not isCopInService then
        return
    end

    POLICE_listMissions = missions
    local nbMissionEnAttente = 0
    for _,m in pairs(POLICE_listMissions) do
        if #m.acceptBy == 0 then
            nbMissionEnAttente = nbMissionEnAttente + 1
        end
    end
    if nbMissionEnAttente == 0 then
        POLICE_nbMissionEnAttenteText = POLICE_TEXT.InfoPoliceNoAppel
    else
        POLICE_nbMissionEnAttenteText = '~g~ ' .. nbMissionEnAttente .. ' ' .. POLICE_TEXT.InfoPoliceNbAppel
    end

    updateMenuMissionPolice()
end)

RegisterNetEvent('police:openMenu')
AddEventHandler('police:openMenu', function()
    if isCopInService then
        TriggerServerEvent('police:requestMission')
        openMenuPoliceGeneral()
    else
        showMessageInformation("~r~Vous devez être en service pour acceder au menu")
    end
end)

RegisterNetEvent('police:callPolice')
AddEventHandler('police:callPolice',function(data)
    callPolice(data)
end)

RegisterNetEvent('police:callPoliceCustom')
AddEventHandler('police:callPoliceCustom',function()
    local raison = venato.OpenKeyboard('', '', 100,"Raison de l'appel")
    if raison ~= nil and raison ~= '' then
        callPolice(raison)
    end
end)

RegisterNetEvent('police:msg')
AddEventHandler('police:msg',function()
    local raison = venato.OpenKeyboard('', '0', 256,"Message à envoyer à la police")
    if raison ~= nil and raison ~= '' then
        TriggerServerEvent("police:msgserv", raison)
        defaultNotification.message = "Le message a bien été envoyé !"
        venato.notify(defaultNotification)
    else
        defaultNotification.message = "Le message n'a pas pu etre envoyé"
        venato.notify(defaultNotification)
    end
end)

RegisterNetEvent('police:callStatus')
AddEventHandler('police:callStatus',function(status)
    POLICE_CALL_ACCEPT_P = status
end)

RegisterNetEvent('police:personnelChange')
AddEventHandler('police:personnelChange',function(nbPersonnel, nbDispo)
    --Citizen.Trace('nbPersonnel : ' .. nbPersonnel .. ' dispo' .. nbDispo)
    POLICE_nbMecanoisInService = nbPersonnel
    POLICE_nbMecanoDispo = nbDispo
end)

RegisterNetEvent('police:cancelCall')
AddEventHandler('police:cancelCall',function(data)
    TriggerServerEvent('police:cancelCall')
end)

--====================================================================================
-- Initialisation
--====================================================================================


RegisterNetEvent('police:drawGetService')
AddEventHandler('police:drawGetService', function (source)
	isCopInService = not isCopInService
    --onServiceChangePolice()
	Citizen.Trace("DRAWDRAW")
	TriggerServerEvent('police:setService', isCopInService)
	if(existingVeh ~= nil) then
		SetEntityAsMissionEntity(existingVeh, true, true)
    local plateOfVehicule = GetVehicleNumberPlateText(existingVeh)
    TriggerServerEvent('ivt:deleteVeh', plateOfVehicule)
		Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(existingVeh))
		existingVeh = nil
	end
end)

RegisterNetEvent('police:getSkin')
AddEventHandler('police:getSkin', function (source)
    local playerPed = PlayerPedId()
    if (isCop and isCopInService) then
        SetPedComponentVariation(playerPed, 11, 55, 0, 2)  --Chemise Police
        SetPedComponentVariation(playerPed, 8, 58, 0, 2)   --Ceinture + matraque Police
        SetPedComponentVariation(playerPed, 4, 35, 0, 2)   --Pantalon Police
        SetPedComponentVariation(playerPed, 6, 24, 0, 2)   -- Chaussure Police
        SetPedComponentVariation(playerPed, 10, 8, 0, 2)   --grade 0
        SetPedComponentVariation(playerPed, 3, 0, 0, 2)   -- under skin
        GiveWeaponToPed(playerPed, GetHashKey("WEAPON_NIGHTSTICK"), true, true)
        GiveWeaponToPed(playerPed, GetHashKey("WEAPON_PISTOL50"), 100, true, true)
        GiveWeaponToPed(playerPed, GetHashKey("WEAPON_STUNGUN"), true, true)
        GiveWeaponToPed(playerPed, GetHashKey("WEAPON_PUMPSHOTGUN"), 100, true, true)
    else
        TriggerServerEvent("skin_customization:SpawnPlayer")
        RemoveAllPedWeapons(PlayerPedId(), true)
    end
end)

RegisterNetEvent('police:receiveIsCop')
AddEventHandler('police:receiveIsCop', function(result)
    if (result == "inconnu") then
        isCop = false
        isCopInService = false
    else
        isCop = true
    end
end)

RegisterNetEvent('police:nowCop')
AddEventHandler('police:nowCop', function()
    isCop = true
    isCopInService = false
    --onServiceChangePolice()
    TriggerServerEvent("metiers:jobs", 2)
end)

RegisterNetEvent('police:noLongerCop')
AddEventHandler('police:noLongerCop', function()
    isCop = false
    isCopInService = false
    --onServiceChangePolice()
    TriggerServerEvent("metiers:jobs", 1)
    if(existingVeh ~= nil) then
        SetEntityAsMissionEntity(existingVeh, true, true)
        local plateOfVehicule = GetVehicleNumberPlateText(existingVeh)
        TriggerServerEvent('ivt:deleteVeh', plateOfVehicule)
        Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(existingVeh))
        existingVeh = nil
    end
end)

RegisterNetEvent('police:postAmendes')
RegisterNetEvent('police:postAmendes', function(data)

end)

RegisterNetEvent('police:postAmendesCustom')
RegisterNetEvent('police:postAmendesCustom', function(data)

end)

RegisterNetEvent('police:targetCheckInventory:cb')
AddEventHandler('police:targetCheckInventory:cb', function(data)
    TriggerEvent('Menu:Clear')
    TriggerEvent('Menu:Init', "Inventaire", "Voyons voir ce qu'on a là", '#46914C99', "")
    for _, v in pairs(data) do    
      if v.isWeapon then
        TriggerEvent('Menu:AddButton2', v.libelle, "getWeaponFouille", v, '', "https://i.ibb.co/xfFb7R6/icons8-gun-96px.png")
      end
      if v.isMoney then
        TriggerEvent('Menu:AddButton2', v.money.." €", "getMoneyFouille", v, '', "https://i.ibb.co/rZfQxnn/icons8-banknotes-96px.png")
      end
      if v.isItem then
        TriggerEvent('Menu:AddShopButton', v.libelle, "getItemFouille", v, v.picture, v.quantity, nil)
      end
    end

    TriggerEvent('Menu:CreateMenu')
    TriggerEvent('Menu:Open')
end)

function getWeaponFouille(weapon)
    print(weapon.targetSource) 
    
    local notif = defaultNotification
    notif.message = 'Information'
    notif.logo = "https://i.ibb.co/xfFb7R6/icons8-gun-96px.png"
    notif.message = 'Vous vous êtes en fait saisir '..weapon.libelle  
    TriggerServerEvent('venato:NotifyPlayer', {weapon.targetSource, notif})    

    TriggerServerEvent('police:removeWeapon', weapon)
    TriggerServerEvent('police:addWeapon', weapon)
    Citizen.Wait(100)
    TriggerServerEvent("police:targetCheckInventory", weapon.targetSource)
end

function getMoneyFouille(money)
    local qty = venato.OpenKeyboard('', "", 100, "Argent à récupérer:")
    if tonumber(qty) ~= nil and tonumber(qty) >= 0  and tonumber(qty) <= money.money then
        TriggerServerEvent('Inventory:CallInfoMoney', money.target, -qty, nil)
        print(money.targetSource)  

        local notif = defaultNotification
        notif.message = 'Information'
        notif.logo = 'https://i.ibb.co/rZfQxnn/icons8-banknotes-96px.png'
        notif.message = 'Vous vous êtes en fait saisir '..money.money..' €'  
        TriggerServerEvent('venato:NotifyPlayer', {money.targetSource, notif})
        TriggerServerEvent("police:targetCheckInventory", money.targetSource)

    else
        venato.notifyError("Erreur dans le nombre renseigné.")
    end
    Menu.close()
end

function getItemFouille(item)
    local qty = venato.OpenKeyboard('', "", 100, "Nombre à récupérer:")
    if tonumber(qty) ~= nil and tonumber(qty) >= 0  and tonumber(qty) <= item.quantity then
        local notif = defaultNotification
        notif.title = 'Information'
        notif.logo = item.picture
        notif.message = 'Vous vous êtes en fait saisir '..item.quantity..' '..item.libelle     
        TriggerServerEvent('venato:NotifyPlayer', { item.targetSource, notif })

        TriggerServerEvent('Inventory:RemoveItem',tonumber(qty), item.id, item.targetSource)
        TriggerServerEvent('Inventory:AddItem',tonumber(qty), item.id)
        Citizen.Wait(100)
        TriggerServerEvent("police:targetCheckInventory", item.targetSource)
    else
        venato.notifyError("Erreur dans le nombre renseigné.")
    end
    Menu.close()
end

AddEventHandler("playerSpawned", function(source)
    TriggerServerEvent("police:checkIsCop")
end)

function openTextInput(title, defaultText, maxlength)
	DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", defaultText or "", "", "", "", maxlength or 180)
	while (UpdateOnscreenKeyboard() == 0) do
		DisableAllControlActions(0);
		Wait(0);
	end
	if (GetOnscreenKeyboardResult()) then
		return GetOnscreenKeyboardResult()
	end
	return nil
end

--====================================================================================
-- Action
--====================================================================================
function POLICE_Check(isPolice)  
    Menu.close()  
    t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 3) then
        if IsPlayerDead(t) then 
            venato.playAnim({
                useLib = true,
                flag = 1,
                lib = "amb@medic@standing@kneel@base",
                anim = "base",
                timeout = 500
            });
        end
        venato.playAnim({
            useLib = true,
            flag = 48,
            lib = "anim@gangops@facility@servers@bodysearch@",
            anim = "player_search",
            timeout = 5000
        });  
        
        local notif = defaultNotification
        notif.title = 'Fouille'
        notif.logo = "https://i.ibb.co/qJ2yMXG/icons8-backpack-96px-1.png"
        notif.message = 'Vous êtes en train de vous faire fouiller'
        
        TriggerServerEvent('venato:NotifyPlayer', {GetPlayerServerId(t), notif})

        TriggerServerEvent("police:targetCheckInventory", GetPlayerServerId(t))
        venato.stopAnim({
            lib = "anim@gangops@facility@servers@bodysearch@",
            anim = "player_search",
        })     
        venato.stopAnim({
            lib = "amb@medic@standing@kneel@base",
            anim = "base",
        })
	else
        defaultNotification.message = "<span class='red--text'>Pas de joueur proche.</span>"
        if isPolice then
            defaultNotification.title = "LSPD"
            defaultNotification.logo = "https://i.ibb.co/K7Cv1Sx/icons8-police-badge-96px.png";
        else
            defaultNotification.title = "Gang"
            defaultNotification.logo = "https://i.ibb.co/dp3xMML/icons8-ski-mask-96px.png";
        end        
	end
end

function POLICE_Cuffed(isPolice)
    t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 3) then
        TriggerServerEvent("police:cuff", GetPlayerServerId(t), isPolice)       
    else
        defaultNotification.message = "<span class='red--text'>Pas de joueur proche.</span>"
        if isPolice then
            defaultNotification.title = "LSPD"
            defaultNotification.logo = "https://i.ibb.co/K7Cv1Sx/icons8-police-badge-96px.png";
        else
            defaultNotification.title = "Gang"
            defaultNotification.logo = "https://i.ibb.co/dp3xMML/icons8-ski-mask-96px.png";
        end 
        venato.notify(defaultNotification)
	end
end


function POLICE_Crocheter()
	Citizen.CreateThread(function()
        local pos = GetEntityCoords(PlayerPedId())
        local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)

        local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
        local a, b, c, d, vehicleHandle = GetRaycastResult(rayHandle)
        if(DoesEntityExist(vehicleHandle)) then
            TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_WELDING", 0, true)
            Citizen.Wait(20000)
            TriggerEvent("lock:addVeh", GetVehicleNumberPlateText(vehicleHandle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicleHandle)))
            SetVehicleDoorsLocked(vehicleHandle, 1)
            ClearPedTasksImmediately(PlayerPedId())
            unlockveh()
        else
            defaultNotification.message = "<span class='red--text'>Pas de véhicule proche.</span>"
            venato.notify(defaultNotification)
        end
	end)
end

function POLICE_PutInVehicle()
	local t, distance = GetClosestPlayer()
    local pos = GetEntityCoords(PlayerPedId())
    local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)

    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
    local a, b, c, d, vehicleHandle = GetRaycastResult(rayHandle)
	if(distance ~= -1 and distance < 3) then
		TriggerServerEvent("police:forceEnterAsk", GetPlayerServerId(t), vehicleHandle)
	else
        defaultNotification.message = "<span class='red--text'>Pas de joueur proche.</span>"
        venato.notify(defaultNotification)
	end
end

function POLICE_UnseatVehicle()
	t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		TriggerServerEvent("police:confirmUnseat", GetPlayerServerId(t))
	else
        defaultNotification.message = "<span class='red--text'>Pas de joueur proche.</span>"
        venato.notify(defaultNotification)
	end
end

function POLICE_CheckPlate()
	local pos = GetEntityCoords(PlayerPedId())
	local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)

	local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
	local a, b, c, d, vehicleHandle = GetRaycastResult(rayHandle)
    if(DoesEntityExist(vehicleHandle)) then
		TriggerServerEvent("police:checkingPlate", GetVehicleNumberPlateText(vehicleHandle), GetEntityModel(vehicleHandle))
    else
        defaultNotification.message = "<span class='red--text'>Pas de véhicule proche.</span>"
        venato.notify(defaultNotification)
        --TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Pas de vehicule proche!")
	end
end

function POLICE_FINE_DATA(data)
    POLICE_Fines(data.tarif, data.title, data.points)
end

function POLICE_FINE_CUSTOM()
    AddTextEntry('FMMC_MPM_NA', "Titre de l'amende")
    local t = openTextInput('','', 128)
    if t ~= nil and t ~= '' then
      AddTextEntry('FMMC_MPM_NA', "Tarif")
      local r = tonumber(openTextInput('','', 128))
      if r ~= nil and r > 0 then
    --     AddTextEntry('FMMC_MPM_NA', "Nombre de point")
    --     local p = tonumber(openTextInput('','', 128))
    --     if p ~= nil then
    --       if r ~= nil and t ~= nil and t ~= '' and p ~= nil then
               POLICE_Fines(r,t,p)
    --       end
    --     else
    --       defaultNotification.message = "<span class='red--text'>Erreur dans le nombre de point de l'amende.</span>"
    --       venato.notify(defaultNotification)
    --     end
       else
        defaultNotification.message = "<span class='red--text'>Erreur dans le tarif de l'amende.</span>"
        venato.notify(defaultNotification)
       end
    else
      defaultNotification.message = "<span class='red--text'>Erreur dans le titre de l'amende.</span>"
      venato.notify(defaultNotification)
    end
end

function POLICE_Fines(amount, reason, points)
    local t, distance = GetClosestPlayer()


    if(distance ~= -1 and distance < 3) then
        TriggerServerEvent("police:finesGranted", GetPlayerServerId(t), amount, reason)
        -- if points > 0 then
        --     --TriggerServerEvent("dmv:removePoints", points, GetPlayerServerId(t), source)
        --     TriggerServerEvent("police:finesGranted", GetPlayerServerId(t), amount, reason)
        -- elseif points < 0 then
        --     --TriggerServerEvent("dmv:removeLicence", GetPlayerServerId(t), source)
        --     TriggerServerEvent("police:finesGranted", GetPlayerServerId(t), amount, reason)
        -- elseif points == 0 then
        --     TriggerServerEvent("police:finesGranted", GetPlayerServerId(t), amount, reason)
        -- end
	else
        defaultNotification.message = "<span class='red--text'>Pas de joueur proche.</span>"
        venato.notify(defaultNotification)
	end
end
--====================================================================================
-- Event
--====================================================================================

RegisterNetEvent('police:payFines')
AddEventHandler('police:payFines', function(amount)
    defaultNotification.message = "Vous avez payé <span class='green--text'>"..amount.."</span>€ d'amende."
    defaultNotification.timeout = 5000
    venato.notify(defaultNotification)
    defaultNotification.timeout = 3500
end)

--====================================================================================
-- Initialisation
--====================================================================================


TriggerServerEvent('police:requestPersonnel')
--TriggerServerEvent("police:checkIsCop")

-- Register a network event
RegisterNetEvent( 'deleteVehicle' )
