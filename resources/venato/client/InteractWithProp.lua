local msec = 0
local NextTo = nil
local Prop = nil
local PropData = {
	["v_med_emptybed"] = {text = "Pour s'allonger", x = 0.0, y = -0.25, z = 1.2, h = 90.0, anim = {lib = "timetable@tracy@sleep@", anim = "idle_c", flag = 1}}
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local pedCoords = GetEntityCoords(PlayerPedId())
		for k,v in pairs(PropData) do
      local objectId = GetClosestObjectOfType(pedCoords, 1.5, GetHashKey(k), false)
			print(objectId)
			print(k)
			if obj ~= 0 then
				NextTo = k
				Prop = objectId
			else
				NextTo = nil
				Prop = nil
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local plyCoords = GetEntityCoords(ply, 0)
		if NextTo ~= nil and Prop ~= nil then
			local coordProp = GetEntityCoords(Prop, true)
			Venato.Text3D(coordProp.x, coordProp.y, coordProp.z, "Appuyez sur ~g~E "..PropData[NextTo].text)
			if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
				if not AttachOnProp then
					AttachEntityToEntity(Venato.GetPlayerPed(), Prop, nil, PropData[NextTo].x, PropData[NextTo].y, PropData[NextTo].z, 0.0, 0.0, PropData[NextTo].h, false, false, false, false, 2, true)
					if PropData[NextTo].anim ~= false then
						Venato.playAnim({lib = PropData[NextTo].anim.lib, anim = PropData[NextTo].anim.anim, useLib = true, flag = PropData[NextTo].anim.flag})
						AttachOnProp = true
					end
				else
					DetachEntity(Venato.GetPlayerPed())
					ClearPedTasks(GetPlayerPed(-1))
				end
			end
		end
	end
end)
