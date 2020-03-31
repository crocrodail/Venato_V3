local mp_pointing = false
local keyPressed = false
local pressButton1 = 0
local pressButton2 = 0
local hiddenHUD = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(0, Keys["F1"]) then
			OpenMenuInteraction()
			Menu.toggle()
		end
		if IsControlJustPressed(0, 21) then
          pressButton1 = 1
        end
		if IsControlJustPressed(0, 167) then
          extSwitDistance()
        end
        if IsControlJustReleased(0, 21) then
          pressButton1 = 0
        end
        if IsControlJustPressed(1, 47) then
          pressButton2 = 1
        end
        if IsControlJustReleased(1, 47) then
          pressButton2 = 0
        end
        if pressButton1 == 1 and pressButton2 == 1 then
           SetPedToRagdoll(GetPlayerPed(-1), 12000, 12000, 0, 0, 0, 0)
        end
	end
end)

function DoRagdoll()
	SetPedToRagdoll(GetPlayerPed(-1), 12000, 12000, 0, 0, 0, 0)
end

function killYourSelf()
    SetEntityHealth(GetPlayerPed(-1), 0)
end

function ClearAnim()
	local lPed = GetPlayerPed(-1)
	if CanCancelOrStartAnim then
    if DoesEntityExist(lPed) then
        Citizen.CreateThread(function()
            ClearPedTasksImmediately(lPed)
        end)
    end
	end
end

function maskHUD()
	if hiddenHUD == false then
		hiddenHUD = true
		TriggerEvent("Hud:Update",{action = "showHUD"})
	else
		hiddenHUD = false
		TriggerEvent("Hud:Update",{action = "hideHUD"})
	end
end

function extOpenTel()
	TriggerServerEvent("gcphone:callData")
end

function extSwitDistance()
	TriggerEvent("Tokovoip:switchdistance")
end

function playAnim(row)
	local	dictionaries = row[1]
	local	clip = row[2]
	local lPed = GetPlayerPed(-1)
	if DoesEntityExist(lPed) then
		Citizen.CreateThread(function()
				RequestAnimDict(dictionaries)
				while not HasAnimDictLoaded(dictionaries) do
						Citizen.Wait(100)
				end

				if IsEntityPlayingAnim(lPed, dictionaries, clip, 3) then
						ClearPedSecondaryTask(lPed)
				else
						TaskPlayAnim(lPed, dictionaries, clip, 8.0, -8, -1, 8, 0, 0, 0, 0)
				end
		end)
	end
end

function playEmote(emoteNane)
	local ped = GetPlayerPed(-1);
    if ped then
        TaskStartScenarioInPlace(ped, emoteNane, 0, false)
        emotePlay = true
    end
end

