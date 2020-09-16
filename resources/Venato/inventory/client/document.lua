function optionPermis(data)
    Menu.clearMenu()
    Menu.setSubtitle("Permis de conduire")
    Menu.addItemButton(
        "<span class='red--text'>Retour</span>",
        "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png",
        "MyDoc",
        data
    )
    Menu.addButton("Regarder", "ShowPermis", data)
    Menu.addButton("Montrer", "ShowToOtherPermis", data)
end

function optionIdCard(data)
    Menu.clearMenu()
    Menu.setSubtitle("Carte d'identité")
    Menu.addItemButton(
        "<span class='red--text'>Retour</span>",
        "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png",
        "MyDoc",
        data
    )
    Menu.addButton("Regarder", "ShowIdCard", data)
    Menu.addButton("Montrer", "ShowToOtherIdCard", data)
end

function optionVisa(data)
    Menu.clearMenu()
    Menu.setSubtitle("Permis de séjour")
    Menu.addItemButton(
        "<span class='red--text'>Retour</span>",
        "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png",
        "MyDoc",
        data
    )
    Menu.addButton("Regarder", "ShowVisa", data)
    Menu.addButton("Montrer", "ShowToOtherVisa", data)
end

function ShowPermis(data)
    if papierOpen == 0 then
        papierOpen = 1
        SendNUIMessage(
            {
                action = "showIdentity",
                string = "type=permis&nom=" ..
                    data.Nom ..
                        "&prenom=" ..
                            data.Prenom ..
                                "&age=" ..
                                    data.Age ..
                                        "&sex=" ..
                                            data.Sexe .. --"&job=" .. data.NameJob ..
                                                "&id=" ..
                                                    data.Source ..
                                                        "&steam=" ..
                                                            data.SteamId ..
                                                                "&datevoiture=" ..
                                                                    data.PermisVoiture ..
                                                                        "&datecamion=" ..
                                                                            data.PermisCamion ..
                                                                                "&point=" ..
                                                                                    data.Point ..
                                                                                        "&startvisa=" ..
                                                                                            data.VisaStart ..
                                                                                                "&endvisa=" ..
                                                                                                    data.VisaEnd ..
                                                                                                        "&url=" ..
                                                                                                            venato.ConvertUrl(
                                                                                                                data.Url
                                                                                                            )
            }
        )
    else
        papierOpen = 0
        CloseDoc()
    end
end

function ShowIdCard(data)
    if papierOpen == 0 then
        papierOpen = 1
        SendNUIMessage(
            {
                action = "showIdentity",
                string = "type=identity&nom=" ..
                    data.Nom ..
                        "&prenom=" ..
                            data.Prenom ..
                                "&age=" ..
                                    data.Age ..
                                        "&sex=" ..
                                            data.Sexe ..
                                                -- "&job=" .. data.NameJob ..
                                                "&id=" ..
                                                    data.Source ..
                                                        "&steam=" ..
                                                            data.SteamId ..
                                                                "&datevoiture=" ..
                                                                    data.PermisVoiture ..
                                                                        "&datecamion=" ..
                                                                            data.PermisCamion ..
                                                                                "&point=" ..
                                                                                    data.Point ..
                                                                                        --"&startvisa=" .. data.VisaStart .. "&endvisa=" .. data.VisaEnd ..
                                                                                        "&url=" ..
                                                                                            venato.ConvertUrl(data.Url)
            }
        )
    else
        papierOpen = 0
        CloseDoc()
    end
end

function ShowVisa(data)
    if papierOpen == 0 then
        papierOpen = 1
        SendNUIMessage(
            {
                action = "showIdentity",
                string = "type=visa&nom=" ..
                    data.Nom ..
                        "&prenom=" ..
                            data.Prenom ..
                                "&age=" ..
                                    data.Age ..
                                        "&sex=" ..
                                            data.Sexe ..
                                                -- "&job=" .. data.NameJob ..
                                                "&id=" ..
                                                    data.Source ..
                                                        "&steam=" ..
                                                            data.SteamId ..
                                                                "&datevoiture=" ..
                                                                    data.PermisVoiture ..
                                                                        "&datecamion=" ..
                                                                            data.PermisCamion ..
                                                                                "&point=" ..
                                                                                    data.Point ..
                                                                                        "&startvisa=" ..
                                                                                            data.VisaStart ..
                                                                                                "&endvisa=" ..
                                                                                                    data.VisaEnd ..
                                                                                                        "&url=" ..
                                                                                                            venato.ConvertUrl(
                                                                                                                data.Url
                                                                                                            )
            }
        )
    else
        papierOpen = 0
        CloseDoc()
    end
end

