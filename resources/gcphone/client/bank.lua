local bank = 0
function setBankBalance (value)
      bank = value
      SendNUIMessage({event = 'updateBankbalance', banking = bank})
end
function setBankAccount (value)
      SendNUIMessage({event = 'updateBankAccount', account = value})
end
function setBankFullname (value)
      SendNUIMessage({event = 'updateFullname', fullname = value})
end

RegisterNetEvent('gcphone:updateBank')
AddEventHandler('gcphone:updateBank', function(playerData)  
  setBankBalance(playerData)
end)
RegisterNetEvent('gcphone:updateAccount')
AddEventHandler('gcphone:updateAccount', function(playerData)  
  setBankAccount(playerData)
end)
RegisterNetEvent('gcphone:updateFullname')
AddEventHandler('gcphone:updateFullname', function(playerData)  
  setBankFullname(playerData)
end)