local function startPointing()
    local ped = GetPlayerPed(-1)
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Wait(0)
    end
    SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
    SetPedConfigFlag(ped, 36, 1)
    Citizen.InvokeNative(0x2D537BA194896636, ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")
end

local function stopPointing()
    local ped = GetPlayerPed(-1)
    Citizen.InvokeNative(0xD01015C7316AE176, ped, "Stop")
    if not IsPedInjured(ped) then
        ClearPedSecondaryTask(ped)
    end
    if not IsPedInAnyVehicle(ped, 1) then
        SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
    end
    SetPedConfigFlag(ped, 36, 0)
    ClearPedSecondaryTask(PlayerPedId())
end

local once = true
local oldval = false
local oldvalped = false

Citizen.CreateThread(function()
    while true do
        Wait(0)
				if CanCancelOrStartAnim then

        if once then
            once = false
        end

        if not keyPressed then
            if IsControlPressed(1, 29) and not mp_pointing and IsPedOnFoot(PlayerPedId()) and GetLastInputMethod(2) then
                Wait(200)
                if not IsControlPressed(1, 29) then
                    keyPressed = true
                    startPointing()
                    mp_pointing = true
                else
                    keyPressed = true
                    while IsControlPressed(1, 29) do
                        Wait(50)
                    end
                end
            elseif (IsControlPressed(1, 29) and mp_pointing) or (not IsPedOnFoot(PlayerPedId()) and mp_pointing) and GetLastInputMethod(2) then
                keyPressed = true
                mp_pointing = false
                stopPointing()
            end
        end

        if keyPressed then
            if not IsControlPressed(1, 29) then
                keyPressed = false
            end
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) and not mp_pointing then
            stopPointing()
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) then
            if not IsPedOnFoot(PlayerPedId()) then
                stopPointing()
            else
                local ped = GetPlayerPed(-1)
                local camPitch = GetGameplayCamRelativePitch()
                if camPitch < -70.0 then
                    camPitch = -70.0
                elseif camPitch > 42.0 then
                    camPitch = 42.0
                end
                camPitch = (camPitch + 70.0) / 112.0

                local camHeading = GetGameplayCamRelativeHeading()
                local cosCamHeading = Cos(camHeading)
                local sinCamHeading = Sin(camHeading)
                if camHeading < -180.0 then
                    camHeading = -180.0
                elseif camHeading > 180.0 then
                    camHeading = 180.0
                end
                camHeading = (camHeading + 180.0) / 360.0

                local blocked = 0
                local nn = 0

                local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7);
                nn,blocked,coords,coords = GetRaycastResult(ray)

                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Pitch", camPitch)
                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Heading", camHeading * -1.0 + 1.0)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isBlocked", blocked)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)

            end
        end
    end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
				if CanCancelOrStartAnim then
        local lPed = GetPlayerPed(-1)
        RequestAnimDict("random@mugging3")
        if not IsPedInAnyVehicle(lPed, false) and not IsPedSwimming(lPed) and not IsPedShooting(lPed) and not IsPedClimbing(lPed) and not IsPedCuffed(lPed) and not IsPedDiving(lPed) and not IsPedFalling(lPed) and not IsPedJumping(lPed) and not IsPedJumpingOutOfVehicle(lPed) and IsPedOnFoot(lPed) and not IsPedRunning(lPed) and not IsPedUsingAnyScenario(lPed) and not IsPedInParachuteFreeFall(lPed) then
            if IsControlPressed(1, 323) then
                if DoesEntityExist(lPed) then
                    SetCurrentPedWeapon(lPed, 0xA2719263, true)
                    Citizen.CreateThread(function()
                        RequestAnimDict("random@mugging3")
                        while not HasAnimDictLoaded("random@mugging3") do
                            Citizen.Wait(100)
                        end

                        if not handsup then
                            handsup = true
                            TaskPlayAnim(lPed, "random@mugging3", "handsup_standing_base", 8.0, -8, -1, 50, 0, 0, 0, 0)
                        end
                    end)
                end
            end
        end
        if IsControlReleased(1, 323) and GetLastInputMethod(2) then
            if DoesEntityExist(lPed) then
                Citizen.CreateThread(function()
                    RequestAnimDict("random@mugging3")
                    while not HasAnimDictLoaded("random@mugging3") do
                        Citizen.Wait(100)
                    end

                    if handsup then
                        handsup = false
                        ClearPedSecondaryTask(lPed)
                    end
                end)
            end
        end
    end
	end
end)

local crouched = false
local proned = false
crouchKey = 26
proneKey = 36

