DataUser = {}

Citizen.CreateThread(function()
  print(GetPlayerPed(GetPlayerFromServerId(1)))
  local ped = Venato.GetPlayerPed()
  NetworkSetFriendlyFireOption(true)
  SetCanAttackFriendly(ped, true, false)
  SetPlayerCanBeHassledByGangs(ped, true)
	SetEveryoneIgnorePlayer(ped, true)
  Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), 'FE_THDR_GTAO', 'Venato.fr')
  TriggerServerEvent("Venato:SyncData")
  SetTimeout(5000, function() TriggerServerEvent("Venato:CallDataPlayerSpawn") end)
  while true do
    Citizen.Wait(0)
    --SetPlayerWantedLevel(ped, 0 , false)
    SetPlayerWantedLevelNow(ped, false, false)
  end
end)

RegisterNetEvent("Venato:displaytext")
AddEventHandler("Venato:displaytext", function(text, time)
  ClearPrints()
  SetTextEntry_2("STRING")
  AddTextComponentString(text)
  DrawSubtitleTimed(time, 1)
end)

RegisterNetEvent("Venato:Connection")
AddEventHandler("Venato:Connection", function()
  SetTimeout(5000, function() TriggerServerEvent("Venato:CallDataPlayerSpawn") end)
end)

RegisterNetEvent("Venato:SpawnInit")
AddEventHandler("Venato:SpawnInit", function(DataPlayers, source)
  if DataPlayers[source] ~= nil then
    LoadBlips()
    Venato.LoadClothes()
    Venato.LoadSkin(DataPlayers[source])
  end
end)
