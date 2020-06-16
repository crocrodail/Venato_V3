local closetPed = nil
local sellInProgress = false
local pedType = 0
--TODO oldPed Array for not resell drugs to same ped
local oldped = {nil}

local accept = 50;
local callPolice = 10;
local displayMenu = false;

local variation = 10;

local voice_male = {"A_M_M_BEACH_01_WHITE_MINI_02","A_M_M_BEACH_02_BLACK_FULL_01","A_M_M_BEACH_02_WHITE_FULL_01"}
local voice_female = {"A_F_M_SALTON_01_WHITE_FULL_01","A_F_M_KTOWN_02_KOREAN_FULL_01","A_F_M_EASTSA_02_LATINO_FULL_01"}


local defaultNotification = {
    title = "Vente de drogue",
    type = "alert",
    logo = "https://i.ibb.co/PxrBpGQ/icons8-pills-96px.png",
    timeout = 900
}

local commandHelp = {
    id = "sellDrugs",
    command = "G",
    icon = "https://i.ibb.co/PxrBpGQ/icons8-pills-96px.png",
    text = "Vendre de la drogue"
  }
  
  local isCommandAdded = nil;

function sellDrugs(drug) 
    sellInProgress = false
    venato.DisableAllControlActions(true)
    TaskStandStill(venato.GetPlayerPed(), 2500)

    venato.playAnim({lib = "mp_common", flag= 48, anim = "givetake2_a", useLib = true})
    local x, y, z = table.unpack(GetEntityCoords(venato.GetPlayerPed(), true))                
    local playerHeading = GetEntityHeading(venato.GetPlayerPed())
    SetEntityHeading(closetPed, playerHeading-180.0)
    -- SetEntityCoords(closetPed, x+0.7, y+0.7, z-1)
    TaskPlayAnim(closetPed,"mp_common", "givetake2_b" ,8.0, -8.0, -1, 0, 0, false, false, false )

    venato.DisableAllControlActions(false)
    PlayAmbientSpeech1(closetPed,"GENERIC_BYE", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR",0) 
    TriggerEvent('Menu:Close')
    TriggerServerEvent('illegal:v2:sell', { drugId = drug.id, price = drug.price, variation = variation })
    displayMenu = false
end

function has_value(tab, field, val)
    for index, value in pairs(tab) do
        if value[field] == val then
            return true
        end
    end

    return false
end

function has_index(tab, val)
    for index, value in pairs(tab) do
        if index == val then
            return true
        end
    end

    return false
end

function filter(tab, filterIter)
    local out = {}

    for k, v in pairs(tab) do
        if filterIter(v, k, t) then out[k] = v end
    end

    return out
end

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(500)
            --print("Start Repeat")
            if not sellInProgress then
                local x, y, z = table.unpack(GetEntityCoords(venato.GetPlayerPed(), true))
                local outped = {}
                local closePed = {}
                local handle, ped = GetClosestPed(x, y, z, 20.0,  1, 0, outPed, 1, 1, -1)   
                local pos = GetEntityCoords(ped)
                local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, x, y, z, true)
                local pedNotFound = true
                if distance < 15.0 then
                    if IsPedInAnyVehicle(venato.GetPlayerPed()) == false then
                        if DoesEntityExist(ped) then
                            if IsPedDeadOrDying(ped) == false then
                                if IsPedInAnyVehicle(ped) == false then
                                    pedType = GetPedType(ped)
                                    if (pedType == 4 or pedType == 5) and IsPedAPlayer(ped) == false then
                                        currentped = pos
                                        if distance <= 3.5 and ped ~= venato.GetPlayerPed() and not has_index(oldped,ped) then
                                            has = true
                                            if has == true then
                                                pedNotFound = false
                                                closetPed = ped
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                if(pedNotFound) then
                    closetPed = nil
                end
            end
        end
    end
)


Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if DataPlayer and DataPlayer.Inventaire and has_value(DataPlayer.Inventaire, "canBeSellToNPC", 1) then
        if closetPed ~= nil or sellInProgress then
            if not isCommandAdded then
                TriggerEvent('Commands:Add', commandHelp)
                isCommandAdded = closetPed
            end
            if IsControlJustPressed(1, Keys['G']) then
                oldped[closetPed] = closetPed
                local randomNumber = math.random(0, 100)
                sellInProgress = true
                if(randomNumber >= accept) then
                    defaultNotification.message = "La personne vous achète de la drogue." 
                    venato.notify(defaultNotification)               
                    PlayAmbientSpeech1(closetPed,"GENERIC_YES", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR",0) 
                    TaskPlayAnim(closetPed,"gestures@m@standing@casual",'gesture_pleased' ,8.0, -8.0, -1, 0, 0, false, false, false )                                                
                elseif randomNumber <= callPolice then
                    defaultNotification.message = "La personne fuit et appelle la police."
                    venato.notify(defaultNotification)
                    TaskStandStill(closetPed, 1000)
                    TaskPlayAnim(closetPed,"amb@code_human_cower_stand@male@react_cowering",'base_right' ,8.0, -8.0, -1, 0, 0, false, false, false )                
                    PlayAmbientSpeech1(closetPed,"GENERIC_INSULT_MED", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR",0)
                    AddShockingEventForEntity(99, venato.GetPlayerPed(), 10.0)
                    sellInProgress = false
                else
                    defaultNotification.message = "La personne à refusé." 
                    venato.notify(defaultNotification)
                    TaskStandStill(closetPed, 2000)
                    
                    PlayAmbientSpeech1(closetPed,"GENERIC_NO", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR",0)

                    TaskPlayAnim(closetPed,"gestures@m@standing@casual",'gesture_head_no' ,8.0, -8.0, -1, 0, 0, false, false, false )                
                    sellInProgress = false
                end
            end
        elseif isCommandAdded then
            TriggerEvent('Commands:Remove', commandHelp.id)
            isCommandAdded = nil
        end
    end
 end
end)




Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
      if closetPed ~= nil and sellInProgress then 
        TaskStandStill(closetPed, 2500)    
        local x, y, z = table.unpack(GetEntityCoords(venato.GetPlayerPed(), true))
        local pos = GetEntityCoords(closetPed)
        local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, x, y, z, true)
        if(distance < 2.0) then
            if(not displayMenu) then
                displayMenu = true
                print("Init Menu")
                TriggerEvent('Menu:Clear')
                TriggerEvent('Menu:Init', "Vente de drogue", "Choissez la drogue à vendre", "#66bb6aBF", "https://www.wklaw.com/wp-content/uploads/2013/03/Possession-of-Drugs-for-Sale-in-California-Drug-Defense-Attorneys.jpg" )
                for k, item in pairs(filter(DataUser.Inventaire, function(o, k, i) return o["canBeSellToNPC"] == 1 end)) do
                    TriggerEvent('Menu:AddShopButton', item.libelle, "sellDrugs", item, item.picture, (tonumber(item.price) - variation) .. "€ - " .. (tonumber(item.price) + variation) .. "€", 0)
                end
                TriggerEvent('Menu:CreateMenu')
                TriggerEvent('Menu:Open')
                displayMenu = true
            end
        elseif(distance > 10.0) then  
            sellInProgress = false
            PlayAmbientSpeech1(closetPed,"GENERIC_INSULT_HIGH", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR",0)
            displayMenu = false
        end
      end
    end
end)