Citizen.CreateThread( function()
	while true do
		Citizen.Wait( 1 )
		local ped = GetPlayerPed( -1 )
		if CanCancelOrStartAnim then
		if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
			ProneMovement()
			DisableControlAction( 1, proneKey, true )
			DisableControlAction( 1, crouchKey, true )
			if ( not IsPauseMenuActive() ) then
				if ( IsDisabledControlJustPressed( 1, crouchKey ) and not proned ) then
					RequestAnimSet( "move_ped_crouched" )
					RequestAnimSet("MOVE_M@TOUGH_GUY@")

					while ( not HasAnimSetLoaded( "move_ped_crouched" ) ) do
						Citizen.Wait( 100 )
					end
					while ( not HasAnimSetLoaded( "MOVE_M@TOUGH_GUY@" ) ) do
						Citizen.Wait( 100 )
					end
					if ( crouched and not proned ) then
						ResetPedMovementClipset( ped )
						ResetPedStrafeClipset(ped)
						SetPedMovementClipset( ped,"MOVE_M@TOUGH_GUY@", 0.5)
						crouched = false
					elseif ( not crouched and not proned ) then
						SetPedMovementClipset( ped, "move_ped_crouched", 0.55 )
						SetPedStrafeClipset(ped, "move_ped_crouched_strafing")
						crouched = true
					end
				elseif ( IsDisabledControlJustPressed(1, proneKey) and not crouched and not IsPedInAnyVehicle(ped, true) and not IsPedFalling(ped) and not IsPedDiving(ped) and not IsPedInCover(ped, false) and not IsPedInParachuteFreeFall(ped) and (GetPedParachuteState(ped) == 0 or GetPedParachuteState(ped) == -1) ) then
					if proned then
						ClearPedTasks(ped)
						StopAnimTask(ped,"move_crawl","onfront_fwd", 1.0)
						platypus.playAnim({lib = "get_up@standard", anim = "front", useLib = true})
						Citizen.Wait(3000)
						ClearPedTasks(ped)
						StopAnimTask(ped,"move_crawl","onfront_fwd", 1.0)
						proned = false
					elseif not proned then
						RequestAnimSet( "move_crawl" )
						while ( not HasAnimSetLoaded( "move_crawl" ) ) do
							Citizen.Wait( 100 )
						end
						ClearPedTasksImmediately(ped)
						proned = true
						if IsPedSprinting(ped) or IsPedRunning(ped) or GetEntitySpeed(ped) > 5 then
							TaskPlayAnim(ped, "move_jump", "dive_start_run", 8.0, 1.0, -1, 0, 0.0, 0, 0, 0)
							Citizen.Wait(1000)
						end
						SetProned()
					end
				end
			end
		else
			proned = false
			crouched = false
		end
	end
end
end)

function SetProned()
	ped = PlayerPedId()
	--ClearPedTasksImmediately(ped)
	TaskPlayAnimAdvanced(ped, "move_crawl", "onfront_bwd", GetEntityCoords(ped), 0.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 46, 1.0, 0, 0)
end


function ProneMovement()
	if proned then
		DisableControlAction(1, 24, true) -- Attack
		DisablePlayerFiring(ped, true) -- Disable weapon firing
		DisableControlAction(1, 142, true) -- MeleeAttackAlternate
		ped = PlayerPedId()
		if IsControlPressed(1, 32) or IsControlPressed(1, 33) then
			DisablePlayerFiring(ped, true)
		elseif IsControlJustReleased(1, 32) or IsControlJustReleased(1, 33) then
		 	DisablePlayerFiring(ped, false)
		 end
		if IsControlJustPressed(1, 32) and not movefwd then
			movefwd = true
		    TaskPlayAnimAdvanced(ped, "move_crawl", "onfront_fwd", GetEntityCoords(ped), 1.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 47, 1.0, 0, 0)
		elseif IsControlJustReleased(1, 32) and movefwd then
		    TaskPlayAnimAdvanced(ped, "move_crawl", "onfront_fwd", GetEntityCoords(ped), 1.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 46, 1.0, 0, 0)
			movefwd = false
		end
		if IsControlJustPressed(1, 33) and not movebwd then
			movebwd = true
		    TaskPlayAnimAdvanced(ped, "move_crawl", "onfront_bwd", GetEntityCoords(ped), 1.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 47, 1.0, 0, 0)
		elseif IsControlJustReleased(1, 33) and movebwd then
		    TaskPlayAnimAdvanced(ped, "move_crawl", "onfront_bwd", GetEntityCoords(ped), 1.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 46, 1.0, 0, 0)
		    movebwd = false
		end
		if IsControlPressed(1, 34) then
			SetEntityHeading(ped, GetEntityHeading(ped)+2.0 )
		elseif IsControlPressed(1, 35) then
			SetEntityHeading(ped, GetEntityHeading(ped)-2.0 )
		end
	end
end

local tazer = 30000 -- in miliseconds >> 1000 ms = 1s

Citizen.CreateThread(function()
	Citizen.Wait(60000)
	SetPedMinGroundTimeForStungun(GetPlayerPed(-1), tazer)
	while true do
		Citizen.Wait(0)
		if IsPedBeingStunned(GetPlayerPed(-1)) then
			SetPedMinGroundTimeForStungun(GetPlayerPed(-1), tazer)
			DisableAllControlActions(0);
		end
	end
end)
