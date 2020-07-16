essence = 0.142
local stade = 0
local lastModel = 0

local vehiclesUsed = {}
local currentCans = 0

local done = true
local addFuelValue = 1


Citizen.CreateThread(function()
	TriggerServerEvent("essence:addPlayer")
	while true do
		Citizen.Wait(0)
		CheckVeh()

		if(currentCans > 0) then
			local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
			local veh = GetClosestVehicle(x, y, z, 4.001, 0, 70)

			if(veh ~= nil and GetVehicleNumberPlateText(veh) ~= nil) then
				local nul, number = GetCurrentPedWeapon(PlayerPedId())
				if(number == 883325847) then
					Info(settings[lang].refeel)
					if(IsControlJustPressed(1, 38)) then

						RequestAnimDict("weapon@w_sp_jerrycan")
						while not HasAnimDictLoaded("weapon@w_sp_jerrycan") do
							Citizen.Wait(100)
						end

						TaskPlayAnim(PlayerPedId(),"weapon@w_sp_jerrycan","fire", 8.0, -8, -1, 49, 0, 0, 0, 0)
						local done = false
						local amountToEssence = 50;
						while done == false do
							Wait(0)
							local _essence = GetVehicleFuelLevel(veh)
							if(amountToEssence-addFuelValue > 0) then
								amountToEssence = amountToEssence-addFuelValue
								if(GetVehicleFuelLevel(veh) >= 100) then
									done = true
								end
								SetVehicleUndriveable(veh, true)
								SetVehicleEngineOn(veh, false, false, false)
								SetVehicleFuelLevel(veh,GetVehicleFuelLevel(veh) + addFuelValue)
								Wait(100)
							else
								done = true
							end
						end
						TaskPlayAnim(PlayerPedId(),"weapon@w_sp_jerrycan","fire_outro", 8.0, -8, -1, 49, 0, 0, 0, 0)
						Wait(500)
						ClearPedTasks(PlayerPedId())
						currentCans = currentCans-1

						if(currentCans == 0) then
							RemoveWeaponFromPed(PlayerPedId(),  0x34A67B97)
						end
						SetVehicleEngineOn(veh, true, false, false)
						SetVehicleUndriveable(veh, false)
					end
				end
			end
		end

	end

end)


