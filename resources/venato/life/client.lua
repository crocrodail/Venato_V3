local pedIsInVehicule = false
local food = 100
local water = 100
local alcool = 0
local old_water = 0
local old_food = 0
local old_alcool = 0
local reserveTrigger = false
local FreezeNeed = false
local old_phase = 0

function LiveFreezeNeed(bool)
  FreezeNeed = bool
end

function LifeInit()
  TriggerServerEvent("Life:Init")
end

Citizen.CreateThread(
    function()
        Citizen.Wait(3500)
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
                        logo = "https://i.ibb.co/61pT4gN/icons8-gas-station-96px.png",
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
            if not FreezeNeed then
                if food > 0 then
                  food = food - 0.02
                end

                if water > 0 then
                  water = water - 0.03
                end

                if alcool > 0 then
                  alcool = alcool - 0.2
                end
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
                SetEntityHealth(Venato.GetPlayerPed(), 0)
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

            AlcoolEffet(old_alcool, alcool)
            old_alcool = alcool
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


function AlcoolEffet()
    local phase = -1
   if(alcool <= 10) then
    phase = 0
   elseif(alcool <= 15) then
    phase = 1
   elseif(alcool <= 25) then
    phase = 2
   elseif(alcool <= 35) then
    phase = 3
   elseif(alcool <= 45) then
    phase = 4
   elseif(alcool <= 55) then
    phase = 5
   elseif(alcool <= 65) then
    phase = 6
   elseif(alcool <= 70) then
    phase = 7
   elseif(alcool <= 75) then
    phase = 8
   elseif(alcool <= 80) then
    phase = 9
   elseif(alcool <= 85) then
    phase = 10
   elseif(alcool <= 90) then
    phase = 11
   elseif(alcool <= 95) then
    phase = 12
   elseif(alcool >= 100) then
    phase = 13
   end

   if(phase ~= old_phase) then
    AlcoolEffetPhase(phase)
    old_phase = phase
   end
    
end

function AlcoolEffetPhase(phase)
    local ped = GetPlayerPed(-1)
    if(phase == 0) then         
        SetPedIsDrunk(ped, false)
        ShakeGameplayCam("DRUNK_SHAKE", 0.0)
        ResetPedMovementClipset( ped )
        ResetPedStrafeClipset(ped)
        -- SetPedCanRagdoll(ped,false)
        -- SetPedCanRagdollFromPlayerImpact(ped,false)
    elseif (phase == 1) then         
        ShakeGameplayCam("DRUNK_SHAKE", 0.5)          
        SetPedIsDrunk(ped, false)
        ResetPedMovementClipset( ped )
        ResetPedStrafeClipset(ped)
        -- SetPedCanRagdoll(ped,false)
        -- SetPedCanRagdollFromPlayerImpact(ped,false)
    elseif (phase == 2) then              
        ShakeGameplayCam("DRUNK_SHAKE", 0.7)          
        SetPedIsDrunk(ped, true)
        ResetPedMovementClipset( ped )
        ResetPedStrafeClipset(ped)
        -- SetPedCanRagdoll(ped,false)
        -- SetPedCanRagdollFromPlayerImpact(ped,false)
    elseif (phase == 3) then             
        ShakeGameplayCam("DRUNK_SHAKE", 1.0)
        SetPedIsDrunk(ped, true)
        SetPedConfigFlag(ped, 100, true)
        if not HasAnimSetLoaded("MOVE_M@DRUNK@MODERATEDRUNK_HEAD_UP") then
            RequestAnimSet("MOVE_M@DRUNK@MODERATEDRUNK_HEAD_UP")
            while not HasAnimSetLoaded("MOVE_M@DRUNK@MODERATEDRUNK_HEAD_UP") do
                Citizen.Wait(0)
            end
        end
        SetPedMovementClipset(ped, "MOVE_M@DRUNK@MODERATEDRUNK_HEAD_UP", 1.0)
        -- SetPedCanRagdoll(ped,false)
        -- SetPedCanRagdollFromPlayerImpact(ped,false)
    elseif (phase == 4) then            
        ShakeGameplayCam("DRUNK_SHAKE", 1.4)
        SetPedIsDrunk(ped, true)
        SetPedConfigFlag(ped, 100, true)
        if not HasAnimSetLoaded("MOVE_M@DRUNK@MODERATEDRUNK_HEAD_UP") then
            RequestAnimSet("MOVE_M@DRUNK@MODERATEDRUNK_HEAD_UP")
            while not HasAnimSetLoaded("MOVE_M@DRUNK@MODERATEDRUNK_HEAD_UP") do
                Citizen.Wait(0)
            end
        end
        SetPedMovementClipset(ped, "MOVE_M@DRUNK@MODERATEDRUNK_HEAD_UP", 1.0)
        -- SetPedCanRagdoll(ped,false)
        -- SetPedCanRagdollFromPlayerImpact(ped,false)
    elseif (phase == 5) then                
        ShakeGameplayCam("DRUNK_SHAKE", 1.7)
        SetPedIsDrunk(ped, true)
        SetPedConfigFlag(ped, 100, true)        
        if not HasAnimSetLoaded("MOVE_M@DRUNK@MODERATEDRUNK") then
            RequestAnimSet("MOVE_M@DRUNK@MODERATEDRUNK")
            while not HasAnimSetLoaded("MOVE_M@DRUNK@MODERATEDRUNK") do
                Citizen.Wait(0)
            end
        end
        SetPedMovementClipset(ped, "MOVE_M@DRUNK@MODERATEDRUNK", 1.0)
        -- SetPedCanRagdoll(ped,false)
        -- SetPedCanRagdollFromPlayerImpact(ped,false)
    elseif (phase == 6) then              
        ShakeGameplayCam("DRUNK_SHAKE", 2.0)
        SetPedIsDrunk(ped, true)
        SetPedConfigFlag(ped, 100, true) 
        if not HasAnimSetLoaded("MOVE_M@DRUNK@SLIGHTLYDRUNK") then
            RequestAnimSet("MOVE_M@DRUNK@SLIGHTLYDRUNK")
            while not HasAnimSetLoaded("MOVE_M@DRUNK@SLIGHTLYDRUNK") do
                Citizen.Wait(0)
            end
        end
        SetPedMovementClipset(ped, "MOVE_M@DRUNK@SLIGHTLYDRUNK", 1.0)
        -- SetPedCanRagdoll(ped,false)
        -- SetPedCanRagdollFromPlayerImpact(ped,false)
    elseif (phase == 7) then            
        ShakeGameplayCam("DRUNK_SHAKE", 2.5)
        SetPedIsDrunk(ped, true)
        SetPedConfigFlag(ped, 100, true)
        if not HasAnimSetLoaded("MOVE_M@DRUNK@SLIGHTLYDRUNK") then
            RequestAnimSet("MOVE_M@DRUNK@SLIGHTLYDRUNK")
            while not HasAnimSetLoaded("MOVE_M@DRUNK@SLIGHTLYDRUNK") do
                Citizen.Wait(0)
            end
        end
        SetPedMovementClipset(ped, "MOVE_M@DRUNK@SLIGHTLYDRUNK", 1.0)
        -- SetPedCanRagdoll(ped,false)
        -- SetPedCanRagdollFromPlayerImpact(ped,false)
    elseif (phase == 8) then             
        ShakeGameplayCam("DRUNK_SHAKE", 3.5)
        SetPedIsDrunk(ped, true)
        SetPedConfigFlag(ped, 100, true)
        if not HasAnimSetLoaded("MOVE_M@DRUNK@VERYDRUNK") then
            RequestAnimSet("MOVE_M@DRUNK@VERYDRUNK")
            while not HasAnimSetLoaded("MOVE_M@DRUNK@VERYDRUNK") do
                Citizen.Wait(0)
            end
        end
        SetPedMovementClipset(ped, "MOVE_M@DRUNK@VERYDRUNK", 1.0)
        -- SetPedCanRagdoll(ped,true)
        -- SetPedCanRagdollFromPlayerImpact(ped,true)
    elseif (phase == 9) then              
        ShakeGameplayCam("DRUNK_SHAKE", 4.5)
        SetPedIsDrunk(ped, true)
        SetPedConfigFlag(ped, 100, true)
        if not HasAnimSetLoaded("MOVE_M@DRUNK@VERYDRUNK") then
            RequestAnimSet("MOVE_M@DRUNK@VERYDRUNK")
            while not HasAnimSetLoaded("MOVE_M@DRUNK@VERYDRUNK") do
                Citizen.Wait(0)
            end
        end
        SetPedMovementClipset(ped, "MOVE_M@DRUNK@VERYDRUNK", 1.0)
        -- SetPedCanRagdoll(ped,true)
        -- SetPedCanRagdollFromPlayerImpact(ped,true)
    elseif (phase == 10) then             
        ShakeGameplayCam("DRUNK_SHAKE", 5.5)
        SetPedIsDrunk(ped, true)
        SetPedConfigFlag(ped, 100, true)
        if not HasAnimSetLoaded("MOVE_M@DRUNK@VERYDRUNK") then
            RequestAnimSet("MOVE_M@DRUNK@VERYDRUNK")
            while not HasAnimSetLoaded("MOVE_M@DRUNK@VERYDRUNK") do
                Citizen.Wait(0)
            end
        end
        SetPedMovementClipset(ped, "MOVE_M@DRUNK@VERYDRUNK", 1.0)
        -- SetPedCanRagdoll(ped,true)
        -- SetPedCanRagdollFromPlayerImpact(ped,true)
    elseif (phase == 11) then             
        ShakeGameplayCam("DRUNK_SHAKE", 6.5)
        SetPedIsDrunk(ped, true)
        SetPedConfigFlag(ped, 73, true)
        if not HasAnimSetLoaded("MOVE_M@DRUNK@VERYDRUNK") then
            RequestAnimSet("MOVE_M@DRUNK@VERYDRUNK")
            while not HasAnimSetLoaded("MOVE_M@DRUNK@VERYDRUNK") do
                Citizen.Wait(0)
            end
        end
        SetPedMovementClipset(ped, "MOVE_M@DRUNK@VERYDRUNK", 1.0)
        -- SetPedCanRagdoll(ped,true)
        -- SetPedCanRagdollFromPlayerImpact(ped,true)
    elseif (phase == 12) then            
        ShakeGameplayCam("DRUNK_SHAKE", 7.7)
        SetPedIsDrunk(ped, true)
        SetPedConfigFlag(ped, 73, true)
        if not HasAnimSetLoaded("MOVE_M@DRUNK@VERYDRUNK") then
            RequestAnimSet("MOVE_M@DRUNK@VERYDRUNK")
            while not HasAnimSetLoaded("MOVE_M@DRUNK@VERYDRUNK") do
                Citizen.Wait(0)
            end
        end
        SetPedMovementClipset(ped, "MOVE_M@DRUNK@VERYDRUNK", 1.0)
        -- SetPedCanRagdoll(ped,true)
        -- SetPedCanRagdollFromPlayerImpact(ped,true)
    elseif (phase == 13) then        
        SetEntityHealth(Venato.GetPlayerPed(), 0)
        old_phase = -1
    end
end
