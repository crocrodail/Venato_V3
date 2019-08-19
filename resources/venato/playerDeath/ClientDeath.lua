local dead = false
local playerPed = nil
local cam = nil
local ClonedPed = nil

Citizen.CreateThread(function()
  Citizen.Wait(5000)
  while true do
    Citizen.Wait(0)
		playerPed = GetPlayerPed(-1)
    if IsEntityDead(playerPed) then
      local Cause = GetCause()
      local killer = GetKiller()
      local Weapon = GetWeapon()
			print('isDead')
      dead = true
			StartScreenEffect("DeathFailMPIn", 10000 , true)
      ResurrectPed(playerPed)
      SetEntityHealth(playerPed, 10.0)
      Citizen.Wait(3000)
      local coordPed = GetEntityCoords(playerPed, true)
      NetworkResurrectLocalPlayer(coordPed.x, coordPed.y, coordPed.z, 0, false, false, false)
      Venato.playAnim({lib = "mini@cpr@char_b@cpr_def", anim = "cpr_pumpchest_idle", useLib = true, flag = 1})
      playemote()
			StopAllScreenEffects()
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
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
