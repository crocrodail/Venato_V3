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

--[[]
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
--[]]


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
local buymask = false
local buytop = false
local buypantalong = false
local buychaussure = false
local coordUI_Y = 0.15
local coordmask = nil
local coordtop = nil
local coordpantalong = nil
local coordchaussure = nil
local buyAnything = false


local priceMask = 600
local priceTop = 200
local priceLegs = 200
local priceShoes = 200

local defaultNotification = {
  title= "Magasin de vêtements",
  logo = "https://i.ibb.co/ZT6dpsG/icons8-clothes-48px.png",
  message = "La transaction s'est bien passé ! Ces vêtements sont à vous.",
 }
 
local commandHelp = {
  id = "clothingShop",
  command = "E",
  icon = "https://i.ibb.co/ZT6dpsG/icons8-clothes-48px.png",
  text = "Essayer de nouveau vêtements"
}

local isCommandAdded = nil;

function venato.LoadClothes()
  TriggerServerEvent("ClothingShop:CallData")
end

RegisterNetEvent("ClothingShop:CallData:cb")
AddEventHandler("ClothingShop:CallData:cb", function(data)
  if data ~= nil then
    Clothes = data.Clothes
    if canSetClothes then
      SetPedComponentVariation(venato.GetPlayerPed(), 1, 0, 0, 1)
      SetPedComponentVariation(venato.GetPlayerPed(), 3, Clothes.ComponentVariation.torso.id, Clothes.ComponentVariation.torso.color, 1)
      SetPedComponentVariation(venato.GetPlayerPed(), 4, Clothes.ComponentVariation.leg.id, Clothes.ComponentVariation.leg.color, 1)
      SetPedComponentVariation(venato.GetPlayerPed(), 5, Clothes.ComponentVariation.parachute.id, Clothes.ComponentVariation.parachute.color, 1)
      SetPedComponentVariation(venato.GetPlayerPed(), 6, Clothes.ComponentVariation.shoes.id, Clothes.ComponentVariation.shoes.color, 1)
      SetPedComponentVariation(venato.GetPlayerPed(), 7, Clothes.ComponentVariation.accessory.id, Clothes.ComponentVariation.accessory.color, 1)
      SetPedComponentVariation(venato.GetPlayerPed(), 8, Clothes.ComponentVariation.undershirt.id, Clothes.ComponentVariation.undershirt.color, 1)
      SetPedComponentVariation(venato.GetPlayerPed(), 9, Clothes.ComponentVariation.kevlar.id, Clothes.ComponentVariation.kevlar.color, 1)
      SetPedComponentVariation(venato.GetPlayerPed(), 10, Clothes.ComponentVariation.badge.id, Clothes.ComponentVariation.badge.color, 1)
      SetPedComponentVariation(venato.GetPlayerPed(), 11, Clothes.ComponentVariation.torso2.id, Clothes.ComponentVariation.torso2.color, 1)
    else
      canSetClothes = true
      CSsendMask()
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
		if shopOpen then
			if Menu.hidden then
        DetachEntity(venato.GetPlayerPed(), true, true)
        DeleteEntity(Prop)
        Vtop = false
				shopOpen = false
				SetCamActive(cam,  false)
			  RenderScriptCams(false,  false,  0,  true,  true)
        nothing = true
        tatalPrice = 0
        buytop = false
        buymask = false
        buypantalong = false
        buychaussure = false
        coordUI_Y = 0.15
        coordtop = nil
        coordpantalong = nil
        coordchaussure = nil
        if not buyAnything then
          venato.LoadClothes()
        end
      elseif noColor == false then
        DrawRect(0.4, 0.25, 0.2, 0.4, 0, 0, 0, 215)
        printTxt("~r~Facture :",0.4, 0.07, true, 0.8)
        printTxt("~r~Total :                                           "..tatalPrice.." €",0.4, 0.41, true)
        if nothing then
          printTxt("~g~Aucun panier.",0.32, 0.2, false)
        end
        if buymask then
          printTxt("~g~Masque :                                           ~r~"..priceMask.." €",0.4, coordmask, true)
        end
        if buytop then
          printTxt("~g~Haut :                                           ~r~"..priceTop.." €",0.4, coordtop, true)
        end
        if buypantalong then
          printTxt("~g~Pantalon :                                      ~r~"..priceLegs.." €",0.4, coordpantalong, true)
        end
        if buychaussure then
          printTxt("~g~Chaussures :                                      ~r~"..priceShoes.." €",0.4, coordchaussure, true)
        end
			end
		end
    local x,y,z = table.unpack(GetEntityCoords(venato.GetPlayerPed(), true))
    for k,v in pairs(ClothingShop) do
      if Vdist(x, y, z, v.x, v.y, v.z) < 20 then
        DrawMarker(27,v.x,v.y,v.z-0.99,0,0,0,0,0,0,1.0,1.0,1.0,0,150,255,200,0,0,0,0)
			end
      if Vdist(x, y, z, v.x, v.y, v.z) < 1 then
        DrawMarker(27,v.x,v.y,v.z-0.99,0,0,0,0,0,0,1.0,1.0,1.0,0,150,255,200,0,0,0,0)
        if not isCommandAdded then
          TriggerEvent('Commands:Add', commandHelp)
          isCommandAdded = k
        end
        if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
          Menu.toggle()
          OpenClothingShop()
          if v.name == "La redoute" then
            debug = true
          else
            debug = false
          end
        end
      elseif isCommandAdded == k then
        TriggerEvent('Commands:Remove', commandHelp.id)
        isCommandAdded = nil
      end
    end
		if ActualDomponentId ~= nil then
      if colorIndex ~= lastcolorIndex then
        lastcolorIndex = colorIndex
        SetPedComponentVariation(venato.GetPlayerPed(), componentId, ActualDomponentId, colorIndex, 1)
      end
			if ActualDomponentId ~= LastArg then
				colorIndex = 0
			  LastArg = ActualDomponentId
			  SetPedComponentVariation(venato.GetPlayerPed(), componentId, ActualDomponentId, colorIndex, 1)
      end
      if shopOpen and noColor then
        local scaleform = scaleformClothingShop()
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
			  ShowInfoColor(GetNumberOfPedTextureVariations(venato.GetPlayerPed(), componentId, ActualDomponentId))
			  if IsControlJustPressed(1, Keys["RIGHT"]) then
				  if colorIndex + 1 <= GetNumberOfPedTextureVariations(venato.GetPlayerPed(), componentId, ActualDomponentId)-1 then
					  colorIndex = colorIndex + 1
				  end
			  end
			  if IsControlJustPressed(1, Keys["LEFT"]) then
				  if colorIndex - 1 >= 0 then
				  	colorIndex = colorIndex - 1
				  end
			  end
      end
		end
  end
end)

