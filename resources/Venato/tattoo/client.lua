local tatooShops = {
    {id = 1 , pos = vector3(-1155.575, -1426.593, 4.954), cam = vector3(-1153.258, -1426.144, 5.175034), camRot = vector3(6.933684, -0, 95.83086)}
}

local cam = -1
-- local currentTattoos = { collection = "mpbeach_overlays", nameHash = "MP_Bea_M_Head_000", x = 0.6, y=0.25 ,z=0.7, rot = 480, price = 50}
local currentTattoos = {}
local shopOpen = false

local x = 1.5
local y= 1
local z= -0.1
local rot = 100.0

local commandTatoo = {
    id = "tatoo",
    command = "E",
    icon = "https://i.ibb.co/jwX4LpD/icons8-tattoo-machine-48px.png",
    text = "Se faire tatouer"
  }
  
local isCommandAdded = nil;

-- Création du blips
Citizen.CreateThread(function()
	for k,v in pairs(tatooShops) do
		local blip = AddBlipForCoord(v.pos)
		SetBlipSprite(blip, 75)
		SetBlipColour(blip, 1)
		SetBlipScale  (blip, 0.8)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString("Salon de tatouage")
		EndTextCommandSetBlipName(blip)
	end
end)

--Boucle de détection de zone

local loopData = {}
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local ply = venato.GetPlayerPed()
    local plyCoords = GetEntityCoords(ply, 0)
    local displayDistance = 20
    local commandDistance = 2
    local displayData = {}
    for _, item in pairs(tatooShops) do
      Citizen.Wait(1)
      local distance = GetDistanceBetweenCoords(item.pos["x"], item.pos["y"], item.pos["z"],  plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
      if loopData.item ~= nil then
        if item.id == loopData.item.id then
          displayData = { distance = distance, item = item }
        end
      end
      if distance < displayDistance then
        displayData = { distance = distance, item = item }
        if distance <= commandDistance then     
          if not isCommandAdded then        
            TriggerEvent('Commands:Add', commandTatoo)          
            isCommandAdded = _
          end
        elseif isCommandAdded == _ then
          TriggerEvent('Commands:Remove', commandTatoo.id)
          isCommandAdded = nil 
        end
      end
    end
    loopData = displayData
  end
end)

--Détection de raccourci clavier
Citizen.CreateThread(function()
    local player = venato.GetPlayerPed()
    while true do
      Citizen.Wait(0)
      if loopData.distance ~= nil then
        if loopData.distance < 50 then
        -- DrawMarker(27,loopData.item.pos["x"], loopData.item.pos["y"], loopData.item.pos["z"]+0.1,0,0,0,0,1,0,1.9,1.9,1.9,0,150,255,200,0,true,0,0)
          if loopData.distance <= 2 then
            FreezeEntityPosition(player, shopOpen)
            if IsControlJustPressed(1, Keys['E']) and GetLastInputMethod(2) then -- press action contextuel (e) pour joueur clavier uniquement
              if not shopOpen then
                openTattooShop()
              else
                closeTattooShop()
              end
            end
          end
        end
      end
    end
  end)


function openTattooShop()
    shopOpen = true

    local player = venato.GetPlayerPed()
    
    SetEntityHeading(player, 297.7296)
    FreezeEntityPosition(player, true)

	  if DoesCamExist(cam) then
      RenderScriptCams(false, false, 0, 1, 0)
      DestroyCam(cam, false)
    end

    if not DoesCamExist(cam) then
      cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
      local x,y,z = table.unpack(GetEntityCoords(player))	
      SetCamCoord(cam, x + 1.7, y + 0.2, z)
      SetCamRot(cam, 0.0, 0.0, 124.9)
      SetCamActive(cam, true)
      RenderScriptCams(true, false, 0, true, true)
    end
    
    cleanPlayer()

    TriggerEvent("Shop:OpenTattoo")

    if(currentTattoos and currentTattoos.collection) then
      applyTattoo()    
    end
end

function applyTattoo()
  cleanPlayer()
  local player = venato.GetPlayerPed()
  
  if 
    string.find(currentTattoos.hash, "_Bea") == nil and
    string.find(currentTattoos.hash, "_Bui") == nil and
    (GetEntityModel(venato.GetPlayerPed()) == GetHashKey("mp_m_freemode_01")) 
  then
    currentTattoos.hash = currentTattoos.hash:gsub("_F", "_M")
  end

  AddPedDecorationFromHashes(player, currentTattoos.collection, currentTattoos.hash)
end

function closeTattooShop()
    local player = venato.GetPlayerPed()
    currentTattoos = nil
    
	if DoesCamExist(cam) then
		RenderScriptCams(false, false, 0, 1, 0)
		DestroyCam(cam, false)
    end   
    
    venato.LoadClothes()
    cleanPlayer()

    FreezeEntityPosition(player, false)
    venato.disableAction(false)
    shopOpen = false

end


function cleanPlayer()
    local player = venato.GetPlayerPed()
    ClearPedDecorationsLeaveScars(player)
    SetPedComponentVariation(player, 8, 15, 0, 0)
    SetPedComponentVariation(player, 11, 15, 0, 0)
    SetPedComponentVariation(player, 3, 15, 0, 0)
    SetPedComponentVariation(player, 4, 18, 0, 0)
    SetPedComponentVariation(player, 6, 34, 0, 0)  
    venato.LoadSkin(DataUser)  
end


RegisterNetEvent('Tattoo:Apply')
AddEventHandler('Tattoo:Apply', function(tattoo)
  currentTattoos = tattoo
  applyTattoo()
end)

RegisterNetEvent('Tattoo:Buy')
AddEventHandler('Tattoo:Buy', function(tattoo)
  TriggerServerEvent("Tattoo:Buy", tattoo)
end)

RegisterNetEvent('Tattoo:Buy:response')
AddEventHandler('Tattoo:Buy:response', function(response)
  if(response.status) then
    TriggerServerEvent('Inventory:RefreshTattoo')    
  end
end)

RegisterNetEvent('Tattoo:Close')
AddEventHandler('Tattoo:Close', function()  
  venato.LoadSkin(DataUser)
  closeTattooShop()
end)
