Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		local Coords   = GetEntityCoords(platypus.GetPlayerPed(), true)
		local Heading = GetEntityHeading(platypus.GetPlayerPed())
		local FinalTable = { Coords.x, Coords.y, Coords.z+0.5, Heading }
		TriggerServerEvent('Coords:UpdatePos', FinalTable)
	end
end)