Citizen.CreateThread(function()

	local menu = false
	local bool = false
	local int = 0
	local position = 1
	local array = {"TEST", "TEST2", "TEST3", "TEST4"}

	while true do
		Citizen.Wait(0)

		local isNearFuelStation, stationNumber = isNearStation()
		local isNearElectricStation, stationElectric = isNearElectricStation()
		local isNearFuelPStation, stationPlaneNumber = isNearPlaneStation()
		local isNearFuelHStation, stationHeliNumber = isNearHeliStation()
		local isNearFuelBStation, stationBoatNumber = isNearBoatStation()

		------------------------------- VEHICLE FUEL PART -------------------------------

		if(done and isNearFuelStation and IsPedInAnyVehicle(PlayerPedId(), -1) and not IsPedInAnyHeli(PlayerPedId()) and not isBlackListedModel() and not isElectricModel() and GetPedVehicleSeat(PlayerPedId()) == -1) then
			Info(settings[lang].openMenu)

			if(IsControlJustPressed(1, 38)) then
				
				local veh = GetVehiclePedIsIn(venato.GetPlayerPed(), 0)
				local station = stationsText[stationNumber]
				local streetA, streetB = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, station.x, station.y, station.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
				local streetName = GetStreetNameFromHashKey(streetA)
				local stationPrice = StationsPrice[stationNumber]
				local essenceNeed = round(100 - GetVehicleFuelLevel(veh),0)

				if(menu) then
					TriggerEvent('Menu:Close')
				else
					int = 0

					TriggerEvent('Menu:Clear')
					TriggerEvent('Menu:Init', streetName, "Prix du carburant : ".. stationPrice .. "€/L", '#8E24AA99', "https://cdn-media.rtl.fr/cache/PBnHCxNdlifvlWMW_w38Vw/880v587-0/online/image/2018/1003/7795039479_un-automobiliste-fait-le-plein-a-une-station-essence-illustration.jpg")
					TriggerEvent('Menu:AddButton', "<span class='red--text'>Retour</span>", "HideMenu", data)
					TriggerEvent('Menu:AddButton', "Faire le plein : ".. essenceNeed .. "L -> ".. (essenceNeed*stationPrice) .. "€", "Refuel", { stationNumber = stationNumber, liter = essenceNeed })
					if(essenceNeed > 5) then
						TriggerEvent('Menu:AddButton', "5 L -> ".. round(5*stationPrice,2) .. "€", "Refuel", { stationNumber = stationNumber, liter = 5 })
					end
					if(essenceNeed > 10) then
						TriggerEvent('Menu:AddButton', "10 L -> ".. round(10*stationPrice,2) .. "€", "Refuel", { stationNumber = stationNumber, liter = 10 })
					end
					if(essenceNeed > 25) then
						TriggerEvent('Menu:AddButton', "25 L -> ".. round(25*stationPrice,2) .. "€", "Refuel", { stationNumber = stationNumber, liter = 25 })
					end
					if(essenceNeed > 50) then
						TriggerEvent('Menu:AddButton', "50 L -> ".. round(50*stationPrice,2) .. "€", "Refuel", { stationNumber = stationNumber, liter = 50 })
					end
					if(essenceNeed > 75) then
						TriggerEvent('Menu:AddButton', "75 L -> ".. round(75*stationPrice,2) .. "€", "Refuel", { stationNumber = stationNumber, liter = 75 })
					end
					TriggerEvent('Menu:AddButton', "<span class='red--text'>Retour</span>", "HideMenu", data)

					TriggerEvent('Menu:Open')
				end
				menu = not menu
			end
		else
			if(isNearFuelStation and IsPedInAnyVehicle(PlayerPedId(), -1) and not IsPedInAnyHeli(PlayerPedId()) and not isBlackListedModel() and isElectricModel()) then
				Info(settings[lang].electricError)
			end
		end


		------------------------------- ELECTRIC VEHICLE PART -------------------------------

		if(done and isNearElectricStation and IsPedInAnyVehicle(PlayerPedId(), -1) and not IsPedInAnyHeli(PlayerPedId()) and not isBlackListedModel() and isElectricModel() and GetPedVehicleSeat(PlayerPedId()) == -1) then
			Info(settings[lang].openMenu)

			if(IsControlJustPressed(1, 38)) then		
				local veh = GetVehiclePedIsIn(venato.GetPlayerPed(), 0)
				local station = stationElectric
				local streetA, streetB = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, station.x, station.y, station.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
				local streetName = GetStreetNameFromHashKey(streetA)
				local stationPrice = 2
				local essenceNeed = round(100 - GetVehicleFuelLevel(veh),0)

				if(menu) then
					TriggerEvent('Menu:Close')
				else
					int = 0

					TriggerEvent('Menu:Clear')
					TriggerEvent('Menu:Init', streetName, "Prix du carburant : ".. stationPrice .. "€/L", '#8E24AA99', "https://cdn-media.rtl.fr/cache/PBnHCxNdlifvlWMW_w38Vw/880v587-0/online/image/2018/1003/7795039479_un-automobiliste-fait-le-plein-a-une-station-essence-illustration.jpg")
					TriggerEvent('Menu:AddButton', "<span class='red--text'>Retour</span>", "HideMenu", data)
					TriggerEvent('Menu:AddButton', "Faire le plein : ".. essenceNeed .. "L -> ".. (essenceNeed*stationPrice) .. "€", "Refuel", { stationNumber = -1, liter = essenceNeed })
					if(essenceNeed > 5) then
						TriggerEvent('Menu:AddButton', "5 L -> ".. round(5*stationPrice,2) .. "€", "Refuel", { stationNumber = -1, liter = 5 })
					end
					if(essenceNeed > 10) then
						TriggerEvent('Menu:AddButton', "10 L -> ".. round(10*stationPrice,2) .. "€", "Refuel", { stationNumber = -1, liter = 10 })
					end
					if(essenceNeed > 25) then
						TriggerEvent('Menu:AddButton', "25 L -> ".. round(25*stationPrice,2) .. "€", "Refuel", { stationNumber = -1, liter = 25 })
					end
					if(essenceNeed > 50) then
						TriggerEvent('Menu:AddButton', "50 L -> ".. round(50*stationPrice,2) .. "€", "Refuel", { stationNumber = -1, liter = 50 })
					end
					if(essenceNeed > 75) then
						TriggerEvent('Menu:AddButton', "75 L -> ".. round(75*stationPrice,2) .. "€", "Refuel", { stationNumber = -1, liter = 75 })
					end
					TriggerEvent('Menu:AddButton', "<span class='red--text'>Retour</span>", "HideMenu", data)

					TriggerEvent('Menu:Open')
				end
				menu = not menu
			end
		else
			if(isNearElectricStation  and IsPedInAnyVehicle(PlayerPedId(), -1) and not IsPedInAnyHeli(PlayerPedId()) and not isBlackListedModel() and not isElectricModel()) then
				Info(settings[lang].fuelError)
			end
		end

		------------------------------- BOAT PART -------------------------------

		if(done and isNearFuelBStation and IsPedInAnyVehicle(PlayerPedId(), -1) and not IsPedInAnyHeli(PlayerPedId()) and not isBlackListedModel() and GetPedVehicleSeat(PlayerPedId()) == -1) then
			Info(settings[lang].openMenu)

			if(IsControlJustPressed(1, 38)) then
				menu = not menu
				int = 0
			end

			if(menu) then
				TriggerEvent("GUI:Title", settings[lang].buyFuel)

				local maxEssence = 60-(essence/0.142)*60
				TriggerEvent("GUI:Int", settings[lang].percent.." : ", int, 0, maxEssence, function(cb)
					int = cb
				end)

				TriggerEvent("GUI:Option", settings[lang].confirm, function(cb)
					if(cb) then
						menu = not menu

						TriggerServerEvent("essence:buy", int, stationBoatNumber,false)
					else

					end
				end)

				TriggerEvent("GUI:Update")
			end
		else
			if(isNearFuelBStation  and IsPedInAnyVehicle(PlayerPedId(), -1) and not IsPedInAnyHeli(PlayerPedId()) and not isBlackListedModel() and isElectricModel()) then
				Info(settings[lang].fuelError)
			end
		end

		------------------------------- PLANE PART -------------------------------

		if(done and isNearFuelPStation and IsPedInAnyVehicle(PlayerPedId(), -1) and not isBlackListedModel() and isPlaneModel() and GetPedVehicleSeat(PlayerPedId()) == -1) then
			Info(settings[lang].openMenu)

			if(IsControlJustPressed(1, 38)) then
				menu = not menu
				int = 0
				--[[Menu.hidden = not Menu.hidden

				Menu.Title = "Station essence"
				ClearMenu()
				Menu.addButton("Eteindre le moteur", "stopMotor")]]--
			end

			if(menu) then
				TriggerEvent("GUI:Title", settings[lang].buyFuel)

				local maxEssence = 60-(essence/0.142)*60

				TriggerEvent("GUI:Int", settings[lang].percent.." : ", int, 0, maxEssence, function(cb)
					int = cb
				end)

				TriggerEvent("GUI:Option", settings[lang].confirm, function(cb)
					if(cb) then
						menu = not menu

						TriggerServerEvent("essence:buy", int, stationPlaneNumber,false)
					else

					end
				end)

				TriggerEvent("GUI:Update")
			end
		else
			if(isNearFuelPStation  and IsPedInAnyVehicle(PlayerPedId(), -1) and not isBlackListedModel() and not isPlaneModel()) then
				Info(settings[lang].fuelError)
			end
		end

		------------------------------- HELI PART -------------------------------

		if(done and isNearFuelHStation and IsPedInAnyVehicle(PlayerPedId(), -1) and not isBlackListedModel() and isHeliModel() and GetPedVehicleSeat(PlayerPedId()) == -1) then
			Info(settings[lang].openMenu)

			if(IsControlJustPressed(1, 38)) then
				menu = not menu
				int = 0
			end

			if(menu) then
				TriggerEvent("GUI:Title", settings[lang].buyFuel)

				local maxEssence = 60-(essence/0.142)*60

				TriggerEvent("GUI:Int", settings[lang].percent.." : ", int, 0, maxEssence, function(cb)
					int = cb
				end)

				TriggerEvent("GUI:Option", settings[lang].confirm, function(cb)
					if(cb) then
						menu = not menu

						TriggerServerEvent("essence:buy", int, stationHeliNumber,false)
					else

					end
				end)

				TriggerEvent("GUI:Update")
			end
		else
			if(isNearFuelHStation  and IsPedInAnyVehicle(PlayerPedId(), -1) and not isBlackListedModel() and not isHeliModel()) then
				Info(settings[lang].fuelError)
			end
		end

		if((isNearFuelStation or isNearFuelPStation or isNearFuelHStation or isNearFuelBStation) and not IsPedInAnyVehicle(PlayerPedId())) then
			Info(settings[lang].getJerryCan)

			if(IsControlJustPressed(1, 38)) then
				TriggerServerEvent("essence:buyCan")
			end
		end

	end
end)

