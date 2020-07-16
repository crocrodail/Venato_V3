Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		local Coords   = GetEntityCoords(venato.GetPlayerPed(), true)
		local Heading = GetEntityHeading(venato.GetPlayerPed())
		local FinalTable = { Coords.x, Coords.y, Coords.z+0.5, Heading }
		TriggerServerEvent('Coords:UpdatePos', FinalTable)
	end
end)
