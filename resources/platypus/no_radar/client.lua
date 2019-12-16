Citizen.CreateThread(function()
    while true do
	Citizen.Wait(0)
		if IsPedInAnyVehicle( PlayerPedId(), false ) then -- Ajouter la vérification si l'utilisateur à un GPS
			DisplayRadar(true)		
		else
			DisplayRadar(false)	
		end
    end
end)