-- 0.0001 pour 0 à 20, 0.142 = 100%
-- Donc 0.0001 km en moins toutes les 10 secondes

local lastPlate = 0
local refresh = true
function CheckVeh()
	if(IsPedInAnyVehicle(PlayerPedId()) and not isBlackListedModel()) then

		--if((lastPlate == GetVehicleNumberPlateText(GetVehiclePedIsUsing(PlayerPedId())) and lastModel ~= GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId())))) or (lastPlate ~= GetVehicleNumberPlateText(GetVehiclePedIsUsing(PlayerPedId())) and lastModel == GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId())))) or (lastPlate ~= GetVehicleNumberPlateText(GetVehiclePedIsUsing(PlayerPedId())) and lastModel ~= GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId())))) then
		if(refresh) then
			TriggerServerEvent("vehicule:getFuel", GetVehicleNumberPlateText(GetVehiclePedIsUsing(PlayerPedId())), GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
			lastModel = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId())))
			lastPlate = GetVehicleNumberPlateText(GetVehiclePedIsUsing(PlayerPedId()))
		end
		refresh = false
	else
		if(not refresh) then
			TriggerServerEvent("essence:setToAllPlayerEscense", essence, lastPlate, lastModel)
			refresh = true
		end
	end



	if(essence == 0 and GetVehiclePedIsUsing(PlayerPedId()) ~= nil) then
		SetVehicleEngineOn(GetVehiclePedIsUsing(PlayerPedId()), false, false, false)
	end
