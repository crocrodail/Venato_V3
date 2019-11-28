
local cars = {
    {name = "I8", plate = "ADMIN", xpoint = 750.994,  ypoint = -1479.012,  zpoint = 19.903, hpoint= 215.495 },
}

-- PROCESS THREAD
Citizen.CreateThread(function()   
    while true do 
        for k,v in ipairs(cars)do
            Citizen.Wait(100)
            local CarOnPoint = GetClosestVehicle(v.xpoint,v.ypoint,v.zpoint, 3.000, 0, 70)
            print("CarOnPoint : "..CarOnPoint)
            if(CarOnPoint and CarOnPoint ~= 0) then
                if(GetVehicleNumberPlateText(CarOnPoint):gsub("%s+", "") ~= v.plate:gsub("%s+", "")) then
                    DeleteEntity(CarOnPoint)
                    SpawnVehicle(v)
                end
            else
                SpawnVehicle(v)
            end
        end
    end
end)


-- DISPLAY THREAD
Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)
    end
end)


function SpawnVehicle(v)
    platypus.CreateVehicle(string.upper(v.name),{x = v.xpoint, y = v.ypoint, z = v.zpoint}, v.hpoint,
        function(vehicle)
            SetVehicleNumberPlateText(vehicle, v.plate)
        end
    )    
end