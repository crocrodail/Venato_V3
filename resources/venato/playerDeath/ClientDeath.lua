local dead = false
local playerPed = nil
local cam = nil
local ClonedPed = nil

Citizen.CreateThread(function()
  Citizen.Wait(5000)
  while true do
    Citizen.Wait(0)
		if playerPed == nil then
			playerPed = GetPlayerPed(-1)
		end
    if IsEntityDead(playerPed) then
			print('isDead')
      ClonedPed = ClonePed(playerPed, GetEntityHeading(playerPed), 1, 1)
			if not DoesCamExist(cam) then
			  cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
		  end
		  SetCamActive(cam,  true)
		  RenderScriptCams(true,  false,  0,  true,  true)
      dead = true
			StartScreenEffect("DeathFailMPIn", 10000 , true)
			StartScreenEffect("PPFilterOut", 10000 , true)
      SetEntityNoCollisionEntity(ClonedPed, playerPed, true)
      SetEntityVisible(playerPed, false, true)
      SetEntityHealth(ClonedPed, 0)
      ResurrectPed(playerPed)
      SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
      Citizen.Wait(1500)
      local coordPed = GetEntityCoords(ClonedPed, true)
      NetworkResurrectLocalPlayer(coordPed.x, coordPed.y, coordPed.z, 0, true, true, false)
      SetPedToRagdoll(playerPed, 10, 0, 0, true, true, false)
      Citizen.Wait(1500)
      DeleteEntity(ClonedPed)
			ClonedPed = nil
      SetEntityVisible(playerPed, true, true)
			Citizen.Wait(5000)
			dead = false
			SetCamActive(cam,  false)
			RenderScriptCams(false,  false,  0,  true,  true)
			StopAllScreenEffects()
    end
  end
end)

Citizen.CreateThread(function()
  Citizen.Wait(5000)
  while true do
    Citizen.Wait(0)
    if dead then
			SetPedToRagdoll(playerPed, 1, 0, 0, true, true, false)
			if ClonedPed ~= nil then
				local coordPed = GetEntityCoords(ClonedPed, true)
				--SetCamCoord(cam,  coordPed["x"]+2,  coordPed["y"]+2,  coordPed["z"]+4)
			  PointCamAtCoord(cam,coordPed["x"],coordPed["y"],coordPed["z"])
			end
    end
  end
end)
