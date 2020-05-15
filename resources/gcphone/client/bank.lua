local bank = 0
function setBankBalance (value)
      bank = value
      SendNUIMessage({event = 'updateBankbalance', banking = bank})
end

RegisterNetEvent('gcphone:updateBank')
AddEventHandler('gcphone:updateBank', function(playerData)
  setBankBalance(playerData)
end)
