local doorList = {
    [1] = { ["objName"] = "185711165", ["x"]= 443.41, ["y"]= -989.45,["z"]= 30.84,["locked"]= true,  ["distance"]=1.5,['jobId'] = 2},
    [2] = { ["objName"] = "185711165", ["x"]= 446.01, ["y"]= -989.45,["z"]= 30.84,["locked"]= true, ["distance"]=1.5,['jobId'] = 2},
    [3] = { ["objName"] = "-1320876379", ["x"]= 446.57, ["y"]= -980.01,["z"]= 30.84,["locked"]= true, ["distance"]=1.5,['jobId'] = 2},
    [4] = { ["objName"] = "-1033001619", ["x"]= 453.09, ["y"]= -983.23,["z"]= 30.84,["locked"]= true, ["distance"]=1.5,['jobId'] = 2},
    [5] = { ["objName"] = "1557126584", ["x"]= 450.10, ["y"]= -985.74,["z"]= 30.84,["locked"]= true, ["distance"]=1.5,['jobId'] = 2},
    [6] = { ["objName"] = "-1033001619", ["x"]= 444.62, ["y"]= -999.00,["z"]= 30.79,["locked"]= true, ["distance"]=1.5,['jobId'] = 2},
    [7] = { ["objName"] = "-1033001619", ["x"]= 447.22, ["y"]= -999.00,["z"]= 30.79,["locked"]= true, ["distance"]=1.5,['jobId'] = 2},
    [8] = { ["objName"] = "631614199", ["x"]= 464.57, ["y"]= -992.66,["z"]= 25.06,["locked"]= true, ["distance"]=1.5,['jobId'] = 2},
	[9] = { ["objName"] = "631614199", ["x"]= 461.81, ["y"]= -994.41,["z"]= 25.06,["locked"]= true, ["distance"]=1.5,['jobId'] = 2},
    [10] = { ["objName"] = "631614199", ["x"]= 461.81, ["y"]= -997.66,["z"]= 25.06,["locked"]= true, ["distance"]=1.5,['jobId'] = 2},
	[11] = { ["objName"] = "631614199", ["x"]= 461.81, ["y"]= -1001.30,["z"]= 25.06,["locked"]= true, ["distance"]=1.5,['jobId'] = 2},
	[12] = { ["objName"] = "-1033001619", ["x"]= 467.19, ["y"]= -996.46,["z"]= 25.01,["locked"]= true, ["distance"]=1.5,['jobId'] = 2},
	[13] = { ["objName"] = "-1033001619", ["x"]= 471.48, ["y"]= -996.46,["z"]= 25.01,["locked"]= true, ["distance"]=1.5,['jobId'] = 2},
    [14] = { ["objName"] = "-1033001619", ["x"]= 475.75, ["y"]= -996.46,["z"]= 25.01,["locked"]= true, ["distance"]=1.5,['jobId'] = 2},
    [15] = { ["objName"] = "-1033001619", ["x"]= 480.03, ["y"]= -996.46,["z"]= 25.01,["locked"]= true, ["distance"]=1.5,['jobId'] = 2},
    [16] = { ["objName"] = "-1033001619", ["x"]= 480.03, ["y"]= -1003.54,["z"]= 25.01,["locked"]= true, ["distance"]=1.5,['jobId'] = 2},
    [17] = { ["objName"] = "-1033001619", ["x"]= 477.05, ["y"]= -1003.54,["z"]= 25.01,["locked"]= true, ["distance"]=1.5,['jobId'] = 2},
    [18] = { ["objName"] = "-1033001619", ["x"]= 471.47, ["y"]= -1003.54,["z"]= 25.01,["locked"]= true, ["distance"]=1.5,['jobId'] = 2},
    [19] = { ["objName"] = "-1033001619", ["x"]= 468.49, ["y"]= -1003.55,["z"]= 25.01,["locked"]= true, ["distance"]=1.5,['jobId'] = 2},
    [20] = { ["objName"] = "-1033001619", ["x"]= 463.48, ["y"]= -1003.54,["z"]= 25.01,["locked"]= true, ["distance"]=1.5,['jobId'] = 2},
    [21] = { ["objName"] = "-2023754432", ["x"]= 469.97, ["y"]= -1014.45,["z"]= 26.54,["locked"]= true, ["distance"]=1.5,['jobId'] = 2},
    [22] = { ["objName"] = "-2023754432", ["x"]= 467.37, ["y"]= -1014.45,["z"]= 26.54,["locked"]= true, ["distance"]=1.5,['jobId'] = 2},
    [23] = { ["objName"] = "91564889", ["x"]= 475.47, ["y"]= -987.03,["z"]= 25.23,["locked"]= true, ["distance"]=1.5,['jobId'] = 2},
    [24] = { ["objName"] = "-495720969", ["x"]= 113.98, ["y"]= -1297.43,["z"]= 29.42,["locked"]= true, ['jobId'] = 34},
    [25] = { ["objName"] = "-626684119", ["x"]= 99.08, ["y"]= -1293.70,["z"]= 29.42,["locked"]= true, ['jobId'] = 34},
    [26] = { ["objName"] = "668467214", ["x"]= 96.09, ["y"]= -1284.85,["z"]= 29.44,["locked"]= true, ['jobId'] = 34},
    [27] = { ["objName"] = "668467214", ["x"]= 96.09, ["y"]= -1284.85,["z"]= 29.44,["locked"]= true, ['jobId'] = 34},
    [28] = { ["objName"] = "-1116041313", ["x"]= 127.96, ["y"]= -1298.50,["z"]= 29.42,["locked"]= true, ['jobId'] = 34},
    [29] = { ["objName"] = "-131296141", ["x"]= -1389.21, ["y"]= -588.04,["z"]= 30.49,["locked"]= true, ['jobId'] = 35},
    [30] = { ["objName"] = "-131296141", ["x"]= -1387.03, ["y"]= -586.61,["z"]= 30.50,["locked"]= true, ['jobId'] = 35},
    [31] = { ["objName"] = "-1884701657", ["x"]= 471.34, ["y"]= -985.45,["z"]= 26.83,["locked"]= true, ["distance"]=1.5,['jobId'] = 2},
    [31] = { ["objName"] = "-340230128", ["x"]= 464.36, ["y"]= -984.68,["z"]= 43.83,["locked"]= true, ["distance"]=1.5,['jobId'] = 2},
    [32] = { ["objName"] = "1695461688", ["x"]= -1583.46, ["y"]= -3004.98,["z"]= -75.84,["locked"]= true, ['jobId'] = 41},
    [33] = { ["objName"] = "1695461688", ["x"]= -1581.91, ["y"]= -3010.06,["z"]= -75.84,["locked"]= true, ['jobId'] = 41},
    [34] = { ["objName"] = "-1555108147", ["x"]= -1608.23, ["y"]= -3005.63,["z"]= -75.21, ['distance']= 1.5, ["locked"]= true, ['jobId'] = 41},
    [35] = { ["objName"] = "402916948", ["x"]= -1614.41, ["y"]= -3008.48,["z"]= -76.21,["locked"]= true, ['jobId'] = 41},
    [36] = { ["objName"] = "-1119680854", ["x"]= -1621.28, ["y"]= -3015.79,["z"]= -75.21,["locked"]= true, ['jobId'] = 41},
    [37] = { ["objName"] = "993120320", ["x"]= -561.29, ["y"]= 293.50,["z"]= 87.78,["distance"]=1.5, ["locked"]= true, ["distance"]=1.5,['jobId'] = 23},
    [38] = { ["objName"] = "993120320", ["x"]= -565.17, ["y"]= 276.63,["z"]= 83.29,["distance"]=1.5, ["locked"]= true, ["distance"]=1.5,['jobId'] = 23},
    [39] = { ["objName"] = "-626684119", ["x"]= -569.80, ["y"]= 293.77,["z"]= 79.33,["distance"]=1.5, ["locked"]= true, ["distance"]=1.5,['jobId'] = 23},
    [40] = { ["objName"] = "-626684119", ["x"]= -560.24, ["y"]= 293.01,["z"]= 82.33,["distance"]=1.5, ["locked"]= true, ["distance"]=1.5,['jobId'] = 23},
    [41] = { ["objName"] = "1289778077", ["x"]= -568.88, ["y"]= 281.11,["z"]= 83.13,["distance"]=1.5, ["locked"]= true, ["distance"]=1.5,['jobId'] = 23},
    [42] = { ["objName"] = "827574885", ["x"]= 622.80, ["y"]= -2921.64,["z"]= 4.05,["distance"]=2.5, ["locked"]= true, ["distance"]=1.5,['jobId'] = 2},--camp d'entrainement police
    [43] = { ["objName"] = "-768779561", ["x"]= 963.21, ["y"]= -141.85,["z"]= 74.76,["distance"]=2.5, ["locked"]= true, ['jobId'] = 56},--lost
    [44] = { ["objName"] = "-250842784", ["x"]= -56.92, ["y"]= -1079.77,["z"]= 26.11,["distance"]=5, ["locked"]= true, ['jobId'] = 59},--carshop
    [45] = { ["objName"] = "30769481", ["x"]= -28.80, ["y"]= -1085.92,["z"]= 28.74,["distance"]=5, ["locked"]= true, ['jobId'] = 59},-- carshop
    [46] = { ["objName"] = "100848840", ["x"]= -24.49, ["y"]= -1086.47,["z"]= 27.18,["distance"]=5, ["locked"]= true, ['jobId'] = 59}, -- carshop
    [47] = { ["objName"] = "-1234764774", ["x"]= 223.983, ["y"]= -2011.299,["z"]= 19.295,["distance"]=5, ["locked"]= true, ['jobId'] = 59}, -- carshop
    [48] = { ["objName"] = "1853479348", ["x"]= 1402.89, ["y"]= 3668.34,["z"]= 34.17,["distance"]=1.5, ["locked"]= true }, -- weed place
    [49] = { ["objName"] = "1890297615", ["x"]= 623.83, ["y"]= -418.63,["z"]= -1.43,["distance"]=0.5, ["locked"]= true }, -- weed recolt space
}


