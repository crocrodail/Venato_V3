
farmInProgress = false
transformInProgress = false
sellInProgress = false
drugInProgress = {}
nbPolice = 0
old_nbPolice = 0

Citizen.CreateThread(function()

    while true do
        Wait(0)
        for i=1, #drugs, 1 do
            if drugs[i].farm then
                distance = GetDistanceBetweenCoords(GetEntityCoords(Venato.GetPlayerPed()), drugs[i].farm.x, drugs[i].farm.y, drugs[i].farm.z, true)
                if distance < 2 and nbPolice > 0 then
                    if not farmInProgress then
                        Venato.InteractTxt('Appuyez sur ~INPUT_PICKUP~ pour récupérer de '.. drugs[i].title)
                    else
                        Venato.InteractTxt('Récupération de '.. drugInProgress.title .. ' en cours ...')
                    end
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
                if distance < 2 and nbPolice > 0 then
                    if not transformInProgress then
                        Venato.InteractTxt('Appuyez sur ~INPUT_PICKUP~ pour transformer '.. drugs[i].title)
                    else
                        Venato.InteractTxt('Transformation de '.. drugInProgress.title .. ' en cours ...')
                    end
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
                if distance < 2 and nbPolice > 0 then
                    if not sellInProgress then
                    Venato.InteractTxt('Appuyez sur ~INPUT_PICKUP~ pour vendre '.. drugs[i].title)
                    else
                        Venato.InteractTxt('Vente de '.. drugInProgress.title .. ' en cours ...')
                    end
                    if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
                        sellInProgress = true
                        drugInProgress = drugs[i]
                    end
                else
                    sellInProgress = false
                end 
            end
        end           
    end
end)

Citizen.CreateThread(function()    
    while true do
        Citizen.Wait(0)        
        if farmInProgress or transformInProgress or sellInProgress then
            Citizen.Wait(5000)
            if farmInProgress and drugInProgress then                
                TaskPlayAnim(drugInProgress.farm.npc,"mp_common", "givetake2_b" ,8.0, -8.0, -1, flag, 0, false, false, false )
                TriggerServerEvent("illegal:farm", drugInProgress.id)
            end
            if transformInProgress and drugInProgress then
                TaskPlayAnim(drugInProgress.transform.npc,"mp_common", "givetake2_b" ,8.0, -8.0, -1, flag, 0, false, false, false )
                TriggerServerEvent("illegal:transform", drugInProgress.id)
            end
            if sellInProgress and drugInProgress then
                TaskPlayAnim(drugInProgress.sell.npc,"mp_common", "givetake2_b" ,8.0, -8.0, -1, flag, 0, false, false, false )
                TriggerServerEvent("illegal:sell", drugInProgress.id)
            end
            if(farmInProgress or transformInProgress or sellInProgress) then
                Venato.playAnim({lib = "mp_common", anim = "givetake2_a", useLib = true})
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

    return npc
end

RegisterNetEvent('illegal:setcop')
AddEventHandler("illegal:setcop", function(nbPolicier)
    old_nbPolice = nbPolice
    nbPolice = 1
    if old_nbPolice == 0 --and nbPolice > 0
    then
        for _, item in ipairs(drugs) do
            if item.farm then
                item.farm.npc = GenerateNpc(item.farm)
            end
    
            if item.transform then
                item.transform.npc = GenerateNpc(item.transform)
            end
    
            if item.sell then
                item.sell.npc = GenerateNpc(item.sell)
            end
        end        
    end

    if old_nbPolice > 0 and nbPolice == 0 
    then    
        for _, item in ipairs(drugs) do
            if item.farm then
                DeleteEntity(item.farm.npc)
            end
    
            if item.transform then
                DeleteEntity(item.transform.npc)
            end
    
            if item.sell then
                DeleteEntity(item.sell.npc)
            end
        end
    end
end)


Citizen.CreateThread(function()
	while true do
        TriggerServerEvent('police:getAllCopsInServiceNb')
        Citizen.Wait(60000)        
	end
end)