end

function Refuel(data)
	TriggerServerEvent("essence:refuel:check", data)
	
	TriggerEvent('Menu:Close')
	menu = not menu
end

RegisterNetEvent("essence:refuel:ok")
AddEventHandler("essence:refuel:ok", function(amountToEssence)
	TriggerEvent('InteractSound_CL:PlayOnOne', "gas_start", 1.0)
	Wait(2000)
	local veh = GetVehiclePedIsIn(venato.GetPlayerPed(), 0)
	done = false
	if(veh ~= nil and GetVehicleNumberPlateText(veh) ~= nil) then		
		while done == false do
			Wait(0)
			TriggerEvent('InteractSound_CL:PlayOnOne', "gas_inprogress", 1.0)
			local _essence = GetVehicleFuelLevel(veh)
			if(amountToEssence-addFuelValue > 0) then
				amountToEssence = amountToEssence-addFuelValue
				if(GetVehicleFuelLevel(veh) >= 100) then
					done = true
				end
				SetVehicleUndriveable(veh, true)
				SetVehicleEngineOn(veh, false, false, false)
				SetVehicleFuelLevel(veh,GetVehicleFuelLevel(veh) + addFuelValue)
				Wait(300)
			else
				done = true
			end
		end
		TriggerEvent('InteractSound_CL:PlayOnOne', "gas_end", 1.0)

		SetVehicleEngineOn(veh, true, false, false)
		SetVehicleUndriveable(veh, false)
		
	end
end)

