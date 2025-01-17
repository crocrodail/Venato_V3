local menuIsOpen = false
local setRegu = false
local vitesseRegu = 0
local defaultStyle = 0
local defaultNotification = {
    title = "Info. Véhicule",
    logo = "https://i.ibb.co/b2jMYxp/icons8-sedan-96px-1.png"
}

local cruiseNotification = {
    title = "Info. Véhicule",
    logo = "https://i.ibb.co/P9VLmNZ/icons8-speedometer-96px.png"
}


local commandsCars = {
    { id="commandCarTitle", title = "En véhicule"},
    { id="commandCloseCarOpenEnter", command='F', icon='https://i.ibb.co/1MTzMKq/icons8-car-theft-48px.png', text='Sortir du véhicule' },  
    { id="commandCarOpenMenu", command='F3', icon='https://i.ibb.co/Gv2Wyhq/icons8-car-96px-1.png', text='Gestion véhicule' },  
    { id="commandCarOpenClose", command='Y', icon='https://i.ibb.co/VwgB5xz/icons8-key-2-96px.png', text='Vérrouiller / Dévérouiller le véhicule' },  
    { id="commandSafety", command='X', icon='https://i.ibb.co/0G3KyFB/icons8-passenger-96px.png', text='Enlever / Mettre la ceinture' },  
    { id="commandHeadLigth", command='H', icon='https://i.ibb.co/yPDj68W/icons8-car-headlights-48px.png', text='Régler phares véhicule' },  
    { id="gnrCarMenuEnd", divider=true },
}

local commandsCloseCars = {
    { id="commandCloseCarTitle", title = "Véhicule"},
    { id="commandCloseCarOpenEnter", command='F', icon='https://i.ibb.co/1MTzMKq/icons8-car-theft-48px.png', text='Entrer dans le véhicule' },  
    { id="commandCloseCarOpenClose", command='Y', icon='https://i.ibb.co/VwgB5xz/icons8-key-2-96px.png', text='Vérrouiller / Dévérouiller le véhicule' },  
    { id="commandCloseCarTrunk", command='L', icon='https://i.ibb.co/G0Hm3LM/cartrunk.png', text='Ouvrir le coffre du véhicule' },  
    { id="gnrCloseCarMenuEnd", divider=true },
}
  
local isCommandCarMenuAdded = nil;
local isCommandCloseCarMenuAdded = nil;

Citizen.CreateThread(
    function()
        SetNuiFocus(false, false)
        while true do
            Citizen.Wait(0)
            if IsControlJustPressed(1, Keys["F3"]) then
                if menuIsOpen then
                    hideMenu()
                else
                    showMenu()
                end
            end
            if
                menuIsOpen and
                    (IsControlJustPressed(1, Keys["F2"]) or IsControlJustPressed(1, Keys["BACKSPACE"]) or
                        IsControlJustPressed(1, Keys["K"]) or
                        IsControlJustPressed(1, Keys["F5"]))
             then
                hideMenu()
                previewSpeedmeter(defaultStyle)
            end
            local car = GetVehiclePedIsIn(PlayerPedId(), false)
            local playerPos = GetEntityCoords(PlayerPedId())
            local closestVehicule = GetClosestVehicle(playerPos.x, playerPos.y, playerPos.z, 3.0, 0, 127)
            if car == 0 and isCommandCarMenuAdded then
                TriggerEvent('Commands:RemoveRange', commandsCars)
                isCommandCarMenuAdded = nil
            end

            if closestVehicule == 0 and isCommandCloseCarMenuAdded then
                TriggerEvent('Commands:RemoveRange', commandsCloseCars)
                isCommandCloseCarMenuAdded = nil
            end
            if car ~= 0 then
                if isCommandCloseCarMenuAdded then
                    TriggerEvent('Commands:RemoveRange', commandsCloseCars)
                    isCommandCloseCarMenuAdded = nil
                end
                if not isCommandCarMenuAdded then
                    TriggerEvent('Commands:AddRange', commandsCars)
                    isCommandCarMenuAdded = true
                end                
            end
            if car == 0 and closestVehicule ~= 0 then
                if not isCommandCloseCarMenuAdded then
                    TriggerEvent('Commands:AddRange', commandsCloseCars)
                    isCommandCloseCarMenuAdded = true
                end
            end
        end
    end
)

