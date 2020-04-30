local ingame = 0
local mask = false
DataUser = {}
local Config = {}
CanCancelOrStartAnim = true

function fCanCancelOrStartAnim(bool)
  CanCancelOrStartAnim = bool
end

Citizen.CreateThread(function()
  local ped = venato.GetPlayerPed()
  local playerId = PlayerId()
  local Startload = false
  NetworkSetFriendlyFireOption(true)
  SetCanAttackFriendly(ped, true, false)
  SetPlayerCanBeHassledByGangs(ped, true)
	SetEveryoneIgnorePlayer(ped, true)
  Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), 'FE_THDR_GTAO', 'venato.fr')
  --if GetEntityModel(venato.GetPlayerPed()) == GetHashKey('mp_f_freemode_01') or GetEntityModel(venato.GetPlayerPed()) == GetHashKey('mp_m_freemode_01') then
    --TriggerServerEvent("venato:SyncData")
  --end
  while true do
    Citizen.Wait(50)
    if not Startload then
      if NetworkIsPlayerActive(PlayerId()) then

        TriggerServerEvent("venato:SyncData")
        TriggerServerEvent('lock:synchr')
        Startload = true
      end
    end
    SetPlayerWantedLevel(playerId, 0 , false)
    SetPlayerWantedLevelNow(playerId, false, false)
  end
end)

RegisterNetEvent("venato:displaytext")
AddEventHandler("venato:displaytext", function(text, time)
  ClearPrints()
  SetTextEntry_2("STRING")
  AddTextComponentString(text)
  DrawSubtitleTimed(time, 1)
end)

RegisterNetEvent("venato:Connection")
AddEventHandler("venato:Connection", function()
  TriggerServerEvent("venato:CallDataPlayerSpawn", PlayerId())
end)

RegisterNetEvent("venato:LoadClothes")
AddEventHandler("venato:LoadClothes", function()
  venato.LoadClothes()
end)

RegisterNetEvent("venato:SpawnInit")
AddEventHandler("venato:SpawnInit", function(DataPlayers, source)
  if DataPlayers[tonumber(source)] ~= nil then
    DataUser = DataPlayers[tonumber(source)]
    LoadBlips()
    venato.LoadSkin(DataPlayers[tonumber(source)])
    venato.LoadClothes()
    if tonumber(DataPlayers[tonumber(source)].Health) < 100 then SetEntityHealth(venato.GetPlayerPed(), tonumber(DataPlayers[tonumber(source)].Health)) end
    TriggerServerEvent("GcPhone:Load")
  end
end)

RegisterNetEvent("venato:notify")
AddEventHandler("venato:notify", function(notif)
  venato.notify(notif)
end)

RegisterNetEvent("venato:notifyError")
AddEventHandler("venato:notifyError", function(msg)
  venato.notifyError(msg)
end)

RegisterNetEvent("venato:InteractTxt")
AddEventHandler("venato:InteractTxt", function(msg)
  venato.InteractTxt(msg)
end)

RegisterNetEvent("venato:TestImage")
AddEventHandler("venato:TestImage", function()
  none()
  --https://openclassrooms.com/bundles/common/images/avatar_defaut.png
end)

RegisterNetEvent("venato:ActuPlayer")
AddEventHandler("venato:ActuPlayer", function(nb)
  ingame = nb
end)

local DiscordAppId = tonumber(GetConvar("RichAppId", "510934092821430282"))
local DiscordAppAsset = GetConvar("RichAssetId", "discordicon")

