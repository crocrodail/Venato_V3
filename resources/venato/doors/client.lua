local doorList = {    
    [1] = { ["objName"] = "v_ilev_ph_gendoor005", ["x"]= 443.97, ["y"]= -989.033,["z"]= 30.6896,["locked"]= true, ['jobId'] = 2},
    [2] = { ["objName"] = "v_ilev_ph_gendoor005", ["x"]= 445.37, ["y"]= -988.705,["z"]= 30.6896,["locked"]= true, ['jobId'] = 2},
    [3] = { ["objName"] = "v_ilev_ph_cellgate", ["x"]= 463.815, ["y"]= -992.686,["z"]= 24.9149,["locked"]= true, ['jobId'] = 2},
    [4] = { ["objName"] = "v_ilev_ph_cellgate", ["x"]= 462.381, ["y"]= -993.651,["z"]= 24.9149,["locked"]= true, ['jobId'] = 2},
    [5] = { ["objName"] = "v_ilev_ph_cellgate", ["x"]= 462.331, ["y"]= -998.152,["z"]= 24.9149,["locked"]= true, ['jobId'] = 2},
    [6] = { ["objName"] = "v_ilev_ph_cellgate", ["x"]= 462.704, ["y"]= -1001.92,["z"]= 24.9149,["locked"]= true, ['jobId'] = 2},
    [7] = { ["objName"] = "v_ilev_gtdoor", ["x"]= 464.1342, ["y"]= -1003.5145,["z"]= 24.9148,["locked"]= true, ['jobId'] = 2},
    [8] = { ["objName"] = "v_ilev_gtdoor02", ["x"]= 464.3087, ["y"]= -983.9446,["z"]= 43.6918,["locked"]= true, ['jobId'] = 2},
	[9] = { ["objName"] = "-1033001619", ["x"]= 452.61877441406, ["y"]= -982.7021484375,["z"]= 30.689598083496,["locked"]= true, ['jobId'] = 2},
    [10] = { ["objName"] = "v_ilev_rc_door2", ["x"]= 468.1539, ["y"]= -1014.6710,["z"]= 26.3864,["locked"]= true, ['jobId'] = 2},
	[11] = { ["objName"] = "v_ilev_rc_door2", ["x"]= 469.3743, ["y"]= -1014.5759,["z"]= 26.3864,["locked"]= true, ['jobId'] = 2},
	[12] = { ["objName"] = "1557126584", ["x"]= 449.554, ["y"]= -986.5680,["z"]= 30.6896,["locked"]= true, ['jobId'] = 2},
	[13] = { ["objName"] = "-1033001619", ["x"]= 447.22, ["y"]= -999.00,["z"]= 30.79,["locked"]= true, ['jobId'] = 2},
    [14] = { ["objName"] = "-1033001619", ["x"]= 444.63, ["y"]= -999.00,["z"]= 30.79,["locked"]= true, ['jobId'] = 2},
    [15] = { ["objName"] = "-1033001619", ["x"]= 468.63, ["y"]= -1003.00,["z"]= 25.01,["locked"]= true, ['jobId'] = 2},
    [16] = { ["objName"] = "-1033001619", ["x"]= 471.63, ["y"]= -1003.00,["z"]= 25.01,["locked"]= true, ['jobId'] = 2},
    [17] = { ["objName"] = "-1033001619", ["x"]= 477.63, ["y"]= -1003.00,["z"]= 25.01,["locked"]= true, ['jobId'] = 2},
    [18] = { ["objName"] = "-1033001619", ["x"]= 480.63, ["y"]= -1003.00,["z"]= 25.01,["locked"]= true, ['jobId'] = 2},
    [19] = { ["objName"] = "-1033001619", ["x"]= 480.63, ["y"]= -996.00,["z"]= 25.01,["locked"]= true, ['jobId'] = 2},
    [20] = { ["objName"] = "-1033001619", ["x"]= 477.63, ["y"]= -996.00,["z"]= 25.01,["locked"]= true, ['jobId'] = 2},
    [21] = { ["objName"] = "-1033001619", ["x"]= 471.63, ["y"]= -996.00,["z"]= 25.01,["locked"]= true, ['jobId'] = 2},
    [22] = { ["objName"] = "-1033001619", ["x"]= 468.63, ["y"]= -996.00,["z"]= 25.01,["locked"]= true, ['jobId'] = 2},
    [23] = { ["objName"] = "507213820", ["x"]= 464.63, ["y"]= -1011.00,["z"]= 33.01,["locked"]= true, ['jobId'] = 2},
    [24] = { ["objName"] = "-495720969", ["x"]= 113.98, ["y"]= -1297.43,["z"]= 29.42,["locked"]= true, ['jobId'] = 34},    
    [25] = { ["objName"] = "-626684119", ["x"]= 99.08, ["y"]= -1293.70,["z"]= 29.42,["locked"]= true, ['jobId'] = 34},    
    [26] = { ["objName"] = "668467214", ["x"]= 96.09, ["y"]= -1284.85,["z"]= 29.44,["locked"]= true, ['jobId'] = 34},    
    [27] = { ["objName"] = "668467214", ["x"]= 96.09, ["y"]= -1284.85,["z"]= 29.44,["locked"]= true, ['jobId'] = 34},    
    [28] = { ["objName"] = "-1116041313", ["x"]= 127.96, ["y"]= -1298.50,["z"]= 29.42,["locked"]= true, ['jobId'] = 34},  
    [29] = { ["objName"] = "-131296141", ["x"]= -1389.21, ["y"]= -588.04,["z"]= 30.49,["locked"]= true, ['jobId'] = 35},  
    [30] = { ["objName"] = "-131296141", ["x"]= -1387.03, ["y"]= -586.61,["z"]= 30.50,["locked"]= true, ['jobId'] = 35},  
}

