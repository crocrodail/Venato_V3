function GenerateNpcAutoEcole()
    RequestModel(GetHashKey(configAutoEcole.ped_model))

    while not HasModelLoaded(GetHashKey(configAutoEcole.ped_model)) do
        Wait(1)
    end

    RequestModel(GetHashKey("cs_tom"))

    while not HasModelLoaded(GetHashKey("cs_tom")) do
        Wait(1)
    end

    local npc = CreatePed(4, GetHashKey(configAutoEcole.ped_model),
    configAutoEcole.x, configAutoEcole.y, configAutoEcole.z, configAutoEcole.h,
    false, true
    )

    SetEntityHeading(npc, configAutoEcole.h)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)

    return npc
end


Citizen.CreateThread(function()
    Citizen.Wait(10000) 
    GenerateNpcAutoEcole()
    while true do
        Citizen.Wait(0) -- Obligatoire pour eviter de crash
        local x,y,z = table.unpack(GetEntityCoords(platypus.GetPlayerPed(), true)) -- Permet de recuperer la position du joueur
        if Vdist(x, y, z, configAutoEcole.x, configAutoEcole.y, configAutoEcole.z) < 2 then
            platypus.InteractTxt('Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu')
            if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
                openmenuautoecole()
            end
        end
    end  
end)
RegisterNetEvent('AutoEcole:GetQuestionForCode')
    AddEventHandler('AutoEcole:GetQuestionForCode', function(data)
        SendNUIMessage({
            action = "sendQuestions",
            questions = data
        })
        
end)
RegisterNetEvent('AutoEcole:OpencodeOrOpenpermis')
    AddEventHandler('AutoEcole:OpencodeOrOpenpermis', function(data)
        if data == "code" then
            Menu.addButton("Code de la route", "openmenucode", nil, '', 'https://img.icons8.com/dusk/64/000000/car.png')
        elseif data == "permis" then
            Menu.addButton("Permis voiture", "carLicense", nil, '', 'https://img.icons8.com/dusk/64/000000/car.png')
            Menu.addButton("Permis camion", "truckLicense", nil, '', 'https://img.icons8.com/color/64/000000/food-truck.png')
            Menu.addButton("Permis moto", "motoLicense", nil, '', 'https://img.icons8.com/officel/64/000000/motorcycle.png')
        end
end)
function openmenuautoecole()
    Menu.clearMenu()
    Menu.open()
    TriggerEvent('Menu:Init', "", "Bienvenue dans le menu de l'auto-école !", "#F9A82599", "https://cdn.discordapp.com/attachments/618546482135433226/618546497373339653/20181216224111_1.jpg")
    Menu.addButton("<span class='red--text'>Fermer</span>", "closemenuautoecole")
    TriggerServerEvent("AutoEcole:CodeOuPermis")
end
function openmenucode()
    SetNuiFocus(true, true)
    open = true
    SendNUIMessage({
        action = "openCodeAutoEcole",
    })
end
function getCarForLicense(vehicle)
    local randomKey = math.random(1,21)
    for k,v in pairs(configAutoEcole.parking_place) do 
        Citizen.Wait(0)
        if k == randomKey then
            local vehiculeDetected = GetClosestVehicle(v.x, v.y, v.z, 4.0, 0, 70)
            if not DoesEntityExist(vehiculeDetected) then
                platypus.CreateVehicle(GetHashKey(vehicle), {x = v.x, y = v.y, z = v.z}, v.h, function(vhl)
                    local npc2 = CreatePed(4, GetHashKey("cs_tom"))
                    if vehicle ~= "tmax" then
                        FreezeEntityPosition(npc2, true)
                        SetEntityInvincible(npc2, true)
                        SetBlockingOfNonTemporaryEvents(npc2, true)
                        SetPedIntoVehicle(npc2, vhl, 0)
                    end
                    SetPedIntoVehicle(platypus.GetPlayerPed(), vhl, -1)
                    closemenuautoecole() 
                end)
            else
                getCarForLicense(vehicle)
            end
        end
    end
end
function vehicleDetected(randomKey, callback)
    local vehiculeDetected = GetClosestVehicle(configAutoEcole.parking_place[randomKey].x, configAutoEcole.parking_place[randomKey].y, configAutoEcole.parking_place[randomKey].z, 4.0, 0, 70)
    if not DoesEntityExist(vehiculeDetected) then
        return callback(randomKey)
    else
        vehicleDetected(math.random(1, #configAutoEcole.parking_place), callback)
    end
end

function drawMarkerForCourse(index, randomKey, callback)
    if index <= #configAutoEcole.Course then        
        -- Create marker point
        DrawMarker(2, configAutoEcole.Course[index].x, configAutoEcole.Course[index].y, configAutoEcole.Course[index].z + 1, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 2.0, 2.0, 2.0, 0,150,255,200, false, true, 2, nil, nil, false)
    elseif index == 18 then
        ClearGpsMultiRoute()
            -- Parking place marker for park the car
        vehicleDetected(randomKey, function(key)
            DrawMarker(2, configAutoEcole.parking_place[key].x, configAutoEcole.parking_place[key].y, configAutoEcole.parking_place[key].z + 1, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 2.0, 2.0, 2.0, 0,150,255,200, false, true, 2, nil, nil, false)
            return callback(key)
        end);
    end
end

function getResult()
    
end

function doTheCourse()
    Citizen.CreateThread(function()
        local index = 17
        local randomKey = math.random(1, #configAutoEcole.parking_place)
        -- Je set une première fois le GPS
        ClearGpsMultiRoute()
        StartGpsMultiRoute(6, true, false)
        AddPointToGpsMultiRoute(configAutoEcole.Course[index].x, configAutoEcole.Course[index].y, configAutoEcole.Course[index].z)
        SetGpsMultiRouteRender(true)
        while true do 
            Citizen.Wait(0)
            local x,y,z = table.unpack(GetEntityCoords(platypus.GetPlayerPed(), true))
            if index <= #configAutoEcole.Course then
                drawMarkerForCourse(index)
                if Vdist(x, y, z, configAutoEcole.Course[index].x, configAutoEcole.Course[index].y, configAutoEcole.Course[index].z) < 5 then
                    -- Une fois qu'il à atteind le point GPS on passe à l'autre
                    ClearGpsMultiRoute()
                    StartGpsMultiRoute(6, true, false)
                    AddPointToGpsMultiRoute(configAutoEcole.Course[index].x, configAutoEcole.Course[index].y, configAutoEcole.Course[index].z)
                    SetGpsMultiRouteRender(true) 
                    index = index + 1    
                end 
            else
                -- Call parking place marker function for park the car
                drawMarkerForCourse(index, randomKey, function(key)
                    randomKey = key
                end)
                if Vdist(x, y, z, configAutoEcole.parking_place[randomKey].x, configAutoEcole.parking_place[randomKey].y, configAutoEcole.parking_place[randomKey].z) < 1 then
                    break;
                    -- Its the end of the exam, now call result

                end
            end 
        end
    end)
end
doTheCourse();

function carLicense()
    getCarForLicense("cooperworks")
    doTheCourse()
end
function truckLicense()
    getCarForLicense("phantom")
    doTheCourse()
end
function motoLicense()
    getCarForLicense("tmax")
    doTheCourse()
end

function closemenuautoecole()
    Menu.close()
end