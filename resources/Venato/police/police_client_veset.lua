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
		if(GetEntityModel(PlayerPedId()) == hashSkin) then

			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2)	  --retrait cravate
			SetPedComponentVariation(PlayerPedId(), 10, 0, 0, 2)	  --retrait grade
			SetPedPropIndex(PlayerPedId(), 1, 5, 0, 2)             --Lunette Soleil
			SetPedPropIndex(PlayerPedId(), 2, 0, 0, 2)             --Ecouteur Bluetooh
			SetPedComponentVariation(PlayerPedId(), 11, 55, 0, 2)  --Chemise Police
			SetPedComponentVariation(PlayerPedId(), 8, 58, 0, 2)   --Ceinture+matraque Police
			SetPedComponentVariation(PlayerPedId(), 4, 35, 0, 2)   --Pantalon Police
			SetPedComponentVariation(PlayerPedId(), 6, 24, 0, 2)   --Chaussure Police
			SetPedComponentVariation(PlayerPedId(), 10, 8, 0, 2)   --grade 0
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)   -- under skin

		else

			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2)	  --retrait cravate
			SetPedComponentVariation(PlayerPedId(), 10, 0, 0, 2)	  --retrait grade
			SetPedPropIndex(PlayerPedId(), 1, 11, 3, 2)           --Lunette Soleil
			SetPedPropIndex(PlayerPedId(), 2, 0, 0, 2)            --Ecouteur Bluetooh
			SetPedComponentVariation(PlayerPedId(), 3, 14, 0, 2)  --Tshirt non bug
			SetPedComponentVariation(PlayerPedId(), 11, 48, 0, 2) --Chemise Police
			SetPedComponentVariation(PlayerPedId(), 8, 35, 0, 2)  --Ceinture+matraque Police
			SetPedComponentVariation(PlayerPedId(), 4, 34, 0, 2)  --Pantalon Police
			SetPedComponentVariation(PlayerPedId(), 6, 24, 0, 2)  -- Chaussure Police
			SetPedComponentVariation(PlayerPedId(), 10, 7, 0, 2)  --grade 0
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)   -- under skin

		end

		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_PISTOL50"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_PUMPSHOTGUN"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FLARE"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_SMOKEGRENADE"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FLASHLIGHT"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_BZGas"), 150, true, true)
		Citizen.Wait(500)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_NIGHTSTICK"), true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_STUNGUN"), true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("GADGET_PARACHUTE"), 150, true, true)

end

function removeUniforme()
		TriggerServerEvent("police:setService",false)
		ClearAllPedProps(PlayerPedId())
		SetPedComponentVariation(PlayerPedId(), 10, 0, 0, 2) -- Grade
		SetPedComponentVariation(PlayerPedId(), 9, 0, 0, 2)
		SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 0)   -- Mask
		ClearPedProp(PlayerPedId(),0)
		TriggerServerEvent("skin_customization:SpawnPlayer")
		SetPedComponentVariation(PlayerPedId(), 9, 0, 1, 2)
		RemoveAllPedWeapons(PlayerPedId())
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
	SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2)	  -- retrait cravate
	SetPedComponentVariation(PlayerPedId(), 9, 0, 0, 2)   -- retrait parballes du swat
	SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 0)   -- retrait Mask du swat
	SetPedComponentVariation(PlayerPedId(), 9, 0, 1, 2) -- retour skin joueurs
	SetPedComponentVariation(PlayerPedId(), 10, 0, 0, 2) -- suppression grade

	TriggerServerEvent("police:setService",true)--add by fox
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_PISTOL50"), 150, true, true)
	--GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_PUMPSHOTGUN"), 150, true, true)
	--GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FLARE"), 150, true, true)
	--GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_SMOKEGRENADE"), 150, true, true)
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FLASHLIGHT"), 150, true, true)
	--GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_BZGas"), 150, true, true)
	Citizen.Wait(500)
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_NIGHTSTICK"), true, true)
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_STUNGUN"), true, true)
	GiveWeaponToPed(PlayerPedId(), GetHashKey("GADGET_PARACHUTE"), 150, true, true)
	TriggerEvent('player:receiveItem',210,1)
	drawNotification("Vous etes en Service")
