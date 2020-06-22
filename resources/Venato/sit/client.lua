local lastPos, currentSitCoords, currentScenario = {}
local sitting = false
local debugProps = {}
local camMode = 0


function DrawText3D(x,y,z, text) 
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(0)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

if Config.Debug then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			for i=1, #debugProps, 1 do
				local coords = GetEntityCoords(debugProps[i])		
				local hash = GetEntityModel(debugProps[i])
				local id = coords.x .. coords.y .. coords.z
				local model = 'unknown'

				for i=1, #Config.Interactables, 1 do
					local seat = Config.Interactables[i]

					if hash == GetHashKey(seat) then
						model = seat
						break
					end
				end

				local text = ('ID: %s~n~Hash: %s~n~Model: %s'):format(id, hash, model)
				DrawText3D(coords.x,coords.y,coords.z + 2.0, text)
			end

			if #debugProps == 0 then
				Citizen.Wait(500)
			end
		end
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if IsControlJustPressed(0, 38) and IsControlPressed(0, 21) and IsInputDisabled(0) and IsPedOnFoot(playerPed) then
			local object, distance = venato.GetClosestObject(Config.Interactables)
			if sitting then
				wakeup(object)
			else

				if Config.Debug then
					table.insert(debugProps, object)
				end

				if distance < 1.5 then
					local hash = GetEntityModel(object)

					for k,v in pairs(Config.Sitable) do
						if GetHashKey(k) == hash then
							sit(object, k, v)
							break
						end
					end
				end
			end
		end
	end
end)

function wakeup(object)
	local playerPed = PlayerPedId()
	ClearPedTasks(playerPed)
	local pos = GetEntityCoords(object)
	local objectCoords = pos.x .. pos.y .. pos.z

	sitting = false

	FreezeEntityPosition(playerPed, false)

	TriggerServerEvent('venato_sit:leavePlace', currentSitCoords)
	currentSitCoords, currentScenario = nil, nil
	Citizen.Wait(1500)
	SetFollowPedCamViewMode(camMode)
end

function sit(object, modelName, data)
	local pos = GetEntityCoords(object)
	local objectCoords = pos.x .. pos.y .. pos.z
	
	venato.TriggerServerCallback('venato_sit:getPlace', function(occupied)
		if occupied then
		else
			camMode = GetFollowPedCamViewMode()
			local playerPed = PlayerPedId()
			lastPos, currentSitCoords = GetEntityCoords(playerPed), objectCoords

			TriggerServerEvent('venato_sit:takePlace', objectCoords)
			FreezeEntityPosition(object, true)
			currentScenario = data.scenario
			TaskStartScenarioAtPosition(playerPed, currentScenario, pos.x, pos.y, pos.z - data.verticalOffset, GetEntityHeading(object) + 180.0, 0, true, true)
			Citizen.Wait(1500)
			sitting = true
			SetFollowPedCamViewMode(4)
		end
	end)
end
