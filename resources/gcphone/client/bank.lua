--====================================================================================
--  Function APP BANK
--====================================================================================

--[[
      Appeller SendNUIMessage({event = 'updateBankbalance', banking = xxxx})
      à la connection & à chaque changement du compte
--]]

-- ES / ESX Implementation

local bank = 0
function setBankBalance (value)
      bank = value
      SendNUIMessage({event = 'updateBankbalance', banking = bank})
end

RegisterNetEvent('gcphone:updateBank')
AddEventHandler('gcphone:updateBank', function(playerData)
  setBankBalance(playerData)
end)