end

function POLICE_GiveSpecialWeapon()

	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_COMBATPDW"), 450, true, true)
	GiveWeaponToPed(PlayerPedId(), GetHashKey("GADGET_PARACHUTE"), 150, true, true)
	drawNotification("Yeah Baby !!!")
end

function takeServiceSwat()
	ServiceOn()
	local hashSkin = GetHashKey("mp_m_freemode_01")
	Citizen.CreateThread(function()
		TriggerServerEvent("police:setService",true)
		if(GetEntityModel(PlayerPedId()) == hashSkin) then

			SetPedComponentVariation(PlayerPedId(), 7, 8, 0, 0)	  -- retrait cravate
			SetPedComponentVariation(PlayerPedId(), 10, 0, 0, 0)	  -- retrait grade

			SetPedComponentVariation(PlayerPedId(), 11, 149, 0, 0) -- Chemise Police
			SetPedComponentVariation(PlayerPedId(), 8, 57, 0, 0)  -- Ceinture+matraque Police
			SetPedComponentVariation(PlayerPedId(), 4, 35, 0, 0)  -- Pantalon Police
			SetPedComponentVariation(PlayerPedId(), 6, 51, 0, 0)  -- Chaussure Police
			SetPedComponentVariation(PlayerPedId(), 3, 30, 0, 0)   -- under skin
			SetPedComponentVariation(PlayerPedId(), 9, 12, 3, 0)   -- parballe
			SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 0)   -- Mask
			SetPedPropIndex(PlayerPedId(), 0, 81,1, true) -- casque
			SetPedPropIndex(PlayerPedId(), 1, -1,-1, true) -- casque
			SetPedPropIndex(PlayerPedId(), 2, -1,-1, true) -- casque
			SetPedPropIndex(PlayerPedId(), 3, -1,-1, true) -- casque

			SetPedArmour(PlayerPedId(), 100) -- Ajout armure

		else

			SetPedComponentVariation(PlayerPedId(), 7, 81, 0, 0)	  -- retrait cravate
		  SetPedComponentVariation(PlayerPedId(), 10, 11, 0, 0)	  -- retrait grade

		  SetPedComponentVariation(PlayerPedId(), 11, 42, 0, 0) -- Chemise Police
		  SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 0)  -- Ceinture+matraque Police
		  SetPedComponentVariation(PlayerPedId(), 4, 30, 0, 0)  -- Pantalon Police
		  SetPedComponentVariation(PlayerPedId(), 6, 25, 0, 0)  -- Chaussure Police
		  SetPedComponentVariation(PlayerPedId(), 3, 111, 0, 0)   -- under skin
		  SetPedComponentVariation(PlayerPedId(), 9, 17, 0, 0)   -- parballe
		  SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 0)   -- Mask
		  SetPedPropIndex(PlayerPedId(), 0, 74, 0, true) -- casque
		  SetPedPropIndex(PlayerPedId(), 1, 25, 0, true) -- casque
		  SetPedPropIndex(PlayerPedId(), 2, -1,-1, true) -- casque
		  SetPedPropIndex(PlayerPedId(), 3, -1,-1, true) -- casque

			SetPedArmour(PlayerPedId(), 100) -- Ajout armure

		end

	--[[]	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_PISTOL50"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_PUMPSHOTGUN"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_BULLPUPRIFLE"), 450, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FLARE"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_SMOKEGRENADE"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FLASHLIGHT"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_BZGas"), 150, true, true)
		Citizen.Wait(500)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_NIGHTSTICK"), true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_STUNGUN"), true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("GADGET_PARACHUTE"), 150, true, true)--[]]
		TriggerEvent('player:receiveItem',210,1)
		TriggerEvent('player:receiveItem',211,1)
	end)
end


