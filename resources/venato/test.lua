local BoxJobs = "prop_box_wood05a"
local BassinBox = "prop_apple_box_01"
local CamionTranport = "mule"
local AllObject = {}
local CoordForCarries = {}
local CamionCoord = {}
local GobalBox = nil
local GobalCamion = nil
local forklift = nil
local BoxOnForklift = false
local ClotheVehicle = false
local BoxOnCamion = false

Citizen.CreateThread(function()
	local ply = venato.GetPlayerPed()
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1, Keys["U"]) then
			OpenTestMenu()
			Menu.toggle()
		end
		if CoordForCarries ~= {} and (not BoxOnForklift or BoxOnCamion) then
      local plyCoords = GetEntityCoords(ply, 0)
			for i,v in ipairs(CoordForCarries) do
				local distance = GetDistanceBetweenCoords(v.x, v.y, v.z,  plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
				if BoxOnCamion then
					distance = GetDistanceBetweenCoords(v.x, v.y, v.z,  plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
				end
				if distance < 0.5 and GetEntityModel(GetVehiclePedIsIn(ply, false)) == GetHashKey("FORKLIFT") then
					venato.InteractTxt("Appuyez sur la touche ~INPUT_CONTEXT~ pour .")
					if IsControlJustPressed(1, Keys['E']) and GetLastInputMethod(2) then
						takebox()
						BoxOnForklift = true
						BoxOnCamion = false
					end
				end
			end
		elseif BoxOnForklift and not ClotheVehicle then
			local plyCoords = GetEntityCoords(ply, 0)
			for i,v in ipairs(CoordForCarries) do
				local distance = GetDistanceBetweenCoords(v.x, v.y, v.z+0.9,  plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
				if distance < 0.5 and GetEntityModel(GetVehiclePedIsIn(ply, false)) == GetHashKey("FORKLIFT") then
					venato.InteractTxt("Appuyez sur la touche ~INPUT_CONTEXT~ pour détacher.")
					if IsControlJustPressed(1, Keys['E']) and GetLastInputMethod(2) then
						dropBoxInForklift()
						BoxOnForklift = false
						BoxOnCamion = false
					end
				end
			end
		elseif ClotheVehicle and not BoxOnCamion then
			local plyCoords = GetEntityCoords(ply, 0)
			local distance = GetDistanceBetweenCoords(CamionCoord.x, CamionCoord.y, CamionCoord.z+0.9,  plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
			if distance < 0.5 and GetEntityModel(GetVehiclePedIsIn(ply, false)) == GetHashKey("FORKLIFT") then
				venato.InteractTxt("Appuyez sur la touche ~INPUT_CONTEXT~ pour détacher.")
				if IsControlJustPressed(1, Keys['E']) and GetLastInputMethod(2) then
					AttacheOnCamion()
					BoxOnForklift = false
					BoxOnCamion = true
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	local ply = venato.GetPlayerPed()
	while true do
		Citizen.Wait(1000)
		local plyCoords = GetEntityCoords(ply, 0)
		local obj = GetClosestObjectOfType(plyCoords.x, plyCoords.y, plyCoords.z, 10.0, GetHashKey(BoxJobs), false, true ,true)
		local veh = GetClosestVehicle(plyCoords.x, plyCoords.y, plyCoords.z, 10.0, GetHashKey(CamionTranport), 127)
		if obj then
			local x1,y1,z1 = {}
			local x2,y2,z2 = {}
			if BoxOnCamion then
				x1,y1,z1 = table.unpack(GetOffsetFromEntityInWorldCoords(obj, 0, 2.0, -0.6))
				x2,y2,z2 = table.unpack(GetOffsetFromEntityInWorldCoords(obj, 0, -2.7, -0.6))
			else
				x1,y1,z1 = table.unpack(GetOffsetFromEntityInWorldCoords(obj, 0, 2.0, -0.2))
				x2,y2,z2 = table.unpack(GetOffsetFromEntityInWorldCoords(obj, 0, -2.0, -0.2))
			end
			CoordForCarries = {{x=x1,y=y1,z=z1},{x=x2,y=y2,z=z2}}
			GobalBox = obj
		end
		if veh ~= 0 then
			ClotheVehicle = true
			local x3,y3,z3 = table.unpack(GetOffsetFromEntityInWorldCoords(veh, 0, -5.5, -1.5))
			CamionCoord = {x=x3,y=y3,z=z3}
			GobalCamion = veh
		else
			GobalCamion = nil
			CamionCoord = {}
			ClotheVehicle = false
		end
	end
end)

function CreateBox(x,y,z)
	local coords = GetEntityCoords(venato.GetPlayerPed(), 0)
	local objet = venato.CreateObject(BoxJobs, x or coords["x"], y or coords["y"], z or coords["z"])
	AllObject[objet] = objet
	local bassin1 = venato.CreateObject(BassinBox, x or coords["x"], y or coords["y"], z or coords["z"])
	AllObject[bassin1] = bassin1
	SetEntityHeading(bassin1, 90.0)
	local bassin2 = venato.CreateObject(BassinBox, x or coords["x"], y or coords["y"], z or coords["z"])
	AllObject[bassin2] = bassin2
	SetEntityHeading(bassin2, 90.0)
	AttachEntityToEntity(bassin1, objet, 0, -0.6, 0.0, -0.08, 0.0, 0.0, 90.0, false, false, false, false, 2, true)
	AttachEntityToEntity(bassin2, objet, 0, 0.6, 0.0, -0.08, 0.0, 0.0, 90.0, false, false, false, false, 2, true)
	PlaceObjectOnGroundProperly(objet)
	coords = GetEntityCoords(objet, 0)
	SetEntityCoords(objet, coords["x"], coords["y"], coords["z"]+0.12, 0, 0, 0, true)
	FreezeEntityPosition(objet, true)
end

function AttacheOnCamion()
	DetachEntity(GobalBox)
	AttachEntityToEntity(GobalBox, GobalCamion, nil, 0.0, -3.0, 0.12, 0.0, 0, 0.0, false, false, false, false, 2, true)
	SetEntityCollision(GobalBox, true, true)
end

function takebox()
	AttachEntityToEntity(GobalBox, GetVehiclePedIsIn(venato.GetPlayerPed(), false), 3, 0.0, 1.0, -0.4, 0.0, 0, 0.0, false, false, false, false, 2, true)
	SetEntityCollision(GobalBox, false, true)
end

function dropBoxInForklift()
	local coords = GetOffsetFromEntityInWorldCoords(venato.GetPlayerPed(), 0, 2.0, 0)
	DetachEntity(GobalBox)
	PlaceObjectOnGroundProperly(GobalBox)
	coords = GetEntityCoords(GobalBox, 0)
	SetEntityCoords(GobalBox, coords["x"], coords["y"], coords["z"]+0.12, 0, 0, 0, true)
	FreezeEntityPosition(GobalBox, true)
	SetEntityCollision(GobalBox, true, true)
end

function DetacheBoxInForklift()
	local coords = GetOffsetFromEntityInWorldCoords(venato.GetPlayerPed(), 0, 2.0, 0)
	DetachEntity(GobalBox)
	PlaceObjectOnGroundProperly(GobalBox)
	coords = GetEntityCoords(GobalBox, 0)
	SetEntityCoords(GobalBox, coords["x"], coords["y"], coords["z"]+0.12, 0, 0, 0, true)
	FreezeEntityPosition(GobalBox, true)
	SetEntityCollision(GobalBox, true, true)
end

function OpenTestMenu()
	Menu.clearMenu()
	Menu.setTitle("Test")
	Menu.addButton("Spawn box", "CreateBox", nil)
	Menu.addButton("Spawn Forklift", "SpawnForkliftTest", nil)
	Menu.addButton("delete", "deleteBox", nil)
	Menu.addButton("test", "test", nil)
	Menu.addButton("test2", "test2", nil)
	Menu.addButton("test3", "test3", nil)
	Menu.addButton("spawn bed", "stopeffect", nil)
	Menu.addButton("attach bed", "attachbed", nil)
	Menu.addButton("deattach bed", "detachebed", nil)
	Menu.addButton("kill me", "dead", nil)
	Menu.addButton("create instance", "cinstance", nil)
	Menu.addButton("join instance", "jinstance", nil)
end

function cinstance()
TriggerEvent('instance:create', 'garage')
TriggerEvent('instance:registerType', 'garage')
end
RegisterNetEvent('instance:onCreate')
AddEventHandler('instance:onCreate', function(instance)
	if instance.type == 'garage' then
		TriggerEvent('instance:enter', instance)
	end
end)

function jinstance()
	TriggerEvent('instance:close')
end

local bed = nil

function dead()
	SetEntityHealth(venato.GetPlayerPed(), 0.0)
end

function detachebed()
	DetachEntity(venato.GetPlayerPed())
	ClearPedTasks(GetPlayerPed(-1))
end

function attachbed()
	venato.playAnim({lib = "timetable@tracy@sleep@", anim = "idle_c", useLib = true, flag = 1})
	AttachEntityToEntity(venato.GetPlayerPed(), bed, nil, 0.0, -0.25, 1.2, 0.0, 0.0, 90.0, false, false, false, false, 2, true)
end

function test()
	--venato.playAnim({lib = "misscarsteal4asleep", anim = "franklin_asleep", useLib = true})
	--venato.playAnim({lib = "savebighouse@", anim = "f_sleep_l_loop_bighouse", useLib = true}) --PLS en mode dodo
	--venato.playAnim({lib = "timetable@tracy@sleep@", anim = "idle_c", useLib = true, flag = 1}) -- couchesur le dos jambe l'une sur l'autre
	venato.playAnim({lib = "get_up@standard", anim = "back", useLib = true})
end

function test2()
	--venato.playAnim({lib = "misscarsteal4asleep", anim = "franklin_asleep", useLib = true})
	--venato.playAnim({lib = "savebighouse@", anim = "f_sleep_l_loop_bighouse", useLib = true}) --PLS en mode dodo
	--venato.playAnim({lib = "timetable@tracy@sleep@", anim = "idle_c", useLib = true, flag = 1}) -- couchesur le dos jambe l'une sur l'autre
	venato.playAnim({lib = "mini@cpr@char_b@cpr_def", anim = "cpr_intro", useLib = true})
	Citizen.Wait(15000)
	venato.playAnim({lib = "mini@cpr@char_b@cpr_str", anim = "cpr_pumpchest", useLib = true, flag = 1})
	Citizen.Wait(5000)
	venato.playAnim({lib = "mini@cpr@char_b@cpr_str", anim = "cpr_cpr_to_kol", useLib = true})
	Citizen.Wait(1500)
	venato.playAnim({lib = "mini@cpr@char_b@cpr_str", anim = "cpr_kol", useLib = true})
	Citizen.Wait(5000)
	venato.playAnim({lib = "mini@cpr@char_b@cpr_str", anim = "cpr_kol_to_cpr", useLib = true})
	Citizen.Wait(1500)
	venato.playAnim({lib = "mini@cpr@char_b@cpr_str", anim = "cpr_pumpchest", useLib = true, flag = 1})
	Citizen.Wait(5000)
	venato.playAnim({lib = "mini@cpr@char_b@cpr_str", anim = "cpr_success", useLib = true})
end

function test3()
	local ClonedPed = ClonePed(venato.GetPlayerPed(), GetEntityHeading(venato.GetPlayerPed()), 1, 1)
	local coord = GetEntityCoords(venato.GetPlayerPed(), true)
	SetEntityCoords(ClonedPed, coord.x, coord.y, coord.z, 0, 0, 0, true)
	SetEntityCoords(venato.GetPlayerPed(), coord.x-0.9, coord.y-0.1, coord.z, 0, 0, 0, true)
	local heading = GetEntityHeading(ClonedPed)
	SetEntityHeading(venato.GetPlayerPed(), heading-90)
	venato.playAnim({lib = "mini@cpr@char_a@cpr_def", anim = "cpr_intro", useLib = true})
	venato.playAnim({lib = "mini@cpr@char_b@cpr_def", anim = "cpr_intro", useLib = true, ped = ClonedPed})
	Citizen.Wait(15000)
	venato.playAnim({lib = "mini@cpr@char_a@cpr_str", anim = "cpr_pumpchest", useLib = true, flag = 1})
	venato.playAnim({lib = "mini@cpr@char_b@cpr_str", anim = "cpr_pumpchest", useLib = true, flag = 1, ped = ClonedPed})
	Citizen.Wait(5000)
	venato.playAnim({lib = "mini@cpr@char_a@cpr_str", anim = "cpr_cpr_to_kol", useLib = true})
	venato.playAnim({lib = "mini@cpr@char_b@cpr_str", anim = "cpr_cpr_to_kol", useLib = true, ped = ClonedPed})
	Citizen.Wait(1500)
	venato.playAnim({lib = "mini@cpr@char_a@cpr_str", anim = "cpr_kol", useLib = true})
	venato.playAnim({lib = "mini@cpr@char_b@cpr_str", anim = "cpr_kol", useLib = true, ped = ClonedPed})
	Citizen.Wait(5000)
	venato.playAnim({lib = "mini@cpr@char_a@cpr_str", anim = "cpr_kol_to_cpr", useLib = true})
	venato.playAnim({lib = "mini@cpr@char_b@cpr_str", anim = "cpr_kol_to_cpr", useLib = true, ped = ClonedPed})
	Citizen.Wait(1500)
	venato.playAnim({lib = "mini@cpr@char_a@cpr_str", anim = "cpr_pumpchest", useLib = true, flag = 1})
	venato.playAnim({lib = "mini@cpr@char_b@cpr_str", anim = "cpr_pumpchest", useLib = true, flag = 1, ped = ClonedPed})
	Citizen.Wait(5000)
	venato.playAnim({lib = "mini@cpr@char_a@cpr_str", anim = "cpr_success", useLib = true})
	venato.playAnim({lib = "mini@cpr@char_b@cpr_str", anim = "cpr_success", useLib = true, ped = ClonedPed})
	Citizen.Wait(26000)
	ClearPedTasks(PlayerPedId())
end

function stopeffect()
	local coord = GetOffsetFromEntityInWorldCoords(venato.GetPlayerPed(), 0, 2.0, 0)
	bed = venato.CreateObject("xm_lab_chairarm_24", coord["x"], coord["y"], coord["z"])
	AllObject[bed] = bed
	PlaceObjectOnGroundProperly(bed)
end

function SpawnForkliftTest()
	local coord = GetOffsetFromEntityInWorldCoords(venato.GetPlayerPed(), 0, 2.0, 0)
	venato.CreateVehicle("forklift", coord , 0, function(vehicle)
		forklift = vehicle
	end)
end

function deleteBox()
	for k,v in pairs(AllObject) do
		DeleteEntity(k)
	end
	CoordForCarries= {}
end
