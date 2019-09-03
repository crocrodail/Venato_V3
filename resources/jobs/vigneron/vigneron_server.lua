RegisterServerEvent('vigneron:Car')
AddEventHandler('vigneron:Car', function()
	TriggerClientEvent('vigneron:getCar',source)
end)