RegisterNetEvent('door:state')
AddEventHandler('door:state', function(id, isLocked)
    if type(doorList[id]) ~= nil then -- Check if door exists
        doorList[id]["locked"] = isLocked -- Change state of door
        local obj = doorList[id]["objName"]
        if tonumber(obj) == nil then
          obj = GetHashKey(doorList[id]["objName"])
        end
        local closeDoor = GetClosestObjectOfType(doorList[id]["x"], doorList[id]["y"], doorList[id]["z"], 5.0, tonumber(obj), false, false, false)
        FreezeEntityPosition(closeDoor, doorList[id]["locked"])
    end

end)

-- Lock Door
Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
      local playerCoords = GetEntityCoords( GetPlayerPed(-1) )
        for i = 1, #doorList do
            local obj = doorList[i]["objName"]
            
            if tonumber(obj) == nil then
            obj = GetHashKey(doorList[i]["objName"])
            end

            local closeDoor = GetClosestObjectOfType(doorList[i]["x"], doorList[i]["y"], doorList[i]["z"], 5.0, tonumber(obj), false, false, false)
                
            
            local playerDistance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, doorList[i]["x"], doorList[i]["y"], doorList[i]["z"], true)

            if(playerDistance < 1 and DataUser.IdJob == doorList[i]["jobId"]) then

                if doorList[i]["locked"] == true then
                    DisplayHelpText("Appuyer sur ~INPUT_PICKUP~ pour ~b~ouvrir la porte",1, 1, 0.5, 0.8, 0.9, 255, 255, 255, 255)
                else
                    DisplayHelpText("Appuyer sur ~INPUT_PICKUP~ pour ~r~fermer la porte",1, 1, 0.5, 0.8, 0.9, 255, 255, 255, 255)
                end
                -- Press E key
                if IsControlJustPressed(1,51) then
                    if doorList[i]["locked"] == true then
                        TriggerServerEvent("door:update", i, false)
                    else
                        TriggerServerEvent("door:update", i, true)
                    end
                end
            else
                FreezeEntityPosition(closeDoor, doorList[i]["locked"])
            end
        end
    end
end)