function showMenu()
    local car = GetVehiclePedIsIn(PlayerPedId(), false)
    if car ~= 0 then
        menuIsOpen = true
        Menu.open()
        Menu.clearMenu()
        TriggerEvent('Menu:Init', "Voiture", "Choisir une action", '#4527A099', "https://www.tesla.com/content/dam/tesla-site/sx-redesign/img/model3-proto/specs/compare-model3--center.png")

        Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "hideMenu")

        if setRegu then
            Menu.addButton(
                "<span class='red--text'>Désactiver régulateur : " .. vitesseRegu .. " km/h</span>",
                "activRegu",
                {car = car, vitesse = -1}
            )
        end

        Menu.addButton("Régulateur", "openRegulMenu", car)

        Menu.addButton("Moteur", "toggleEngine", car)

        Menu.addButton("Baisser les vitres", "WindowsRollDown", car)
        Menu.addButton("Monter les vitres", "WindowsRollUp", car)

        Menu.addButton("Baisser la vitre", "WindowRollDown", car)
        Menu.addButton("Monter la vitre", "WindowRollUp", car)

        if DoesVehicleHaveDoor(car, 0) then
            Menu.addButton("Portière avant gauche", "openDoor", {car = car, index = 0})
        end

        if DoesVehicleHaveDoor(car, 1) then
            Menu.addButton("Portière avant droite", "openDoor", {car = car, index = 1})
        end

        if DoesVehicleHaveDoor(car, 2) then
            Menu.addButton("Portière arrière gauche", "openDoor", {car = car, index = 2})
        end

        if DoesVehicleHaveDoor(car, 3) then
            Menu.addButton("Portière arrière droite", "openDoor", {car = car, index = 3})
        end

        if DoesVehicleHaveDoor(car, 4) then
            Menu.addButton("Capot", "openDoor", {car = car, index = 4})
        end

        if DoesVehicleHaveDoor(car, 5) then
            Menu.addButton("Coffre", "openDoor", {car = car, index = 5})
        end

        if DoesVehicleHaveDoor(car, 6) then
            Menu.addButton("Arrière 1", "openDoor", {car = car, index = 6})
        end

        if DoesVehicleHaveDoor(car, 7) then
            Menu.addButton("Arrière 2", "openDoor", {car = car, index = 7})
        end

        Menu.addButton("Affichage compteur", "settingsMenu")
    end
end

function hideMenu()
    menuIsOpen = false
    Menu.close()
end

function WindowsRollUp(car)      
    for i=0, 9 do    
        RollUpWindow(car, i)      
    end 
end
function WindowsRollDown(car)      
    RollDownWindows(car) 
end

function WindowRollDown(car)      
    RollDownWindow(car,0) 
end
function WindowRollUp(car)      
    RollUpWindow(car,0) 
end

function toggleEngine(car)
    if IsVehicleEngineOn(car) then
        defaultNotification.message = "Moteur : <span class='red--text'>éteint</span>"
        SetVehicleEngineOn(car, false, false, true)
    else
        defaultNotification.message = "Moteur : <span class='green--text'>démarré</span>"
        SetVehicleEngineOn(car, true, false, true)
    end
    venato.notify(defaultNotification)
end

function openDoor(data)
    local status = GetVehicleDoorAngleRatio(data.car, data.index)

    if status == 0 then
        SetVehicleDoorOpen(data.car, data.index, 0, 0)
    else
        SetVehicleDoorShut(data.car, data.index, 0, 0)
    end