function ChangeDomponentId(arg)
  ActualDomponentId = arg
  if componentId == 11 then
    SetPedComponentVariation(venato.GetPlayerPed(), 8, 15, 0, 1)
    SetPedComponentVariation(venato.GetPlayerPed(), 3, 15, 0, 1)
  end
end

function scaleformClothingShop()
  local scaleform = venato.ScaleForm("instructional_buttons")
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
  PushScaleformMovieFunction(scaleform, "SET_RetourGROUND_COLOUR")
  PushScaleformMovieFunctionParameterInt(0)
  PushScaleformMovieFunctionParameterInt(0)
  PushScaleformMovieFunctionParameterInt(0)
  PushScaleformMovieFunctionParameterInt(80)
  EndScaleformMovieMethodReturn()
  return scaleform
end

function ShowInfoColor(a)
	DrawRect(0.5, 0.95, 0.2, 0.05, 0, 0, 0, 215)
	printTxt("~b~Couleur : "..colorIndex.." ~s~/~b~ "..GetNumberOfPedTextureVariations(venato.GetPlayerPed(), componentId, ActualDomponentId)-1 ,0.5, 0.933, true)
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
	local ped = venato.GetPlayerPed()
  local coords = GetEntityCoords(ped)
	x  = coords.x
	y = coords.y
	z = coords.z
	SetEntityHeading(ped, 180)
	shopOpen = true
  local Coords = GetEntityCoords(ped, true)
  Prop = venato.CreateObject("prop_apple_box_01", Coords["x"], Coords["y"], Coords["z"]-0.1)
  FreezeEntityPosition(Prop, true)
  AttachEntityToEntity(ped, Prop, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 180.0, false, false, false, false, 2, false)
  SetEntityVisible(Prop, false, 0)
  SetEntityVisible(ped, true, 0)
	-- if not DoesCamExist(cam) then
	-- 	cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	-- end
	-- SetCamActive(cam,  true)
	-- RenderScriptCams(true,  false,  0,  true,  true)
	-- SetCamCoord(cam,  coords.x,  coords.y-2.0,  coords.z)
	-- PointCamAtCoord(cam,x-1.0,y,z)
	SetEntityCoords(ped, coords.x+0.0, coords.y+0.0, coords.z)
  Menu.clearMenu()
  TriggerEvent('Menu:Init', "Magasin de vétements", "Ca vous va à merveille !", "#455A64BF", "https://www.pret-a-porter-femme.com/wp-content/uploads/2016/10/magasins-de-vetement.jpg" )
  if debug then TriggerEvent('Menu:AddButton2',"Changer de sexe", "CSswitchsex", '', '', "https://i.ibb.co/5syzbqT/icons8-gender-symbols-96px.png") end
  TriggerEvent('Menu:AddButton2',"Masque", "CMask", '', '', "https://i.ibb.co/fqMn3sv/icons8-anonymous-mask-96px.png")
  TriggerEvent('Menu:AddButton2',"Haut", "ClothesShopMenuTop", '', '', "https://i.ibb.co/8YRG4Rt/icons8-t-shirt-96px-1.png")
	TriggerEvent('Menu:AddButton2',"Pantalon", "CSpantalong", '', '', "https://i.ibb.co/ZJmNjMK/icons8-jeans-96px.png")
  TriggerEvent('Menu:AddButton2',"Chaussures", "CSchausure", '', '', "https://i.ibb.co/0ZDJsZ4/icons8-trainers-96px.png")
  TriggerEvent('Menu:AddButton2',"Payer : "..tatalPrice.." €", "BuyClothe", '', '', "https://i.ibb.co/y8LZBy2/icons8-receipt-96px.png")
  TriggerEvent('Menu:CreateMenu')
  TriggerEvent('Menu:Open')
