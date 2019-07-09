RegisterCommand(
    "car",
    function(source, args, rawCommand)
        local playerped = PlayerPedId()
        local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(playerped, 0.0, 8.0, 0.5))
        local veh = args[1]
        if veh == nil then
            veh = "adder"
        end

        Citizen.CreateThread(
            function()
                RequestModel(veh)

                -- wait for the model to load
                while not HasModelLoaded(veh) do
                    Wait(500) -- often you'll also see Citizen.Wait
                end
                color = 0
                -- get the player's position
                local pos = GetEntityCoords(playerPed) -- get the position of the local player ped

                -- create the vehicle
                local vehicle = CreateVehicle(veh, pos.x, pos.y, pos.z, GetEntityHeading(playerPed), true, false)

                if IsPedInAnyVehicle(playerPed, false) then
                    car = GetVehiclePedIsIn(playerPed, false)
                    deleteCar(car)
                end

                -- set the player ped into the vehicle's driver seat
                SetPedIntoVehicle(playerPed, vehicle, -1)

                SetModelAsNoLongerNeeded(veh)
            end
        )
    end
)

RegisterCommand(
    "GetStorePosition",
    function(source, args, rawCommand)
        local pos = GetEntityCoords(PlayerPedId())
        print("{x = " .. pos.x .. ", y = " .. pos.y .. ", z = " .. pos.z .. ", type = 36, vehiculeType = 1, name=''},")
    end
)

RegisterCommand(
    "eat",
    function(source, args, rawCommand)
        TriggerServerEvent("Life:Eat", args[1]+0)
    end
)

RegisterCommand(
    "notify",
    function(source, args, rawCommand)
        SendNUIMessage(
            {
                action = "notify",
                title = "Big News",
                type="info",
                message = "LeGrosBubu est le meilleur",
                logo = "https://firebasestorage.googleapis.com/v0/b/legrosbubu-streamplanner.appspot.com/o/upload%2Flegrosbubu%2FLogo.png?alt=media&token=c05e011e-c4f2-46f2-a672-ec76625e46df",
                timeout = 3500
            }
        )
    end
)

RegisterCommand(
    "drink",
    function(source, args, rawCommand)
        TriggerServerEvent("Life:Drink", args[1]+0)
    end
)

RegisterCommand(
    "removeLast",
    function(source, args, rawCommand)
        local car = GetVehiclePedIsIn(PlayerPedId(), true)
        deleteCar(car)
    end
)

RegisterCommand(
    "refuel",
    function(source, args, rawCommand)
        local car = GetVehiclePedIsIn(PlayerPedId(), false)
        SetVehicleFuelLevel(car, GetVehicleFuelLevel(car)+25)
    end
)

RegisterCommand(
    "enterCar",
    function(source, args, rawCommand)
        SendNUIMessage(
            {
                action = "enterCar"
            }
        )
    end
)

RegisterCommand(
    "leaveCar",
    function(source, args, rawCommand)
        SendNUIMessage(
            {
                action = "leaveCar"
            }
        )
    end
)
