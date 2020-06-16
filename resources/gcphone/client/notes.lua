
RegisterNUICallback('notes_getChannels', function(data, cb)
    TriggerServerEvent('gcPhone:notes_getChannels', data["userId"])
end)

RegisterNUICallback('notes_getMessage', function(data, cb)
    TriggerServerEvent('gcPhone:notes_getMessage', data["userId"])
end)


RegisterNetEvent('gcPhone:notes_getChannels')
AddEventHandler('gcPhone:notes_getChannels', function(channels)
    SendNUIMessage({event = 'notes_setChannels', channels = channels})    
end)