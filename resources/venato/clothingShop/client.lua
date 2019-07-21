local tablee = {
  ComponentVariation = {
    Mask = {id = 0, color = 0},
    torso = {id = 0, color = 0},
    leg = {id = 0, color = 0},
    parachute = {id = 0, color = 0},
    shoes = {id = 0, color = 0},
    accessory = {id = 0, color = 0},
    undershirt = {id = 0, color = 0},
    kevlar = {id = 0, color = 0},
    badge = {id = 0, color = 0},
    torso2 = {id = 0, color = 0},
  },
  prop = {
    hat = {id = -1, color = 0},
    glass = {id = -1, color = 0},
    ear = {id = -1, color = 0},
    watch = {id = -1, color = 0},
    bracelet = {id = -1, color = 0},
  }
}


local cam = nil
local canSetClothes = true
local Clothes = {}
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
local brasidTop = 0
local debug = false
local noColor = false
local nothing = true
local tatalPrice = 0
local buytop = false
local buypantalong = false
local buychaussure = false
local coordUI_Y = 0.15
local coordtop = nil
local coordpantalong = nil
local coordchaussure = nil
local buyAnything = false


local priceTop = 200
local priceLegs = 200
local priceShoes = 200

function Venato.Spawn()
  Venato.LoadClothes()
end

function Venato.LoadClothes()
  TriggerServerEvent("ClothingShop:CallData")
end

