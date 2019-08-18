DataUser = {}

Citizen.CreateThread(function()
  local ped = Venato.GetPlayerPed()
  local playerId = PlayerId()
  local Startload = false
  NetworkSetFriendlyFireOption(true)
  SetCanAttackFriendly(ped, true, false)
  SetPlayerCanBeHassledByGangs(ped, true)
	SetEveryoneIgnorePlayer(ped, true)
  Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), 'FE_THDR_GTAO', 'Venato.fr')
  --if GetEntityModel(Venato.GetPlayerPed()) == GetHashKey('mp_f_freemode_01') or GetEntityModel(Venato.GetPlayerPed()) == GetHashKey('mp_m_freemode_01') then
    --TriggerServerEvent("Venato:SyncData")
  --end
  while true do
    Citizen.Wait(50)
    if not Startload then
      if NetworkIsPlayerActive(PlayerId()) then
        print('load')
        TriggerServerEvent("Venato:SyncData")
        Startload = true
      end
    end
    SetPlayerWantedLevel(playerId, 0 , false)
    SetPlayerWantedLevelNow(playerId, false, false)
  end
end)

AddEventHandler('playerSpawned', function()
  TriggerServerEvent('lock:synchr')
  TriggerServerEvent("Venato:SyncData")
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
  TriggerServerEvent("Venato:CallDataPlayerSpawn", PlayerId())
end)

RegisterNetEvent("Venato:SpawnInit")
AddEventHandler("Venato:SpawnInit", function(DataPlayers, source)
  if DataPlayers[source] ~= nil then
    LoadBlips()
    Venato.LoadSkin(DataPlayers[source])
  end
end)

RegisterNetEvent("Venato:notify")
AddEventHandler("Venato:notify", function(notif)
  Venato.notify(notif)
end)

RegisterNetEvent("Venato:notifyError")
AddEventHandler("Venato:notifyError", function(msg)
  Venato.notifyError(msg)
end)

RegisterNetEvent("Menu:Execute")
AddEventHandler("Menu:Execute", function(params)
  _ = _G[params.fn] and _G[params.fn](params.args)
end)

RegisterNetEvent("Venato:InteractTxt")
AddEventHandler("Venato:InteractTxt", function(msg)
  Venato.InteractTxt(msg)
end)