-- Cadet ici --
function takeServiceCadet()
	ServiceOn()
	local hashSkin = GetHashKey("mp_m_freemode_01")
		TriggerServerEvent("police:setService",true)
		if(GetEntityModel(PlayerPedId()) == hashSkin) then

			SetPedComponentVariation(PlayerPedId(), 9, 0, 0, 2)   -- retrait parballes du swat
			SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 0)   -- retrait Mask du swat
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2)	  --retrait cravate
			SetPedComponentVariation(PlayerPedId(), 10, 0, 0, 2)	  --retrait grade

			SetPedPropIndex(PlayerPedId(), 0, 46,0, 0) -- Casquette police
			SetPedComponentVariation(PlayerPedId(), 3, 30, 0, 0)--gants/top
			SetPedComponentVariation(PlayerPedId(), 4, 35, 0, 0)--/pentalon/pant
			SetPedComponentVariation(PlayerPedId(), 6, 24, 0, 0)--chaussures/shoes
			SetPedComponentVariation(PlayerPedId(), 8, 58, 0, 0)--mattraque (shirt)
			SetPedComponentVariation(PlayerPedId(), 11, 55, 0, 0)--veste/jacket
			SetPedPropIndex(PlayerPedId(), 2, 2, 0, 1)--Oreillete

		else

			SetPedComponentVariation(PlayerPedId(), 9, 0, 0, 2)   -- retrait parballes du swat
			SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 0)   -- retrait Mask du swat
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2)	  --retrait cravate
			SetPedComponentVariation(PlayerPedId(), 10, 0, 0, 2)	  --retrait grade

			SetPedPropIndex(PlayerPedId(), 0, 45,0, 0) -- Casquette police
			SetPedComponentVariation(PlayerPedId(), 3, 44, 0, 2) --Gants
			SetPedComponentVariation(PlayerPedId(), 4, 34, 0, 2) --Jean
			SetPedComponentVariation(PlayerPedId(), 6, 24, 0, 2)--Chaussure
			SetPedComponentVariation(PlayerPedId(), 8, 35, 0, 2)--mattraque (shirt)
			SetPedComponentVariation(PlayerPedId(), 11, 48, 0, 2)--Veste
			SetPedPropIndex(PlayerPedId(), 2, 0, 0, 2)--Oreillete

		end

		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_PISTOL50"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FLARE"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FLASHLIGHT"), 150, true, true)
		Citizen.Wait(500)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_NIGHTSTICK"), true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_STUNGUN"), true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("GADGET_PARACHUTE"), 150, true, true)
		TriggerEvent('player:receiveItem',210,1)
		TriggerEvent('player:receiveItem',211,1)
		drawNotification("Vous êtes en Service")
end

-- Agent ici --

