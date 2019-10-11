local dead = false
local playerPed = nil
local cam = nil
local ClonedPed = nil
local TimeToRespawn = 0
local assommePlayer = false
local shooting = 0
local causeOfDeath = 'Cause inconnue'
local CoordHospital = {x = 1141.0, y= -1594.32, z = 4.979}
local old_cause = ''

function Venato.resurect()
  assommePlayer = false
  TimeToRespawn = 0
  dead = false
  LiveFreezeNeed(false)
  fCanCancelOrStartAnim(true)
  Venato.playAnim({lib = "get_up@standard", anim = "back", useLib = true})
  TriggerServerEvent("Death:health", false)
  StopAllScreenEffects()
end

Citizen.CreateThread(function()
  Citizen.Wait(5000)
  while true do
    Citizen.Wait(0)
    playerPed = GetPlayerPed(-1)
    if dead then
      print('dead : true')
    else
      print('dead : false')
    end
    if assommePlayer then
      print('assommePlayer : true')
    else
      print('assommePlayer : false')
    end
    print('old_cause : '..old_cause)
    print('TimeToRespawn : '..TimeToRespawn)
    if IsEntityDead(playerPed) then
      causeOfDeath = GetCause()
      local killer = GetKiller()
      local Weapon = GetWeapon()
      print('killer : '..killer)
      print('causeOfDeath : '..causeOfDeath)
      if not dead or (assommePlayer and causeOfDeath ~= old_cause) then      
          TriggerServerEvent("Death:ComaOrNot", killer, causeOfDeath)
          StartScreenEffect("DeathFailMPIn", 10000 , true)
          Citizen.Wait(3000)
          local coordPed = GetEntityCoords(playerPed, true)
          NetworkResurrectLocalPlayer(coordPed.x, coordPed.y, coordPed.z, 0, false, false, false)
          Venato.playAnim({lib = "mini@cpr@char_b@cpr_def", anim = "cpr_pumpchest_idle", useLib = true, flag = 1})
          FreezeEntityPosition(playerPed, true)
          ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 1.0)
          SetEntityHealth(playerPed, 100)
      end

      old_cause = causeOfDeath
    end
    if dead then
      DisableControlAction(0, Keys['F2'], true)
      DisableControlAction(0, Keys['F1'], true)
      DisableControlAction(0, Keys['F3'], true)
      DisableControlAction(0, Keys['F8'], true)
      DisableControlAction(0, Keys['F7'], true)
      DisableControlAction(0, Keys['F6'], true)
      DisableControlAction(0, Keys['F5'], true)
      DisableControlAction(0, Keys['K'], true)
      --Venato.playAnim({lib = "mini@cpr@char_b@cpr_def", anim = "cpr_pumpchest_idle", useLib = true, flag = 2})
    end
  end
end)

RegisterNetEvent("Death:ComaOrNot:cb")
AddEventHandler("Death:ComaOrNot:cb", function(boolean)
  Citizen.CreateThread(function()    
    dead = true
    LiveFreezeNeed(true)
    fCanCancelOrStartAnim(false)
    TriggerServerEvent("Death:health", true)
    assommePlayer = boolean
    ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 1.0)
    Venato.ScaleForm("MP_BIG_MESSAGE_FREEMODE")
    PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
    BeginTextComponent("STRING")
    
    if assommePlayer and (causeOfDeath == 'Cause inconnue' or causeOfDeath == 'Trace de coup')  then
      TimeToRespawn = 120
      AddTextComponentString("~r~Vous êtes dans le coma.")
    else
      TimeToRespawn = 300
      AddTextComponentString("~r~Vous êtes dans un état grave")
    end
    
    EndTextComponent()
    PopScaleformMovieFunctionVoid()
    Citizen.Wait(500)
			
    while dead do
      DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
      Citizen.Wait(0)
    end
  end)
end)

Citizen.CreateThread(function()
  local firtdead = true
  local fait = 1
  local fait2 = 0
	while true do
    if dead and TimeToRespawn > 0 and not assommePlayer then
			drawTxt(0.88, 1.02, 1.0,1.0,0.4, "Attendez ~r~" .. TimeToRespawn .. "~w~ secondes avant de respawn.", 255, 255, 255, 255)
      drawTxt(0.88, 1.45, 1.0,1.0,0.4, "~r~Appuyez sur ~g~C ~r~pour appeler un médecin. (+300sec pour leur laisser le temps de venir)", 255, 255, 255, 255)
      if IsControlJustPressed(1, Keys["C"]) and  GetLastInputMethod(2) then
        CallHospital()
        if TimeToRespawn < 300 then
          TimeToRespawn = TimeToRespawn + 300
        end
      end
    elseif dead and TimeToRespawn == 0 and not assommePlayer then
      drawTxt(0.88, 1.02, 1.0,1.0,0.4, "~g~Appuyez sur ~r~X ~g~pour respawn à l'hospital.", 255, 255, 255, 255)
      if IsControlJustPressed(1, Keys["X"]) and  GetLastInputMethod(2) then
        RespawnHospital()
      end
    elseif dead and TimeToRespawn > 0 and assommePlayer then
      drawTxt(0.88, 1.02, 1.0,1.0,0.4, "Attendez ~r~" .. TimeToRespawn .. "~w~ secondes avant de vous réveillez.", 255, 255, 255, 255)
    elseif dead and TimeToRespawn == 0 and assommePlayer then
      Venato.playAnim({lib = "get_up@standard", anim = "back", useLib = true})
      StopAllScreenEffects()
      print('DEAD = FALSE')
      dead = false
      FreezeEntityPosition(GetPlayerPed(-1), false)
      LiveFreezeNeed(false)
      fCanCancelOrStartAnim(true)
      TriggerServerEvent("Death:health", false)
    else
      if IsPedShooting(GetPlayerPed(-1)) then
        shooting = 2
        fait = 0
      end
      if shooting ~= 0 and fait == 0 and fait2 == 0 then
        TriggerServerEvent("Death:KillerAreShooting", true)
        fait2 = 1
      end
      if shooting == 0 and fait == 0 then
        TriggerServerEvent("Death:KillerAreShooting", false)
        fait = 1
        fait2 = 0
      end
    end
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
    if TimeToRespawn > 0 then
      TimeToRespawn = TimeToRespawn - 1
    end
    if shooting > 0 then
      shooting = shooting -1
    end
  end
end)

