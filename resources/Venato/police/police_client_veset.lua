local vestpolice = {
	opened = false,
	title = "Cop Locker",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 200, type = 1 }, -- ???
	menu = {
		x = 0.11,
		y = 0.25,
		width = 0.2,
		height = 0.04,
		buttons = 10,  --Nombre de bouton
		from = 1,
		to = 10,
		scale = 0.4,
		font = 0,
		["main"] = {
			title = "CATEGORIES",
			name = "main",
			buttons = {
				{name = "Take your service", description = ""},
				{name = "Break your service", description = ""},
				{name = "Bulletproof jacket", description = ""},
				{name = "Take offbulletproof jacket", description = ""},
				{name = "High-visibility clothing", description = ""},
				{name = "Take off High-visibility clothing", description = ""},
			}
		},
	}
}



local hashSkin = GetHashKey("mp_m_freemode_01")
function giveUniforme()
		TriggerServerEvent("police:setService",true)
		if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then

			SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2)	  --retrait cravate
			SetPedComponentVariation(GetPlayerPed(-1), 10, 0, 0, 2)	  --retrait grade
			SetPedPropIndex(GetPlayerPed(-1), 1, 5, 0, 2)             --Lunette Soleil
			SetPedPropIndex(GetPlayerPed(-1), 2, 0, 0, 2)             --Ecouteur Bluetooh
			SetPedComponentVariation(GetPlayerPed(-1), 11, 55, 0, 2)  --Chemise Police
			SetPedComponentVariation(GetPlayerPed(-1), 8, 58, 0, 2)   --Ceinture+matraque Police
			SetPedComponentVariation(GetPlayerPed(-1), 4, 35, 0, 2)   --Pantalon Police
			SetPedComponentVariation(GetPlayerPed(-1), 6, 24, 0, 2)   --Chaussure Police
			SetPedComponentVariation(GetPlayerPed(-1), 10, 8, 0, 2)   --grade 0
			SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)   -- under skin

		else

			SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2)	  --retrait cravate
			SetPedComponentVariation(GetPlayerPed(-1), 10, 0, 0, 2)	  --retrait grade
			SetPedPropIndex(GetPlayerPed(-1), 1, 11, 3, 2)           --Lunette Soleil
			SetPedPropIndex(GetPlayerPed(-1), 2, 0, 0, 2)            --Ecouteur Bluetooh
			SetPedComponentVariation(GetPlayerPed(-1), 3, 14, 0, 2)  --Tshirt non bug
			SetPedComponentVariation(GetPlayerPed(-1), 11, 48, 0, 2) --Chemise Police
			SetPedComponentVariation(GetPlayerPed(-1), 8, 35, 0, 2)  --Ceinture+matraque Police
			SetPedComponentVariation(GetPlayerPed(-1), 4, 34, 0, 2)  --Pantalon Police
			SetPedComponentVariation(GetPlayerPed(-1), 6, 24, 0, 2)  -- Chaussure Police
			SetPedComponentVariation(GetPlayerPed(-1), 10, 7, 0, 2)  --grade 0
			SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)   -- under skin

		end

		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PISTOL50"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PUMPSHOTGUN"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_FLARE"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_SMOKEGRENADE"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_FLASHLIGHT"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_BZGas"), 150, true, true)
		Citizen.Wait(500)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_NIGHTSTICK"), true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_STUNGUN"), true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("GADGET_PARACHUTE"), 150, true, true)

end

function removeUniforme()
		TriggerServerEvent("police:setService",false)
		ClearAllPedProps(GetPlayerPed(-1))
		SetPedComponentVariation(GetPlayerPed(-1), 10, 0, 0, 2) -- Grade
		SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 0, 2)
		SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0, 0)   -- Mask
		ClearPedProp(GetPlayerPed(-1),0)
		TriggerServerEvent("skin_customization:SpawnPlayer")
		SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 1, 2)
		RemoveAllPedWeapons(GetPlayerPed(-1))
		TriggerServerEvent('weaponshop:GiveWeaponsToPlayer')
end

function takeService()
    ServiceOn()
    giveUniforme()
    drawNotification("Vous etes en Service")
end


