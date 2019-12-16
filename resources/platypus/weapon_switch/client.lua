Config = {}

-- Lägg till alla vapen det ska fungera på
Config.WeaponList = {
	453432689, --pistol
	-1716189206, --knife
}

Config.PedAbleToWalkWhileSwapping = true
Config.UnarmedHash = -1569615261

Citizen.CreateThread(function()
	local animDict = 'reaction@intimidation@1h'

	local animIntroName = 'intro'
	local animOutroName = 'outro'

	local animFlag = 0

	RequestAnimDict(animDict)
	  
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(100)
	end

	local lastWeapon = nil

	while true do
		Citizen.Wait(0)

		if not IsPedInAnyVehicle(PlayerPedId(), true) then
			if Config.PedAbleToWalkWhileSwapping then
				animFlag = 48
			else
				animFlag = 0
			end

			for i=1, #Config.WeaponList do
				if lastWeapon ~= nil and lastWeapon ~= Config.WeaponList[i] and GetSelectedPedWeapon(PlayerPedId()) == Config.WeaponList[i] then
					SetCurrentPedWeapon(PlayerPedId(), Config.UnarmedHash, true)
					TaskPlayAnim(PlayerPedId(), animDict, animIntroName, 8.0, -8.0, 2700, animFlag, 0.0, false, false, false)

					Citizen.Wait(1000)
					SetCurrentPedWeapon(PlayerPedId(), Config.WeaponList[i], true)
				end

				if lastWeapon ~= nil and lastWeapon == Config.WeaponList[i] and GetSelectedPedWeapon(PlayerPedId()) == Config.UnarmedHash then
					TaskPlayAnim(PlayerPedId(), animDict, animOutroName, 8.0, -8.0, 2100, animFlag, 0.0, false, false, false)

					Citizen.Wait(1000)
					SetCurrentPedWeapon(PlayerPedId(), Config.UnarmedHash, true)
				end
			end
		end

		lastWeapon = GetSelectedPedWeapon(PlayerPedId())
	end
end)