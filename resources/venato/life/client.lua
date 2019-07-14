local pedIsInVehicule = false
local food = 100
local water = 100
local alcool = 0
local old_water = 0
local old_food = 0
local reserveTrigger = false

Citizen.CreateThread(
    function()
        Citizen.Wait(1500)
        TriggerServerEvent("Life:Init")
        while true do
            local playerPed = PlayerPedId()
            Citizen.Wait(1000)
            if not pedIsInVehicule and IsPedInAnyVehicle(playerPed, false) then
                TriggerEvent(
                    "Hud:Update",
                    {
                        action = "enterCar"
                    }
                )
                pedIsInVehicule = true
                local car = GetVehiclePedIsIn(playerPed, false)
            end

            if pedIsInVehicule and not IsPedInAnyVehicle(playerPed, false) then
                TriggerEvent(
                    "Hud:Update",
                    {
                        action = "leaveCar"
                    }
                )
                pedIsInVehicule = false
            end

            if pedIsInVehicule then
                local car = GetVehiclePedIsIn(playerPed, false)

                if GetIsVehicleEngineRunning(car) then
                    SetVehicleFuelLevel(car, GetVehicleFuelLevel(car) - (GetVehicleCurrentRpm(car) / 10))
                end
                
                if(GetVehicleFuelLevel(car) > 20) then
                    reserveTrigger = false
                end
                                
                if(GetVehicleFuelLevel(car) < 20 and not reserveTrigger) then
                    local defaultNotification = {
                        title ="Info. Véhicule",
                        type = "danger",
                        logo = "https://i.ibb.co/CBxPS3F/icons8-gas-station-96px-1.png",
                        message = "Vous êtes dans la résèrve",
                        timeout = "5000"
                    }
                    Venato.notify(defaultNotification)
                    reserveTrigger = true;
                end

                TriggerEvent(
                    "Hud:Update",
                    {
                        action = "vehiculeStatus",
                        fuel = GetVehicleFuelLevel(car),
                        carHealth = GetEntityHealth(car),
                        speed = GetVehicleDashboardSpeed(car) * 1.60934
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

            TriggerEvent(
                    "Hud:Update",
                {
                    action = "playerStatus",
                    food = food,
                    water = water,
                    alcool = alcool
                }
            )

            if food <= 0 or water <= 0 then
                SetEntityHealth(GetPlayerPed(-1), 0)
                if food <= 0 then
                    food = 25
                end
                if water <= 0 then
                    water = 25
                end
                old_food = food
                old_water = water
                
                local needs = {
                    food = Venato.Round(food, 2),
                    water = Venato.Round(water, 2),
                    alcool = Venato.Round(alcool, 2)
                }

                TriggerServerEvent("Life:UpdateDB", needs)
                TriggerServerEvent("Life: Dead")
            end

            local needs = {
                food = Venato.Round(food, 2),
                water = Venato.Round(water, 2),
                alcool = Venato.Round(alcool, 2)
            }
            TriggerServerEvent("Life:Update", needs)

            if old_food - food >= 0.5 or old_water - water >= 0.5 then
                old_food = food
                old_water = water
                TriggerServerEvent("Life:UpdateDB", needs)
            end
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(0)
        while true do
            Citizen.Wait(10)
            local playerPed = PlayerPedId()
            if IsPedInAnyVehicle(playerPed, false) then
                local car = GetVehiclePedIsIn(playerPed, false)
                TriggerEvent(
                    "Hud:Update",
                    {
                        action = "speed",
                        speed = GetEntitySpeed(car) * 3.6
                    }
                )
            end
        end
    end
)

RegisterNetEvent("Life:InitStatus")
AddEventHandler(
    "Life:InitStatus",
    function(needs)
        TriggerEvent(
            "Hud:Update",
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
        old_food = food
        old_water = water
    end
)

RegisterNetEvent("Life:UpdateState")
AddEventHandler(
    "Life:UpdateState",
    function(needs)
        TriggerEvent(
            "Hud:Update",
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
        old_food = food
        old_water = water
    end
)
