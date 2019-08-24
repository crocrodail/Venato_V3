local top = false
local down = false
local stayPressedUp = false
local stayPressedDown = false
local a = 0
local b = 0
local aa = 20
local bb = 20
local menuOpen = false
local idButton = 0
local MenuGen = {}
local Audio = {
  Library = "HUD_FRONTEND_DEFAULT_SOUNDSET",
  UpDown = "NAV_UP_DOWN",
  LeftRight = "NAV_LEFT_RIGHT",
  Select = "SELECT",
  Back = "BACK",
  Error = "ERROR",
}
local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["UP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118, ["RIGHTMOUSE"] = 25, ["INPUT_CONTEXT"] = 51
}


Citizen.CreateThread(function ()
    SetNuiFocus(false, false)
    while true do
      Citizen.Wait(0)
			stayPressed()
        actionCall = ""
        if menuOpen then
            --print('menu open')
            if IsControlJustPressed(1, Keys["UP"]) or stayPressedUp then
							PlaySoundFrontend(-1, Audio.UpDown, Audio.Library, true)
                actionCall = "up"
            elseif IsControlJustPressed(1, Keys["DOWN"]) or stayPressedDown then
							PlaySoundFrontend(-1, Audio.UpDown, Audio.Library, true)
                actionCall = "down"
            elseif IsControlJustPressed(1, Keys["LEFT"]) then
							PlaySoundFrontend(-1, Audio.LeftRight, Audio.Library, true)
                actionCall = "left"
            elseif IsControlJustPressed(1, Keys["RIGHT"]) then
							PlaySoundFrontend(-1, Audio.LeftRight, Audio.Library, true)
                actionCall = "right"
            elseif IsControlJustPressed(1, Keys["ENTER"]) then
							PlaySoundFrontend(-1, Audio.Select, Audio.Library, true)
                actionCall = "enter"
            end
            if actionCall ~= '' then
                SendNUIMessage({
                    action= actionCall
                })
            end
        end
    end
end)

function stayPressed()
  if IsControlJustPressed(0,  Keys["DOWN"]) then down = true end
  if IsControlJustReleased(0,  Keys["DOWN"]) then down = false end
  if IsControlJustPressed(0, Keys["UP"]) then top = true end
  if IsControlJustReleased(0, Keys["UP"]) then top = false end
	if a > aa then stayPressedUp = true  a = 0 aa = 5 else stayPressedUp = false end
	if top then a = a + 1 else  a = 0 aa = 20 end
	if b > bb then  stayPressedDown = true  b = 0 bb = 5 else  stayPressedDown = false end
	if down then  b = b + 1 else  b = 0  bb = 20 end
end


RegisterNetEvent('Menu:Open')
AddEventHandler('Menu:Open', function()
	menuOpen = true
	SendNUIMessage({
        action = "open"
	})
end)

RegisterNetEvent('Menu:Close')
AddEventHandler('Menu:Close', function()
	menuOpen = false
	SendNUIMessage({
		action = "close"
	})
end)

RegisterNetEvent('Menu:Clear')
AddEventHandler('Menu:Clear', function()
	SendNUIMessage({
		action = "clear"
	})
	idButton = 0
	MenuGen = {}
end)


RegisterNetEvent('Menu:Init')
AddEventHandler('Menu:Init', function(title, subtitle, color, background)
	SendNUIMessage({
        action = "init",
        title = title,
        subtitle = subtitle,
        color = color,
        background = background
	})
end)

RegisterNetEvent('Menu:Title')
AddEventHandler('Menu:Title', function(title)
	SendNUIMessage({
        action = "title",
        title = title
	})
end)

RegisterNetEvent('Menu:SubTitle')
AddEventHandler('Menu:SubTitle', function(subtitle)
	SendNUIMessage({
        action = "subtitle",
        subtitle = subtitle
	})
end)

RegisterNetEvent('Menu:AddButton')
AddEventHandler('Menu:AddButton', function(name, func, args, hover)

	SendNUIMessage({
        action = "addButton",
        name = name,
        func = func,
        args = args,
        hover = hover
	})
end)

RegisterNetEvent('Menu:AddItemButton')
AddEventHandler('Menu:AddItemButton', function(name, picture, func, args, hover)

	SendNUIMessage({
        action = "addItemButton",
        name = name,
        picture = picture,
        func = func,
        args = args,
        hover = hover
	})
end)

RegisterNetEvent('Menu:AddButton2')
AddEventHandler('Menu:AddButton2', function(name, func, args, hover, picture)
    idButton = idButton + 1
	MenuGen[idButton] = {name = name, func = func, args = args, hover = hover, avatar = picture}
end)

RegisterNetEvent('Menu:AddShopButton')
AddEventHandler('Menu:AddShopButton', function(name, func, args, picture, stock, price, isShopItem)
	idButton = idButton + 1
	MenuGen[idButton] = {name = name, func = func, args = args, avatar = picture, stock = stock, price = price, isShopItem = true }
end)

RegisterNetEvent('Menu:CreateMenu')
AddEventHandler('Menu:CreateMenu', function()
	SendNUIMessage({
        action = "genMenu",
        json.encode(MenuGen),
	})
end)

RegisterNetEvent('Menu:ShowVehicleInformation')
AddEventHandler('Menu:ShowVehicleInformation', function(vehicle)
    SendNUIMessage({
        action = "showVehicleInfo",
        vehicle = vehicle
	})
end)

RegisterNetEvent('Menu:HideVehicleInformation')
AddEventHandler('Menu:HideVehicleInformation', function()
	SendNUIMessage({
        action = "hideVehicleInfo"
	})
end)

RegisterNetEvent('Menu:ShowShopAdmin')
AddEventHandler('Menu:ShowShopAdmin', function()
    SendNUIMessage({
        action = "showShopAdmin",
	})
end)

RegisterNetEvent('Menu:HideShopAdmin')
AddEventHandler('Menu:HideShopAdmin', function()
	SendNUIMessage({
        action = "hideShopAdmin"
	})
end)

RegisterNUICallback('callback', function(data, cb)
    cb('ok')
    if data.data.hover then
        TriggerEvent("Menu:Execute",{ fn = data.data.hover, args =data.data.data })
    end
end)

RegisterNUICallback('confirm', function(data, cb)
    cb('ok')
    TriggerEvent("Menu:Execute",{ fn = data.data.confirm, args =data.data.data })
end)

RegisterNUICallback('close', function(data, cb)
    cb('ok')
    _G[data.data.hover](data.data.data)
    TriggerEvent("Menu:Close")
end)
