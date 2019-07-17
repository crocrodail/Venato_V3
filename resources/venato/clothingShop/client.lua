local cam = nil
local shopOpen = false
local x,y,z = nil
local onPantalong = false
local colorIndex = 1
local bras = 1
local LastArg = nil
local componentId = nil
local BagIsEquiped = false

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
		if shopOpen then
			if Menu.hidden then
				shopOpen = false
				SetCamActive(cam,  false)
			  RenderScriptCams(false,  false,  0,  true,  true)
			end
			SetEntityCoords(Venato.GetPlayerPed(), x, y, z-1)
		end
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    for k,v in pairs(ClothingShop) do
      if Vdist(x, y, z, v.x, v.y, v.z) < 20 then
        DrawMarker(27,v.x,v.y,v.z-0.99,0,0,0,0,0,0,1.0,1.0,1.0,0,150,255,200,0,0,0,0)
			end
      if  Vdist(x, y, z, v.x, v.y, v.z) < 1 then
        DrawMarker(27,v.x,v.y,v.z-0.99,0,0,0,0,0,0,1.0,1.0,1.0,0,150,255,200,0,0,0,0)
        Venato.InteractTxt('Appuyez sur ~INPUT_PICKUP~ Pour accèder au shop.')
        if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
          OpenClothingShop()
          showPageInfo = not showPageInfo
          Menu.hidden = not Menu.hidden
        end
      end
    end
		if onPantalong and Menu.GUI[Menu.selection +1]["args"]~= nil then
			if Menu.hidden then
				onPantalong = false
			end
			if Menu.GUI[Menu.selection +1]["args"] ~= LastArg then
				colorIndex = 1
			end
			LastArg = Menu.GUI[Menu.selection +1]["args"]
			SetPedComponentVariation(Venato.GetPlayerPed(), componentId, Menu.GUI[Menu.selection +1]["args"], colorIndex, 1)
			ShowInfoColor(GetNumberOfPedTextureVariations(Venato.GetPlayerPed(), componentId, Menu.GUI[Menu.selection +1]["args"]))
      DrawRect(0.5, 0.9, 0.2, 0.05, 0, 0, 0, 215)
    	printTxt(bras.." / "..GetNumberOfPedDrawableVariations(Venato.GetPlayerPed(),3)-1 ,0.5, 0.89, true)
			if IsControlJustPressed(1, Keys["RIGHT"]) then
				if colorIndex + 1 <= GetNumberOfPedTextureVariations(Venato.GetPlayerPed(), componentId, Menu.GUI[Menu.selection +1]["args"])-1 then
					colorIndex = colorIndex + 1
				end
			end
			if IsControlJustPressed(1, Keys["LEFT"]) then
				if colorIndex - 1 >= 1 then
					colorIndex = colorIndex - 1
				end
			end

      if IsControlJustPressed(1, Keys["N6"]) then
        if bras + 1 <= GetNumberOfPedDrawableVariations(Venato.GetPlayerPed(), 3)-1 then
          bras = bras + 1
          SetPedComponentVariation(Venato.GetPlayerPed(), 3, bras, 0, 1)
        end
      end
      if IsControlJustPressed(1, Keys["N4"]) then
        if bras - 1 >= 1 then
          bras = bras - 1
          SetPedComponentVariation(Venato.GetPlayerPed(), 3, bras, 0, 1)
        end
      end

		end
  end
end)

function ShowInfoColor(a)
	DrawRect(0.5, 0.95, 0.2, 0.05, 0, 0, 0, 215)
	printTxt(colorIndex.." / "..GetNumberOfPedTextureVariations(Venato.GetPlayerPed(), componentId, Menu.GUI[Menu.selection +1]["args"])-1 ,0.5, 0.933, true)
end

function printTxt(text, x,y, center)
	local center = center or false
	SetTextFont(4)
	SetTextScale(0.0,0.5)
	SetTextCentre(center)
	SetTextDropShadow(0, 0, 0, 0, 0)
	SetTextEdge(0, 0, 0, 0, 0)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

function OpenClothingShop()
	local ped = Venato.GetPlayerPed()
	SetEntityHeading(ped, 180)
	shopOpen = true
	if not DoesCamExist(cam) then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	end
	SetCamActive(cam,  true)
	RenderScriptCams(true,  false,  0,  true,  true)
	local coords = GetEntityCoords(ped)
	x  = coords.x
	y = coords.y
	z = coords.z
	SetCamCoord(cam,  coords.x,  coords.y-2.0,  coords.z)
	PointCamAtCoord(cam,x-1.0,y,z)
	SetEntityCoords(ped, coords.x+0.0, coords.y+0.0, coords.z)
	ClearMenu()
	MenuTitle = "Clothing Shop"
  Menu.addButton("sexe switch", "CSswitchsex", nil)
	Menu.addButton("Pantalong", "CSpantalong", nil)
  Menu.addButton("Chausure", "CSchausure", nil)
  Menu.addButton("Haut", "CStop", nil)
  Menu.addButton("Accessoire", "CSAccessoire", nil)