function takeServiceAgent()
	ServiceOn()
	local hashSkin = GetHashKey("mp_m_freemode_01")
		TriggerServerEvent("police:setService",true)
		if(GetEntityModel(PlayerPedId()) == hashSkin) then

			SetPedComponentVariation(PlayerPedId(), 9, 0, 0, 2)   -- retrait parballes du swat
			SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 0)   -- retrait Mask du swat
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2)	  --retrait cravate
			SetPedComponentVariation(PlayerPedId(), 10, 0, 0, 2)	  --retrait grade

			SetPedComponentVariation(PlayerPedId(), 3, 30, 0, 0)--Gants
			SetPedComponentVariation(PlayerPedId(), 4, 35, 0, 0)--Jean
			SetPedComponentVariation(PlayerPedId(), 6, 24, 0, 0)--Chaussure
			SetPedComponentVariation(PlayerPedId(), 8, 58, 0, 0)--mattraque
			SetPedComponentVariation(PlayerPedId(), 11, 55, 0, 0)--Veste
			SetPedPropIndex(PlayerPedId(), 2, 2, 0, 1)--Oreillete
			SetPedPropIndex(PlayerPedId(), 6, 3, 0, 1)--Montre
			SetPedPropIndex(PlayerPedId(), 1, 7, 0, 1)--Lunette

		else

			SetPedComponentVariation(PlayerPedId(), 9, 0, 0, 2)   -- retrait parballes du swat
			SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 0)   -- retrait Mask du swat
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2)	  --retrait cravate
			SetPedComponentVariation(PlayerPedId(), 10, 0, 0, 2)	  --retrait grade

			SetPedComponentVariation(PlayerPedId(), 3, 44, 0, 2) --Gants
			SetPedComponentVariation(PlayerPedId(), 4, 34, 0, 2) --Jean
			SetPedComponentVariation(PlayerPedId(), 6, 24, 0, 2)--Chaussure
			SetPedComponentVariation(PlayerPedId(), 8, 35, 0, 2)--mattraque (shirt)
			SetPedComponentVariation(PlayerPedId(), 11, 48, 0, 2)--Veste
			SetPedPropIndex(PlayerPedId(), 2, 0, 0, 2)--Oreillete
			SetPedPropIndex(PlayerPedId(), 1, 11, 3, 2) -- lunette femme

		end

		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_PISTOL50"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_PUMPSHOTGUN"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FLARE"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FLASHLIGHT"), 150, true, true)
		Citizen.Wait(500)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_NIGHTSTICK"), true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_STUNGUN"), true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("GADGET_PARACHUTE"), 150, true, true)
		TriggerEvent('player:receiveItem',210,1)
		TriggerEvent('player:receiveItem',211,1)
end

-- Sergent ici --

function takeServiceSergent()
	ServiceOn()
	local hashSkin = GetHashKey("mp_m_freemode_01")
		TriggerServerEvent("police:setService",true)
		if(GetEntityModel(PlayerPedId()) == hashSkin) then

			SetPedComponentVariation(PlayerPedId(), 9, 0, 0, 2)   -- retrait parballes du swat
			SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 0)   -- retrait Mask du swat
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2)	  -- retrait cravate
			SetPedComponentVariation(PlayerPedId(), 10, 0, 0, 2)	  -- retrait grade


			SetPedComponentVariation(PlayerPedId(), 3, 30, 0, 0)--Gants
			SetPedComponentVariation(PlayerPedId(), 4, 35, 0, 0)--Jean
			SetPedComponentVariation(PlayerPedId(), 6, 24, 0, 0)--Chaussure
			SetPedComponentVariation(PlayerPedId(), 8, 58, 0, 0)--mattraque
			SetPedComponentVariation(PlayerPedId(), 11, 55, 0, 0)--Veste
			SetPedPropIndex(PlayerPedId(), 2, 2, 0, 1)--Oreillete
			SetPedPropIndex(PlayerPedId(), 6, 3, 0, 1)--Montre
			SetPedPropIndex(PlayerPedId(), 1, 7, 0, 1)--Lunette
			SetPedComponentVariation(PlayerPedId(), 10, 8, 1, 0)--Grade

		else

			SetPedComponentVariation(PlayerPedId(), 9, 0, 0, 2)   -- retrait parballes du swat
			SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 0)   -- retrait Mask du swat
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2)	  -- retrait cravate
			SetPedComponentVariation(PlayerPedId(), 10, 0, 0, 2)	  -- retrait grade

			SetPedComponentVariation(PlayerPedId(), 3, 44, 0, 2) -- Gants
			SetPedComponentVariation(PlayerPedId(), 4, 34, 0, 2) -- Jean
			SetPedComponentVariation(PlayerPedId(), 6, 24, 0, 2)-- Chaussure
			SetPedComponentVariation(PlayerPedId(), 8, 35, 0, 2)-- mattraque (shirt)
			SetPedComponentVariation(PlayerPedId(), 11, 48, 0, 2)-- Veste
			SetPedPropIndex(PlayerPedId(), 2, 0, 0, 2)-- Oreillete
			SetPedPropIndex(PlayerPedId(), 6, 3, 0, 1)-- Montre
			SetPedPropIndex(PlayerPedId(), 1, 11, 3, 2) -- lunette femme
			SetPedComponentVariation(PlayerPedId(), 10, 7, 1, 0)-- Grade

		end

		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_PISTOL50"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_PUMPSHOTGUN"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FLARE"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FLASHLIGHT"), 150, true, true)
		Citizen.Wait(500)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_NIGHTSTICK"), true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_STUNGUN"), true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("GADGET_PARACHUTE"), 150, true, true)
		TriggerEvent('player:receiveItem',210,1)
		TriggerEvent('player:receiveItem',211,1)
