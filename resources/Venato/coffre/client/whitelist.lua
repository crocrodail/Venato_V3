RegisterNetEvent("Coffre:CheckWhitelist:cb")
AddEventHandler(
    "Coffre:CheckWhitelist:cb",
    function(result)
        if result.status then
            venato.playAnim(
                {
                    useLib = true,
                    flag = 48,
                    lib = "missheistfbisetup1",
                    anim = "unlock_enter_janitor",
                    timeout = 3333
                }
            )
            OpenCoffre(coffre_index)
            Menu.toggle()
        else
            defaultNotification.message = "Vous ne connaissez pas le code de " .. DataCoffre[coffre_index].nom
            venato.notify(defaultNotification)
        end
    end
)

function CoffreParametre(index)
    Menu.clearMenu()
    Menu.setTitle("Parametres")
    Menu.addItemButton(
        "<span class='red--text'>Retour</span>",
        "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png",
        "OpenCoffre",
        index
    )
    Menu.addButton("Liste des personnes avec l'accès", "CoffreListWhitelist", index)
    Menu.addButton("Donner l'accès à une personne", "CoffreAddWhitelist", index)
end

function CoffreAddWhitelist(index)
    Menu.clearMenu()
    local name = venato.OpenKeyboard("", "", 250, "Nom de la personne à whitelist")
    if name ~= "" then
        TriggerServerEvent("Coffre:CallWhitelistPlayer", index, name)
    else
        venato.notifyError("Une erreur est survenue.")
    end
end

RegisterNetEvent("Coffre:CallWhitelistPlayer:cb")
AddEventHandler(
    "Coffre:CallWhitelistPlayer:cb",
    function(data)
        if data.users ~= nil then
            for k, v in pairs(data.users) do
                Menu.addButton(
                    "Donner accès à " .. v.prenom .. " " .. v.nom,
                    "CoffreWhitelistPlayer",
                    {data.index, v.identifier}
                )
            end
        end
    end
)

function CoffreWhitelistPlayer(row)
    TriggerServerEvent("Coffre:CoffreWhitelistPlayer", row)
    Menu.close()
end

function CoffreListWhitelist(index)
    Menu.clearMenu()
    Menu.setTitle("Accès")
    Menu.addItemButton(
        "<span class='red--text'>Retour</span>",
        "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png",
        "CoffreParametre",
        index
    )
    TriggerServerEvent("Coffre:GetCoffreWhitelistPlayer", index)
end

RegisterNetEvent("Coffre:GetCoffreWhitelistPlayer:cb")
AddEventHandler(
    "Coffre:GetCoffreWhitelistPlayer:cb",
    function(data)
        for k, v in pairs(data.whitelist) do
            Menu.addButton(v.prenom .. " " .. v.nom, "unwhitelist", {v.coffreId, v.id, v.nom, v.prenom})
        end
    end
)

function unwhitelist(row)
    Menu.clearMenu()
    Menu.setTitle("Confirmer")
    Menu.addButton("Non", "CoffreListWhitelist", row[1])
    Menu.addButton("Confirmer suppression accès de " .. row[4] .. " " .. row[3], "confirmUnWhitelist", row)
end

function confirmUnWhitelist(row)
    TriggerServerEvent("Coffre:UnWhitelist", row)
    Menu.close()
end