end

function MainMenuButCantBackSo()
  Menu.clearMenu()
  TriggerEvent('Menu:Init', "Magasin de vétements", "Ca vous va à merveille !", "#455A64BF", "https://www.pret-a-porter-femme.com/wp-content/uploads/2016/10/magasins-de-vetement.jpg" )
  TriggerEvent('Menu:AddButton2',"Changer de sexe", "CSswitchsex", '', '', "https://i.ibb.co/5syzbqT/icons8-gender-symbols-96px.png")
  TriggerEvent('Menu:AddButton2',"Haut", "ClothesShopMenuTop", '', '', "https://i.ibb.co/8YRG4Rt/icons8-t-shirt-96px-1.png")
	TriggerEvent('Menu:AddButton2',"Pantalon", "CSpantalong", '', '', "https://i.ibb.co/ZJmNjMK/icons8-jeans-96px.png")
  TriggerEvent('Menu:AddButton2',"Chaussures", "CSchausure", '', '', "https://i.ibb.co/0ZDJsZ4/icons8-trainers-96px.png")
  TriggerEvent('Menu:AddButton2',"Payer : "..tatalPrice.." €", "BuyClothe", '', '', "https://i.ibb.co/y8LZBy2/icons8-receipt-96px.png")
  TriggerEvent('Menu:CreateMenu')
end

function BuyToClothesShopMenuTop()
  ClothesShopMenuTop()
  buytopcs()
end

function ClothesShopMenuTop()
  Menu.clearMenu()
  TriggerEvent('Menu:AddButton2',"<span class='red--text'>Retour</span>", "OpenClothingShop", '', '', "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png")
  TriggerEvent('Menu:AddButton2',"Haut primaire", "CStop", '', '', "https://cdn.icon-icons.com/icons2/1082/PNG/512/sweater_78110.png")
	TriggerEvent('Menu:AddButton2',"Haut secondaire", "CStopSecondary", '', '', "https://img.icons8.com/cotton/2x/t-shirt--v1.png")
  TriggerEvent('Menu:AddButton2',"Ajuster bras/corp", "CSBras", '', '', "https://i.ibb.co/9vMJ04x/icons8-flex-biceps-96px.png")
  TriggerEvent('Menu:AddButton2',"Valider le haut", "OpenClothingShop", '', '', "https://icon-library.net/images/validation-icon/validation-icon-10.jpg")
  TriggerEvent('Menu:CreateMenu')
end

