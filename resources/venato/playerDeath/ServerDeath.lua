local shooting = {}

RegisterServerEvent('Death:KillerAreShooting')
AddEventHandler('Death:KillerAreShooting', function(bool)
  local source = source
  shooting[source] = bool
end)

RegisterServerEvent('Death:ComaOrNot')
AddEventHandler('Death:ComaOrNot', function(killer)
  local source = source
	if shooting[killer] then
		TriggerClientEvent("Death:ComaOrNot:cb", source, true)
	else
		TriggerClientEvent("Death:ComaOrNot:cb", source, false)
  end
end)
