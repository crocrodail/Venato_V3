local cam = nil
local shopOpen = false
local x,y,z = nil
local onPantalong = false
local colorIndex = 1
local LastArg = nil

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
				print(Menu.GUI[Menu.selection +1]["args"])
			end
			LastArg = Menu.GUI[Menu.selection +1]["args"]
			SetPedComponentVariation(Venato.GetPlayerPed(), 4, Menu.GUI[Menu.selection +1]["args"], colorIndex, 1)
			ShowInfoColor(GetNumberOfPedTextureVariations(Venato.GetPlayerPed(), 4, Menu.GUI[Menu.selection +1]["args"]))
			if IsControlJustPressed(1, Keys["RIGHT"]) then
				if colorIndex + 1 <= GetNumberOfPedTextureVariations(Venato.GetPlayerPed(), 4, Menu.GUI[Menu.selection +1]["args"])-1 then
					colorIndex = colorIndex + 1
				end
			end
			if IsControlJustPressed(1, Keys["LEFT"]) then
				if colorIndex - 1 >= 1 then
					colorIndex = colorIndex - 1
				end
			end
		end
  end
end)

function ShowInfoColor(a)
	DrawRect(0.5, 0.95, 0.2, 0.05, 0, 0, 0, 215)
	printTxt(colorIndex.." / "..GetNumberOfPedTextureVariations(Venato.GetPlayerPed(), 4, Menu.GUI[Menu.selection +1]["args"])-1 ,0.5, 0.933, true)
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
	SetCamCoord(cam,  coords.x,  coords.y-1.5,  coords.z-0.5)
	PointCamAtCoord(cam,x,y,z-0.5)
	SetEntityCoords(ped, coords.x+0.0, coords.y+0.0, coords.z)
	ClearMenu()
	MenuTitle = "Clothing Shop"
	Menu.addButton("Pantalong", "CSpantalong", nil)
end

function CSpantalong()
	ClearMenu()
	local idLeg = 1
	local ped = Venato.GetPlayerPed()
	onPantalong = true
	Menu.addButton("~r~Back", "OpenClothingShop", nil)
	for i=1,GetNumberOfPedDrawableVariations(ped, 4) do
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
			Menu.addButton("~b~Pantalong ~r~#"..idLeg, "OpenClothingShop", i)
			idLeg = idLeg + 1
		end
	end
end
FreezeEntityPosition(Venato.GetPlayerPed(), false)
