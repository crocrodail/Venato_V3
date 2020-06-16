
local farmInProgress = false
local transformInProgress = false
local sellInProgress = false
local drugInProgress = {}
local nbPolice = 0
local old_nbPolice = 0
local is_on_farm_zone = false
local is_on_transform_zone = false
local is_on_sell_zone = false

local defaultNotification = {
  title = 'Illégal',
  type = "alert",
  logo = "https://cdn.pixabay.com/photo/2017/05/15/21/58/drug-icon-2316244_960_720.png"
}


local commandHelp = {
    id = "recoltWeed",
    command = "E",
    icon = "https://i.ibb.co/jfwZ8kB/icons8-cannabis-48px.png",
    text = "Recolter"
}

local isCommandAdded = false;

local checkInterval = 30
local minWeed = 2
local maxWeed = 10

Citizen.CreateThread(function()
    while true do
        Wait(0)
        for i=1, #drugs, 1 do
            if drugs[i].farm then
                distance = GetDistanceBetweenCoords(GetEntityCoords(venato.GetPlayerPed()), drugs[i].farm.x, drugs[i].farm.y, drugs[i].farm.z, true)
                if distance < 2 then --and nbPolice > 0 then
                    is_on_farm_zone = true
                    if not farmInProgress then
                        venato.InteractTxt('Appuyez sur ~INPUT_PICKUP~ pour récupérer de '.. drugs[i].title)
                    else
                        venato.InteractTxt('Récupération de '.. drugInProgress.title .. ' en cours ...')
                    end
                    if IsControlJustPressed(1, Keys['E']) and GetLastInputMethod(2) then
                        farmInProgress = true
                        drugInProgress = drugs[i]
                    end
                end
            end
            if drugs[i].transform then
                distance = GetDistanceBetweenCoords(GetEntityCoords(venato.GetPlayerPed()), drugs[i].transform.x, drugs[i].transform.y, drugs[i].transform.z, true)
                if distance < 2 then --and nbPolice > 0 then
                    is_on_transform_zone = true
                    if not transformInProgress then
                        venato.InteractTxt('Appuyez sur ~INPUT_PICKUP~ pour transformer '.. drugs[i].title)
                    else
                        venato.InteractTxt('Transformation de '.. drugInProgress.title .. ' en cours ...')
                    end
                    if IsControlJustPressed(1, Keys['E']) and GetLastInputMethod(2) then
                        transformInProgress = true
                        drugInProgress = drugs[i]
                    end
                end
            end
            if drugs[i].sell then
                distance = GetDistanceBetweenCoords(GetEntityCoords(venato.GetPlayerPed()), drugs[i].sell.x, drugs[i].sell.y, drugs[i].sell.z, true)
                if distance < 2 then --and nbPolice > 0 then
                    is_on_sell_zone = true
                    if not sellInProgress then
                        venato.InteractTxt('Appuyez sur ~INPUT_PICKUP~ pour vendre '.. drugs[i].title)
                    else
                        venato.InteractTxt('Vente de '.. drugInProgress.title .. ' en cours ...')
                    end
                    if IsControlJustPressed(1, Keys['E']) and GetLastInputMethod(2) then
                      if nbPolice > 0 then
                        sellInProgress = true
                        drugInProgress = drugs[i]
                      else
                        defaultNotification.message = "Il n'y a pas assez d'agent en service pour vendre"
                        venato.notify(defaultNotification)
                      end
                    end
                end
            end
        end

        if not is_on_farm_zone then
            farmInProgress = false
        end
        if not is_on_transform_zone then
            transformInProgress = false
        end
        if not is_on_sell_zone then
            sellInProgress = false
        end

        is_on_farm_zone = false
        is_on_transform_zone = false
        is_on_sell_zone = false
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
                venato.playAnim({lib = "mp_common", flag= 48, anim = "givetake2_a", useLib = true})
            end

        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local closeWeed = GetClosestObjectOfType(GetEntityCoords(venato.GetPlayerPed()), 1.3, GetHashKey("bkr_prop_weed_lrg_01b"), false, false, false)
        local closeWeedMedium = GetClosestObjectOfType(GetEntityCoords(venato.GetPlayerPed()), 1.3, GetHashKey("bkr_prop_weed_med_01a"), false, false, false)
        if closeWeed ~= 0 and IsEntityVisible(closeWeed) then
            
            if not isCommandAdded then
                TriggerEvent('Commands:Add', commandHelp)
                isCommandAdded = true
            end
            if IsControlJustPressed(1, 38) then
                local recipe = {
                    animLib="amb@world_human_gardener_plant@male@base",
                    animName="base",
                    animTimeout= 8933,
                    ingredients = {nil},
                    results = {nil}
                }

                recipe.results[29] = {quantity = math.random(minWeed, maxWeed)}

                venato.Craft(recipe)
                TriggerServerEvent('illegal:weed:recolt', GetEntityCoords(closeWeed))
                SetEntityVisible(closeWeed, false)
                SetEntityVisible(closeWeedMedium, false)
            end            
        elseif isCommandAdded then
            TriggerEvent('Commands:Remove', commandHelp.id)
            isCommandAdded = false
        end
    end
end)

-- Trigger despawn check (set interval in config).
Citizen.CreateThread(function()    
	while true do
        TriggerServerEvent('illegal:weed:check')
        Citizen.Wait(intervals.check*1000)
    end
end)


RegisterNetEvent('illegal:weed:checkResult')
AddEventHandler("illegal:weed:checkResult", function(recolts)
    for i=1,#recolts,1 do 
        local weedPlantLarge = GetClosestObjectOfType(recolts[i].pos, 1.0, GetHashKey("bkr_prop_weed_lrg_01b"), false, false, false)
        local weedPlantMedium= GetClosestObjectOfType(recolts[i].pos, 1.0, GetHashKey("bkr_prop_weed_med_01a"), false, false, false)        
        if weedPlantLarge ~= nil then
            if (recolts[i].progress >= 100) then
                SetEntityVisible(weedPlantLarge, true)
                SetEntityVisible(weedPlantMedium, true)
            elseif(recolts[i].progress >= 50) then
                SetEntityVisible(weedPlantLarge, false)
                SetEntityVisible(weedPlantMedium, true)
            elseif(recolts[i].progress < 50) then
                SetEntityVisible(weedPlantLarge, false)
                SetEntityVisible(weedPlantMedium, false)
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
    nbPolice = nbPolicier    
end)


Citizen.CreateThread(function()
  Citizen.Wait(10000)
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
	while true do
        TriggerServerEvent('police:getAllCopsInServiceNb')
        Citizen.Wait(60000)
	end
end)


table.filter = function(t, filterIter)
    local out = {}
  
    for k, v in pairs(t) do
      if filterIter(v, k, t) then out[k] = v end
    end
  
    return out
  end