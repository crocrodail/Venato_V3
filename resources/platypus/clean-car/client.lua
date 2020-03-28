
local cleaner = {
    {name = "Garage Central Cleaner", xpoint = 238.438,  ypoint = -757.233,  zpoint = 34.643 },    
}


local defaultNotification = {
    title = "Lavomatic",
    type = "alert",
    logo = "https://i.ibb.co/K6THzfK/icons8-cleaning-service-96px-1.png"
  }

function setMapMarkerCleaner()
    for k,v in ipairs(cleaner)do
        local blip = AddBlipForCoord(v.xpoint, v.ypoint, v.zpoint)
        SetBlipSprite(blip, 100)
        SetBlipColour(blip, 38)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Lavomatic")
        EndTextCommandSetBlipName(blip)
    end
end

Citizen.CreateThread(function()
    setMapMarkerCleaner()
    while true do
        Citizen.Wait(0)
        local ply = platypus.GetPlayerPed()
        local plyCoords = GetEntityCoords(ply, 0)
        for _, item in pairs(cleaner) do
          local distance = GetDistanceBetweenCoords(item.xpoint, item.ypoint, item.zpoint,  plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
          if distance < 5 then
            DrawMarker(25,item.xpoint, item.ypoint, item.zpoint,0,0,0,0,0,0,0.5,0.5,0.5,0,55,118,189,0,0,0,0)
            if distance <= 2 then
                defaultNotification.title = item.name
                platypus.InteractTxt("Appuyez sur la touche ~INPUT_CONTEXT~ pour nettoyer votre voiture (10€).")
                if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then -- press action contextuel (e) pour joueur clavier uniquement                
                    local current = GetPlayersLastVehicle(platypus.GetPlayerPed(), true)
                    if current == nil then
                        defaultNotification.message = "Le véhicule n'est pas détecté par les capteurs, montez dedans et réessayer."
                        platypus.notify(defaultNotification)
                    else
                        SetVehicleDirtLevel(car, 10)
                        print(GetVehicleDirtLevel(car))
                        if(GetVehicleDirtLevel(car) <= 0.5) then
                            defaultNotification.message = 'Votre véhicule est propre'
                            defaultNotification.timeout = 3500
                            platypus.notify(defaultNotification)
                        else
                            TriggerServerEvent("CleanCar:Clean")
                        end
                    end
                end
            end
          end
        end
    end
end)


RegisterNetEvent("CleanCar:Clean:ok")
AddEventHandler("CleanCar:Clean:ok", function()
    local car = GetPlayersLastVehicle(platypus.GetPlayerPed(), true)
    local dirt = GetVehicleDirtLevel(car)
    local effiency = 0.5

    local time = dirt/effiency * 1000
    print(dirt)
    print(time)
    defaultNotification.timeout = time
    defaultNotification.message = "Nettoyage en cours..."
    platypus.notify(defaultNotification)
    Citizen.Wait(time)
    SetVehicleDirtLevel(car, 0)
    defaultNotification.timeout = 3500
    defaultNotification.message = "Vous pouvez récupérer votre véhicule"
    platypus.notify(defaultNotification)
end)

RegisterNetEvent("CleanCar:Clean:ko")
AddEventHandler("CleanCar:Clean:ko", function(paymentCB)    
    defaultNotification.timeout = 10000
    defaultNotification.message = paymentCB.message
    platypus.notify(defaultNotification)  
end)