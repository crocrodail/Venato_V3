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
        TriggerEvent('Hud:Update',
            {
                action = "notify",
                title = "Big News",
                type="info",
                message = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ultrices dictum ex id mattis. Pellentesque rutrum nisl a ligula commodo, a molestie mauris aliquet. Fusce consectetur nec orci et euismod. Nam et nibh vel odio finibus suscipit. Duis dictum sapien nec ligula rutrum ullamcorper. Duis fermentum felis neque, ac scelerisque dui lacinia nec. Cras hendrerit diam eget rutrum ultrices. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Praesent bibendum velit nec velit efficitur aliquam. Curabitur fringilla, sem sed tempor dapibus, dolor elit venenatis lorem, id sagittis turpis orci sit amet massa. Integer sed laoreet sapien. Maecenas vestibulum blandit tellus eget sodales. Phasellus in ullamcorper nisi. Donec nec consectetur neque. Nam dignissim lorem vel erat accumsan semper. Phasellus maximus et libero id tincidunt.              Suspendisse iaculis nunc et commodo auctor. Sed et commodo lectus. Sed mollis feugiat malesuada. Praesent odio ipsum, laoreet eu est quis, rhoncus rhoncus dolor. Pellentesque posuere enim mauris, vulputate sollicitudin risus mattis id. Aliquam sed rhoncus lectus. Proin justo felis, aliquam ac consectetur at, condimentum ut libero. Integer libero ligula, vulputate et elit a, bibendum suscipit magna. Nunc a tortor sagittis, laoreet ante ac, bibendum nulla. Duis ut purus pellentesque, mollis augue vitae, sodales ex. Duis a dapibus felis, in placerat velit.              Suspendisse aliquet, justo sed porta tempor, risus elit condimentum turpis, et congue lorem urna at enim. Fusce malesuada nec enim et rutrum. Suspendisse consectetur finibus diam, rutrum volutpat eros. Nulla facilisi. Mauris sodales nulla sit amet odio luctus, quis molestie nisl ultrices. Pellentesque rutrum sagittis fringilla. Nunc nec cursus nisl.",
                logo = "https://firebasestorage.googleapis.com/v0/b/legrosbubu-streamplanner.appspot.com/o/upload%2Flegrosbubu%2FLogo.png?alt=media&token=c05e011e-c4f2-46f2-a672-ec76625e46df",
                timeout = 10500
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
    "policeOn",
    function(source, args, rawCommand)
        ServiceOn()
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