function takeServiceInvestigation()
	ServiceOn()
	TriggerServerEvent("skin_customization:SpawnPlayer")
	SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2)	  -- retrait cravate
	SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 0, 2)   -- retrait parballes du swat
	SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0, 0)   -- retrait Mask du swat
	SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 1, 2) -- retour skin joueurs
	SetPedComponentVariation(GetPlayerPed(-1), 10, 0, 0, 2) -- suppression grade

	TriggerServerEvent("police:setService",true)--add by fox
	GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PISTOL50"), 150, true, true)
	--GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PUMPSHOTGUN"), 150, true, true)
	--GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_FLARE"), 150, true, true)
	--GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_SMOKEGRENADE"), 150, true, true)
	GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_FLASHLIGHT"), 150, true, true)
	--GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_BZGas"), 150, true, true)
	Citizen.Wait(500)
	GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_NIGHTSTICK"), true, true)
	GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_STUNGUN"), true, true)
	GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("GADGET_PARACHUTE"), 150, true, true)
	TriggerEvent('player:receiveItem',210,1)
	drawNotification("Vous etes en Service")
end

function POLICE_GiveSpecialWeapon()

	GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_COMBATPDW"), 450, true, true)
	GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("GADGET_PARACHUTE"), 150, true, true)
	drawNotification("Yeah Baby !!!")
end

function takeServiceSwat()
	ServiceOn()
	local hashSkin = GetHashKey("mp_m_freemode_01")
	Citizen.CreateThread(function()
		TriggerServerEvent("police:setService",true)
		if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then

			SetPedComponentVariation(GetPlayerPed(-1), 7, 8, 0, 0)	  -- retrait cravate
			SetPedComponentVariation(GetPlayerPed(-1), 10, 0, 0, 0)	  -- retrait grade

			SetPedComponentVariation(GetPlayerPed(-1), 11, 149, 0, 0) -- Chemise Police
			SetPedComponentVariation(GetPlayerPed(-1), 8, 57, 0, 0)  -- Ceinture+matraque Police
			SetPedComponentVariation(GetPlayerPed(-1), 4, 35, 0, 0)  -- Pantalon Police
			SetPedComponentVariation(GetPlayerPed(-1), 6, 51, 0, 0)  -- Chaussure Police
			SetPedComponentVariation(GetPlayerPed(-1), 3, 30, 0, 0)   -- under skin
			SetPedComponentVariation(GetPlayerPed(-1), 9, 12, 3, 0)   -- parballe
			SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0, 0)   -- Mask
			SetPedPropIndex(GetPlayerPed(-1), 0, 81,1, true) -- casque
			SetPedPropIndex(GetPlayerPed(-1), 1, -1,-1, true) -- casque
			SetPedPropIndex(GetPlayerPed(-1), 2, -1,-1, true) -- casque
			SetPedPropIndex(GetPlayerPed(-1), 3, -1,-1, true) -- casque

			SetPedArmour(GetPlayerPed(-1), 100) -- Ajout armure

		else

			SetPedComponentVariation(GetPlayerPed(-1), 7, 81, 0, 0)	  -- retrait cravate
		  SetPedComponentVariation(GetPlayerPed(-1), 10, 11, 0, 0)	  -- retrait grade

		  SetPedComponentVariation(GetPlayerPed(-1), 11, 42, 0, 0) -- Chemise Police
		  SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 0)  -- Ceinture+matraque Police
		  SetPedComponentVariation(GetPlayerPed(-1), 4, 30, 0, 0)  -- Pantalon Police
		  SetPedComponentVariation(GetPlayerPed(-1), 6, 25, 0, 0)  -- Chaussure Police
		  SetPedComponentVariation(GetPlayerPed(-1), 3, 111, 0, 0)   -- under skin
		  SetPedComponentVariation(GetPlayerPed(-1), 9, 17, 0, 0)   -- parballe
		  SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0, 0)   -- Mask
		  SetPedPropIndex(GetPlayerPed(-1), 0, 74, 0, true) -- casque
		  SetPedPropIndex(GetPlayerPed(-1), 1, 25, 0, true) -- casque
		  SetPedPropIndex(GetPlayerPed(-1), 2, -1,-1, true) -- casque
		  SetPedPropIndex(GetPlayerPed(-1), 3, -1,-1, true) -- casque

			SetPedArmour(GetPlayerPed(-1), 100) -- Ajout armure

		end

	--[[]	GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PISTOL50"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PUMPSHOTGUN"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_BULLPUPRIFLE"), 450, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_FLARE"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_SMOKEGRENADE"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_FLASHLIGHT"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_BZGas"), 150, true, true)
		Citizen.Wait(500)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_NIGHTSTICK"), true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_STUNGUN"), true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("GADGET_PARACHUTE"), 150, true, true)--[]]
		TriggerEvent('player:receiveItem',210,1)
		TriggerEvent('player:receiveItem',211,1)
	end)
