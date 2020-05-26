
function NotesGetChannel (userId, cb)    
    MySQL.Async.fetchAll([===[
    SELECT nc.id, channel, MAX(ncm.timestamp) as lastMessage, COUNT(ncm.id) as nbMessage
    FROM notes_channels nc
    LEFT JOIN notes_channels_messages ncm on nc.id = ncm.channelId
    WHERE userId = @userId
    GROUP BY nc.id, channel
    ]===], { ['@userId'] = userId }, cb)
end

function NotesGetMessages (channelId, cb)    
    MySQL.Async.fetchAll([===[
        SELECT * FROM notes_channels_messages WHERE channelId = @channelId
    ]===], { ['@channel'] = channelId }, cb)
end


RegisterServerEvent('gcPhone:notes_getChannels')
AddEventHandler('gcPhone:notes_getChannels', function(id)
    local sourcePlayer = tonumber(source)  
    NotesGetChannel(id, function (channels)
        TriggerClientEvent('gcPhone:notes_getChannels', sourcePlayer, channels)
    end)
end)

RegisterServerEvent('gcPhone:notes_getMessage')
AddEventHandler('gcPhone:notes_getMessage', function(id)
    local sourcePlayer = tonumber(source)  
    NotesGetMessages(id, function (messages)
        TriggerClientEvent('gcPhone:notes_getMessage', sourcePlayer, messages)
    end)
end)