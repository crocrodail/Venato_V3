DataUser = {}

RegisterNetEvent("Venato:displaytext")
AddEventHandler("Venato:displaytext", function(text, time)
  ClearPrints()
  SetTextEntry_2("STRING")
  AddTextComponentString(text)
  DrawSubtitleTimed(time, 1)
end)

RegisterNetEvent("Venato:notify")
AddEventHandler("Venato:notify", function(message)
  SetNotificationTextEntry("STRING")
  AddTextComponentString(message)
  DrawNotification(false, false)
end)