end

-- Sergent-chef ici --

function takeServiceSergentChef()
	ServiceOn()
	local hashSkin = GetHashKey("mp_m_freemode_01")
		TriggerServerEvent("police:setService",true)
		if(GetEntityModel(PlayerPedId()) == hashSkin) then

			SetPedComponentVariation(PlayerPedId(), 9, 0, 0, 2)   -- retrait parballes du swat
			SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 0)   -- retrait Mask du swat
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2)	  -- retrait cravate
			SetPedComponentVariation(PlayerPedId(), 10, 0, 0, 2)	  -- retrait grade

			SetPedComponentVariation(PlayerPedId(), 3, 30, 0, 0)--Gants
			SetPedComponentVariation(PlayerPedId(), 4, 35, 0, 0)--Jean
			SetPedComponentVariation(PlayerPedId(), 6, 24, 0, 0)--Chaussure
			SetPedComponentVariation(PlayerPedId(), 8, 58, 0, 0)--mattraque
			SetPedComponentVariation(PlayerPedId(), 11, 55, 0, 0)--Veste
			SetPedPropIndex(PlayerPedId(), 2, 2, 0, 1)--Oreillete
			SetPedPropIndex(PlayerPedId(), 6, 3, 0, 1)--Montre
			SetPedPropIndex(PlayerPedId(), 1, 7, 0, 1)--Lunette
			SetPedComponentVariation(PlayerPedId(), 10, 8, 2, 0)--Grade

		else

			SetPedComponentVariation(PlayerPedId(), 9, 0, 0, 2)   -- retrait parballes du swat
			SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 0)   -- retrait Mask du swat
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2)	  -- retrait cravate
			SetPedComponentVariation(PlayerPedId(), 10, 0, 0, 2)	  -- retrait grade

			SetPedComponentVariation(PlayerPedId(), 3, 44, 0, 2) -- Gants
			SetPedComponentVariation(PlayerPedId(), 4, 34, 0, 2) -- Jean
			SetPedComponentVariation(PlayerPedId(), 6, 24, 0, 2)-- Chaussure
			SetPedComponentVariation(PlayerPedId(), 8, 35, 0, 2)-- mattraque (shirt)
			SetPedComponentVariation(PlayerPedId(), 11, 48, 0, 2)-- Veste
			SetPedPropIndex(PlayerPedId(), 2, 0, 0, 2)-- Oreillete
			SetPedPropIndex(PlayerPedId(), 6, 3, 0, 1)-- Montre
			SetPedPropIndex(PlayerPedId(), 1, 11, 3, 2) -- lunette femme
			SetPedComponentVariation(PlayerPedId(), 10, 7, 2, 0)-- Grade

		end

		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_PISTOL50"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_PUMPSHOTGUN"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_BULLPUPRIFLE"), 450, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FLARE"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FLASHLIGHT"), 150, true, true)
		Citizen.Wait(500)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_NIGHTSTICK"), true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_STUNGUN"), true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("GADGET_PARACHUTE"), 150, true, true)
		TriggerEvent('player:receiveItem',210,1)
		TriggerEvent('player:receiveItem',211,1)
end

-- Lieutenant --