function isNearStation()
	local ped = PlayerPedId()
	local plyCoords = GetEntityCoords(PlayerPedId(), 0)

	for _,items in pairs(station) do
		if(GetDistanceBetweenCoords(items.x, items.y, items.z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true) < 2) then
			return true, items.s
		end
	end

	return false
end


function isNearPlaneStation()
	local ped = PlayerPedId()
	local plyCoords = GetEntityCoords(PlayerPedId(), 0)

	for _,items in pairs(avion_stations) do
		if(GetDistanceBetweenCoords(items.x, items.y, items.z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true) < 10) then
			return true, items.s
		end
	end

	return false
end


function isNearHeliStation()
	local ped = PlayerPedId()
	local plyCoords = GetEntityCoords(PlayerPedId(), 0)

	for _,items in pairs(heli_stations) do
		if(GetDistanceBetweenCoords(items.x, items.y, items.z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true) < 10) then
			return true, items.s
		end
	end

	return false
end


function isNearBoatStation()
	local ped = PlayerPedId()
	local plyCoords = GetEntityCoords(PlayerPedId(), 0)

	for _,items in pairs(boat_stations) do
		if(GetDistanceBetweenCoords(items.x, items.y, items.z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true) < 10) then
			return true, items.s
		end
	end

	return false
end


function isNearElectricStation()
	local ped = PlayerPedId()
	local plyCoords = GetEntityCoords(PlayerPedId(), 0)

	for _,items in pairs(electric_stations) do
		if(GetDistanceBetweenCoords(items.x, items.y, items.z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true) < 2) then
			return true, items
		end
	end

	return false
end

--100% = 100L = 100$
-- 1% = 1L = 1


function Info(text, loop)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, loop, 1, 0)
end



function round(num, dec)
  local mult = 10^(dec or 0)
  return math.floor(num * mult + 0.5) / mult
end


function isBlackListedModel()
	local model = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(PlayerPedId())))
	local isBL = false
	for _,k in pairs(blacklistedModels) do
		if(k==model) then
			isBL = true
			break;
		end
	end

	return isBL
end

function isElectricModel()
	local model = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(PlayerPedId())))
	local isEL = false
	for _,k in pairs(electric_model) do
		if(k==model) then
			isEL = true
			break;
		end
	end

	return isEL
end


function isHeliModel()
	local model = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(PlayerPedId())))
	local isHe = false
	for _,k in pairs(heli_model) do
		if(k==model) then
			isHe = true
			break;
		end
	end

	return isHe
end


function isPlaneModel()
	local model = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(PlayerPedId())))
	local isPl = false
	for _,k in pairs(plane_model) do
		if(k==model) then
			isPl = true
			break;
		end
	end

	return isPl
end


function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
	N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end


function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function drawRct(x,y,width,height,r,g,b,a)
	DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end



RegisterNetEvent("essence:setEssence")
AddEventHandler("essence:setEssence", function(ess,vplate,vmodel)
	if(ess ~= nil and vplate ~= nil and vmodel ~=nil) then
		local bool,index = searchByModelAndPlate(vplate,vmodel)

		if(bool and index ~=nil) then
			vehiclesUsed[index].es = ess
		else
			table.insert(vehiclesUsed, {plate = vplate, model = vmodel, es = ess})
		end
	end
end)




