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

Menu = {}
Menu.hidden = true


-- Audio = {
--   Library = "HUD_FRONTEND_DEFAULT_SOUNDSET",
--   UpDown = "NAV_UP_DOWN",
--   LeftRight = "NAV_LEFT_RIGHT",
--   Select = "SELECT",
--   Back = "BACK",
--   Error = "ERROR",
-- }

function Menu.open()
	TriggerEvent('Menu:Open')
	Menu.hidden = false
end

function Menu.close()
	TriggerEvent('Menu:Close')
	Menu.hidden = true
end

function Menu.toggle()
	if Menu.hidden then
		Menu.open()
	else
		Menu.close()
	end
end

function Menu.setTitle(title)
	TriggerEvent('Menu:Title', title)
end

function Menu.setSubtitle(subtitle)
	TriggerEvent('Menu:SubTitle', subtitle)
end

function Menu.addButton(name, func, args, hover)
	TriggerEvent('Menu:AddButton', name, func, args, hover)
end

function Menu.addItemButton(name, picture, func, args, hover)
	TriggerEvent('Menu:AddItemButton', name, picture, func, args, hover)
end

function Menu.addButton2(name, func, args, hover)
	TriggerEvent('Menu:AddButton2', name, func, args, hover)
end

function Menu.CreateMenu()
	TriggerEvent('Menu:CreateMenu')
end
--------------------------------------------------------------------------------------------------------------------

function Menu.clearMenu()
	TriggerEvent('Menu:Clear')
end

function MenuCallFunction(fnc, arg)
	_G[fnc](arg)
end


-- function Menu.stayPressed()
--   if IsControlJustPressed(0,  Keys["DOWN"]) then down = true end
--   if IsControlJustReleased(0,  Keys["DOWN"]) then down = false end
--   if IsControlJustPressed(1, Keys["TOP"]) then top = true end
--   if IsControlJustReleased(1, Keys["TOP"]) then top = false end
-- 	if a > aa then stayPressedUp = true  a = 0 aa = 5 else stayPressedUp = false end
-- 	if top then a = a + 1 else  a = 0 aa = 20 end
-- 	if b > bb then  stayPressedDown = true  b = 0 bb = 5 else  stayPressedDown = false end
-- 	if down then  b = b + 1 else  b = 0  bb = 20 end
-- end
