local open = false
local type = 'fleeca'

Citizen.CreateThread(function ()
  SetNuiFocus(false, false)
	local time = 500
  while true do
    Citizen.Wait(time)
		inMarker = false
		inBankMarker = false

    for i=1, #Config.ATMS, 1 do
      if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.ATMS[i].x, Config.ATMS[i].y, Config.ATMS[i].z, true) < 20 and ( Config.ATMS[i].b ~= nil ) then
        DrawMarker(27,Config.ATMS[i].x, Config.ATMS[i].y, Config.ATMS[i].z+0.1,0,0,0,0,0,0,1.0,1.0,1.0,0,150,255,200,0,0,0,0)
      end
      if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.ATMS[i].x, Config.ATMS[i].y, Config.ATMS[i].z, true) < 2  then
				time = 0
				if ( Config.ATMS[i].b == nil ) then
					inMarker = true
					Venato.InteractTxt('Appuyez sur ~INPUT_PICKUP~ Pour utiliser le distributeur')
				else
					inBankMarker = true
					type = Config.ATMS[i].t
					Venato.InteractTxt('Appuyez sur ~INPUT_PICKUP~ pour être servi')
				end
			elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.ATMS[i].x, Config.ATMS[i].y, Config.ATMS[i].z, true) > 4 then
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
  menuBank(data)
end)

function menuBank(data)
  Menu.hidden = false
  MenuTitle = "Banque"
  MenuDescription = "Options"
  ClearMenu()
  if data.Account == 'aucun' then
    Menu.addButton("Créer un compte banquaire pour ~g~1 000 €", "CreatAcount", data)
  else
    Menu.addButton("Mon compte", "myAcount", data)
    Menu.addButton("Déposer un chèque", "depoCheque", data)
    Menu.addButton("Acheter une carte ~g~1 000 €", "buyCard", data)
    Menu.addButton("Acheter un chequier ~g~1 000 €", "buyCheque", data)
  end
end

function depoCheque(data)
  Menu.hidden = false
  ClearMenu()
  MenuTitle = "Mes chèques"
	MenuDescription = "Choisisez le chèque à déposer"
  Menu.addButton("~r~↩ Retour", "menuBank", data)
  for k,v in pairs(data.Documents) do
    if v.type == "cheque" then
      Menu.addButton("Cheque de ~g~"..v.montant.." €", "selecChequedepot", {data,k})
    end
  end
end

function selecChequedepot(row)
  ClearMenu()
  Menu.addButton("~r~↩ Retour", "depoCheque", row[1])
  Menu.addButton("Encaissé", "encaise", row)
  Menu.addButton("~r~Annuler ce cheque", "cancelChequetest", row)
end

function encaise(row)
  TriggerServerEvent("Bank:DepotCheque", row[2])
  Menu.hidden = true
end

function cancelChequetest(row)
  ClearMenu()
  MenuTitle = "~r~Confirmer l'annulation"
  MenuDescription = "Etes vous sur de vouloir annuler ce chèque ?"
  Menu.addButton("~r~Annuler l'annulation", "selecChequedepot", row)
  Menu.addButton("~b~Confirmer l'annulation", "cancelCheque", row)
end

function cancelCheque(row)
  TriggerServerEvent("Bank:CancelCheque", row[2])
  Menu.hidden = true
end


function buyCheque(data)
  if data.Money >= 1000 then
    local alereadyAChequier = false
    for k,v in pairs(data.Documents) do
      if v.type == "chequier" then
        alereadyAChequier = true
      end
    end
    if alereadyAChequier == false then
      TriggerServerEvent("Bank:createCheque")
      TriggerServerEvent("Inventory:RemoveMoney", 1000)
    else
      Venato.notify("~r~Vous possèdez déjà un chèquier.")
    end
  else
    Venato.notify("Vous n'avez pas les 1 000 € néssaisaire pour acheter un chequier.")
  end
end

function buyCard(data)
  if data.Money >= 1000 then
    TriggerServerEvent("Bank:createCard")
    TriggerServerEvent("Inventory:RemoveMoney", 1000)
  else
    Venato.notify("Vous n'avez pas les 1 000 € néssaisaire pour acheter une carte banquaire.")
  end
end

function CreatAcount(data)
  Menu.hidden = true
  if data.Money >= 1000 then
    TriggerServerEvent("Bank:createAccount")
    TriggerServerEvent("Inventory:RemoveMoney", 1000)
  else
    Venato.notify("Vous n'avez pas les 1 000 € néssaisaire pour ouvrir un compte.")
  end
end

function myAcount(data)
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
end


Citizen.CreateThread(function ()
  while true do
    Citizen.Wait(0)
		if IsControlJustPressed(1, Keys['BACKSPACE']) or IsControlJustPressed(1, Keys['RIGHTMOUSE']) and GetLastInputMethod(2) then
			SetNuiFocus(false, false)
			open = false
		end
		if IsControlJustReleased(0, 38) and inMarker and GetLastInputMethod(2) then
			TriggerServerEvent("Bank:GetDataMoneyForATM")
		end
		if IsControlJustReleased(0, 38) and inBankMarker and GetLastInputMethod(2) then
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