end


-- Cadet ici --
function takeServiceCadet()
	ServiceOn()
	local hashSkin = GetHashKey("mp_m_freemode_01")
		TriggerServerEvent("police:setService",true)
		if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then

			SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 0, 2)   -- retrait parballes du swat
			SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0, 0)   -- retrait Mask du swat
			SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2)	  --retrait cravate
			SetPedComponentVariation(GetPlayerPed(-1), 10, 0, 0, 2)	  --retrait grade

			SetPedPropIndex(GetPlayerPed(-1), 0, 46,0, 0) -- Casquette police
			SetPedComponentVariation(GetPlayerPed(-1), 3, 30, 0, 0)--gants/top
			SetPedComponentVariation(GetPlayerPed(-1), 4, 35, 0, 0)--/pentalon/pant
			SetPedComponentVariation(GetPlayerPed(-1), 6, 24, 0, 0)--chaussures/shoes
			SetPedComponentVariation(GetPlayerPed(-1), 8, 58, 0, 0)--mattraque (shirt)
			SetPedComponentVariation(GetPlayerPed(-1), 11, 55, 0, 0)--veste/jacket
			SetPedPropIndex(GetPlayerPed(-1), 2, 2, 0, 1)--Oreillete

		else

			SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 0, 2)   -- retrait parballes du swat
			SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0, 0)   -- retrait Mask du swat
			SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2)	  --retrait cravate
			SetPedComponentVariation(GetPlayerPed(-1), 10, 0, 0, 2)	  --retrait grade

			SetPedPropIndex(GetPlayerPed(-1), 0, 45,0, 0) -- Casquette police
			SetPedComponentVariation(GetPlayerPed(-1), 3, 44, 0, 2) --Gants
			SetPedComponentVariation(GetPlayerPed(-1), 4, 34, 0, 2) --Jean
			SetPedComponentVariation(GetPlayerPed(-1), 6, 24, 0, 2)--Chaussure
			SetPedComponentVariation(GetPlayerPed(-1), 8, 35, 0, 2)--mattraque (shirt)
			SetPedComponentVariation(GetPlayerPed(-1), 11, 48, 0, 2)--Veste
			SetPedPropIndex(GetPlayerPed(-1), 2, 0, 0, 2)--Oreillete

		end

		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PISTOL50"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_FLARE"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_FLASHLIGHT"), 150, true, true)
		Citizen.Wait(500)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_NIGHTSTICK"), true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_STUNGUN"), true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("GADGET_PARACHUTE"), 150, true, true)
		TriggerEvent('player:receiveItem',210,1)
		TriggerEvent('player:receiveItem',211,1)
		drawNotification("Vous êtes en Service")
end

-- Agent ici --

