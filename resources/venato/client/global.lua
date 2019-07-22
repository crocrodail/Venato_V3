DataUser = {}

RegisterNetEvent("Venato:displaytext")
AddEventHandler("Venato:displaytext", function(text, time)
  ClearPrints()
  SetTextEntry_2("STRING")
  AddTextComponentString(text)
  DrawSubtitleTimed(time, 1)
end)

RegisterNetEvent("Venato:Connection")
AddEventHandler("Venato:Connection", function()
  --Venato.Connecting()
end)

AddEventHandler('playerSpawned', function(spawn)
	Venato.Spawn()
  LoadBlips()
end)
