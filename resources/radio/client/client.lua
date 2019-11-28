
--===============================================================================
--=== Stworzone przez Alcapone aka suprisex. Zakaz rozpowszechniania skryptu! ===
--===================== na potrzeby LS-Story.pl =================================
--===============================================================================


local DataUser = {}


local radioMenu = false

function PrintChatMessage(text)
    TriggerEvent('chatMessage', "system", { 255, 0, 0 }, text)
end



function enableRadio(enable)

  SetNuiFocus(true, true)
  radioMenu = enable

  SendNUIMessage({

    type = "enableui",
    enable = enable

  })

end

--- sprawdza czy komenda /radio jest włączony

RegisterCommand('radio', function(source, args)
    if Config.enableCmd then
      enableRadio(true)
    end
end, false)


-- radio test

RegisterCommand('radiotest', function(source, args)
  local playerName = GetPlayerName(PlayerId())
  local data = exports.tokovoip_script:getPlayerData(playerName, "radio:channel")

  print(tonumber(data))

  if data == "nil" then
    platypusNotify(Config.messages['not_on_radio'])
  else
   platypusNotify(Config.messages['on_radio'] .. data .. '.00 MHz </b>')
 end

end, false)

-- dołączanie do radia

RegisterNUICallback('joinRadio', function(data, cb)
    local _source = source
    local playerName = GetPlayerName(PlayerId())
    local getPlayerRadioChannel = exports.tokovoip_script:getPlayerData(playerName, "radio:channel")

    if tonumber(data.channel) ~= tonumber(getPlayerRadioChannel) then
        if tonumber(data.channel) <= Config.RestrictedChannels then
          print(DataUser.NameJob)
          if(DataUser.NameJob == 'Policier' or DataUser.NameJob == 'ambulance' or DataUser.NameJob == 'fire') then
            exports.tokovoip_script:removePlayerFromRadio(getPlayerRadioChannel)
            exports.tokovoip_script:setPlayerData(playerName, "radio:channel", tonumber(data.channel), true);
            exports.tokovoip_script:addPlayerToRadio(tonumber(data.channel))
            platypusNotify(Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
          elseif not (DataUser.NameJob == 'Policier' or DataUser.NameJob == 'ambulance' or DataUser.NameJob == 'fire') then
            --- info że nie możesz dołączyć bo nie jesteś policjantem
            platypusErrorNotify(Config.messages['restricted_channel_error'])
          end
        end
        if tonumber(data.channel) > Config.RestrictedChannels then
          exports.tokovoip_script:removePlayerFromRadio(getPlayerRadioChannel)
          exports.tokovoip_script:setPlayerData(playerName, "radio:channel", tonumber(data.channel), true);
          exports.tokovoip_script:addPlayerToRadio(tonumber(data.channel))
          platypusNotify(Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        end
      else
        platypusErrorNotify(Config.messages['you_on_radio'] .. data.channel .. '.00 MHz </b>')
      end
      --[[
    exports.tokovoip_script:removePlayerFromRadio(getPlayerRadioChannel)
    exports.tokovoip_script:setPlayerData(playerName, "radio:channel", tonumber(data.channel), true);
    exports.tokovoip_script:addPlayerToRadio(tonumber(data.channel))
    PrintChatMessage("radio: " .. data.channel)
    print('radiook')
      ]]--
    cb('ok')
end)

-- opuszczanie radia

RegisterNUICallback('leaveRadio', function(data, cb)
   local playerName = GetPlayerName(PlayerId())
   local getPlayerRadioChannel = exports.tokovoip_script:getPlayerData(playerName, "radio:channel")

    if getPlayerRadioChannel == "nil" then
      platypusNotify(Config.messages['not_on_radio'])
        else
          exports.tokovoip_script:removePlayerFromRadio(getPlayerRadioChannel)
          exports.tokovoip_script:setPlayerData(playerName, "radio:channel", "nil", true)
          platypusNotify(Config.messages['you_leave'] .. getPlayerRadioChannel .. '.00 MHz </b>')
    end

   cb('ok')

end)

RegisterNUICallback('escape', function(data, cb)

    enableRadio(false)
    SetNuiFocus(false, false)


    cb('ok')
end)

-- net eventy

RegisterNetEvent('ls-radio:use')
AddEventHandler('ls-radio:use', function()
  enableRadio(true)
end)

RegisterNetEvent('ls-radio:onRadioDrop')
AddEventHandler('ls-radio:onRadioDrop', function(source)
  local playerName = GetPlayerName(source)
  local getPlayerRadioChannel = exports.tokovoip_script:getPlayerData(playerName, "radio:channel")


  if getPlayerRadioChannel ~= "nil" then

    exports.tokovoip_script:removePlayerFromRadio(getPlayerRadioChannel)
    exports.tokovoip_script:setPlayerData(playerName, "radio:channel", "nil", true)
    platypusNotify(Config.messages['you_leave'] .. getPlayerRadioChannel .. '.00 MHz </b>')

end
end)

Citizen.CreateThread(function()
    while true do
        if radioMenu then
            DisableControlAction(0, 1, guiEnabled) -- LookLeftRight
            DisableControlAction(0, 2, guiEnabled) -- LookUpDown

            DisableControlAction(0, 142, guiEnabled) -- MeleeAttackAlternate

            DisableControlAction(0, 106, guiEnabled) -- VehicleMouseControlOverride

            if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
              --TriggerServerEvent("Radio:CallData")
            end
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
            if IsControlJustPressed(1, 20) then
              if radioMenu then
                enableRadio(false)
              else
                TriggerServerEvent("Radio:CallData")
              end
            end
        Citizen.Wait(0)
    end
end)


RegisterNetEvent('Radio:CallData:cb')
AddEventHandler('Radio:CallData:cb', function(data)
  DataUser = data
  TriggerEvent("ls-radio:use")
end)

function platypusNotify(text)
  local notif = {
    title= "Radio",
    type = "info", --  danger, error, alert, info, success, warning
    logo = "https://img.icons8.com/cotton/64/000000/marine-radio.png",
    message = text,
  }
  TriggerEvent("platypus:notify", notif)
end

function platypusErrorNotify(text)
  local notif = {
    title= "Radio",
    type = "error", --  danger, error, alert, info, success, warning
    logo = "https://img.icons8.com/cotton/64/000000/marine-radio.png",
    message = text,
  }
  TriggerEvent("platypus:notify", notif)
end
