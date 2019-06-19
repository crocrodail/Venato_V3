local open = false
local type = 'fleeca'

Citizen.CreateThread(function ()
  SetNuiFocus(false, false)
	time = 500
	x = 1
  while true do
    Citizen.Wait(time)
		inMarker = false
		inBankMarker = false

    for i=1, #Config.ATMS, 1 do
      if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.ATMS[i].x, Config.ATMS[i].y, Config.ATMS[i].z, true) < 2  then
				x = i
				time = 0
				if ( Config.ATMS[i].b == nil ) then
					inMarker = true
					Venato.InteractTxt('Appuyez sur ~INPUT_PICKUP~ Pour utiliser le distributeur')
				else
					inBankMarker = true
					type = Config.ATMS[i].t
					Venato.InteractTxt('Appuyez sur ~INPUT_PICKUP~ pour être servi')
				end
			elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.ATMS[x].x, Config.ATMS[x].y, Config.ATMS[x].z, true) > 4 then
				time = 500
			end
    end
	end
end)

RegisterNetEvent('Bank:GetDataMoneyForATM:cb')
AddEventHandler('Bank:GetDataMoneyForATM:cb', function(data)
	SetNuiFocus(true, true)
	open = true
	SendNUIMessage({
		action = "open",
		bank = data.Bank,
		cash = data.Money,
    code = tostring(data.Code)
	})
end)

RegisterNetEvent('Bank:GetDataMoneyForBank:cb')
AddEventHandler('Bank:GetDataMoneyForBank:cb', function(data)
	SetNuiFocus(true, true)
	open = true
	SendNUIMessage({
		action = "openBank",
		bank = data.Bank,
		cash = data.Money,
		type = type,
		firstname = data.Prenom,
		lastname = data.Nom,
		account = data.Account
	})
end)


Citizen.CreateThread(function ()
  while true do
    Citizen.Wait(0)
		if IsControlJustPressed(1, Keys['BACKSPACE']) or IsControlJustPressed(1, Keys['RIGHTMOUSE']) and GetLastInputMethod(2) then
			SetNuiFocus(false, false)
			open = false
		end
		if IsControlJustReleased(0, 38) and inMarker then
		--	for k,v in pairs(DataPlayers[source].Inventaire) do
    --    if k == 41 then
    --      godDamn = true
    --    end
    --  end
			TriggerServerEvent("Bank:GetDataMoneyForATM")
			--	else
				--	ESX.ShowNotification('You have no credit card. Go to the bank')
				--end
			--end)
		end
		if IsControlJustReleased(0, 38) and inBankMarker then
			TriggerServerEvent("Bank:GetDataMoneyForBank")
		end
		if open then
      DisableControlAction(0, 1, true) -- LookLeftRight
      DisableControlAction(0, 2, true) -- LookUpDown
      DisableControlAction(0, 24, true) -- Attack
      DisablePlayerFiring(GetPlayerPed(-1), true) -- Disable weapon firing
      DisableControlAction(0, 142, true) -- MeleeAttackAlternate
      DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
    end
	end
end)

RegisterNUICallback('insert', function(data, cb)
	cb('ok')
	TriggerServerEvent('Bank:insert', data.money)
end)

RegisterNUICallback('take', function(data, cb)
	cb('ok')
	TriggerServerEvent('Bank:take', data.money)
end)

-- Transfer money
RegisterNUICallback('transfer', function(data, cb)
	cb('ok')
	TriggerServerEvent('Bank:transfer', data.money, data.account)
end)

-- Close the NUI/HTML window
RegisterNUICallback('escape', function(data, cb)
	SetNuiFocus(false, false)
	open = false
	cb('ok')
end)

-- Handles the error message
RegisterNUICallback('error', function(data, cb)
	SetNuiFocus(false, false)
	open = false
	cb('ok')
	Venato.notify('The machine is working. Please wait')
end)
