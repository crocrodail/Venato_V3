DataUser = {}

RegisterNetEvent("Venato:displaytext")
AddEventHandler("Venato:displaytext", function(text, time)
  ClearPrints()
  SetTextEntry_2("STRING")
  AddTextComponentString(text)
  DrawSubtitleTimed(time, 1)
end)

RegisterNetEvent("VenatoSpawn")
AddEventHandler("VenatoSpawn", function()
  print("1")
	LoadBlips()
	Venato.Spawn()
end)
