local cam = nil
local shopOpen = false
local x,y,z = nil
local colorIndex = 1
local lastcolorIndex = 1
local bras = 1
local LastArg = nil
local componentId = nil
local BagIsEquiped = false
local ActualDomponentId = nil
local Vtop = false
local PrimaryTopIndex = nil

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
		if shopOpen then
			if Menu.hidden then
        Vtop = false
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
          Menu.toggle()
          OpenClothingShop()
        end
      end
    end
		if ActualDomponentId ~= nil then
      if componentId == 8 and ActualDomponentId == 15 then
      end
      if colorIndex ~= lastcolorIndex then
        lastcolorIndex = colorIndex
        SetPedComponentVariation(Venato.GetPlayerPed(), componentId, ActualDomponentId, colorIndex, 1)
      end
			if ActualDomponentId ~= LastArg then
				colorIndex = 1
			  LastArg = ActualDomponentId
			  SetPedComponentVariation(Venato.GetPlayerPed(), componentId, ActualDomponentId, colorIndex, 1)
        if Vtop == true then
          if(GetEntityModel(Venato.GetPlayerPed()) == GetHashKey("mp_m_freemode_01")) then
            SetPedComponentVariation(Venato.GetPlayerPed(), 3, MaleCombinaisonTop[PrimaryTopIndex].bras, 0, 1)
            if componentId ~= 8 then
              SetPedComponentVariation(Venato.GetPlayerPed(), 8, MaleCombinaisonTop[PrimaryTopIndex].list[1], 0, 1)
            end
    		  else
            SetPedComponentVariation(Venato.GetPlayerPed(), 3, FemaleCombinaisonTop[PrimaryTopIndex].bras, 0, 1)
            if componentId ~= 8 then
              SetPedComponentVariation(Venato.GetPlayerPed(), 8, FemaleCombinaisonTop[PrimaryTopIndex].list[1], 0, 1)
            end
    		  end
        end
      end
			ShowInfoColor(GetNumberOfPedTextureVariations(Venato.GetPlayerPed(), componentId, ActualDomponentId))
      DrawRect(0.5, 0.9, 0.2, 0.05, 0, 0, 0, 215)
    	printTxt(bras.." - "..MaleCombinaisonTop[PrimaryTopIndex].bras.." / "..GetNumberOfPedDrawableVariations(Venato.GetPlayerPed(),3)-1 ,0.5, 0.89, true)
			if IsControlJustPressed(1, Keys["RIGHT"]) then
				if colorIndex + 1 <= GetNumberOfPedTextureVariations(Venato.GetPlayerPed(), componentId, ActualDomponentId)-1 then
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

function ChangeDomponentId(arg)
  ActualDomponentId = arg
  if componentId == 11 then
    PrimaryTopIndex = arg
  end
end

function ShowInfoColor(a)
	DrawRect(0.5, 0.95, 0.2, 0.05, 0, 0, 0, 215)
	printTxt(colorIndex.." / "..GetNumberOfPedTextureVariations(Venato.GetPlayerPed(), componentId, ActualDomponentId)-1 ,0.5, 0.933, true)
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
  Vtop = false
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
	Menu.clearMenu()
	Menu.setTitle("Clothing Shop")
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
  Vtop = false
  componentId = 7-- Parachute / bag
  Menu.clearMenu()
  SetCamActive(cam,  false)
  RenderScriptCams(false,  false,  0,  true,  true)
	local id = 1
	local ped = Venato.GetPlayerPed()
	Menu.addButton2("~r~Back", "OpenClothingShop", nil)
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
			Menu.addButton2("~b~Accessoire ~r~#"..id, "OpenClothingShop", i, "ChangeDomponentId")
			id = id + 1
		end
	end
  Menu.CreateMenu()
end

function CStop()
  Vtop = true
  componentId = 11-- Parachute / bag
  Menu.clearMenu()
  SetCamCoord(cam,  x,  y-1.0,  z)
	PointCamAtCoord(cam,x,y,z)
	local id = 1
	local ped = Venato.GetPlayerPed()
	Menu.addButton2("~r~Back", "OpenClothingShop", nil)
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
			Menu.addButton2("~b~Haut Primaire ~r~#"..i, "ChoseSecondeTop", i, "ChangeDomponentId")
			id = id + 1
		end
	end
  Menu.CreateMenu()
end

function ChoseSecondeTop(i)
  Menu.setTitle(i)
  PrimaryTopIndex = i
  SetCamActive(cam,  false)
  RenderScriptCams(false,  false,  0,  true,  true)
  componentId = 8
  Menu.clearMenu()
  local id = 1
  local ped = Venato.GetPlayerPed()
  Menu.addButton2("~r~Back", "CStop", nil)
    if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then
      for k,v in pairs(MaleCombinaisonTop[PrimaryTopIndex].list) do
        Menu.addButton2("Haut Secondaire #"..v, "ChoseSecondeTop", v, "ChangeDomponentId")
        id = id + 1
      end
    else
      Menu.addButton2("~Haut Secondaire #"..i, "ChoseSecondeTop", i, "ChangeDomponentId")
      --for k,v in pairs(table_name) do

      --end
    end
  Menu.CreateMenu()
end


function CSchausure()
  Vtop = false
  componentId = 6 -- Shoes
  Menu.clearMenu()
  SetCamCoord(cam,  x,  y-1.0,  z-0.5)
	PointCamAtCoord(cam,x,y,z-0.8)
	local id = 1
	local ped = Venato.GetPlayerPed()
	Menu.addButton2("~r~Back", "OpenClothingShop", nil)
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
			Menu.addButton2("~b~Chaussure ~r~#"..id, "OpenClothingShop", i, "ChangeDomponentId")
			id = id + 1
		end
	end
  Menu.CreateMenu()
end

function CSpantalong()
  Vtop = false
  componentId = 4 -- legs
	Menu.clearMenu()
  SetCamCoord(cam,  x,  y-1.0,  z)
	PointCamAtCoord(cam,x,y,z-0.5)
	local id = 1
	local ped = Venato.GetPlayerPed()
	Menu.addButton2("~r~Back", "OpenClothingShop", nil)
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
			Menu.addButton2("~b~Pantalong ~r~#"..id, "OpenClothingShop", i, "ChangeDomponentId")
			id = id + 1
		end
	end
  Menu.CreateMenu()
end