function takeServiceAgent()
	ServiceOn()
	local hashSkin = GetHashKey("mp_m_freemode_01")
		TriggerServerEvent("police:setService",true)
		if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then

			SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 0, 2)   -- retrait parballes du swat
			SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0, 0)   -- retrait Mask du swat
			SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2)	  --retrait cravate
			SetPedComponentVariation(GetPlayerPed(-1), 10, 0, 0, 2)	  --retrait grade

			SetPedComponentVariation(GetPlayerPed(-1), 3, 30, 0, 0)--Gants
			SetPedComponentVariation(GetPlayerPed(-1), 4, 35, 0, 0)--Jean
			SetPedComponentVariation(GetPlayerPed(-1), 6, 24, 0, 0)--Chaussure
			SetPedComponentVariation(GetPlayerPed(-1), 8, 58, 0, 0)--mattraque
			SetPedComponentVariation(GetPlayerPed(-1), 11, 55, 0, 0)--Veste
			SetPedPropIndex(GetPlayerPed(-1), 2, 2, 0, 1)--Oreillete
			SetPedPropIndex(GetPlayerPed(-1), 6, 3, 0, 1)--Montre
			SetPedPropIndex(GetPlayerPed(-1), 1, 7, 0, 1)--Lunette

		else

			SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 0, 2)   -- retrait parballes du swat
			SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0, 0)   -- retrait Mask du swat
			SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2)	  --retrait cravate
			SetPedComponentVariation(GetPlayerPed(-1), 10, 0, 0, 2)	  --retrait grade

			SetPedComponentVariation(GetPlayerPed(-1), 3, 44, 0, 2) --Gants
			SetPedComponentVariation(GetPlayerPed(-1), 4, 34, 0, 2) --Jean
			SetPedComponentVariation(GetPlayerPed(-1), 6, 24, 0, 2)--Chaussure
			SetPedComponentVariation(GetPlayerPed(-1), 8, 35, 0, 2)--mattraque (shirt)
			SetPedComponentVariation(GetPlayerPed(-1), 11, 48, 0, 2)--Veste
			SetPedPropIndex(GetPlayerPed(-1), 2, 0, 0, 2)--Oreillete
			SetPedPropIndex(GetPlayerPed(-1), 1, 11, 3, 2) -- lunette femme

		end

		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PISTOL50"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PUMPSHOTGUN"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_FLARE"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_FLASHLIGHT"), 150, true, true)
		Citizen.Wait(500)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_NIGHTSTICK"), true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_STUNGUN"), true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("GADGET_PARACHUTE"), 150, true, true)
		TriggerEvent('player:receiveItem',210,1)
		TriggerEvent('player:receiveItem',211,1)
end

-- Sergent ici --

function takeServiceSergent()
	ServiceOn()
	local hashSkin = GetHashKey("mp_m_freemode_01")
		TriggerServerEvent("police:setService",true)
		if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then

			SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 0, 2)   -- retrait parballes du swat
			SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0, 0)   -- retrait Mask du swat
			SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2)	  -- retrait cravate
			SetPedComponentVariation(GetPlayerPed(-1), 10, 0, 0, 2)	  -- retrait grade


			SetPedComponentVariation(GetPlayerPed(-1), 3, 30, 0, 0)--Gants
			SetPedComponentVariation(GetPlayerPed(-1), 4, 35, 0, 0)--Jean
			SetPedComponentVariation(GetPlayerPed(-1), 6, 24, 0, 0)--Chaussure
			SetPedComponentVariation(GetPlayerPed(-1), 8, 58, 0, 0)--mattraque
			SetPedComponentVariation(GetPlayerPed(-1), 11, 55, 0, 0)--Veste
			SetPedPropIndex(GetPlayerPed(-1), 2, 2, 0, 1)--Oreillete
			SetPedPropIndex(GetPlayerPed(-1), 6, 3, 0, 1)--Montre
			SetPedPropIndex(GetPlayerPed(-1), 1, 7, 0, 1)--Lunette
			SetPedComponentVariation(GetPlayerPed(-1), 10, 8, 1, 0)--Grade

		else

			SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 0, 2)   -- retrait parballes du swat
			SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0, 0)   -- retrait Mask du swat
			SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2)	  -- retrait cravate
			SetPedComponentVariation(GetPlayerPed(-1), 10, 0, 0, 2)	  -- retrait grade

			SetPedComponentVariation(GetPlayerPed(-1), 3, 44, 0, 2) -- Gants
			SetPedComponentVariation(GetPlayerPed(-1), 4, 34, 0, 2) -- Jean
			SetPedComponentVariation(GetPlayerPed(-1), 6, 24, 0, 2)-- Chaussure
			SetPedComponentVariation(GetPlayerPed(-1), 8, 35, 0, 2)-- mattraque (shirt)
			SetPedComponentVariation(GetPlayerPed(-1), 11, 48, 0, 2)-- Veste
			SetPedPropIndex(GetPlayerPed(-1), 2, 0, 0, 2)-- Oreillete
			SetPedPropIndex(GetPlayerPed(-1), 6, 3, 0, 1)-- Montre
			SetPedPropIndex(GetPlayerPed(-1), 1, 11, 3, 2) -- lunette femme
			SetPedComponentVariation(GetPlayerPed(-1), 10, 7, 1, 0)-- Grade

		end

		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PISTOL50"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PUMPSHOTGUN"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_FLARE"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_FLASHLIGHT"), 150, true, true)
		Citizen.Wait(500)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_NIGHTSTICK"), true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_STUNGUN"), true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("GADGET_PARACHUTE"), 150, true, true)
		TriggerEvent('player:receiveItem',210,1)
		TriggerEvent('player:receiveItem',211,1)
