RegisterServerEvent('door:update')
AddEventHandler('door:update', function(id, isLocked)
    if (id ~= nil and isLocked ~= nil) then -- Make sure values got sent
    TriggerClientEvent('door:state', -1, id, isLocked)
    end
end)
