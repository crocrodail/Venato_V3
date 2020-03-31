function GenerateNpcAutoEcole()
    print("uhrujhf")
    RequestModel(GetHashKey(configAutoEcole.ped_model))

    while not HasModelLoaded(GetHashKey(configAutoEcole.ped_model)) do
        Wait(1)
    end

    local npc = CreatePed(4, GetHashKey(configAutoEcole.ped_model),
    configAutoEcole.x, configAutoEcole.y, configAutoEcole.z, configAutoEcole.h,
    false, true
    )

    SetEntityHeading(npc, configAutoEcole.h)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)

    return npc
end


Citizen.CreateThread(function()
    Citizen.Wait(10000) 
    GenerateNpcAutoEcole()
    while true do
        Citizen.Wait(0) -- Obligatoire pour eviter de crash
        local x,y,z = table.unpack(GetEntityCoords(platypus.GetPlayerPed(), true)) -- Permet de recuperer la position du joueur
        if Vdist(x, y, z, configAutoEcole.x, configAutoEcole.y, configAutoEcole.z) < 4 then
            Venato.InteractTxt('Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu')
            if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
                openmenuautoecole()
                print("uhfuohf")
            end
        end
    end  

end)

function openmenuautoecole()
    Menu.clearMenu()
    Menu.open()
    TriggerEvent('Menu:Init', "", "La vitamine c mais ne dira rien", "#F9A82599", "https://cdn.discordapp.com/attachments/618546482135433226/618546497373339653/20181216224111_1.jpg")
    Menu.addButton("<span class='red--text'>Fermer</span>", "closemenuautoecole")
    Menu.addButton2("Code de la route", "openmenucode", nil, '', 'https://img.icons8.com/office/30/000000/traffic-jam.png')
    Menu.CreateMenu()
end

function openmenucode()
end

function openmenupermis()
end

function closemenuautoecole()
    Menu.close()
end