Citizen.CreateThread(function()
  SetVehicleDensityMultiplierThisFrame(0.2)
	SetPedDensityMultiplierThisFrame(0.2)
	SetRandomVehicleDensityMultiplierThisFrame(0.2)
	SetParkedVehicleDensityMultiplierThisFrame(0.2)
  SetScenarioPedDensityMultiplierThisFrame(0.2, 0.2)
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
    local x,y,z = table.unpack(GetEntityCoords(venato.GetPlayerPed(), true))
    local disPole = Vdist(x, y, z, poleemploie.x, poleemploie.y, poleemploie.z)
    local disScouteur = Vdist(x, y, z, Scouteur.x, Scouteur.y, Scouteur.z)
    if disPole <= 1 then
      DrawMarker(27,poleemploie.x,poleemploie.y,poleemploie.z-0.9,0,0,0,0,0,0,1.0,1.0,1.0,250,250,250,200,0,0,0,0)
      venato.InteractTxt('Appuyez sur ~INPUT_PICKUP~ pour choisir votre nouveau métier')
      if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
        Openpoleemploie()
        Menu.toggle()
      end
    elseif disPole < 20 then
      DrawMarker(27,poleemploie.x,poleemploie.y,poleemploie.z-0.9,0,0,0,0,0,0,1.0,1.0,1.0,250,250,250,200,0,0,0,0)
    elseif disScouteur <= 1 then
      DrawMarker(37,Scouteur.x,Scouteur.y,Scouteur.z,0,0,0,0,0,0,1.0,1.0,1.0,250,0,0,200,1,0,0,0)
      venato.InteractTxt('Appuyez sur ~INPUT_PICKUP~ pour louer un scooter')
      if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
        getScouteur()
      end
    elseif disScouteur < 20 then
      DrawMarker(37,Scouteur.x,Scouteur.y,Scouteur.z,0,0,0,0,0,0,1.0,1.0,1.0,250,0,0,200,1,0,0,0)
    end
    RemoveAllPickupsOfType(0xDF711959) -- carbine rifle
    RemoveAllPickupsOfType(0xF9AFB48F) -- pistol
    RemoveAllPickupsOfType(0xA9355DCD) -- pumpshotgun
	end
end)

function getScouteur()
  venato.CreateVehicle('Faggio',{x=Scouteur.x, y=Scouteur.y, z=Scouteur.z},-50.0, function(vehicle)
    SetVehicleNumberPlateText(vehicle,"LOCATION")
    plate = GetVehicleNumberPlateText(vehicle)
    SetPedIntoVehicle(venato.GetPlayerPed(), vehicle, -1)
    TriggerEvent('lock:addVeh', plate, GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
  end)
end

function Openpoleemploie()
  TriggerEvent('Menu:Init', "", "Choisissez votre nouveau métier", "#90CAF999", "https://www.afar-fiction.com/IMG/arton1890.png?201901021826")
  Menu.clearMenu()
  Menu.addButton2("Pompiste", "sitchJob", 22, nil, nil)
  Menu.addButton2("Vigneron", "sitchJob", 13, nil, nil)
  Menu.addButton2("Brasseur", "sitchJob", 12, nil, nil)
  --Menu.addButton2("Liveur PostOp (Beta v1.0)", "PostOp", nil, nil, nil)
  Menu.addButton2("Démissioner (Pompiste, Vigneron, Brasseur)", "quitJob", nil, nil, nil)
  Menu.CreateMenu()
end

function toggleMask()
  if mask then
    venato.playAnim({
      useLib = true,
      flag = 48,
      lib = "missfbi4",
      anim = "takeoff_mask",
      timeout = 1666
    })
    SetPedComponentVariation(venato.GetPlayerPed(), 1, 0, 0, 1)
  else
    venato.playAnim({
      useLib = true,
      flag = 48,
      lib = "mp_masks@low_car@ds@",
      anim = "put_on_mask",
      timeout = 1000
    })
    SetPedComponentVariation(venato.GetPlayerPed(), 1, DataUser.Clothes.ComponentVariation.Mask.id, DataUser.Clothes.ComponentVariation.Mask.color, 1)
  end
  mask = not mask
end

function PostOp()
  AddPointToGpsCustomRoute(-423.96, -2789.39 ,6.0)
  local defaultNotification = {
    type = "alert",
    title ="PoleEmploi",
    logo = "https://www.pngfactory.net/_png/_thumb/29520-Caetano-Paleemploi.png",
    message = "PostOP est une entreprise libre vous pouvez y travailler sans avec l'emploi 'PostOP'. les coordonées de l'entreprise on été ajouté à votre GPS."
  }
  venato.notify(defaultNotification)
end

function sitchJob(id)
  TriggerServerEvent("venato:SwitchJob", id)
  Menu.close()
end

function quitJob(id)
  TriggerServerEvent("venato:QuitJob")
  local defaultNotification = {
    type = "alert",
    title ="PoleEmploi",
    logo = "https://www.pngfactory.net/_png/_thumb/29520-Caetano-Paleemploi.png",
    message = "Vous avez démissionné de votre travail."
  }
  venato.notify(defaultNotification)
  Menu.close()
end

RegisterCommand(
    "retour",
    function(source, args, rawCommand)
        SetEntityCoords(venato.GetPlayerPed(), -2317.391, -553.92, 12.426, 0, 0, 0, true)
    end
)