end

-- Sergent-chef ici --

function takeServiceSergentChef()
	ServiceOn()
	local hashSkin = GetHashKey("mp_m_freemode_01")
		TriggerServerEvent("police:setService",true)
		if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then

			SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 0, 2)   -- retrait parballes du swat
			SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0, 0)   -- retrait Mask du swat
			SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2)	  -- retrait cravate
			SetPedComponentVariation(GetPlayerPed(-1), 10, 0, 0, 2)	  -- retrait grade

			SetPedComponentVariation(GetPlayerPed(-1), 3, 30, 0, 0)--Gants
			SetPedComponentVariation(GetPlayerPed(-1), 4, 35, 0, 0)--Jean
			SetPedComponentVariation(GetPlayerPed(-1), 6, 24, 0, 0)--Chaussure
			SetPedComponentVariation(GetPlayerPed(-1), 8, 58, 0, 0)--mattraque
			SetPedComponentVariation(GetPlayerPed(-1), 11, 55, 0, 0)--Veste
			SetPedPropIndex(GetPlayerPed(-1), 2, 2, 0, 1)--Oreillete
			SetPedPropIndex(GetPlayerPed(-1), 6, 3, 0, 1)--Montre
			SetPedPropIndex(GetPlayerPed(-1), 1, 7, 0, 1)--Lunette
			SetPedComponentVariation(GetPlayerPed(-1), 10, 8, 2, 0)--Grade

		else

			SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 0, 2)   -- retrait parballes du swat
			SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0, 0)   -- retrait Mask du swat
			SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2)	  -- retrait cravate
			SetPedComponentVariation(GetPlayerPed(-1), 10, 0, 0, 2)	  -- retrait grade

			SetPedComponentVariation(GetPlayerPed(-1), 3, 44, 0, 2) -- Gants
			SetPedComponentVariation(GetPlayerPed(-1), 4, 34, 0, 2) -- Jean
			SetPedComponentVariation(GetPlayerPed(-1), 6, 24, 0, 2)-- Chaussure
			SetPedComponentVariation(GetPlayerPed(-1), 8, 35, 0, 2)-- mattraque (shirt)
			SetPedComponentVariation(GetPlayerPed(-1), 11, 48, 0, 2)-- Veste
			SetPedPropIndex(GetPlayerPed(-1), 2, 0, 0, 2)-- Oreillete
			SetPedPropIndex(GetPlayerPed(-1), 6, 3, 0, 1)-- Montre
			SetPedPropIndex(GetPlayerPed(-1), 1, 11, 3, 2) -- lunette femme
			SetPedComponentVariation(GetPlayerPed(-1), 10, 7, 2, 0)-- Grade

		end

		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PISTOL50"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PUMPSHOTGUN"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_BULLPUPRIFLE"), 450, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_FLARE"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_FLASHLIGHT"), 150, true, true)
		Citizen.Wait(500)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_NIGHTSTICK"), true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_STUNGUN"), true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("GADGET_PARACHUTE"), 150, true, true)
		TriggerEvent('player:receiveItem',210,1)
		TriggerEvent('player:receiveItem',211,1)
end

-- Lieutenant --

