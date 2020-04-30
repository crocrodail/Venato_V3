-- Register the cuff command.
RegisterServerEvent('police:cuff')
AddEventHandler('police:cuff', function(target, isPolice)
    -- If there is at least 1 argument passed to the command ("/cuff <id>" was used), we want to...
    
    local source = source
    if target ~= nil then
        -- ...cuff the player specified by the argument (server id)
        TriggerClientEvent('anim:cuff', tonumber(target), isPolice, source)
    
    -- There's no arguments passed ("/cuff" was used.) then....
    end
    
    -- And last but not least, make it restricted, only people with the "command.cuff" permission can use this command.
end)


RegisterServerEvent('anim:playerCuffedStatus')
AddEventHandler('anim:playerCuffedStatus', function(status, from)
    -- If there is at least 1 argument passed to the command ("/cuff <id>" was used), we want to...    
    local source = source
    if status then
        -- ...cuff the player specified by the argument (server id)
        TriggerClientEvent('anim:getPlayerCuffedStatus', tonumber(from), status)
    
    -- There's no arguments passed ("/cuff" was used.) then....
    end
    
    -- And last but not least, make it restricted, only people with the "command.cuff" permission can use this command.
end)