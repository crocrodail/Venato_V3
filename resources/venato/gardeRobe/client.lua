function callServer(eventName, arg)
    local response = nil

    TriggerServerEvent(eventName, arg)


    RegisterNetEvent(eventName..":cb")
    AddEventHandler(eventName..":cb", function(cb)
      response = cb
    end)

      while response == nil do
        Citizen.Wait(10)
      end

    return response
end

Citizen.CreateThread(function()

  print(callServer("gardeRobe:test", "nil").."#####################################")
  print(callServer("gardeRobe:test", "nil").."#####################################")
  Citizen.Wait(2000)
  print(callServer("gardeRobe:test", "nil").."#####################################")

end)
