
RegisterNUICallback('tattoo/apply', function(data, cb)
    TriggerEvent('Tattoo:Apply', data)
end)

RegisterNUICallback('tattoo/buy', function(data, cb)
    TriggerEvent('Tattoo:Buy', data)
end)

RegisterNUICallback('tattoo/close', function(data, cb)
    TriggerEvent('Shop:CloseTattoo', data)
end)

RegisterNUICallback('tattoo/key', function(data, cb)
    TriggerEvent('Shop:MovePlayer', data.key)
end)


RegisterNetEvent('Shop:OpenTattoo')
AddEventHandler('Shop:OpenTattoo', function()  
    SendNUIMessage({event = "open", appName = "tattoo"})
    SetNuiFocus(true, true)
end)

RegisterNetEvent('Shop:CloseTattoo')
AddEventHandler('Shop:CloseTattoo', function()  
    SendNUIMessage({event = "close"})
    SetNuiFocus(false, false)
    TriggerEvent('Tattoo:Close')
end)

RegisterNetEvent('Shop:MovePlayer')
AddEventHandler('Shop:MovePlayer', function(key)  
    local player = GetPlayerPed(-1)
    local rot = 5
    local heading = GetEntityHeading(player)
    if key == 'a' then
        heading = heading - rot
    elseif key == 'e' then
        heading = heading + rot
    end
    SetEntityHeading(player, heading)
end)