function BuyClothe()
  local ped = venato.GetPlayerPed()
  DataUser.Clothes.ComponentVariation.Mask.id = GetPedDrawableVariation(ped, 1)
  DataUser.Clothes.ComponentVariation.Mask.color = GetPedTextureVariation(ped, 1)
  tablee = {
    ComponentVariation = {
      Mask = {id = GetPedDrawableVariation(ped, 1), color = GetPedTextureVariation(ped, 1)},
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
  TriggerServerEvent("ClothingShop:SaveClothes", tablee, tatalPrice)
  venato.LoadClothes()
end

function CSsendMask()
  tablee.ComponentVariation.Mask.id = Clothes.ComponentVariation.Mask.id
  tablee.ComponentVariation.Mask.color = Clothes.ComponentVariation.Mask.color
end

RegisterNetEvent("ClothingShop:SaveClothes:response")
AddEventHandler("ClothingShop:SaveClothes:response", function(response)
  if response.status then
   buyAnything = true
   Menu.close()
   venato.LoadClothes()
   
   venato.notify(defaultNotification)
  else
    venato.notifyError(response.message)
    Menu.close()
    venato.LoadClothes()
  end
end)

function CSswitchsex()
  Citizen.CreateThread(function()
    DetachEntity(venato.GetPlayerPed(), true, true)
  if(GetEntityModel(venato.GetPlayerPed()) == GetHashKey("mp_m_freemode_01")) then
    local model = "mp_f_freemode_01"
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
    SetPlayerModel(PlayerId(), model)
    SetModelAsNoLongerNeeded(model)
    SetPedDefaultComponentVariation(venato.GetPlayerPed())
    SetPedComponentVariation(venato.GetPlayerPed(), 2, 0, 0, 0)
  else
    local model = "mp_m_freemode_01"
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
    SetPlayerModel(PlayerId(), model)
    SetModelAsNoLongerNeeded(model)
    SetPedDefaultComponentVariation(venato.GetPlayerPed())
    SetPedComponentVariation(venato.GetPlayerPed(), 2, 0, 0, 0)
  end
end)
end


function CSAccessoire()
  noColor = true
  Vtop = false
  componentId = 0-- Parachute / bag
  Menu.clearMenu()
  SetCamActive(cam,  false)
  RenderScriptCams(false,  false,  0,  true,  true)
	local id = 1
	local ped = venato.GetPlayerPed()
	Menu.addButton2("Retour", "OpenClothingShop", nil)
	for i=1,GetNumberOfPedDrawableVariations(ped, componentId) do
		local dont = false
		if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then
			for k,v in pairs(BlackListAccessoireMale) do
				if i == v and not debug then
					dont = true
					break
				end
			end
		else
			for k,v in pairs(BlackListAccessoireFemale) do
				if i == v and not debug then
					dont = true
					break
				end
			end
		end
		if dont == false then
			Menu.addButton2("Accessoires #"..id, "OpenClothingShop", i, "ChangeDomponentId")
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
	local ped = venato.GetPlayerPed()
  TriggerEvent('Menu:AddButton2',"<span class='red--text'>Retour</span>", "ClothesShopMenuTop", '', '', "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png")
	for i=1,GetNumberOfPedDrawableVariations(ped, componentId) do
		local dont = false
		if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then
			for k,v in pairs(BlackListTorsoMale) do
				if i == v and not debug then
					dont = true
					break
				end
			end
		else
			for k,v in pairs(BlackListTorsoFemale) do
				if i == v and not debug then
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
			Menu.addButton2("Haut Primaire #"..number, "BuyToClothesShopMenuTop", i, "ChangeDomponentId")
			id = id + 1
		end
	end
  Menu.CreateMenu()
end

function CStopSecondary()
  noColor = true
  PrimaryTopIndex = i
  SetCamCoord(cam,  x,  y-1.0,  z+0.5)
	PointCamAtCoord(cam,x,y,z)
  if debug then
    Menu.setTitle(i)
  end
  componentId = 8
  Menu.clearMenu()
  local id = 1
  local ped = venato.GetPlayerPed()
  TriggerEvent('Menu:AddButton2',"<span class='red--text'>Retour</span>", "ClothesShopMenuTop", '', '', "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png")
  Menu.addButton2("Retour", "ClothesShopMenuTop", nil)
  for i=1,GetNumberOfPedDrawableVariations(ped, componentId) do
		local dont = false
  	if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then
  		for k,v in pairs(BlackListTorso2Male) do
  			if i == v and not debug then
  				dont = true
  				break
  			end
  		end
		else
			for k,v in pairs(BlackListTorso2Female) do
  			if i == v and not debug then
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
			Menu.addButton2("Haut secondaire #"..number, "BuyToClothesShopMenuTop", i, "ChangeDomponentId")
  		id = id + 1
  	end
	end
  Menu.CreateMenu()
end

function CSBras()
  noColor = true
  PrimaryTopIndex = i
  SetCamCoord(cam,  x,  y-1.0,  z+0.5)
	PointCamAtCoord(cam,x,y,z)
  if debug then
    Menu.setTitle(i)
  end
  componentId = 3
  Menu.clearMenu()
  local id = 1
  local ped = venato.GetPlayerPed()
  TriggerEvent('Menu:AddButton2',"<span class='red--text'>Retour</span>", "ClothesShopMenuTop", '', '', "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png")
  for i=0,GetNumberOfPedDrawableVariations(ped, componentId) do
		local dont = false
  	if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then
  		for k,v in pairs(BlackListBrasMale) do
  			if i == v and not debug then
  				dont = true
  				break
  			end
  		end
		else
			for k,v in pairs(BlackListBrasFemale) do
  			if i == v and not debug then
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
			Menu.addButton2("Bras #"..number, "BuyToClothesShopMenuTop", i, "ChangeDomponentId")
  		id = id + 1
  	end
	end
  Menu.CreateMenu()
end

function buytopcs()
  if buytop == false then
    nothing = false
    buytop = true
    tatalPrice = tatalPrice + priceTop
    coordUI_Y = coordUI_Y +0.05
    coordtop = coordUI_Y
  end
end


function CMask()
  noColor = true
  Vtop = false
  componentId = 1 -- Mask
  Menu.clearMenu()
  SetCamCoord(cam,  x,  y-1.0,  z+0.5)
	PointCamAtCoord(cam,x,y,z+0.8)
	local id = 1
	local ped = venato.GetPlayerPed()
	Menu.addButton2("Retour", "OpenClothingShop", nil)
	for i=1,GetNumberOfPedDrawableVariations(ped, componentId) do
    local dont = false
    if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then
			for k,v in pairs(BlackListMaskMale) do
				if i == v and not debug then
					dont = true
					break
				end
			end
		else
			for k,v in pairs(BlackListMaskFemale) do
				if i == v and not debug then
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
			Menu.addButton2("Masque #"..number, "buyMasks", i, "ChangeDomponentId")
			id = id + 1
		end
	end
  Menu.CreateMenu()
end


function CSchausure()
  noColor = true
  Vtop = false
  componentId = 6 -- Shoes
  Menu.clearMenu()
  SetCamCoord(cam,  x,  y-1.0,  z-0.5)
	PointCamAtCoord(cam,x,y,z-0.8)
	local id = 1
	local ped = venato.GetPlayerPed()
	Menu.addButton2("Retour", "OpenClothingShop", nil)
	for i=1,GetNumberOfPedDrawableVariations(ped, componentId) do
		local dont = false
		if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then
			for k,v in pairs(BlackListShoesMale) do
				if i == v and not debug then
					dont = true
					break
				end
			end
		else
			for k,v in pairs(BlackListShoesFemale) do
				if i == v and not debug then
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
			Menu.addButton2("Chaussures #"..number, "buyShoescs", i, "ChangeDomponentId")
			id = id + 1
		end
	end
  Menu.CreateMenu()
end


function buyMasks()
  if buymask == false then
    nothing = false
    buymask = true
    tatalPrice = tatalPrice + priceMask
    coordUI_Y = coordUI_Y +0.05
    coordmask = coordUI_Y
    OpenClothingShop()
  else
    OpenClothingShop()
  end
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
	local ped = venato.GetPlayerPed()
	Menu.addButton2("Retour", "OpenClothingShop", nil)
	for i=1,GetNumberOfPedDrawableVariations(ped, componentId) do
		local dont = false
		if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then
			for k,v in pairs(BlackListLegMale) do
				if i == v and not debug then
					dont = true
					break
				end
			end
		else
			for k,v in pairs(BlackListLegFemale) do
				if i == v and not debug then
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
			Menu.addButton2("Pantalon #"..number, "buyLegscs", i, "ChangeDomponentId")
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