function showCheque(data)
    if papierOpen == 0 then
        papierOpen = 1
        SendNUIMessage(
            {
                action = "showCheque",
                string = "&type=show&date=" ..
                    data[1].Documents[data[2]].date ..
                        "&nomprenom=" ..
                            data[1].Documents[data[2]].nom1 ..
                                " " ..
                                    data[1].Documents[data[2]].prenom1 ..
                                        "&nomprenomd=" ..
                                            data[1].Documents[data[2]].nom2 ..
                                                " " ..
                                                    data[1].Documents[data[2]].prenom2 ..
                                                        "&montant=" ..
                                                            data[1].Documents[data[2]].montant ..
                                                                "&num=" .. data[1].Documents[data[2]].numeroDeCompte
            }
        )
    else
        papierOpen = 0
        CloseDoc()
    end
end

function ShowToOtherPermis(data)
    local ClosePlayer, distance = venato.ClosePlayer()
    if ClosePlayer ~= 0 and ClosePlayer ~= nil and distance < 4 then
        TriggerServerEvent("Inventory:ShowToOtherPermis", data, ClosePlayer)
    else
        venato.notifyError("Il n'y a personne à proximité.")
    end
end

function ShowToOtherIdCard(data)
    local ClosePlayer, distance = venato.ClosePlayer()
    if ClosePlayer ~= 0 and ClosePlayer ~= nil and distance < 4 then
        TriggerServerEvent("Inventory:ShowToOtherIdCard", data, ClosePlayer)
    else
        venato.notifyError("Il n'y a personne à proximité.")
    end
end

function ShowToOtherVisa(data)
    local ClosePlayer, distance = venato.ClosePlayer()
    if ClosePlayer ~= 0 and ClosePlayer ~= nil and distance < 4 then
        TriggerServerEvent("Inventory:ShowToOtherVisa", data, ClosePlayer)
    else
        venato.notifyError("Il n'y a personne à proximité.")
    end
end

RegisterNetEvent("Inventory:ShowToOtherPermis:cb")
AddEventHandler(
    "Inventory:ShowToOtherPermis:cb",
    function(data)
        ShowPermis(data)
    end
)

RegisterNetEvent("Inventory:ShowToOtherIdCard:cb")
AddEventHandler(
    "Inventory:ShowToOtherIdCard:cb",
    function(data)
        ShowIdCard(data)
    end
)

RegisterNetEvent("Inventory:ShowToOtherVisa:cb")
AddEventHandler(
    "Inventory:ShowToOtherVisa:cb",
    function(data)
        ShowVisa(data)
    end
)

function CloseDoc()
    SendNUIMessage(
        {
            action = "showIdentity",
            string = "type=close"
        }
    )
    SendNUIMessage(
        {
            action = "showCheque",
            string = "type=close"
        }
    )
end

function MyDoc(data)
    Menu.clearMenu()
    Menu.setSubtitle("Mes Documents")
    Menu.addItemButton(
        "<span class='red--text'>Retour</span>",
        "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png",
        "OpenInventory",
        nil
    )
    if data.Citoyen == 1 then
        Menu.addItemButton("Carte d'identité", "https://i.ibb.co/V2vy2Y6/icons8-id-card-96px.png", "optionIdCard", data)
    else
        Menu.addItemButton(
            "Carte de séjour",
            "https://i.ibb.co/vm9WFHn/icons8-electronic-identity-card-96px.png",
            "optionVisa",
            data
        )
    end
    if data.PermisVoiture ~= "non aquis" or data.PermisVoiture ~= "non aquis" then
        Menu.addItemButton(
            "Permis de conduire",
            "https://i.ibb.co/D8PPnXK/icons8-driver-license-card-96px-1.png",
            "optionPermis",
            data
        )
    end
    for k, v in pairs(data.Documents) do
        if v.type == "chequier" then
            Menu.addItemButton(
                "Chéquier <span class='orange--text'>(" .. venato.FormatMoney(v.montant, 2) .. " restant)</span>",
                "https://i.ibb.co/vs3ptjz/icons8-paycheque-96px-2.png",
                "CreateCheque",
                data
            )
        end
        if v.type == "cheque" then
            Menu.addItemButton(
                "Cheque de <span class='green--text'>" .. venato.FormatMoney(v.montant, 2) .. "</span> €",
                "https://i.ibb.co/ZXZgqSF/icons8-paycheque-96px.png",
                "showCheque",
                {data, k}
            )
        end
    end
end

function CreateCheque(data)
    Menu.clearMenu()
    Menu.setSubtitle("Chèque pour la persone à proximité")
    Menu.addItemButton(
        "<span class='red--text'>Retour</span>",
        "https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png",
        "MyDoc",
        data
    )
    Menu.addButton("Donner un chèque", "CreateChequeConf", data)
end

function CreateChequeConf(data)
    local ClosePlayer, distance = venato.ClosePlayer()
    if ClosePlayer ~= 0 and ClosePlayer ~= nil and distance < 4 then
        local montant = venato.OpenKeyboard("", "", 10, "Montant du chèque")
        if montant ~= "" and tonumber(montant) ~= nil and tonumber(montant) ~= 0 then
            TriggerServerEvent("Inventory:CreateCheque", ClosePlayer, montant)
        else
            venato.notifyError("Le montant indiqué est erroné.")
        end
    else
        venato.notifyError("Il n'y a personne à proximité.")
    end
end
