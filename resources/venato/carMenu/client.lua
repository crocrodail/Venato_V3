local menuIsOpen = false
local setRegu = false
local defaultNotification = {
    title ="Info. Véhicule",
    logo = "https://i.ibb.co/R466dWy/icons8-sedan-96px.png"
}

local cruiseNotification = {
    title ="Info. Véhicule",
    logo = "https://i.ibb.co/5c5Rcj9/icons8-speedometer-96px.png"
}

Citizen.CreateThread(function ()
    SetNuiFocus(false, false)  
    while true do
      Citizen.Wait(0) 
      if menuIsOpen then
        Venato.GetCarMenuIntruction()
      end
      if IsControlJustPressed(1, Keys['F2']) then
        if menuIsOpen then
            hideMenu()
        else                 
            showMenu()
        end
      end
      if menuIsOpen and (IsControlJustPressed(1, Keys["F3"]) or IsControlJustPressed(1, Keys["BACKSPACE"]) or IsControlJustPressed(1, Keys["K"]) or IsControlJustPressed(1, Keys["F5"])) then
        hideMenu()
      end

    end
end)

function showMenu()
    local car = GetVehiclePedIsIn( PlayerPedId(), false )
    if car ~= 0 then 
        menuIsOpen = true
        Menu.hidden = false
        ClearMenu()
        MenuTitle = "Voiture"
        MenuDescription = "Choisir une action"
        Menu.addButton("~r~↩ Retour", "hideMenu")
        Menu.addButton("Moteur", "toggleEngine", car)
        
        Menu.addButton("Régulateur", "openRegulMenu", car)       
        
        if DoesVehicleHaveDoor(car, 0) then
        Menu.addButton("Portière avant gauche", "openDoor", { car = car, index = 0})
        end

        if DoesVehicleHaveDoor(car, 1) then
        Menu.addButton("Portière avant droite", "openDoor", { car = car, index = 1})
        end

        if DoesVehicleHaveDoor(car, 2) then
        Menu.addButton("Portière arrière gauche", "openDoor", { car = car, index = 2})
        end
                
        if DoesVehicleHaveDoor(car, 3) then
        Menu.addButton("Portière arrière droite", "openDoor", { car = car, index = 3})
        end
        
        if DoesVehicleHaveDoor(car, 4) then
        Menu.addButton("Capot", "openDoor", { car = car, index = 4})
        end
                
        if DoesVehicleHaveDoor(car, 5) then
            Menu.addButton("Coffre", "openDoor", { car = car, index = 5})
        end 

        if DoesVehicleHaveDoor(car, 6) then
            Menu.addButton("Arrière 1", "openDoor", { car = car, index = 6})
        end

        if DoesVehicleHaveDoor(car, 7) then
            Menu.addButton("Arrière 2", "openDoor", { car = car, index = 7})
        end
    end
end

function hideMenu()
    menuIsOpen = false
    Menu.hidden = true
end

function toggleEngine(car)
    if IsVehicleEngineOn(car) then
        defaultNotification.message = "Moteur : <span class='red--text'>éteint</span>";
		SetVehicleEngineOn(car, false, false, true)
    else
        defaultNotification.message = "Moteur : <span class='green--text'>démarré</span>";
		SetVehicleEngineOn(car, true, false, true)
    end
    Venato.notify(defaultNotification)
end

function openDoor(data)
    local status = GetVehicleDoorAngleRatio(data.car, data.index)
    print(status)
    if status == 0 then
        SetVehicleDoorOpen(data.car, data.index, 0, 0) 
    else
        SetVehicleDoorShut(data.car, data.index, 0, 0)
    end
end

function openRegulMenu(car)
    ClearMenu()
    MenuTitle = "Voiture"
    MenuDescription = "Réglage régulateur"
    Menu.addButton("~r~↩ Retour", "showMenu")
    Menu.addButton("30 km/h", "activRegu", {car = car, vitesse = 30})
    Menu.addButton("50 km/h", "activRegu", {car = car, vitesse = 50})
    Menu.addButton("90 km/h", "activRegu", {car = car, vitesse = 90})
    Menu.addButton("130 km/h", "activRegu", {car = car, vitesse = 130})
    Menu.addButton("Désactiver", "activRegu", {car = car, vitesse = -1})
end

function activRegu(data)    
      setRegu = true
      print(GetVehiclePedIsIn( PlayerPedId(), false ))
     
      print(data.vitesse)
      local maxSpeed = GetVehicleHandlingFloat(GetVehiclePedIsIn( PlayerPedId(), false ),"CHandlingData","fInitialDriveMaxFlatVel")
      print(maxSpeed)
      local speed = 0
      if(data.vitesse == -1)then
        speed = maxSpeed
        cruiseNotification.message = "Régulateur : <span class='red--text'>Désactivé</span>"
      else
        speed = (data.vitesse/3.6)
        cruiseNotification.message = "Régulateur : <span class='green--text'>"..data.vitesse.."km/h</span>"
      end

      local cruise = GetEntitySpeed(GetVehiclePedIsIn( PlayerPedId(), false ))
      
      if(cruise >= speed) then
        cruiseNotification.message = "Régulateur : <span class='red--text'>Impossible, ralentissez</span>"
      else
        print(cruise)
        if(cruise == 0) then
            SetVehicleForwardSpeed(data.car,0.01)
        end
        SetEntityMaxSpeed(GetVehiclePedIsIn( PlayerPedId(), false ), speed) 
      end

      Venato.notify(cruiseNotification)

end