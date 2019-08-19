Citizen.CreateThread(function()
	while true do
		Citizen.Wait(20000)
		local Coords   = GetEntityCoords(Venato.GetPlayerPed(), true)
		local Heading = GetEntityHeading(Venato.GetPlayerPed())
		local FinalTable = { Coords.x, Coords.y, Coords.z+0.5, Heading }
		TriggerServerEvent('Coords:UpdatePos', FinalTable)
	end
end)
