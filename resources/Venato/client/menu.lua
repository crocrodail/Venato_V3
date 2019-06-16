--##############################################################################################
--
--                             By Crocrodail  -  Venato.fr
--
--##############################################################################################


Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118, ["RIGHTMOUSE"] = 25, ["INPUT_CONTEXT"] = 51
}

local drawControl = nil
local form = nil
local itemsPerPage = 10
local top = false
local down = false
local stayPressedUp = false
local stayPressedDown = false
local a = 0
local b = 0
local aa = 20
local bb = 20
menuIsopen = false
Menu = {}
Menu.GUI = {}
Menu.buttonCount = 0
Menu.selection = 0
Menu.hidden = true
Menu.from = 0
Menu.to = itemsPerPage
Menu.previous = nil
MenuTitle = "Menu"
MenuDescription = ""
showPageInfo = false
Audio = {
  Library = "HUD_FRONTEND_DEFAULT_SOUNDSET",
  UpDown = "NAV_UP_DOWN",
  LeftRight = "NAV_LEFT_RIGHT",
  Select = "SELECT",
  Back = "BACK",
  Error = "ERROR",
}
yoffset = 0.25
xoffset = -0.022
xmin = 0.2
xmax = 0.25
ysize = 0.04
xtext = xmin + xoffset + 0.025
ytitle = yoffset - 0.11
xdescriptionText = 0.12

function Menu.addButton(name, func,args)
	Menu.GUI[Menu.buttonCount +1] = {}
	Menu.GUI[Menu.buttonCount +1]["name"] = name
	Menu.GUI[Menu.buttonCount+1]["func"] = func
	Menu.GUI[Menu.buttonCount+1]["args"] = args
	Menu.GUI[Menu.buttonCount+1]["active"] = false
	Menu.GUI[Menu.buttonCount+1]["xmin"] = xmin
	Menu.GUI[Menu.buttonCount+1]["ymin"] = yoffset - ysize
	Menu.GUI[Menu.buttonCount+1]["xmax"] = xmax
	Menu.GUI[Menu.buttonCount+1]["ymax"] = ysize
	Menu.buttonCount = Menu.buttonCount+1
end

function Menu.stayPressed()
  if IsControlJustPressed(0,  Keys["DOWN"]) then down = true end
  if IsControlJustReleased(0,  Keys["DOWN"]) then down = false end
  if IsControlJustPressed(1, Keys["TOP"]) then top = true end
  if IsControlJustReleased(1, Keys["TOP"]) then top = false end
	if a > aa then stayPressedUp = true  a = 0 aa = 5 else stayPressedUp = false end
	if top then a = a + 1 else  a = 0 aa = 20 end
	if b > bb then  stayPressedDown = true  b = 0 bb = 5 else  stayPressedDown = false end
	if down then  b = b + 1 else  b = 0  bb = 20 end
end

function Menu.updateSelection()
	if IsControlJustPressed(1, Keys["DOWN"]) or stayPressedDown then
    PlaySoundFrontend(-1, Audio.UpDown, Audio.Library, true)
		if (Menu.selection <= Menu.to and Menu.selection < Menu.buttonCount - 1) then
			Menu.selection = Menu.selection + 1
			if (Menu.selection == Menu.to) then
				Menu.from = Menu.from + 1
				Menu.to = Menu.to + 1
			end
		else
			Menu.from = 0
			Menu.to = itemsPerPage
			Menu.selection = Menu.from
		end
	elseif IsControlJustPressed(1, Keys["TOP"])  or stayPressedUp then
    PlaySoundFrontend(-1, Audio.UpDown, Audio.Library, true)
		if (Menu.selection > Menu.from or Menu.selection > 0 ) then
			if (Menu.selection == Menu.from) then
				Menu.from = Menu.from - 1
				Menu.to = Menu.to - 1
			end
			Menu.selection = Menu.selection - 1
		else
    if Menu.buttonCount < itemsPerPage then
        Menu.from = Menu.buttonCount - Menu.buttonCount
        Menu.to = Menu.buttonCount
        Menu.selection = Menu.buttonCount - 1
      else
        Menu.from = Menu.buttonCount - itemsPerPage
        Menu.to = Menu.buttonCount
        Menu.selection = Menu.buttonCount - 1
      end
		end
	elseif IsControlJustPressed(1, Keys["NENTER"])  then
    PlaySoundFrontend(-1, Audio.Select, Audio.Library, true)
		if Menu.buttonCount > 0 then
			MenuCallFunction(Menu.GUI[Menu.selection +1]["func"], Menu.GUI[Menu.selection +1]["args"])
		end
	end
	local iterator = 0
	for id, settings in ipairs(Menu.GUI) do
		Menu.GUI[id]["active"] = false
		if(iterator == Menu.selection ) then
			Menu.GUI[iterator +1]["active"] = true
		end
		iterator = iterator +1
	end
