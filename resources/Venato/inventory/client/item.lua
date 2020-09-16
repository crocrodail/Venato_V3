function OptionItem(table)
    Menu.clearMenu()
    Menu.setSubtitle(table[3])
    Menu.addItemButton(
        "<span class='red--text'>Retour</span>",
        "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png",
        "OpenInventory",
        nil
    )
    if (table[7] == 1) then
        Menu.addButton("Utiliser", "UseItem", {table[1], table[2]})
    end
    Menu.addButton("Donner", "GiveItem", {table[1], table[2], table[4]})
    Menu.addButton("Jeter", "DropItem", {table[1], table[2], table[3], table[4], table[5], table[6]})
end

function UseItem(table)
    if table[1] - 1 >= 0 then
        TriggerServerEvent("Inventory:DataItem", table[2], table[1])
        Menu.clearMenu()
        --Citizen.Wait(1000)
        OpenInventory()
    else
        venato.notifyError("Error !")
    end
end

function GiveItem(row)
    local row = row
    local ClosePlayer, distance = venato.ClosePlayer()
    if ClosePlayer ~= 0 and ClosePlayer ~= nil and distance < 4 then
        local nb = venato.OpenKeyboard("", "", 2, "Nombre à donner")
        if tonumber(nb) ~= nil and tonumber(nb) ~= 0 then
            TriggerServerEvent("Inventory:CallInfo", ClosePlayer, tonumber(nb), row)
            Citizen.Wait(500)
            OpenInventory()
        end
    else
        venato.notifyError("Il n'y a personne à proximité.")
    end
end

RegisterNetEvent("Inventory:CallInfo:cb")
AddEventHandler(
    "Inventory:CallInfo:cb",
    function(ClosePlayer, nb, table, poid, qty)
        if table[1] - nb >= 0 then
            print(table[3])
            print(nb)
            print(poid)
            print((table[3] * nb) + poid)
            print(PoidMax)
            if table[3] * nb + poid <= PoidMax then
                TriggerServerEvent("Inventory:NotifGive", ClosePlayer, nb, table[2])
                TriggerServerEvent("Inventory:SetItem", table[1] - nb, table[2])
                TriggerServerEvent("Inventory:SetItem", qty + nb, table[2], ClosePlayer)
            else
                venato.notifyError("L'inventaire de la personne est plein pour ces items.")
            end
        else
            venato.notifyError("Vous ne pouvez pas donner plus que ce que vous avez.")
        end
    end
)

function DropItem(tableau)
    local nb = venato.OpenKeyboard("", "", 2, "Nombre à jeter")
    if tonumber(nb) ~= nil and tonumber(nb) ~= 0 then
        if tableau[1] - tonumber(nb) >= 0 then
            local x, y, z = table.unpack(GetEntityCoords(venato.GetPlayerPed(), true))
            TriggerServerEvent(
                "Inventory:DropItem",
                tableau[3],
                tonumber(nb),
                tableau[2],
                tableau[4],
                x,
                y,
                z - 0.5,
                tableau[5],
                tableau[6]
            )
            TriggerServerEvent("Inventory:SetItem", tableau[1] - tonumber(nb), tableau[2])
            local objet = venato.CreateObject(dropItem, x, y, z - 1)
            PlaceObjectOnGroundProperly(objet)
            FreezeEntityPosition(objet, true)
            venato.notify("Vous avez jeté " .. nb .. " " .. tableau[3] .. " .")
            OpenInventory()
        else
            venato.notifyError("Vous ne pouvez pas jeter plus que ce que vous avez.")
        end
    else
        venato.notifyError("Erreur dans le nombre désiré.")
    end
end

RegisterNetEvent("Inventory:SendItemsOnTheGround")
AddEventHandler(
    "Inventory:SendItemsOnTheGround",
    function(ParItemsOnTheGround)
        ItemsOnTheGround = ParItemsOnTheGround
    end
)
