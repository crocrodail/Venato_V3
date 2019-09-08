local ingame = 0
DataUser = {}
CanCancelOrStartAnim = true

function fCanCancelOrStartAnim(bool)
  CanCancelOrStartAnim = bool
end

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

RegisterNetEvent("Venato:LoadClothes")
AddEventHandler("Venato:LoadClothes", function()
  Venato.LoadClothes()
end)

RegisterNetEvent("Venato:SpawnInit")
AddEventHandler("Venato:SpawnInit", function(DataPlayers, source)
  if DataPlayers[source] ~= nil then
    DataUser = DataPlayers[source]
    LoadBlips()
    Venato.LoadSkin(DataPlayers[source])
    Venato.LoadClothes()
    if tonumber(DataPlayers[source].Health) < 100 then SetEntityHealth(Venato.GetPlayerPed(), tonumber(DataPlayers[source].Health)) end
    TriggerServerEvent("GcPhone:Load")
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
  SetVehicleDensityMultiplierThisFrame(0.5)
	SetPedDensityMultiplierThisFrame(0.5)
	SetRandomVehicleDensityMultiplierThisFrame(0.5)
	SetParkedVehicleDensityMultiplierThisFrame(0.5)
	SetScenarioPedDensityMultiplierThisFrame(0.5, 0.5)
	while true do
    local cheatNb = 0
    if ingame > 30 then cheatNb = 15 elseif ingame > 20 then cheatNb = 10 elseif ingame > 15 then cheatNb = 7 --- CHEAT NB JOUEURS
    elseif ingame > 10 then cheatNb = 5 elseif ingame > 5 then cheatNb = 2 end                                --- CHEAT NB JOUEURS
  	  SetDiscordAppId(DiscordAppId)
  	  SetDiscordRichPresenceAsset(DiscordAppAsset)
		  SetRichPresence(ingame+cheatNb.." joueurs connectés")
		  Citizen.Wait(10000)
	end
end)

local poleemploie = {x=-1055.0,y=-242.371,z=44.021}
local Scouteur = {x=-1026.454,y=-2736.643,z=20.169}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
    local x,y,z = table.unpack(GetEntityCoords(Venato.GetPlayerPed(), true))
    local disPole = Vdist(x, y, z, poleemploie.x, poleemploie.y, poleemploie.z)
    local disScouteur = Vdist(x, y, z, Scouteur.x, Scouteur.y, Scouteur.z)
    if disPole <= 1 then
      DrawMarker(27,poleemploie.x,poleemploie.y,poleemploie.z-0.9,0,0,0,0,0,0,1.0,1.0,1.0,250,250,250,200,0,0,0,0)
      Venato.InteractTxt('Appuyez sur ~INPUT_PICKUP~ Pour ouvrir PoleEmploie')
      if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
        Openpoleemploie()
        Menu.toggle()
      end
    elseif disPole < 20 then
      DrawMarker(27,poleemploie.x,poleemploie.y,poleemploie.z-0.9,0,0,0,0,0,0,1.0,1.0,1.0,250,250,250,200,0,0,0,0)
    elseif disScouteur <= 1 then
      DrawMarker(27,Scouteur.x,Scouteur.y,Scouteur.z-0.9,0,0,0,0,0,0,1.0,1.0,1.0,250,250,250,200,0,0,0,0)
      Venato.InteractTxt('Appuyez sur ~INPUT_PICKUP~ Pour louer un scouteur')
      if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
        getScouteur()
      end
    elseif disScouteur < 20 then
      DrawMarker(27,Scouteur.x,Scouteur.y,Scouteur.z-0.9,0,0,0,0,0,0,1.0,1.0,1.0,250,250,250,200,0,0,0,0)
    end
	end
end)

function getScouteur()
  Venato.CreateVehicle('Faggio',{x=Scouteur.x, y=Scouteur.y, z=Scouteur.z},-50.0, function(vehicle)
    SetVehicleNumberPlateText(vehicle,"LOCATION")
    plate = GetVehicleNumberPlateText(vehicle)
    SetPedIntoVehicle(Venato.GetPlayerPed(), vehicle, -1)
    TriggerEvent('lock:addVeh', plate, GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
  end)
end

function Openpoleemploie()
  TriggerEvent('Menu:Init', "", "Choisissez votre nouveau métier", "#90CAF999", "https://www.afar-fiction.com/IMG/arton1890.png?201901021826")
  Menu.clearMenu()
  Menu.addButton2("Pompiste", "sitchJob", 22, nil, nil)
  Menu.addButton2("Vigneron", "sitchJob", 13, nil, nil)
  Menu.addButton2("Brasseur", "sitchJob", 12, nil, nil)
  Menu.addButton2("Liveur PostOp (Beta v1.0)", "PostOp", nil, nil, nil)
  Menu.CreateMenu()
end

function PostOp()
  AddPointToGpsCustomRoute(-423.96, -2789.39 ,6.0)
  local defaultNotification = {
    type = "alert",
    title ="PoleEmploi",
    logo = "https://www.pngfactory.net/_png/_thumb/29520-Caetano-Paleemploi.png",
    message = "PostOP est une entreprise libre vous pouvez y travailler sans avec l'emploi 'PostOP'. les coordonées de l'entreprise on été ajouté à votre GPS."
  }
  Venato.notify(defaultNotification)
end

function sitchJob(id)
  TriggerServerEvent("Venato:SwitchJob", id)
end
