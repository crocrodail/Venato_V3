local BoxJobs = "prop_box_wood08a"
local BassinBox = "prop_box_wood05a"

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1, Keys["U"]) then
			OpenTestMenu()
			Menu.toggle()
		end
	end
end)

function OpenTestMenu()
	Menu.clearMenu()
	Menu.setTitle("Test")
	Menu.addButton("Spawn box", "SpawnBoxTest", nil)
end

function SpawnBoxTest()
	local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
	local objet = Venato.CreateObject(BassinBox, x, y, z)
end
