local pedIsInVehicule = false
local food = 100
local water = 100
local alcool = 0

Citizen.CreateThread(function() 
        Citizen.Wait(1500)
        TriggerServerEvent("Life:Init") 
        while true do
            local playerPed = PlayerPedId()          
            Citizen.Wait(1000)            
            if not pedIsInVehicule and IsPedInAnyVehicle(playerPed, false) then
                SendNUIMessage(
                    {
                        action = "enterCar"
                    }
                )
                pedIsInVehicule = true
                local car = GetVehiclePedIsIn(playerPed, false)
            end

            if pedIsInVehicule and not IsPedInAnyVehicle(playerPed, false) then
                SendNUIMessage(
                    {
                        action = "leaveCar"
                    }
                )
                pedIsInVehicule = false
            end

            if pedIsInVehicule then
                local car = GetVehiclePedIsIn(playerPed, false)

                if GetIsVehicleEngineRunning(car) then
                    SetVehicleFuelLevel(car, GetVehicleFuelLevel(car)-(GetVehicleCurrentRpm(car)/10))
                end

                SendNUIMessage(
                    {
                        action = "vehiculeStatus",
                        fuel = GetVehicleFuelLevel(car),
                        carHealth = GetEntityHealth(car)
                    }
                )
            end   
            
            if food > 0 then
                food = food - 0.05
            end

            if water > 0 then
                water = water - 0.1
            end

            if alcool > 0 then
                alcool = alcool - 0.2
            end

            SendNUIMessage(
            {
                action = "playerStatus",
                food = food,
                water = water,
                alcool = alcool
            })

            if food <= 0 or water <= 0 then
                TriggerServerEvent("Life: Dead")                
            end

            if food % 1 == 0 or water % 1 == 0 then
                local needs = {
                    food = food,
                    water = water,
                    alcool = alcool
                }
                TriggerServerEvent("Life: Update", needs)
            end
        end
    end
)

RegisterNetEvent("Life:InitStatus")
AddEventHandler("Life:InitStatus", function(needs)
    SendNUIMessage(
        {
            action = "playerStatus",
            food = needs.food,
            water = needs.water,
            alcool = needs.alcool
        }
    )
    food = needs.food
    water = needs.water
    alcool = needs.alcool
end)