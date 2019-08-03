DataUser = {}

AddEventHandler('playerSpawned', function()
  TriggerServerEvent("Venato:CallDataPlayerSpawn")
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
  LifeInit()
end)

RegisterNetEvent("Venato:SpawnInit")
AddEventHandler("Venato:SpawnInit", function(DataPlayers, source)
  print("la")
  if DataPlayers[source] ~= nil then
    print("couocu")
    LoadBlips()
    Venato.LoadClothes()
    Venato.LoadSkin(DataPlayers[source])
  end
end)

if(GetEntityModel(Venato.GetPlayerPed()) == GetHashKey("mp_m_freemode_01")) or (GetEntityModel(Venato.GetPlayerPed()) == GetHashKey("mp_f_freemode_01")) then
	TriggerServerEvent("debuge")
	SetTimeout(3000, function() TriggerServerEvent("Venato:CallDataPlayerSpawn") end)
end