local commandHelp = {
  id = "door",
  command = "E",
  icon = "https://i.ibb.co/2NPLqZ3/icons8-open-door-48px.png",
  text = "Ouvrir/Fermer porte"
}

local isCommandAdded = -1;

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
local loopData = {}
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local playerCoords = GetEntityCoords( PlayerPedId() )
    local testDistance = 999999
    local testLoopData = {}
    for i = 1, #doorList do
      Citizen.Wait(10)
      local obj = doorList[i]["objName"]
      if tonumber(obj) == nil then
        obj = GetHashKey(doorList[i]["objName"])
      end
      local closeDoor = GetClosestObjectOfType(doorList[i]["x"], doorList[i]["y"], doorList[i]["z"], 5.0, tonumber(obj), false, false, false)
      local playerDistance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, doorList[i]["x"], doorList[i]["y"], doorList[i]["z"], true)
      if(playerDistance < (doorList[i]["distance"] ~= undefined and doorList[i]["distance"] or 1) and venato.HasJob(doorList[i]["jobId"])) then
      else
        FreezeEntityPosition(closeDoor, doorList[i]["locked"])
      end
      if loopData.item ~= nil then
        if i == loopData.i then
          testLoopData = { playerDistance = playerDistance, i = i }
        end
      end
      if playerDistance < testDistance then
        testDistance = playerDistance
        testLoopData = { playerDistance = playerDistance, i = i }
      end
    end
    loopData = testLoopData
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if loopData.playerDistance ~= nil then
      if(loopData.playerDistance < (doorList[loopData.i]["distance"] ~= undefined and doorList[loopData.i]["distance"] or 1) and venato.HasJob(doorList[loopData.i]["jobId"])) then        
        if isCommandAdded == -1 then
          print(doorList[loopData.i]["locked"])
          if doorList[loopData.i]["locked"] == true then
            dprint('unlock1')
            commandHelp.text = "Déverrouiller la porte"
          else
            dprint('lock1')
            commandHelp.text = "Verrouiller la porte"
          end
          TriggerEvent('Commands:Add', commandHelp)
          isCommandAdded = loopData.i
        end
        if IsControlJustPressed(1,51) then
          venato.disableAction(true)
          venato.playAnim({
              useLib = true,
              flag = 48,
              lib = "missheistfbisetup1",
              anim = "unlock_enter_janitor",
              timeout = 2500
          })
          venato.disableAction(false)
          if doorList[loopData.i]["locked"] == true then
            doorList[loopData.i]["locked"] = false
            TriggerServerEvent("door:update", loopData.i, false)
          else
            doorList[loopData.i]["locked"] = true
            TriggerServerEvent("door:update", loopData.i, true)
          end
          print(doorList[loopData.i]["locked"])
          TriggerEvent('Commands:Remove', commandHelp.id)
          isCommandAdded = -1 
        end
      else
        if isCommandAdded == loopData.i then
          isCommandAdded = -1 
          TriggerEvent('Commands:Remove', commandHelp.id)
        end
      end
    end
  end
end)
