local WeaponList = {
	453432689, --pistol
	-1716189206, --knife
}

local PedAbleToWalkWhileSwapping = true
local UnarmedHash = -1569615261

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
			if PedAbleToWalkWhileSwapping then
				animFlag = 48
			else
				animFlag = 0
			end

			for i=1, #WeaponList do
				if lastWeapon ~= nil and lastWeapon ~= WeaponList[i] and GetSelectedPedWeapon(PlayerPedId()) == WeaponList[i] then
					SetCurrentPedWeapon(PlayerPedId(), UnarmedHash, true)
					TaskPlayAnim(PlayerPedId(), animDict, animIntroName, 8.0, -8.0, 2700, animFlag, 0.0, false, false, false)

					Citizen.Wait(1000)
					SetCurrentPedWeapon(PlayerPedId(), WeaponList[i], true)
				end

				if lastWeapon ~= nil and lastWeapon == WeaponList[i] and GetSelectedPedWeapon(PlayerPedId()) == UnarmedHash then
					TaskPlayAnim(PlayerPedId(), animDict, animOutroName, 8.0, -8.0, 2100, animFlag, 0.0, false, false, false)

					Citizen.Wait(1000)
					SetCurrentPedWeapon(PlayerPedId(), UnarmedHash, true)
				end
			end
		end

		lastWeapon = GetSelectedPedWeapon(PlayerPedId())
	end
end)
