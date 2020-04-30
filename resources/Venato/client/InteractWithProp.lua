local msec = 0
local NextTo = nil
local Prop = nil
local PropData = {
	["v_med_emptybed"] = {text = "Pour s'allonger", x = 0.0, y = -0.25, z = 1.2, h = 90.0, anim = {lib = "timetable@tracy@sleep@", anim = "idle_c", flag = 1}},
	["V_Med_bed2"] = {text = "Pour s'allonger", x = 0.0, y = 0.2, z = 1.4, h = -90.0, anim = {lib = "timetable@tracy@sleep@", anim = "idle_c", flag = 1}},
	["V_ilev_chair02_ped"] = {text = "Pour s'assoire", x = 0.0, y = 0.0, z = 0.0, h = 180.0, anim = {lib = "nil", anim = "PROP_HUMAN_SEAT_CHAIR_UPRIGHT", flag = 1}},
}
--V_Med_fabricchair1
--xm_lab_chairarm_24


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local pedCoords = GetEntityCoords(PlayerPedId())
		for k,v in pairs(PropData) do
      local objectId = GetClosestObjectOfType(pedCoords, 1.0, GetHashKey(k), false)
			if objectId ~= 0 then
				NextTo = k
				Prop = objectId
				break
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
		if NextTo ~= nil and Prop ~= nil then
			local coordProp = GetEntityCoords(Prop, true)
			platypus.Text3D(coordProp.x, coordProp.y, coordProp.z, "Appuyez sur ~g~E~s~ "..PropData[NextTo].text)
			if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
				if not AttachOnProp then
					AttachEntityToEntity(platypus.GetPlayerPed(), Prop, nil, PropData[NextTo].x, PropData[NextTo].y, PropData[NextTo].z, 0.0, 0.0, PropData[NextTo].h, false, false, false, false, 2, true)
					if PropData[NextTo].anim ~= false then
						local Libb = true
						if PropData[NextTo].anim.lib == 'nil' then
							Libb = false
						end
						platypus.playAnim({lib = PropData[NextTo].anim.lib, anim = PropData[NextTo].anim.anim, useLib = Libb, flag = PropData[NextTo].anim.flag})
						AttachOnProp = true
						FreezeEntityPosition(PlayerPedId(), true)
					end
				else
					AttachOnProp = false
					DetachEntity(platypus.GetPlayerPed())
					ClearPedTasks(PlayerPedId())
					FreezeEntityPosition(PlayerPedId(), false)
				end
			end
		end
	end
end)
