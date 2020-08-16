local currentInstance = nil;


Citizen.CreateThread(function()
    while true do
        Wait(1000)
        currentInstance = venato.callServer("instance:get",NetworkGetNetworkIdFromEntity(venato.GetPlayerPed()))
    end
end)

Citizen.CreateThread(function()
    local playerPed = venato.GetPlayerPed()
	while true do
        Citizen.Wait(10)
        if currentInstance then
            for networkEntity,_ in pairs(currentInstance.entitiesToHide) do
                Citizen.Wait(0)
                local entity = NetworkGetEntityFromNetworkId(networkEntity)      
                if entity then
                    SetEntityVisible(entity, false, false)
                    SetEntityCollision(entity, false, false)
                end
            end
            for networkEntity,_ in pairs(currentInstance.entities) do
                Citizen.Wait(0)
                local entity = NetworkGetEntityFromNetworkId(networkEntity)      
                if entity then
                    SetEntityVisible(entity, true, false)
                    SetEntityCollision(entity, true, true)
                end
            end
        end
	end
end)
