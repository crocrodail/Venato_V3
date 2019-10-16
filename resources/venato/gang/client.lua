
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)        
        if IsControlJustPressed(1, 56) and GetLastInputMethod(2) and Venato.HasJob(8) then -- press action contextuel (e) pour joueur clavier uniquement
            TriggerEvent('Menu:Init', "Gang", "Gang Gang !", "#46914C99", "")
            Menu.clearMenu()            
            TriggerEvent('Menu:AddButton2', "Fouiller", "POLICE_Check",  false , "", "https://i.ibb.co/GQJWMRt/icons8-customs-officer-96px.png")
            if Venato.HasItem(2020) then
                TriggerEvent('Menu:AddButton2', "Menoter", "POLICE_Cuffed", false , "", "https://i.ibb.co/6D2GVzD/icons8-handcuffs-96px.png")
            end
            if Venato.HasJob(56) then
                TriggerEvent('Menu:AddButton2', "Verrouiler Portail LOST", "LockPortail", 43 , "", "https://i.ibb.co/bv1pLgg/icons8-front-gate-closed-96px.png")
                TriggerEvent('Menu:AddButton2', "Déverrouiler Portail LOST", "UnlockPortail", 43 , "", "https://i.ibb.co/sKvVTZk/icons8-front-gate-open-96px-1.png")
            end
            if Venato.HasJob(60) then
                TriggerEvent('Menu:AddButton2', "Verrouiler Portail Vagos", "LockPortail", 47 , "", "https://i.ibb.co/bv1pLgg/icons8-front-gate-closed-96px.png")
                TriggerEvent('Menu:AddButton2', "Déverrouiler Portail Vagos", "UnlockPortail", 47 , "", "https://i.ibb.co/sKvVTZk/icons8-front-gate-open-96px-1.png")
            end
            TriggerEvent('Menu:CreateMenu')
            Menu.toggle()
        end              
    end
end)

function LockPortail(doorId)
    TriggerServerEvent("door:update", doorId, true)
    Venato.playAnim({
        useLib = true,
        flag = 48,
        lib = "anim@mp_player_intmenu@key_fob@",
        anim = "fob_click_fp",
        timeout = 500
      })
end

function UnlockPortail(doorId)
    TriggerServerEvent("door:update", doorId, false)
    Venato.playAnim({
        useLib = true,
        flag = 48,
        lib = "anim@mp_player_intmenu@key_fob@",
        anim = "fob_click_fp",
        timeout = 500
      })
end