end

function CSswitchsex()
  Citizen.CreateThread(function()
  if(GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01")) then
    local model = "mp_f_freemode_01"
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
    SetPlayerModel(PlayerId(), model)
    SetModelAsNoLongerNeeded(model)
    SetPedDefaultComponentVariation(GetPlayerPed(-1))
    SetPedComponentVariation(GetPlayerPed(-1), 2, 0, 0, 0)
  else
    local model = "mp_m_freemode_01"
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
    SetPlayerModel(PlayerId(), model)
    SetModelAsNoLongerNeeded(model)
    SetPedDefaultComponentVariation(GetPlayerPed(-1))
    SetPedComponentVariation(GetPlayerPed(-1), 2, 0, 0, 0)
  end
end)
end


function CSAccessoire()
  componentId = 7-- Parachute / bag
  ClearMenu()
  SetCamActive(cam,  false)
  RenderScriptCams(false,  false,  0,  true,  true)
	local id = 1
	local ped = Venato.GetPlayerPed()
	onPantalong = true
	Menu.addButton("~r~Back", "OpenClothingShop", nil)
	for i=1,GetNumberOfPedDrawableVariations(ped, componentId) do
		local dont = false
		if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then
			for k,v in pairs(BlackListAccessoireMale) do
				if i == v then
					dont = true
					break
				end
			end
		else
			for k,v in pairs(BlackListAccessoireFemale) do
				if i == v then
					dont = true
					break
				end
			end
		end
		if dont == false then
			Menu.addButton("~b~Accessoire ~r~#"..id, "OpenClothingShop", i)
			id = id + 1
		end
	end
end

function CStop()
  componentId = 11-- Parachute / bag
  ClearMenu()
  SetCamCoord(cam,  x,  y-1.0,  z)
	PointCamAtCoord(cam,x,y,z)
	local id = 1
	local ped = Venato.GetPlayerPed()
	onPantalong = true
	Menu.addButton("~r~Back", "OpenClothingShop", nil)
	for i=1,GetNumberOfPedDrawableVariations(ped, componentId) do
		local dont = false
		if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then
			for k,v in pairs(BlackListTorsoMale) do
				if i == v then
					dont = true
					break
				end
			end
		else
			for k,v in pairs(BlackListTorsoFemale) do
				if i == v then
					dont = true
					break
				end
			end
		end
		if dont == false then
			Menu.addButton("~b~Haut Primaire ~r~#"..i, "ChoseSecondeTop", i)
			id = id + 1
		end
	end
end

function ChoseSecondeTop(i)
  SetCamActive(cam,  false)
  RenderScriptCams(false,  false,  0,  true,  true)
  componentId = 8
  ClearMenu()
  local id = 1
  local ped = Venato.GetPlayerPed()
  Menu.addButton("~r~Back", "CStop", nil)
  for i=1,GetNumberOfPedDrawableVariations(ped, componentId) do
    if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then
      Menu.addButton("~b~Haut Secondaire ~r~#"..i, "ChoseSecondeTop", i)
      --for k,v in pairs(MaleCombinaisonTop) do
      --  Menu.addButton("~b~Haut Secondaire ~r~#"..k, "ChoseSecondeTop", k)
      --end
    else
      --for k,v in pairs(table_name) do

      --end
    end
  end
end


function CSchausure()
  componentId = 6 -- Shoes
  ClearMenu()
  SetCamCoord(cam,  x,  y-1.0,  z-0.5)
	PointCamAtCoord(cam,x,y,z-0.8)
	local id = 1
	local ped = Venato.GetPlayerPed()
	onPantalong = true
	Menu.addButton("~r~Back", "OpenClothingShop", nil)
	for i=1,GetNumberOfPedDrawableVariations(ped, componentId) do
		local dont = false
		if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then
			for k,v in pairs(BlackListShoesMale) do
				if i == v then
					dont = true
					break
				end
			end
		else
			for k,v in pairs(BlackListShoesFemale) do
				if i == v then
					dont = true
					break
				end
			end
		end
		if dont == false then
			Menu.addButton("~b~Chaussure ~r~#"..id, "OpenClothingShop", i)
			id = id + 1
		end
	end
end

function CSpantalong()
  componentId = 4 -- legs
	ClearMenu()
  SetCamCoord(cam,  x,  y-1.0,  z)
	PointCamAtCoord(cam,x,y,z-0.5)
	local id = 1
	local ped = Venato.GetPlayerPed()
	onPantalong = true
	Menu.addButton("~r~Back", "OpenClothingShop", nil)
	for i=1,GetNumberOfPedDrawableVariations(ped, componentId) do
		local dont = false
		if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then
			for k,v in pairs(BlackListLegMale) do
				if i == v then
					dont = true
					break
				end
			end
		else
			for k,v in pairs(BlackListLegFemale) do
				if i == v then
					dont = true
					break
				end
			end
		end
		if dont == false then
			Menu.addButton("~b~Pantalong ~r~#"..id, "OpenClothingShop", i)
			id = id + 1
		end
	end
end