function takeServiceLieutenant()
	ServiceOn()
	local hashSkin = GetHashKey("mp_m_freemode_01")
		TriggerServerEvent("police:setService",true)
		if(GetEntityModel(PlayerPedId()) == hashSkin) then

			SetPedComponentVariation(PlayerPedId(), 9, 0, 0, 2)   -- retrait parballes du swat
			SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 0)   -- retrait Mask du swat
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2)	  -- retrait cravate
			SetPedComponentVariation(PlayerPedId(), 10, 0, 0, 2)	  -- retrait grade

			SetPedComponentVariation(PlayerPedId(), 3, 30, 0, 0)--Gants
			SetPedComponentVariation(PlayerPedId(), 4, 35, 0, 0)--Jean
			SetPedComponentVariation(PlayerPedId(), 6, 24, 0, 0)--Chaussure
			SetPedComponentVariation(PlayerPedId(), 8, 58, 0, 0)--mattraque
			SetPedComponentVariation(PlayerPedId(), 11, 55, 0, 0)--Veste
			SetPedPropIndex(PlayerPedId(), 2, 2, 0, 1)--Oreillete
			SetPedPropIndex(PlayerPedId(), 6, 3, 0, 1)--Montre
			SetPedPropIndex(PlayerPedId(), 1, 5, 0, 1)--Lunette
			SetPedComponentVariation(PlayerPedId(), 10, 8, 3, 0)--Grade

		else

			SetPedComponentVariation(PlayerPedId(), 9, 0, 0, 2)   -- retrait parballes du swat
			SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 0)   -- retrait Mask du swat
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2)	  -- retrait cravate
			SetPedComponentVariation(PlayerPedId(), 10, 0, 0, 2)	  -- retrait grade

			SetPedComponentVariation(PlayerPedId(), 3, 44, 0, 2) -- Gants
			SetPedComponentVariation(PlayerPedId(), 4, 34, 0, 2) -- Jean
			SetPedComponentVariation(PlayerPedId(), 6, 24, 0, 2)-- Chaussure
			SetPedComponentVariation(PlayerPedId(), 8, 35, 0, 2)-- mattraque (shirt)
			SetPedComponentVariation(PlayerPedId(), 11, 48, 0, 2)-- Veste
			SetPedPropIndex(PlayerPedId(), 2, 0, 0, 2)-- Oreillete
			SetPedPropIndex(PlayerPedId(), 6, 3, 0, 1)-- Montre
			SetPedPropIndex(PlayerPedId(), 1, 11, 3, 2) -- lunette femme
			SetPedComponentVariation(PlayerPedId(), 10, 7, 3, 0)-- Grade



		end

		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_PISTOL50"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_PUMPSHOTGUN"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_MarksmanRifle"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_BULLPUPRIFLE"), 450, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FLARE"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_SMOKEGRENADE"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FLASHLIGHT"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_BZGas"), 150, true, true)
		Citizen.Wait(500)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_NIGHTSTICK"), true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_STUNGUN"), true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("GADGET_PARACHUTE"), 150, true, true)
		TriggerEvent('player:receiveItem',210,1)
		TriggerEvent('player:receiveItem',211,1)
end

-- Capitaine --

