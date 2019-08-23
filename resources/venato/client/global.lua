local ingame = 0
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
    Citizen.Wait(10)
    if not Startload then
      if NetworkIsPlayerActive(PlayerId()) then

        TriggerServerEvent("Venato:SyncData")
        TriggerServerEvent('lock:synchr')
        Startload = true
      end
    end
    SetPlayerWantedLevel(playerId, 0 , false)
    SetPlayerWantedLevelNow(playerId, false, false)
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
  TriggerServerEvent("Venato:CallDataPlayerSpawn", PlayerId())
end)

RegisterNetEvent("Venato:SpawnInit")
AddEventHandler("Venato:SpawnInit", function(DataPlayers, source)
  if DataPlayers[source] ~= nil then
    LoadBlips()
    Venato.LoadSkin(DataPlayers[source])
    Venato.LoadClothes()
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

RegisterNetEvent("Venato:InteractTxt")
AddEventHandler("Venato:InteractTxt", function(msg)
  Venato.InteractTxt(msg)
end)

RegisterNetEvent("Venato:TestImage")
AddEventHandler("Venato:TestImage", function()
  none()
  --https://openclassrooms.com/bundles/common/images/avatar_defaut.png
end)

RegisterNetEvent("Venato:ActuPlayer")
AddEventHandler("Venato:ActuPlayer", function(nb)
  ingame = nb
end)

local DiscordAppId = tonumber(GetConvar("RichAppId", "510934092821430282"))
local DiscordAppAsset = GetConvar("RichAssetId", "discordicon")

Citizen.CreateThread(function()
	while true do
  	  SetDiscordAppId(DiscordAppId)
  	  SetDiscordRichPresenceAsset(DiscordAppAsset)
		  SetRichPresence(--[[]VNT_ScriptCoreVenato:getPrenom().." "..exports.VNT_ScriptCoreVenato:getNom()..--[]]" "..ingame.." joueurs connectés")
		  Citizen.Wait(10000)
	end
end)
