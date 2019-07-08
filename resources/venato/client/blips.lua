AddEventHandler('playerSpawned', function()
	LoadBlips()
end)


RegisterNetEvent("VenatoSpawn")
AddEventHandler("VenatoSpawn", function()
	LoadBlips()
end)

function LoadBlips()
	Citizen.CreateThread(function()
		for i,v in ipairs(Config.ATMS) do
			if v.b == true then
				local blip = AddBlipForCoord(v.x, v.y, v.z)
				SetBlipSprite(blip, 108)
				SetBlipColour(blip, 3)
				SetBlipScale(blip, 1.0)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString("Banque")
				EndTextCommandSetBlipName(blip)
			else
				local blip = AddBlipForCoord(v.x, v.y, v.z)
				SetBlipSprite(blip, 108)
				SetBlipColour(blip, 2)
				SetBlipScale(blip, 0.5)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString("Distributeur")
				EndTextCommandSetBlipName(blip)
			end
		end
	end)
end
