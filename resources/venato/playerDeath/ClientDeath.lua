local dead = false
local playerPed = nil
local cam = nil
local ClonedPed = nil
local TimeToRespawn = 0
local assommePlayer = false
local shooting = 0
local causeOfDeath = 'Cause inconnue'

function Venato.resurect()
  assommePlayer = false
  TimeToRespawn = 0
  dead = false
  Venato.playAnim({lib = "get_up@standard", anim = "back", useLib = true})
  StopAllScreenEffects()
end

Citizen.CreateThread(function()
  Citizen.Wait(5000)
  while true do
    Citizen.Wait(0)
		playerPed = GetPlayerPed(-1)
    if IsEntityDead(playerPed) then
      causeOfDeath = GetCause()
      local killer = GetKiller()
      local Weapon = GetWeapon()
			StartScreenEffect("DeathFailMPIn", 10000 , true)
      TriggerServerEvent("Death:ComaOrNot", killer, causeOfDeath)
      Citizen.Wait(3000)
      local coordPed = GetEntityCoords(playerPed, true)
      NetworkResurrectLocalPlayer(coordPed.x, coordPed.y, coordPed.z, 0, false, false, false)
      Venato.playAnim({lib = "mini@cpr@char_b@cpr_def", anim = "cpr_pumpchest_idle", useLib = true, flag = 1})
      ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 1.0)
      SetEntityHealth(playerPed, 100)
    end
  end
end)

RegisterNetEvent("Death:ComaOrNot:cb")
AddEventHandler("Death:ComaOrNot:cb", function(boolean)
  Citizen.CreateThread(function()
    dead = true
    TriggerServerEvent("Death:Dead", true)
    assommePlayer = boolean
    if assommePlayer and (causeOfDeath == 'Cause inconnue' or causeOfDeath == 'Trace de coup')  then
      TimeToRespawn = 120
    else
      TimeToRespawn = 300
      ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 1.0)
      Venato.ScaleForm("MP_BIG_MESSAGE_FREEMODE")
			PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
			BeginTextComponent("STRING")
			AddTextComponentString("~r~Vous êtes dans le coma =3")
			EndTextComponent()
			PopScaleformMovieFunctionVoid()
      Citizen.Wait(500)
      while dead do
				DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
			 	Citizen.Wait(0)
      end
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
      drawTxt(0.88, 1.45, 1.0,1.0,0.4, "~r~Appuyez sur ~g~C ~r~pour appeler un médecin.", 255, 255, 255, 255)
    elseif dead and TimeToRespawn == 0 and not assommePlayer then
      drawTxt(0.88, 1.02, 1.0,1.0,0.4, "~g~Appuyez sur ~r~X ~g~pour respawn à l'hospital.", 255, 255, 255, 255)
      if IsControlJustPressed(1, 73) and  GetLastInputMethod(2) then
        TriggerEvent('ambulancier:selfRespawn')
      end
    elseif dead and TimeToRespawn > 0 and assommePlayer then
      drawTxt(0.88, 1.02, 1.0,1.0,0.4, "Attendez ~r~" .. TimeToRespawn .. "~w~ secondes avant de vous réveillez.", 255, 255, 255, 255)
    elseif dead and TimeToRespawn == 0 and assommePlayer then
      Venato.playAnim({lib = "get_up@standard", anim = "back", useLib = true})
      StopAllScreenEffects()
      dead = false
      TriggerServerEvent("Death:Dead", false)
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
    if dead then
      Venato.playAnim({lib = "mini@cpr@char_b@cpr_def", anim = "cpr_pumpchest_idle", useLib = true, flag = 1})
    end
  end
end)

function playemote()
  dead = false
  local ClonedPed = ClonePed(Venato.GetPlayerPed(), GetEntityHeading(Venato.GetPlayerPed()), 1, 1)
  local coord = GetEntityCoords(Venato.GetPlayerPed(), true)
  local heading = GetEntityHeading(Venato.GetPlayerPed())
  SetEntityCoords(ClonedPed, coord.x-0.9, coord.y-0.1, coord.z, 0, 0, 0, true)
  SetEntityHeading(ClonedPed, heading-90)
  Venato.playAnim({lib = "mini@cpr@char_a@cpr_def", anim = "cpr_intro", useLib = true, ped = ClonedPed})
  Venato.playAnim({lib = "mini@cpr@char_b@cpr_def", anim = "cpr_intro", useLib = true})
  Citizen.Wait(15000)
  Venato.playAnim({lib = "mini@cpr@char_a@cpr_str", anim = "cpr_pumpchest", useLib = true, flag = 1, ped = ClonedPed})
  Venato.playAnim({lib = "mini@cpr@char_b@cpr_str", anim = "cpr_pumpchest", useLib = true, flag = 1})
  Citizen.Wait(5000)
  Venato.playAnim({lib = "mini@cpr@char_a@cpr_str", anim = "cpr_cpr_to_kol", useLib = true, ped = ClonedPed})
  Venato.playAnim({lib = "mini@cpr@char_b@cpr_str", anim = "cpr_cpr_to_kol", useLib = true})
  Citizen.Wait(1500)
  Venato.playAnim({lib = "mini@cpr@char_a@cpr_str", anim = "cpr_kol", useLib = true, ped = ClonedPed})
  Venato.playAnim({lib = "mini@cpr@char_b@cpr_str", anim = "cpr_kol", useLib = true})
  Citizen.Wait(5000)
  Venato.playAnim({lib = "mini@cpr@char_a@cpr_str", anim = "cpr_kol_to_cpr", useLib = true, ped = ClonedPed})
  Venato.playAnim({lib = "mini@cpr@char_b@cpr_str", anim = "cpr_kol_to_cpr", useLib = true})
  Citizen.Wait(1500)
  Venato.playAnim({lib = "mini@cpr@char_a@cpr_str", anim = "cpr_pumpchest", useLib = true, flag = 1, ped = ClonedPed})
  Venato.playAnim({lib = "mini@cpr@char_b@cpr_str", anim = "cpr_pumpchest", useLib = true, flag = 1})
  Citizen.Wait(5000)
  Venato.playAnim({lib = "mini@cpr@char_a@cpr_str", anim = "cpr_success", useLib = true, ped = ClonedPed})
  Venato.playAnim({lib = "mini@cpr@char_b@cpr_str", anim = "cpr_success", useLib = true})
  Citizen.Wait(26000)
  ClearPedTasks(GetPlayerPed(-1))
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
    Reanim("a")
  else
    Reanim("b")
  end
end)

function Reanim(char, coord, heading)
  Citizen.CreateThread(function()
    if char == "a" then
      SetEntityCoords(GetPlayerPed(-1), coord.x-0.9, coord.y-0.1, coord.z, 0, 0, 0, true)
      SetEntityHeading(GetPlayerPed(-1), heading-90)
    else
      dead = false
      TriggerServerEvent("Death:Dead", false)
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
  end)
end
