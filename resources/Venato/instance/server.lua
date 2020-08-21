local instances = {
}


RegisterServerEvent('instance:addEntity')
AddEventHandler('instance:addEntity', function(instance, networkId)
    removeEntityFunc(networkId)
    addEntity(instance, networkId)
end)

RegisterServerEvent('instance:removeEntity')
AddEventHandler('instance:removeEntity', function(networkId)
    removeEntityFunc(networkId)
end)

function removeEntityFunc(networkId)
    removeEntity(networkId)
end


RegisterServerEvent('instance:addPlayer')
AddEventHandler('instance:addPlayer', function(instance, networkId, playerId)
    if networkId == 0 then
        return
    end
    removePlayerFunc(networkId, playerId)
    addEntity(instance, networkId)
    MySQL.Async.execute("UPDATE users SET instance = @instance WHERE identifier = @identifier",{ ["@identifier"] = playerId,  ["@instance"] = instance}, function()
    end)
end)

RegisterServerEvent('instance:removePlayer')
AddEventHandler('instance:removePlayer', function(networkId, playerId)
    removePlayerFunc(networkId, playerId)
end)

function removePlayerFunc(networkId, playerId)
    removeEntity(networkId)
    MySQL.Async.execute("UPDATE users SET instance = NULL WHERE identifier = @identifier",{ ["@identifier"] = playerId }, function()
    end)
end


function addEntity(instance, networkId)
    if not instances[instance] then
    instances[instance] = {
        id = instance,
        entities = {}
    }
   end
   instances[instance].entities[networkId] = true
end

function removeEntity(networkId)
    for k, j in pairs(instances) do     
        if j.entities[networkId] then
            j.entities[networkId] = nil
        end
    end
end



RegisterServerEvent('instance:get')
AddEventHandler('instance:get', function(networkId)
    local entitiesToHide = {}
    local currentInstance = nil
	for k, j in pairs(instances) do     
        if j.entities[networkId] then
            currentInstance = j
            DataPlayers[tonumber(source)].Instance = k
        else
          for index, needToBeHide in pairs(j.entities) do
            if needToBeHide then   
                entitiesToHide[index] = index 
            end
          end
        end
    end

    if not currentInstance then
        currentInstance = { 
            id = -1,
            label = "Global",
            entitiesToHide = entitiesToHide,
            entities = {}
        }
        DataPlayers[tonumber(source)].Instance = nil
    else
        currentInstance['entitiesToHide'] = entitiesToHide
    end

    TriggerClientEvent('instance:get:cb', source, currentInstance)
end)