function takeServiceCapitaine()
	ServiceOn()
	local hashSkin = GetHashKey("mp_m_freemode_01")
		TriggerServerEvent("police:setService",true)
		if(GetEntityModel(PlayerPedId()) == hashSkin) then

			SetPedComponentVariation(PlayerPedId(), 9, 0, 0, 2)   -- retrait parballes du swat
			SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 0)   -- retrait Mask du swat
			SetPedComponentVariation(PlayerPedId(), 10, 0, 0, 2)	  -- retrait grade

			SetPedComponentVariation(PlayerPedId(), 3, 11, 0, 0)--Gants(top/arm)
			SetPedComponentVariation(PlayerPedId(), 4, 25, 0, 0)--Jean
			SetPedComponentVariation(PlayerPedId(), 6, 11, 12, 0)--Chaussure
			SetPedComponentVariation(PlayerPedId(), 8, 58, 0, 0)--mattraque
		local texture = math.random(0, 1) -- random pour cravate
			SetPedComponentVariation(PlayerPedId(), 7, 115, texture, 1)--cravate
			SetPedComponentVariation(PlayerPedId(), 11, 26, 0, 0)--Veste(jacket)
			SetPedPropIndex(PlayerPedId(), 2, 2, 0, 1)--Oreillete
			SetPedPropIndex(PlayerPedId(), 6, 3, 0, 1)--Montre

		else

			SetPedComponentVariation(PlayerPedId(), 9, 0, 0, 2)   -- retrait parballes du swat
			SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 0)   -- retrait Mask du swat
			SetPedComponentVariation(PlayerPedId(), 10, 0, 0, 2)	  -- retrait grade

			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 0)--Gants (tops)
			SetPedComponentVariation(PlayerPedId(), 4, 34, 0, 0)--Jean
			SetPedComponentVariation(PlayerPedId(), 6, 42, 2, 0)--Chaussure
			SetPedComponentVariation(PlayerPedId(), 8, 35, 0, 2)-- mattraque (shirt)
		local texture2 = math.random(0, 5) -- random pour shirt
			SetPedComponentVariation(PlayerPedId(), 11, 27, texture2, 0)--Veste
			SetPedPropIndex(PlayerPedId(), 2, 2, 0, 1)--Oreillete
			SetPedPropIndex(PlayerPedId(), 6, 3, 0, 1)--Montre

		end

		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_PISTOL50"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_PUMPSHOTGUN"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_MarksmanRifle"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_BULLPUPRIFLE"), 450, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FLARE"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_SMOKEGRENADE"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FLASHLIGHT"), 150, true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_BZGas"), 150, true, true)
		Citizen.Wait(500)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_NIGHTSTICK"), true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_STUNGUN"), true, true)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("GADGET_PARACHUTE"), 150, true, true)
		TriggerEvent('player:receiveItem',210,1)
		TriggerEvent('player:receiveItem',211,1)
end

function finishService()
    ServiceOff()
		SetPedArmour(PlayerPedId(), 0) -- Retrait armure
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 1)--cravate
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
	SetPedComponentVariation(PlayerPedId(), 11, 32, 0, 2)  --Chemise Police
	SetPedComponentVariation(PlayerPedId(), 8, 31, 0, 2)   --Ceinture+matraque Police
	SetPedComponentVariation(PlayerPedId(), 4, 35, 0, 2)   --Pantalon Police
	SetPedComponentVariation(PlayerPedId(), 6, 10, 0, 2)   --Chaussure Police
	--SetPedComponentVariation(PlayerPedId(), 10, 8, 0, 2)   --grade 0
	SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)   -- under skin
	SetPedComponentVariation(PlayerPedId(), 7, 29, 2, 1)
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
            if(GetEntityModel(PlayerPedId()) == hashSkin) then
                SetPedComponentVariation(PlayerPedId(), 9, 4, 1, 2)  --Bulletproof jacket
				SetPedArmour(PlayerPedId(), 100) -- Ajout armure

            else

			SetPedComponentVariation(PlayerPedId(), 9, 6, 1, 2)
				SetPedArmour(PlayerPedId(), 100) -- Ajout armure
            end
    elseif type == "Take offbulletproof jacket" then
            SetPedComponentVariation(PlayerPedId(), 9, 0, 1, 2)  --Remove Bulletproof jacket
			SetPedArmour(PlayerPedId(), 0) -- Retrait armure
    elseif type == "High-visibility clothing" then
            if(GetEntityModel(PlayerPedId()) == hashSkin) then
                SetPedComponentVariation(PlayerPedId(), 8, 59, 0, 2) --High-visibility clothing

            else

                SetPedComponentVariation(PlayerPedId(), 8, 36, 0, 2)
            end

    elseif type == "Take off High-visibility clothing" then
            if(GetEntityModel(PlayerPedId()) == hashSkin) then
                SetPedComponentVariation(PlayerPedId(), 8, 58, 0, 2) --Remove High-visibility clothing + Remet la ceinture

            else

                SetPedComponentVariation(PlayerPedId(), 8, 35, 0, 2)
            end
    end
end
