

Citizen.CreateThread(function()    
    local playerPed = venato.GetPlayerPed()
	while true do
        Citizen.Wait(10)
        if IsPedArmed(playerPed, 4) then
            local weapon = GetSelectedPedWeapon(playerPed)
            if IsPedShooting(playerPed) then
                local ammo = GetAmmoInPedWeapon(playerPed, weapon)
                local output = (string.format('%02x',weapon)):gsub("ffffffff","0x")               
                TriggerServerEvent("Weapon:UpdateAmmo", output, ammo)
            end
        end
	end
end)