function CallHospital()
  TriggerEvent("ambulancier:callAmbulancier", "Coma")
end

function RespawnHospital()
  dead = false
  TriggerServerEvent("Death:health", false)
  FreezeEntityPosition(GetPlayerPed(-1), false)
  LiveFreezeNeed(false)
  fCanCancelOrStartAnim(true)
  NetworkResurrectLocalPlayer(CoordHospital.x, CoordHospital.y, CoordHospital.z, 0, false, false, false)
  SetEntityCoords(GetPlayerPed(-1), CoordHospital.x, CoordHospital.y, CoordHospital.z, 0, 0, 0, true)
  ClearPedTasks(GetPlayerPed(-1))
  StopAllScreenEffects()
end


function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

Citizen.CreateThread(function()
	local isKo = false
  while true do
    Citizen.Wait(1)
    local playerPed = GetPlayerPed(-1)
    local playerID = PlayerId()
    local currentPos = GetEntityCoords(playerPed, true)
    local previousPos
    local isDead = IsEntityDead(playerPed)

    if isKO and previousPos ~= currentPos then
      isKO = false
    end

   if (GetEntityHealth(playerPed) < 120 and not isDead and not isKO) then
      if (IsPedInMeleeCombat(playerPed)) then
        isKO = true
        --SendNotification('Vous êtes KO !')
        SetPedToRagdoll(playerPed, 6000, 6000, 0, 0, 0, 0)
      end
    end

    previousPos = currentPos
  end
end)

RegisterNetEvent("Death:Reanimation")
AddEventHandler("Death:Reanimation", function(who, coord, heading)
  local coord = coord
  if who ~= "victim" then
    Reanim("a",coord,heading)
  else
    Reanim("b")
  end
end)

RegisterNetEvent("vnt:heal:cb")
AddEventHandler("vnt:heal:cb", function()
  SetEntityHealth(Venato.GetPlayerPed(), 200.0)
  TriggerServerEvent("Death:health", false)
end)

RegisterNetEvent("vnt:resurect:cb")
AddEventHandler("vnt:resurect:cb", function()
  local coord = GetEntityCoords(Venato.GetPlayerPed(), false)
  local heading = GetEntityHeading(Venato.GetPlayerPed())
  FreezeEntityPosition(Venato.GetPlayerPed(), false)
  NetworkResurrectLocalPlayer(coord.x, coord.y, coord.z, heading, true, true, false)
  ClearPedTasksImmediately(Venato.GetPlayerPed())
  Venato.resurect()
  TriggerServerEvent("Death:health", false)
  LiveFreezeNeed(false)
  fCanCancelOrStartAnim(true)
  SetEntityHealth(Venato.GetPlayerPed(), 200.0)
end)

function Reanim(char, coord, heading)
  Citizen.CreateThread(function()
    if char == "a" then
      SetEntityCoords(GetPlayerPed(-1), coord.x-0.9, coord.y-0.1, coord.z-0.0, 0, 0, 0, true)
      SetEntityHeading(GetPlayerPed(-1), heading-90)
    else
      FreezeEntityPosition(GetPlayerPed(-1), false)
      LiveFreezeNeed(false)
      fCanCancelOrStartAnim(true)
    end
    Venato.playAnim({lib = "mini@cpr@char_"..char.."@cpr_def", anim = "cpr_intro", useLib = true})
    Citizen.Wait(15000)
    Venato.playAnim({lib = "mini@cpr@char_"..char.."@cpr_str", anim = "cpr_pumpchest", useLib = true, flag = 1})
    Citizen.Wait(5000)
    Venato.playAnim({lib = "mini@cpr@char_"..char.."@cpr_str", anim = "cpr_cpr_to_kol", useLib = true})
    Citizen.Wait(1500)
    Venato.playAnim({lib = "mini@cpr@char_"..char.."@cpr_str", anim = "cpr_kol", useLib = true})
    Citizen.Wait(5000)
    Venato.playAnim({lib = "mini@cpr@char_"..char.."@cpr_str", anim = "cpr_kol_to_cpr", useLib = true})
    Citizen.Wait(1500)
    Venato.playAnim({lib = "mini@cpr@char_"..char.."@cpr_str", anim = "cpr_pumpchest", useLib = true, flag = 1})
    Citizen.Wait(5000)
    Venato.playAnim({lib = "mini@cpr@char_"..char.."@cpr_str", anim = "cpr_success", useLib = true})
    Citizen.Wait(26000)
    ClearPedTasks(GetPlayerPed(-1))
    StopAllScreenEffects()
    if char == "b" then
      TriggerServerEvent("Death:health", false)
      assommePlayer = false
      dead = false
      SetEntityHealth(GetPlayerPed(-1), 200.0)
    end
  end)
end
