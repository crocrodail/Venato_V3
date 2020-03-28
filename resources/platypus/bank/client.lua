local open = false
local type = 'fleeca'
local defaultNotification = {
  title ="Banque",
  logo = "https://img.icons8.com/officel/16/000000/bank-euro.png"
}
local accountIsBlocked = false
local message_block = "Votre compte est bloqué pour mouvements suspicieux.<br/><br/><span class='red--text'> Rendez-vous au LSPD pour régulariser votre situation.</span>"
local indexLoop = nil
local indexLoopATM = nil

Citizen.CreateThread(function()
  SetNuiFocus(false, false)
  while true do
    Citizen.Wait(0)
    for i = 1, #Config.ATMS, 1 do
      Citizen.Wait(0)
      if GetDistanceBetweenCoords(GetEntityCoords(Venato.GetPlayerPed()), Config.ATMS[i].x, Config.ATMS[i].y, Config.ATMS[i].z, true) < 2 and (Config.ATMS[i].b ~= nil) then
        indexLoop = i
      end
      if GetDistanceBetweenCoords(GetEntityCoords(Venato.GetPlayerPed()), Config.ATMS[i].x, Config.ATMS[i].y, Config.ATMS[i].z, true) < 0.5 and (Config.ATMS[i].b == nil) then
        indexLoopATM = i
      end
      if indexLoop ~= nil then
        if GetDistanceBetweenCoords(GetEntityCoords(Venato.GetPlayerPed()), Config.ATMS[indexLoop].x, Config.ATMS[indexLoop].y, Config.ATMS[indexLoop].z, true) < 0.5 then
          inBankMarker = true
        else
          inBankMarker = false
        end
      end
      if indexLoopATM ~= nil then
        if GetDistanceBetweenCoords(GetEntityCoords(Venato.GetPlayerPed()), Config.ATMS[indexLoopATM].x, Config.ATMS[indexLoopATM].y, Config.ATMS[indexLoopATM].z, true) < 0.6 then
          inMarker = true
        else
          inMarker = false
        end
      end
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if indexLoop ~= nil then
      DrawMarker(27, Config.ATMS[indexLoop].x, Config.ATMS[indexLoop].y, Config.ATMS[indexLoop].z + -0.9, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0,150, 255, 200, 0, 0, 0, 0)
    end
    if inMarker == true then
      Venato.InteractTxt('Appuyez sur ~INPUT_PICKUP~ Pour utiliser le distributeur')
    elseif inBankMarker == true then
      Venato.InteractTxt('Appuyez sur ~INPUT_PICKUP~ pour être servi')
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

RegisterNetEvent('Bank:AccountIsBlocked:Set')
AddEventHandler('Bank:AccountIsBlocked:Set', function(value)
  print("AccountIsBlocked : ".. value)
  accountIsBlocked = value == 1
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

function buyCheque()
  TriggerServerEvent("Bank:createCheque")
end

function buyCard(data)
  local alereadyACard = false
  for k, v in pairs(data.Inventaire) do
    if v.id == 41 then
      alereadyACard = true
    end
  end
  if alereadyACard == false then
    TriggerServerEvent("Bank:createCard")
    Menu.close()
  else
    platypus.notifyError("Vous possèdez déjà une carte de crédit.")
  end


end

function CreatAcount(data)
  TriggerServerEvent("Bank:createAccount")
  Menu.close()
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
      if accountIsBlocked then
        defaultNotification.message = message_block
        defaultNotification.timeout = 5000
        Venato.notify(defaultNotification)
      else
        TriggerServerEvent("Bank:GetDataMoneyForATM")
      end
		end
    if IsControlJustReleased(0, 38) and inBankMarker and GetLastInputMethod(2) then
      if accountIsBlocked then
        defaultNotification.message = message_block
        defaultNotification.timeout = 5000
        platypus.notify(defaultNotification)
      else
        TriggerServerEvent("Bank:GetDataMoneyForBank")
      end
		end
    if open then
      defaultNotification.timeout = 5000
      DisableControlAction(0, 1, true) -- LookLeftRight
      DisableControlAction(0, 2, true) -- LookUpDown
      DisableControlAction(0, 24, true) -- Attack
      DisablePlayerFiring(platypus.GetPlayerPed(), true) -- Disable weapon firing
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
  platypus.notifyError("Erreur dans le montant entré")
end)