function takeServiceLieutenant()
	ServiceOn()
	local hashSkin = GetHashKey("mp_m_freemode_01")
		TriggerServerEvent("police:setService",true)
		if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then

			SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 0, 2)   -- retrait parballes du swat
			SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0, 0)   -- retrait Mask du swat
			SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2)	  -- retrait cravate
			SetPedComponentVariation(GetPlayerPed(-1), 10, 0, 0, 2)	  -- retrait grade

			SetPedComponentVariation(GetPlayerPed(-1), 3, 30, 0, 0)--Gants
			SetPedComponentVariation(GetPlayerPed(-1), 4, 35, 0, 0)--Jean
			SetPedComponentVariation(GetPlayerPed(-1), 6, 24, 0, 0)--Chaussure
			SetPedComponentVariation(GetPlayerPed(-1), 8, 58, 0, 0)--mattraque
			SetPedComponentVariation(GetPlayerPed(-1), 11, 55, 0, 0)--Veste
			SetPedPropIndex(GetPlayerPed(-1), 2, 2, 0, 1)--Oreillete
			SetPedPropIndex(GetPlayerPed(-1), 6, 3, 0, 1)--Montre
			SetPedPropIndex(GetPlayerPed(-1), 1, 5, 0, 1)--Lunette
			SetPedComponentVariation(GetPlayerPed(-1), 10, 8, 3, 0)--Grade

		else

			SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 0, 2)   -- retrait parballes du swat
			SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0, 0)   -- retrait Mask du swat
			SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2)	  -- retrait cravate
			SetPedComponentVariation(GetPlayerPed(-1), 10, 0, 0, 2)	  -- retrait grade

			SetPedComponentVariation(GetPlayerPed(-1), 3, 44, 0, 2) -- Gants
			SetPedComponentVariation(GetPlayerPed(-1), 4, 34, 0, 2) -- Jean
			SetPedComponentVariation(GetPlayerPed(-1), 6, 24, 0, 2)-- Chaussure
			SetPedComponentVariation(GetPlayerPed(-1), 8, 35, 0, 2)-- mattraque (shirt)
			SetPedComponentVariation(GetPlayerPed(-1), 11, 48, 0, 2)-- Veste
			SetPedPropIndex(GetPlayerPed(-1), 2, 0, 0, 2)-- Oreillete
			SetPedPropIndex(GetPlayerPed(-1), 6, 3, 0, 1)-- Montre
			SetPedPropIndex(GetPlayerPed(-1), 1, 11, 3, 2) -- lunette femme
			SetPedComponentVariation(GetPlayerPed(-1), 10, 7, 3, 0)-- Grade



		end

		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PISTOL50"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PUMPSHOTGUN"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_MarksmanRifle"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_BULLPUPRIFLE"), 450, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_FLARE"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_SMOKEGRENADE"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_FLASHLIGHT"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_BZGas"), 150, true, true)
		Citizen.Wait(500)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_NIGHTSTICK"), true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_STUNGUN"), true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("GADGET_PARACHUTE"), 150, true, true)
		TriggerEvent('player:receiveItem',210,1)
		TriggerEvent('player:receiveItem',211,1)
end

-- Capitaine --

function takeServiceCapitaine()
	ServiceOn()
	local hashSkin = GetHashKey("mp_m_freemode_01")
		TriggerServerEvent("police:setService",true)
		if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then

			SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 0, 2)   -- retrait parballes du swat
			SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0, 0)   -- retrait Mask du swat
			SetPedComponentVariation(GetPlayerPed(-1), 10, 0, 0, 2)	  -- retrait grade

			SetPedComponentVariation(GetPlayerPed(-1), 3, 11, 0, 0)--Gants(top/arm)
			SetPedComponentVariation(GetPlayerPed(-1), 4, 25, 0, 0)--Jean
			SetPedComponentVariation(GetPlayerPed(-1), 6, 11, 12, 0)--Chaussure
			SetPedComponentVariation(GetPlayerPed(-1), 8, 58, 0, 0)--mattraque
		local texture = math.random(0, 1) -- random pour cravate
			SetPedComponentVariation(GetPlayerPed(-1), 7, 115, texture, 1)--cravate
			SetPedComponentVariation(GetPlayerPed(-1), 11, 26, 0, 0)--Veste(jacket)
			SetPedPropIndex(GetPlayerPed(-1), 2, 2, 0, 1)--Oreillete
			SetPedPropIndex(GetPlayerPed(-1), 6, 3, 0, 1)--Montre

		else

			SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 0, 2)   -- retrait parballes du swat
			SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0, 0)   -- retrait Mask du swat
			SetPedComponentVariation(GetPlayerPed(-1), 10, 0, 0, 2)	  -- retrait grade

			SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 0)--Gants (tops)
			SetPedComponentVariation(GetPlayerPed(-1), 4, 34, 0, 0)--Jean
			SetPedComponentVariation(GetPlayerPed(-1), 6, 42, 2, 0)--Chaussure
			SetPedComponentVariation(GetPlayerPed(-1), 8, 35, 0, 2)-- mattraque (shirt)
		local texture2 = math.random(0, 5) -- random pour shirt
			SetPedComponentVariation(GetPlayerPed(-1), 11, 27, texture2, 0)--Veste
			SetPedPropIndex(GetPlayerPed(-1), 2, 2, 0, 1)--Oreillete
			SetPedPropIndex(GetPlayerPed(-1), 6, 3, 0, 1)--Montre

		end

		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PISTOL50"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PUMPSHOTGUN"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_MarksmanRifle"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_BULLPUPRIFLE"), 450, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_FLARE"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_SMOKEGRENADE"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_FLASHLIGHT"), 150, true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_BZGas"), 150, true, true)
		Citizen.Wait(500)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_NIGHTSTICK"), true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_STUNGUN"), true, true)
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("GADGET_PARACHUTE"), 150, true, true)
		TriggerEvent('player:receiveItem',210,1)
		TriggerEvent('player:receiveItem',211,1)
