
local speedBuffer  = {}
local velBuffer    = {}
local beltOn       = false
local wasInCar     = false

local defaultNotification = {
  title = "Ceinture",
  type = "alert",
  logo = "https://i.ibb.co/0G3KyFB/icons8-passenger-96px.png"
}


IsCar = function(veh)
		    local vc = GetVehicleClass(veh)
		    return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
        end	

Fwv = function (entity)
		    local hr = GetEntityHeading(entity) + 90.0
		    if hr < 0.0 then hr = 360.0 + hr end
		    hr = hr * 0.0174533
		    return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
      end

Citizen.CreateThread(function()
	Citizen.Wait(500)
	while true do
		
		local ped = PlayerPedId()
		local car = GetVehiclePedIsIn(ped)
		
		if car ~= 0 and (wasInCar or IsCar(car)) then
		
			wasInCar = true
			
			if beltOn then DisableControlAction(0, 75) end
			
			speedBuffer[2] = speedBuffer[1]
			speedBuffer[1] = GetEntitySpeed(car)
			
			if speedBuffer[2] ~= nil 
			   and not beltOn
			   and GetEntitySpeedVector(car, true).y > 1.0  
			   and speedBuffer[1] > Cfg.MinSpeed 
			   and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * Cfg.DiffTrigger) then
			   
				local co = GetEntityCoords(ped)
				local fw = Fwv(ped)
				SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
				SetEntityVelocity(ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
				Citizen.Wait(1)
				SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
				SmashVehicleWindow(car, 6)
			end
				
			velBuffer[2] = velBuffer[1]
			velBuffer[1] = GetEntityVelocity(car)
				
			if IsControlJustReleased(0, 73) then
				beltOn = not beltOn				  
				if beltOn then 
					defaultNotification.message =  Cfg.Strings.belt_on
				else 
					defaultNotification.message = Cfg.Strings.belt_off
				 end 
				platypus.notify(defaultNotification)
			end
			
		elseif wasInCar then
			wasInCar = false
			beltOn = false
			speedBuffer[1], speedBuffer[2] = 0.0, 0.0
		end
		Citizen.Wait(0)
	end
end)