end

function openRegulMenu(car)
    Menu.clearMenu()
    Menu.setTitle( "Voiture")
    Menu.setSubtitle( "Réglage régulateur")
    Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "showMenu")

    Menu.addButton("30 km/h", "activRegu", {car = car, vitesse = 30})
    Menu.addButton("50 km/h", "activRegu", {car = car, vitesse = 50})
    Menu.addButton("70 km/h", "activRegu", {car = car, vitesse = 70})
    Menu.addButton("90 km/h", "activRegu", {car = car, vitesse = 90})
    Menu.addButton("130 km/h", "activRegu", {car = car, vitesse = 130})
    Menu.addButton("140 km/h", "activRegu", {car = car, vitesse = 140})

    if setRegu then
        Menu.addButton("Désactiver", "activRegu", {car = car, vitesse = -1})
    end
end

function settingsMenu()
    Menu.clearMenu()
    Menu.setTitle( "Voiture")
    Menu.setSubtitle( "Changer affichage compteur")
    Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "showMenu")

    Menu.addButton("Style 1", "setSpeedmeter", 0, "previewSpeedmeter")
    Menu.addButton("Style 2", "setSpeedmeter", 1, "previewSpeedmeter")
    Menu.addButton("Style 3", "setSpeedmeter", 2, "previewSpeedmeter")

    if setRegu then
        Menu.addButton("Désactiver", "activRegu", {car = car, vitesse = -1})
    end
end

function setSpeedmeter(style)
    TriggerServerEvent("CarMenu:SetSpeedmeter", style)
    defaultStyle = style
    showMenu()
end

function previewSpeedmeter(style)
    if (style == 0) then
        TriggerEvent("Speedmeter:Toggle", true)
        TriggerEvent(
            "Hud:Update",
            {
                action = "toggleSpeedmeter",
                value = false
            }
        )
        TriggerEvent(
            "Hud:Update",
            {
                action = "toggleMiniSpeedmeter",
                value = false
            }
        )
    elseif style == 1 then
        TriggerEvent("Speedmeter:Toggle", false)
        TriggerEvent(
            "Hud:Update",
            {
                action = "toggleSpeedmeter",
                value = true
            }
        )
        TriggerEvent(
            "Hud:Update",
            {
                action = "toggleMiniSpeedmeter",
                value = false
            }
        )
    else
        TriggerEvent("Speedmeter:Toggle", false)
        TriggerEvent(
            "Hud:Update",
            {
                action = "toggleSpeedmeter",
                value = false
            }
        )
        TriggerEvent(
            "Hud:Update",
            {
                action = "toggleMiniSpeedmeter",
                value = true
            }
        )
    end
end

function activRegu(data)
    vitesseRegu = data.vitesse
    local maxSpeed =
        GetVehicleHandlingFloat(GetVehiclePedIsIn(PlayerPedId(), false), "CHandlingData", "fInitialDriveMaxFlatVel")

    local speed = 0
    if (data.vitesse == -1) then
        speed = maxSpeed
        setRegu = false
        cruiseNotification.message = "Régulateur : <span class='red--text'>Désactivé</span>"
    else
        setRegu = true
        speed = (data.vitesse / 3.6)
        cruiseNotification.message = "Régulateur : <span class='green--text'>" .. data.vitesse .. "km/h</span>"
    end

    local cruise = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false))

    if (cruise >= speed) then
        cruiseNotification.message = "Régulateur : <span class='red--text'>Impossible, ralentissez</span>"
    else
        if (cruise == 0) then
            SetVehicleForwardSpeed(data.car, 0.01)
        end
        SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), speed)
        showMenu()
    end

    venato.notify(cruiseNotification)
end

RegisterNetEvent("CarMenu:InitSpeedmeter")
AddEventHandler(
    "CarMenu:InitSpeedmeter",
    function(style)
        defaultStyle = style
        previewSpeedmeter(style)
    end
)