RegisterNetEvent("ClothingShop:CallData:cb")
AddEventHandler("ClothingShop:CallData:cb", function(data)
  Clothes = data.Clothes
  if canSetClothes then
    SetPedComponentVariation(Venato.GetPlayerPed(), 3, Clothes.ComponentVariation.torso.id, Clothes.ComponentVariation.torso.color, 1)
    SetPedComponentVariation(Venato.GetPlayerPed(), 4, Clothes.ComponentVariation.leg.id, Clothes.ComponentVariation.leg.color, 1)
    SetPedComponentVariation(Venato.GetPlayerPed(), 5, Clothes.ComponentVariation.parachute.id, Clothes.ComponentVariation.parachute.color, 1)
    SetPedComponentVariation(Venato.GetPlayerPed(), 6, Clothes.ComponentVariation.shoes.id, Clothes.ComponentVariation.shoes.color, 1)
    SetPedComponentVariation(Venato.GetPlayerPed(), 7, Clothes.ComponentVariation.accessory.id, Clothes.ComponentVariation.accessory.color, 1)
    SetPedComponentVariation(Venato.GetPlayerPed(), 8, Clothes.ComponentVariation.undershirt.id, Clothes.ComponentVariation.undershirt.color, 1)
    SetPedComponentVariation(Venato.GetPlayerPed(), 9, Clothes.ComponentVariation.kevlar.id, Clothes.ComponentVariation.kevlar.color, 1)
    SetPedComponentVariation(Venato.GetPlayerPed(), 10, Clothes.ComponentVariation.badge.id, Clothes.ComponentVariation.badge.color, 1)
    SetPedComponentVariation(Venato.GetPlayerPed(), 11, Clothes.ComponentVariation.torso2.id, Clothes.ComponentVariation.torso2.color, 1)
  else
    canSetClothes = true
    CSsendMask()
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
		if shopOpen then
			if Menu.hidden then
        Vtop = false
				shopOpen = false
				SetCamActive(cam,  false)
			  RenderScriptCams(false,  false,  0,  true,  true)
        nothing = true
        tatalPrice = 0
        buytop = false
        buypantalong = false
        buychaussure = false
        coordUI_Y = 0.15
        coordtop = nil
        coordpantalong = nil
        coordchaussure = nil
        if not buyAnything then
          Venato.LoadClothes()
        end
      elseif noColor == false then
        DrawRect(0.4, 0.25, 0.2, 0.4, 0, 0, 0, 215)
        printTxt("~r~Facture :",0.4, 0.07, true, 0.8)
        printTxt("~r~Total :                                           "..tatalPrice.." €",0.4, 0.41, true)
        if nothing then
          printTxt("~g~Aucun panier.",0.32, 0.2, false)
        end
        if buytop then
          printTxt("~g~Haut :                                           ~r~"..priceTop.." €",0.4, coordtop, true)
        end
        if buypantalong then
          printTxt("~g~Pantalong :                                      ~r~"..priceLegs.." €",0.4, coordpantalong, true)
        end
        if buychaussure then
          printTxt("~g~Chaussure :                                      ~r~"..priceShoes.." €",0.4, coordchaussure, true)
        end
			end
			SetEntityCoords(Venato.GetPlayerPed(), x, y, z-1)
		end
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    for k,v in pairs(ClothingShop) do
      if Vdist(x, y, z, v.x, v.y, v.z) < 20 then
        DrawMarker(27,v.x,v.y,v.z-0.99,0,0,0,0,0,0,1.0,1.0,1.0,0,150,255,200,0,0,0,0)
			end
      if Vdist(x, y, z, v.x, v.y, v.z) < 1 then
        DrawMarker(27,v.x,v.y,v.z-0.99,0,0,0,0,0,0,1.0,1.0,1.0,0,150,255,200,0,0,0,0)
        Venato.InteractTxt('Appuyez sur ~INPUT_PICKUP~ Pour accèder au shop.')
        if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
          Menu.toggle()
          OpenClothingShop()
          if v.name == "La redoute" then
            debug = true
          else
            debug = false
          end
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
            brasidTop = MaleCombinaisonTop[PrimaryTopIndex].bras
            if componentId == 8 and ActualDomponentId == 15 then
              brasidTop = 14
            elseif componentId == 8 and (ActualDomponentId == 72 or ActualDomponentId == 75 or ActualDomponentId == 31 or ActualDomponentId == 32 or ActualDomponentId == 63 or ActualDomponentId == 94 or ActualDomponentId == 10 or ActualDomponentId == 11) then
              brasidTop = 4
            elseif componentId == 8 and (ActualDomponentId == 40 or ActualDomponentId == 17 or ActualDomponentId == 111 or ActualDomponentId == 43) then
              brasidTop = 6
            end
            SetPedComponentVariation(Venato.GetPlayerPed(), 3, brasidTop, 0, 1)
            if componentId ~= 8 then
              SetPedComponentVariation(Venato.GetPlayerPed(), 8, MaleCombinaisonTop[PrimaryTopIndex].list[1], 0, 1)
            end
    		  else
            brasidTop = FemaleCombinaisonTop[PrimaryTopIndex].bras
            if componentId == 8 and (ActualDomponentId == 38 or ActualDomponentId == 39 or ActualDomponentId == 101) then
              brasidTop = 11
            end
            SetPedComponentVariation(Venato.GetPlayerPed(), 3, brasidTop, 0, 1)
            if componentId ~= 8 then
              SetPedComponentVariation(Venato.GetPlayerPed(), 8, 2, 0, 1)
            end
    		  end
        end
      end
      if shopOpen and noColor then
        local scaleform = scaleformClothingShop()
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
			  ShowInfoColor(GetNumberOfPedTextureVariations(Venato.GetPlayerPed(), componentId, ActualDomponentId))
        if debug then
          DrawRect(0.5, 0.9, 0.2, 0.05, 0, 0, 0, 215)
    	    printTxt(bras.." - "..brasidTop.." / "..GetNumberOfPedDrawableVariations(Venato.GetPlayerPed(),3)-1 ,0.5, 0.89, true)
        end
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

        if IsControlJustPressed(1, Keys["N6"]) and debug then
          if bras + 1 <= GetNumberOfPedDrawableVariations(Venato.GetPlayerPed(), 3)-1 then
            bras = bras + 1
            SetPedComponentVariation(Venato.GetPlayerPed(), 3, bras, 0, 1)
          end
        end
        if IsControlJustPressed(1, Keys["N4"]) and debug  then
          if bras - 1 >= 1 then
            bras = bras - 1
            SetPedComponentVariation(Venato.GetPlayerPed(), 3, bras, 0, 1)
          end
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

function scaleformClothingShop()
  local scaleform = Venato.ScaleForm("instructional_buttons")
  PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
  PopScaleformMovieFunctionVoid()
  PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
  PushScaleformMovieFunctionParameterInt(1)
  Button(GetControlInstructionalButton(2, 190, true))
  Button(GetControlInstructionalButton(2, 189, true))
  ButtonMessage("Changer la couleur principale")
  PopScaleformMovieFunctionVoid()
  PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
  PopScaleformMovieFunctionVoid()
  PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
  PushScaleformMovieFunctionParameterInt(0)
  PushScaleformMovieFunctionParameterInt(0)
  PushScaleformMovieFunctionParameterInt(0)
  PushScaleformMovieFunctionParameterInt(80)
  EndScaleformMovieMethodReturn()
  return scaleform
end

function ShowInfoColor(a)
	DrawRect(0.5, 0.95, 0.2, 0.05, 0, 0, 0, 215)
	printTxt("~b~Couleur : "..colorIndex.." ~s~/~b~ "..GetNumberOfPedTextureVariations(Venato.GetPlayerPed(), componentId, ActualDomponentId)-1 ,0.5, 0.933, true)
end

function printTxt(text, x,y, center,police)
	local center = center or false
  local police = police or 0.5
	SetTextFont(4)
	SetTextScale(0.0, police)
	SetTextCentre(center)
	SetTextDropShadow(0, 0, 0, 0, 0)
	SetTextEdge(0, 0, 0, 0, 0)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

function OpenClothingShop()
  noColor = false
  buyAnything = false
  Vtop = false
	local ped = Venato.GetPlayerPed()
  local coords = GetEntityCoords(ped)
	x  = coords.x
	y = coords.y
	z = coords.z
	SetEntityHeading(ped, 180)
	shopOpen = true
	if not DoesCamExist(cam) then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	end
	SetCamActive(cam,  true)
	RenderScriptCams(true,  false,  0,  true,  true)
	SetCamCoord(cam,  coords.x,  coords.y-2.0,  coords.z)
	PointCamAtCoord(cam,x-1.0,y,z)
	SetEntityCoords(ped, coords.x+0.0, coords.y+0.0, coords.z)
	Menu.clearMenu()
	Menu.setTitle("Clothing Shop")
  Menu.addButton("sexe switch", "CSswitchsex", nil)
  Menu.addButton("Haut", "CStop", nil)
	Menu.addButton("Pantalong", "CSpantalong", nil)
  Menu.addButton("Chaussure", "CSchausure", nil)
  Menu.addButton("Payer : "..tatalPrice.." €", "BuyClothe", nil)
end

function BuyClothe()
  local ped = Venato.GetPlayerPed()
  tablee = {
    ComponentVariation = {
      Mask = {id = 0, color = 0},
      torso = {id = GetPedDrawableVariation(ped, 3), color = GetPedTextureVariation(ped, 3)},
      leg = {id = GetPedDrawableVariation(ped, 4), color = GetPedTextureVariation(ped, 4)},
      parachute = {id = GetPedDrawableVariation(ped, 5), color = GetPedTextureVariation(ped, 5)},
      shoes = {id = GetPedDrawableVariation(ped, 6), color = GetPedTextureVariation(ped, 6)},
      accessory = {id = GetPedDrawableVariation(ped, 7), color = GetPedTextureVariation(ped, 7)},
      undershirt = {id = GetPedDrawableVariation(ped, 8), color = GetPedTextureVariation(ped, 8)},
      kevlar = {id = GetPedDrawableVariation(ped, 9), color = GetPedTextureVariation(ped, 9)},
      badge = {id = GetPedDrawableVariation(ped, 10), color = GetPedTextureVariation(ped, 10)},
      torso2 = {id = GetPedDrawableVariation(ped, 11), color = GetPedTextureVariation(ped, 11)},
    },
    prop = {
      hat = {id = GetPedPropIndex(ped, 0), color = GetPedPropTextureIndex(ped, 0)},
      glass = {id = GetPedPropIndex(ped, 1), color = GetPedPropTextureIndex(ped, 1)},
      ear = {id = GetPedPropIndex(ped, 2), color = GetPedPropTextureIndex(ped, 2)},
      watch = {id = GetPedPropIndex(ped, 6), color = GetPedPropTextureIndex(ped, 6)},
      bracelet = {id = GetPedPropIndex(ped, 7), color = GetPedPropTextureIndex(ped, 7)},
    }
  }
  canSetClothes = false
  Venato.LoadClothes()
end

function CSsendMask()
  tablee.ComponentVariation.Mask.id = Clothes.ComponentVariation.Mask.id
  tablee.ComponentVariation.Mask.color = Clothes.ComponentVariation.Mask.color
  TriggerServerEvent("ClothingShop:SaveClothes", tablee, tatalPrice)
end

RegisterNetEvent("ClothingShop:SaveClothes:response")
AddEventHandler("ClothingShop:SaveClothes:response", function(response)
  print("rr")
  if response then
   buyAnything = true
   Menu.close()
   Venato.LoadClothes()
   local defaultNotification = {
    title= "Magasin de vêtements",
    type = "success", --  danger, error, alert, info, success, warning
    logo = "https://img.icons8.com/nolan/64/000000/clothes.png",
    message = "La transaction s'est bien passé ! C'est vêtement sont à vous.",
   }
   Venato.notify(defaultNotification)
  else
    Venato.notifyError("il y a une erreur de payement !")
    Menu.close()
    Venato.LoadClothes()
  end
end)

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
  noColor = true
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
  noColor = true
  Vtop = true
  componentId = 11-- Parachute / bag
  Menu.clearMenu()
  SetCamCoord(cam,  x,  y-1.0,  z+0.5)
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
      local number = id
      if debug then
        number = i
      end
			Menu.addButton2("~b~Haut Primaire ~r~#"..number, "ChoseSecondeTop", i, "ChangeDomponentId")
			id = id + 1
		end
	end
  Menu.CreateMenu()
end

function ChoseSecondeTop(i)
  noColor = true
    PrimaryTopIndex = i
    local notok = false
    if debug then
      Menu.setTitle(i)
    end
    componentId = 8
    Menu.clearMenu()
    local id = 1
    local ped = Venato.GetPlayerPed()
    Menu.addButton2("~r~Back", "CStop", nil)
    if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then
      if MaleCombinaisonTop[PrimaryTopIndex].Secondary == false then
        buytopcs()
        notok = true
      else
        for k,v in pairs(MaleCombinaisonTop[PrimaryTopIndex].list) do
          local number = id
          if debug then
            number = v
          end
          Menu.addButton2("Haut Secondaire #"..number, "buytopcs", v, "ChangeDomponentId")
          id = id + 1
        end
      end
    else
      if FemaleCombinaisonTop[PrimaryTopIndex].Secondary == false then
        buytopcs()
        notok = true
      else
        for k,v in pairs(FemaleCombinaisonTop[PrimaryTopIndex].list) do
          local number = id
          if debug then
            number = v
          end
          Menu.addButton2("Haut Secondaire #"..number, "buytopcs", v, "ChangeDomponentId")
          id = id + 1
        end
      end
    end
    if notok == false then
      Menu.CreateMenu()
    end
end

function buytopcs()
  if buytop == false then
    nothing = false
    buytop = true
    tatalPrice = tatalPrice + priceTop
    coordUI_Y = coordUI_Y +0.05
    coordtop = coordUI_Y
    OpenClothingShop()
  else
    OpenClothingShop()
  end
end


function CSchausure()
  noColor = true
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
      local number = id
      if debug then
        number = i
      end
			Menu.addButton2("~b~Chaussure ~r~#"..number, "buyShoescs", i, "ChangeDomponentId")
			id = id + 1
		end
	end
  Menu.CreateMenu()
end

function buyShoescs()
  if buychaussure == false then
    nothing = false
    buychaussure = true
    tatalPrice = tatalPrice + priceShoes
    coordUI_Y = coordUI_Y +0.05
    coordchaussure = coordUI_Y
    OpenClothingShop()
  else
    OpenClothingShop()
  end
end

function CSpantalong()
  noColor = true
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
      local number = id
      if debug then
        number = i
      end
			Menu.addButton2("~b~Pantalong ~r~#"..number, "buyLegscs", i, "ChangeDomponentId")
			id = id + 1
		end
	end
  Menu.CreateMenu()
end

function buyLegscs()
  if buypantalong == false then
    nothing = false
    buypantalong = true
    tatalPrice = tatalPrice + priceLegs
    coordUI_Y = coordUI_Y + 0.05
    coordpantalong = coordUI_Y
    OpenClothingShop()
  else
    OpenClothingShop()
  end
end
