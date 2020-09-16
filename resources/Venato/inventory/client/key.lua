function MyKeys(Data)
    TriggerEvent("getInv:clef")
end

RegisterNetEvent("getInv:back")
AddEventHandler(
    "getInv:back",
    function(TableOfKey)
        Menu.clearMenu()
        Menu.setTitle("Mes clefs")
        Menu.addItemButton(
            "<span class='red--text'>Retour</span>",
            "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png",
            "OpenInventory",
            nil
        )
        if #TableOfKey > 0 then
            for i, v in pairs(TableOfKey) do
                if v.name ~= nil then
                    Menu.addButton(
                        "<span class='blue--text'>" ..
                            v.name .. "</span> : <span class='red--text'>" .. v.plate .. "</span>",
                        "giveclef",
                        {v.name, v.plate}
                    )
                else
                    Menu.addButton("<span class='red--text'>Vous n'avez aucune clef</span>", "none", nil)
                end
            end
        end
    end
)

function giveclef(clef)
    Menu.clearMenu()
    Menu.setTitle("Details:")
    Menu.setSubtitle("<span class='blue--text'>" .. clef[1] .. " plaque : " .. clef[2] .. "</span>")
    Menu.addButton("Donner un double de la clef", "givecleff", {clef[1], clef[2]})
end

function givecleff(item)
    local ClosePlayer, distance = venato.ClosePlayer()
    if ClosePlayer ~= 0 and ClosePlayer ~= nil and distance < 4 then
        TriggerServerEvent("inv:giveclef", GetPlayerServerId(ClosePlayer), item[1], item[2])
        TriggerEvent("Inventory:AnimGive")
        venato.notify("<span class='green--text'>Vous avez donné les clef du vehicule " .. item[1] .. "</span>")
    else
        venato.notifyError("Aucun joueurs à proximité")
    end
end