end

function Menu.renderGUI()
	if not Menu.hidden then
    if not menuIsopen then
      PlaySoundFrontend(-1, Audio.Select, Audio.Library, true)
      menuIsopen = true
    end
		Menu.renderButtons()
		Menu.updateSelection()
    Menu.stayPressed()
  elseif menuIsopen then
    menuIsopen = false
    PlaySoundFrontend(-1, Audio.Back, Audio.Library, true)
	end
end

function Menu.renderBox(xMin,xMax,yMin,yMax,color1,color2,color3,color4)
	DrawRect(xMin, yMin,xMax, yMax, color1, color2, color3, color4);
end

function Menu.renderMainBox(xMin,xMax,yMin,yMax,color1,color2,color3,color4)
  if not HasStreamedTextureDictLoaded("CommonMenu") then
		RequestStreamedTextureDict("CommonMenu", true)
	end
  DrawSprite("CommonMenu" , "interaction_bgd", xMin, yMin - 0.05, xMax, yMax +0.05, 0, 255, 255, 255, 255)
  DrawRect(xMin, yMin+0.01, xMax, yMax-0.025, 0, 0, 0, 255);
  SetTextFont(1)
  SetTextScale(1,0.45)
  SetTextColour(255, 255, 255, 255)
  SetTextCentre(false)
  SetTextDropShadow(0, 0, 0, 0, 0)
  SetTextEdge(0, 0, 0, 0, 0)
  SetTextEntry("STRING")
  local text = MenuDescription
  if showPageInfo then  text = text.." "..(Menu.selection + 1).."/"..Menu.buttonCount end
  AddTextComponentString(text)
  DrawText(xtext-xdescriptionText , ytitle+0.0655)
end

function Menu.renderButtons()
	SetTextFont(1)
	SetTextScale(1,0.9)
	SetTextColour(255, 255, 255, 255)
	SetTextCentre(true)
	SetTextDropShadow(0, 0, 0, 0, 0)
	SetTextEdge(0, 0, 0, 0, 0)
	SetTextEntry("STRING")
	-- AddTextComponentString(string.upper(MenuTitle)..(Menu.selection + 1).."/"..Menu.buttonCount)
	AddTextComponentString(MenuTitle)
	DrawText(xtext, ytitle)
  Menu.renderMainBox(xmin, xmax, (yoffset - 0.04), 0.05, 38, 75, 165, 255)

	for id, settings in pairs(Menu.GUI) do
		if id > Menu.from and id <= Menu.to then
			local yPos = settings["ymin"] + (id * ysize) - (Menu.from * ysize)
			if(settings["active"]) then
				boxColor = {255,255,255,220}
				textColor = {0,0,0,250}
			else
				boxColor = {0,0,0,150}
				textColor = {255,255,255,255}
			end
			SetTextFont(0)
			SetTextScale(0.0,0.35)
			SetTextColour(textColor[1],textColor[2],textColor[3],textColor[4])
			SetTextCentre(true)
			-- SetTextDropShadow(0, 0, 0, 0, 0)
			SetTextEdge(0, 0, 0, 0, 0)
			SetTextEntry("STRING")
			AddTextComponentString(settings["name"])
			DrawText(xtext, (yPos - 0.0125))
			Menu.renderBox(settings["xmin"] ,settings["xmax"], yPos, settings["ymax"], boxColor[1], boxColor[2], boxColor[3], boxColor[4])
		end
	end
end



--------------------------------------------------------------------------------------------------------------------

function ClearMenu()
	--Menu = {}
	Menu.GUI = {}
	Menu.buttonCount = 0
	Menu.selection = 0
	Menu.from = 0
	Menu.to = itemsPerPage
end

function MenuCallFunction(fnc, arg)
	_G[fnc](arg)
end
