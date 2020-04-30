local price = 0

RegisterNetEvent("CleanCar:Clean")
AddEventHandler("CleanCar:Clean", function()
    local source = source
    local paymentCB = platypus.paymentCB(source, price)
	if paymentCB.status then
		TriggerClientEvent('CleanCar:Clean:ok', source)
    else
        TriggerClientEvent('CleanCar:Clean:ko', source, paymentCB)
	end
end)