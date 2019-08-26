	RegisterServerEvent('pompiste:Car1')
	AddEventHandler('pompiste:Car1', function()
		local source = source
		TriggerClientEvent('pompiste:getCamion',source)
	end)

	RegisterServerEvent('pompiste:Car2')
	AddEventHandler('pompiste:Car2', function()
		local source = source
		TriggerClientEvent('pompiste:getRemorque',source)
	end)
