local instances = {
}


RegisterServerEvent('instance:addEntity')
AddEventHandler('instance:addEntity', function(instance, networkId)
   TriggerEvent('instance:removeEntity', networkId)
   if not instances[instance] then
    instance[instance] = {
        entities = {}
    }
   end
   instances[instance].entities[networkId] = true
end)

RegisterServerEvent('instance:removeEntity')
AddEventHandler('instance:removeEntity', function(networkId)
    for k, j in pairs(instances) do     
        if j.entities[networkId] then
            j.entities[networkId] = nil
        end
    end
end)


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