end

function finishService()
    ServiceOff()
		SetPedArmour(GetPlayerPed(-1), 0) -- Retrait armure
		SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 1)--cravate
    removeUniforme()
    drawNotification("Service Terminé")
		TriggerEvent('player:looseItem',210, 1)
		TriggerEvent('player:looseItem',211, 1)
end

RegisterNetEvent('police:finishService')
AddEventHandler('police:finishService', function()
		ServiceOff()
    removeUniforme()
end)


RegisterNetEvent('police:Procureur')
AddEventHandler('police:Procureur', function()
	EquipProcureur()
end)

RegisterNetEvent('police:ProcureurFinish')
AddEventHandler('police:ProcureurFinish', function()
	NoProcureur()
end)

function EquipProcureur()
	SetPedComponentVariation(GetPlayerPed(-1), 11, 32, 0, 2)  --Chemise Police
	SetPedComponentVariation(GetPlayerPed(-1), 8, 31, 0, 2)   --Ceinture+matraque Police
	SetPedComponentVariation(GetPlayerPed(-1), 4, 35, 0, 2)   --Pantalon Police
	SetPedComponentVariation(GetPlayerPed(-1), 6, 10, 0, 2)   --Chaussure Police
	--SetPedComponentVariation(GetPlayerPed(-1), 10, 8, 0, 2)   --grade 0
	SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)   -- under skin
	SetPedComponentVariation(GetPlayerPed(-1), 7, 29, 2, 1)
end

function NoProcureur()
	TriggerServerEvent("skin_customization:SpawnPlayer")
end

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function equipeVest(data)
    local type = data.type
    if type == "Bulletproof jacket" then
            if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then
                SetPedComponentVariation(GetPlayerPed(-1), 9, 4, 1, 2)  --Bulletproof jacket
				SetPedArmour(GetPlayerPed(-1), 100) -- Ajout armure

            else

			SetPedComponentVariation(GetPlayerPed(-1), 9, 6, 1, 2)
				SetPedArmour(GetPlayerPed(-1), 100) -- Ajout armure
            end
    elseif type == "Take offbulletproof jacket" then
            SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 1, 2)  --Remove Bulletproof jacket
			SetPedArmour(GetPlayerPed(-1), 0) -- Retrait armure
    elseif type == "High-visibility clothing" then
            if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then
                SetPedComponentVariation(GetPlayerPed(-1), 8, 59, 0, 2) --High-visibility clothing

            else

                SetPedComponentVariation(GetPlayerPed(-1), 8, 36, 0, 2)
            end

    elseif type == "Take off High-visibility clothing" then
            if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then
                SetPedComponentVariation(GetPlayerPed(-1), 8, 58, 0, 2) --Remove High-visibility clothing + Remet la ceinture

            else

                SetPedComponentVariation(GetPlayerPed(-1), 8, 35, 0, 2)
            end
    end
end
