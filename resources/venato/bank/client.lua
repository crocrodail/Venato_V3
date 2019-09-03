local open = false
local type = 'fleeca'
local defaultNotification = {
  type = "info",
  title ="Banque",
  logo = "https://img.icons8.com/officel/16/000000/bank-euro.png"
}

Citizen.CreateThread(function()
  SetNuiFocus(false, false)
  local time = 500
  while true do
    Citizen.Wait(0)
    inMarker = false
    inBankMarker = false

    for i = 1, #Config.ATMS, 1 do
      if GetDistanceBetweenCoords(GetEntityCoords(Venato.GetPlayerPed()), Config.ATMS[i].x, Config.ATMS[i].y,
        Config.ATMS[i].z, true) < 20 and (Config.ATMS[i].b ~= nil) then
        DrawMarker(27, Config.ATMS[i].x, Config.ATMS[i].y, Config.ATMS[i].z + 0.1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0,
          150, 255, 200, 0, 0, 0, 0)
      end
      if GetDistanceBetweenCoords(GetEntityCoords(Venato.GetPlayerPed()), Config.ATMS[i].x, Config.ATMS[i].y,
        Config.ATMS[i].z, true) < 2 then
        time = 0
        if (Config.ATMS[i].b == nil) then
          inMarker = true
          Venato.InteractTxt('Appuyez sur ~INPUT_PICKUP~ Pour utiliser le distributeur')
        else
          inBankMarker = true
          type = Config.ATMS[i].t
          Venato.InteractTxt('Appuyez sur ~INPUT_PICKUP~ pour être servi')
        end
      elseif GetDistanceBetweenCoords(GetEntityCoords(Venato.GetPlayerPed()), Config.ATMS[i].x, Config.ATMS[i].y,
        Config.ATMS[i].z, true) > 4 then
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
  TriggerEvent('Menu:Init', "Banque", "Options", '#11751C70', "http://www.kiplinger.com/kipimages/pages/18919.jpg")
  Menu.open()
  Menu.setTitle("Banque")
  Menu.setSubtitle("Options")
  Menu.clearMenu()
  if data.Account == 'aucun' then
    Menu.addItemButton("Créer un compte bancaire pour <span class='green--text'>1 000 €</span>", "https://i.ibb.co/6t5n3yP/icons8-merchant-account-96px.png", "CreatAcount", data)
  else
    Menu.addItemButton("Mon compte", "https://i.ibb.co/LPxNL9M/icons8-atm-96px.png", "myAcount", data)
    Menu.addItemButton("Déposer un chèque", "https://i.ibb.co/99492rt/drop-Cheque.png", "depoCheque", data)
    Menu.addItemButton("Acheter une carte <span class='green--text'>1 000 €</span>", "https://i.ibb.co/3kWgbbN/icons8-mastercard-credit-card-96px.png", "buyCard", data)
    Menu.addItemButton("Acheter un chequier <span class='green--text'>1 000 €</span>", "https://i.ibb.co/vs3ptjz/icons8-paycheque-96px-2.png", "buyCheque", data)
  end
end

function depoCheque(data)
  Menu.open()
  Menu.clearMenu()
  Menu.setTitle("Mes chèques")
  Menu.setSubtitle("Choisisez le chèque à déposer")
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "menuBank", data)
  for k, v in pairs(data.Documents) do
    if v.type == "cheque" then
      Menu.addItemButton("Cheque de <span class='green--text'>" .. v.montant .. "</span> €", 'https://i.ibb.co/ZXZgqSF/icons8-paycheque-96px.png', "selecChequedepot", { data, k })
    end
  end
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "menuBank", data)
end

function selecChequedepot(row)
  Menu.clearMenu()
  Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "depoCheque", row[1])
  Menu.addItemButton("Encaisser le chèque", "https://i.ibb.co/Y3fwFnQ/icons8-request-money-96px-1.png","encaise", row)
  Menu.addItemButton("<span class='red--text'>Annuler ce chèque</span>", "https://i.ibb.co/YXNSF7R/cancel-Check.png", "cancelChequetest", row)
end

function encaise(row)
  TriggerServerEvent("Bank:DepotCheque", row[2])
  Menu.close()
end

function cancelChequetest(row)
  Menu.clearMenu()
  Menu.setTitle("<span class='red--text'>Confirmer l'annulation</span>")
  Menu.setSubtitle("Etes vous sur de vouloir annuler ce chèque ?")
  Menu.addItemButton("<span class='red--text'>Annuler l'annulation</span>", "https://i.ibb.co/gg9x451/icons8-close-window-96px.png", "selecChequedepot", row)
  Menu.addItemButton("<span class='blue--text'>Confirmer l'annulation</span>", "https://i.ibb.co/sgQMTLR/icons8-checked-96px-1.png", "cancelCheque", row)
end

function cancelCheque(row)
  TriggerServerEvent("Bank:CancelCheque", row[2])
  Menu.close()
end

function buyCheque(data)
  if data.Money >= 1000 then
    local alereadyAChequier = false
    for k, v in pairs(data.Documents) do
      if v.type == "chequier" then
        alereadyAChequier = true
      end
    end
    if alereadyAChequier == false then
      TriggerServerEvent("Bank:createCheque")
      TriggerServerEvent("Inventory:RemoveMoney", 1000)
    else
      Venato.notifyError("Vous possèdez déjà un chèquier.")
    end
  else
    Venato.notifyError("Vous n'avez pas les 1 000 € nécessaire pour acheter un chequier.")
  end
end

function buyCard(data)
  if data.Money >= 1000 then
    TriggerServerEvent("Bank:createCard")
    TriggerServerEvent("Inventory:RemoveMoney", 1000)
  else
    Venato.notifyError("Vous n'avez pas les 1 000 € nécessaire pour acheter une carte bancaire.")
  end
end

function CreatAcount(data)
  Menu.close()
  if data.Money >= 1000 then
    TriggerServerEvent("Bank:createAccount")
    TriggerServerEvent("Inventory:RemoveMoney", 1000)
  else
    Venato.notifyError("Vous n'avez pas les 1 000 € nécessaire pour ouvrir un compte.")
  end
end

RegisterNetEvent('Bank:ActuSoldeErrone')
AddEventHandler('Bank:ActuSoldeErrone', function(data)
  myAcount(data)
end)

function myAcount(data)
  Menu.close()
  open = true
  SetNuiFocus(true, true)
  SendNUIMessage({
    action = "ResetIndex",
  })
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

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
		if IsControlJustPressed(1, Keys['BACKSPACE']) or IsControlJustPressed(1, Keys['RIGHTMOUSE']) or IsControlJustPressed(1, Keys['ESC']) and GetLastInputMethod(2) then
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
      DisablePlayerFiring(Venato.GetPlayerPed(), true) -- Disable weapon firing
      DisableControlAction(0, 142, true) -- MeleeAttackAlternate
      DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
    end
  end
end)

RegisterNUICallback('closeBank', function(data, cb)
	cb('ok')
  SetNuiFocus(false, false)
  open = false
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
RegisterNUICallback('errorbank', function(data, cb)
  Venato.notifyError("Erreur dans le montant entré")
end)
