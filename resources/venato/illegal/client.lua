
farmInProgress = false
transformInProgress = false
sellInProgress = false
drugInProgress = {}

Citizen.CreateThread(function()    

    for _, item in ipairs(drugs) do
        if item.farm then
            GenerateNpc(item.farm)
        end

        if item.transform then
            GenerateNpc(item.transform)
        end

        if item.sell then
            GenerateNpc(item.sell)
        end
    end

    while true do
        Wait(0)
        for i=1, #drugs, 1 do
            if drugs[i].farm then
                distance = GetDistanceBetweenCoords(GetEntityCoords(Venato.GetPlayerPed()), drugs[i].farm.x, drugs[i].farm.y, drugs[i].farm.z, true)
                if distance < 2 then
                    Venato.InteractTxt('Appuyez sur ~INPUT_PICKUP~ pour récupérer de '.. drugs[i].title)
                    if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
                        farmInProgress = true
                        drugInProgress = drugs[i]
                    end
                else
                    farmInProgress = false
                end 
            end
            if drugs[i].transform then
                distance = GetDistanceBetweenCoords(GetEntityCoords(Venato.GetPlayerPed()), drugs[i].transform.x, drugs[i].transform.y, drugs[i].transform.z, true)
                if distance < 2 then
                    Venato.InteractTxt('Appuyez sur ~INPUT_PICKUP~ pour transformer '.. drugs[i].title)
                    if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
                        transformInProgress = true
                        drugInProgress = drugs[i]
                    end
                else
                    transformInProgress = false
                end 
            end
            if drugs[i].sell then
                distance = GetDistanceBetweenCoords(GetEntityCoords(Venato.GetPlayerPed()), drugs[i].sell.x, drugs[i].sell.y, drugs[i].sell.z, true)
                if distance < 2 then
                    Venato.InteractTxt('Appuyez sur ~INPUT_PICKUP~ pour vendre '.. drugs[i].title)
                    if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
                        transformInProgress = true
                        drugInProgress = drugs[i]
                    end
                else
                    transformInProgress = false
                end 
            end
        end           
    end
end)

Citizen.CreateThread(function()    
    while true do
        if farmInProgress or transformInProgress or sellInProgress then
            Citizen.Wait(5000)
            if farmInProgress and drugInProgress then
                print(Venato.dump(drugInProgress))
                print("Farm : "..drugInProgress.title)
            end
            if transformInProgress and drugInProgress then
                print(Venato.dump(drugInProgress))
                print("Transform : "..drugInProgress.title)
            end
            if sellInProgress and drugInProgress then
                print(Venato.dump(drugInProgress))
                print("Sell : "..drugInProgress.title)
            end
        end
    end    
end)

function GenerateNpc(item)
    RequestModel(GetHashKey(item.ped_model))

    while not HasModelLoaded(GetHashKey(item.ped_model)) do
        Wait(1)
    end

    local npc = CreatePed(4, GetHashKey(item.ped_model),
    item.x, item.y, item.z, item.h,
    false, true
    )
    
    SetEntityHeading(npc, item.h)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
end