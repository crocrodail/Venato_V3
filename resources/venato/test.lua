local BoxJobs = "prop_box_wood05a"
local BassinBox = "prop_apple_box_01"
local AllObject = {}
local CoordForCarries = {}
local GobalBox = nil
local forklift = nil
local WaitWhile = 1000

Citizen.CreateThread(function()
	local ply = GetPlayerPed(-1)
	while true do
		Citizen.Wait(WaitWhile)
		if IsControlJustPressed(1, Keys["U"]) then
			OpenTestMenu()
			Menu.toggle()
		end
		if CoordForCarries ~= {} then
      local plyCoords = GetEntityCoords(ply, 0)
			for i,v in ipairs(CoordForCarries) do
				local distance = GetDistanceBetweenCoords(v.x, v.y, v.z,  plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
				if distance < 50 then
					WaitWhile = 0
					DrawMarker(27,v.x, v.y, v.z,0,0,0,0,0,0,0.2,0.2,0.2,0,150,255,200,0,0,0,0)
				else
					WaitWhile = 1000
				end
				if distance < 0.5 and GetEntityModel(GetVehiclePedIsIn(ply, false)) == GetHashKey("FORKLIFT") then
					Venato.InteractTxt("Appuyez sur la touche ~INPUT_CONTEXT~ pour .")
					if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
						takebox()
					end
				end
			end
		end
	end
end)



function takebox()
	--AttachEntityToEntity(GobalBox, forklift, nil, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, nil, true)
	AttachEntityToEntity(GobalBox, GetVehiclePedIsIn(GetPlayerPed(-1), false), 3, 0.0, 1.2, -0.5, 0.0, 0, 0.0, false, false, false, false, 2, true)
end

function OpenTestMenu()
	Menu.clearMenu()
	Menu.setTitle("Test")
	Menu.addButton("Spawn box", "SpawnBoxTest", nil)
	Menu.addButton("Spawn Forklift", "SpawnForkliftTest", nil)
	Menu.addButton("delete", "deleteBox", nil)
end



function SpawnForkliftTest()
	local coord = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 2.0, 0)
	Venato.CreateVehicle("forklift", coord , 0, function(vehicle)
		forklift = vehicle
	end)
end

function SpawnBoxTest()
	local x,y,z = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 2.0, 0)
	local objet = Venato.CreateObject(BoxJobs, -1250.0, -3015.0, 14.0)
	AllObject[objet] = objet
	local bassin1 = Venato.CreateObject(BassinBox, -1251.0, -3015.0, 14.77)
	AllObject[bassin1] = bassin1
	SetEntityHeading(bassin1, 90.0)
	local bassin2 = Venato.CreateObject(BassinBox, -1249.0, -3015.0, 14.77)
	AllObject[bassin2] = bassin2
	SetEntityHeading(bassin2, 90.0)
	AttachEntityToEntity(bassin1, objet, 0, -0.6, 0.0, -0.08, 0.0, 0.0, 90.0, false, false, false, false, 2, true)
	AttachEntityToEntity(bassin2, objet, 0, 0.6, 0.0, -0.08, 0.0, 0.0, 90.0, false, false, false, false, 2, true)
	local x1,y1,z1 = table.unpack(GetOffsetFromEntityInWorldCoords(objet, 0, 2.0, -0.2))
	local x2,y2,z2 = table.unpack(GetOffsetFromEntityInWorldCoords(objet, 0, -2.0, -0.2))
	CoordForCarries = {{x=x1,y=y1,z=z1},{x=x2,y=y2,z=z2}}
	GobalBox = objet
	PlaceObjectOnGroundProperly(objet)
	local coords = GetEntityCoords(objet, 0)
	SetEntityCoords(objet, coords["x"], coords["y"], coords["z"]+0.12, 0, 0, 0, true)
	FreezeEntityPosition(objet, true)
	SetEntityCollision(objet, false, true)
	--AttachEntityToEntity(objet, GetPlayerPed(-1), nil, 1.0, 0.0, -0.1, 0.0, 0.0, 0.0, false, false, false, false, nil, false)
end

function deleteBox()
	for k,v in pairs(AllObject) do
		DeleteEntity(k)
	end
	CoordForCarries= {}
end
