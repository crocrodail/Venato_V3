local KeyToucheClose = 177 -- PhoneCancel
local distMaxCheck = 3
local menuIsOpen = 0
local cansend = false

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if menuIsOpen ~= 0 then
      if IsControlJustPressed(1, KeyToucheClose) and menuIsOpen == 1 then
        closeGui()
      elseif menuIsOpen == 2 then
        local ply = PlayerPedId()
        DisableControlAction(0, 1, true)
        DisableControlAction(0, 2, true)
        DisableControlAction(0, 24, true)
        DisablePlayerFiring(ply, true)
        DisableControlAction(0, 142, true)
        DisableControlAction(0, 106, true)
        DisableControlAction(0,KeyToucheClose,true)
        if IsDisabledControlJustReleased(0, 142) then
          SendNUIMessage({method = "clickGui"})
        end
      end
    end
  end
end)

RegisterNetEvent("Register:showRegisterItentity")
AddEventHandler("Register:showRegisterItentity", function()
  openGuiRegisterIdentity()
end)

RegisterNUICallback('register', function(data, cb)
    closeGui()
    if cansend then
      TriggerServerEvent('Register:setIdentity', data)
      cansend = false
    end
    cb()
end)

function openGuiRegisterIdentity()
  cansend = true
  SetNuiFocus(true)
  SendNUIMessage({method = 'openGuiRegisterIdentity'})
  menuIsOpen = 2
end

function closeGui()
  SetNuiFocus(false)
  SendNUIMessage({method = 'closeGui'})
  menuIsOpen = 0
end
