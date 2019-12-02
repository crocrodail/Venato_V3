function GenerateNpc(item)
    RequestModel(GetHashKey(item.ped_model))

    while not HasModelLoaded(GetHashKey(item.ped_model)) do
        Wait(1)
    end

    local npc = CreatePed(4, GetHashKey(item.ped_model),
    item.x, item.y, item.z, item.h,
    false, true
    )

    SetEntityHeading(npc, item.h)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)

    return npc
end


Citizen.CreateThread(function()
    Citizen.Wait(10000) 
    GenerateNpc(config)
end)