RegisterNetEvent("essence:hasBuying")
AddEventHandler("essence:hasBuying", function(amount)
	showDoneNotif(settings[lang].YouHaveBought..amount..settings[lang].fuel)
	local amountToEssence = (amount/60)*0.142

	local done = false
	while done == false do
		Wait(0)
		local _essence = essence
		if(amountToEssence-0.0005 > 0) then
			amountToEssence = amountToEssence-0.0005
			essence = _essence + 0.0005
			_essence = essence
			if(_essence > 0.142) then
				essence = 0.142
				done = true
			end
			SetVehicleUndriveable(GetVehiclePedIsUsing(PlayerPedId()), true)
			SetVehicleEngineOn(GetVehiclePedIsUsing(PlayerPedId()), false, false, false)
			local essenceToPercent = (essence/0.142)*65
			SetVehicleFuelLevel(GetVehiclePedIsIn(PlayerPedId()),round(essenceToPercent))
			Wait(100)
		else
			essence = essence + amountToEssence
			local essenceToPercent = (essence/0.142)*65
			SetVehicleFuelLevel(GetVehiclePedIsIn(PlayerPedId()),round(essenceToPercent))
			done = true
		end
	end

	TriggerServerEvent("essence:setToAllPlayerEscense", essence, GetVehicleNumberPlateText(GetVehiclePedIsUsing(PlayerPedId())), GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))

	SetVehicleUndriveable(GetVehiclePedIsUsing(PlayerPedId()), false)
	SetVehicleEngineOn(GetVehiclePedIsUsing(PlayerPedId()), true, false, false)
end)



RegisterNetEvent("essence:buyCan")
AddEventHandler("essence:buyCan", function()

	GiveWeaponToPed(PlayerPedId(), 0x34A67B97, currentCans+1,  0, true)
	currentCans = currentCans +1
end)


RegisterNetEvent("vehicule:sendFuel")
AddEventHandler("vehicule:sendFuel", function(bool, ess)

	if(bool == 1) then
		essence = ess
	else
		essence = (math.random(30,100)/100)*0.142
		--table.insert(vehiclesUsed, {plate = GetVehicleNumberPlateText(GetVehiclePedIsUsing(PlayerPedId())), model = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))), es = essence})
		vehicle = GetVehiclePedIsUsing(PlayerPedId())
		TriggerServerEvent("essence:setToAllPlayerEscense", essence, GetVehicleNumberPlateText(GetVehiclePedIsUsing(PlayerPedId())), GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
	end

end)

function GetPedVehicleSeat(ped)
    local vehicle = GetVehiclePedIsIn(ped, false)
    for i=-2,GetVehicleMaxNumberOfPassengers(vehicle) do
        if(GetPedInVehicleSeat(vehicle, i) == ped) then return i end
    end
    return -2
end


AddEventHandler("playerSpawned", function()
	TriggerServerEvent("essence:playerSpawned")
	TriggerServerEvent("essence:addPlayer")
end)


RegisterNetEvent("showNotif")
AddEventHandler("showNotif", function(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end)


RegisterNetEvent("advancedFuel:setEssence")
AddEventHandler("advancedFuel:setEssence", function(percent, plate, model)
	local toEssence = (percent/100)*0.142

	if(GetVehicleNumberPlateText(GetVehiclePedIsUsing(PlayerPedId())) == plate and model == GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId())))) then
		essence = toEssence
		local essenceToPercent = (essence/0.142)*65
		SetVehicleFuelLevel(GetVehiclePedIsIn(PlayerPedId()),round(essenceToPercent))
	end
	
	TriggerServerEvent("advancedFuel:setEssence_s",percent,plate,model)
end)


RegisterNetEvent('essence:sendEssence')
AddEventHandler('essence:sendEssence', function(array)
	for i,k in pairs(array) do
		vehiclesUsed[i] = {plate=k.plate,model=k.model,es=k.es}
	end
end)





function IsVehInArray()
	for i,k in pairs(vehiclesUsed) do
		if(k.plate == GetVehicleNumberPlateText(GetVehiclePedIsUsing(PlayerPedId())) and k.model == GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId())))) then
			return true
		end
	end

	return false
end


function searchByModelAndPlate(plate, model)
	for i,k in pairs(vehiclesUsed) do
		if(k.plate == plate and k.model == model) then
			return true, i
		end
	end

	return false, nil
end


function getVehIndex()
	local index = -1

	for i,k in pairs(vehiclesUsed) do
		if(k.plate == GetVehicleNumberPlateText(GetVehiclePedIsUsing(PlayerPedId())) and k.model == GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId())))) then
			index = i
		end
	end

	return index
end
