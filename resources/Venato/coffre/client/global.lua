DataCoffre = {}
DataUser = {}
local isInit = false

coffre_index = -1

local defaultNotification = {
    title = "Coffre",
    type = "alert",
    logo = "https://i.ibb.co/Sn8gqHX/icons8-safe-96px.png"
}

local commandHelp = {
    id = "coffre",
    command = "E",
    icon = "https://i.ibb.co/Sn8gqHX/icons8-safe-96px.png",
    text = "Ouvrir le coffre"
}

local isCommandAdded = nil
local indexLoop = nil

Citizen.CreateThread(
    function()
        TriggerServerEvent("Coffre:CallData")
        TriggerServerEvent("Coffre:ReloadCoffre")
        while true do
            local dataPlayer = venato.GetDataPlayer()
            Citizen.Wait(0)
            local x, y, z = table.unpack(GetEntityCoords(venato.GetPlayerPed(), true))
            for k, v in pairs(DataCoffre) do
                Citizen.Wait(0)
                if Vdist(x, y, z, v.x, v.y, v.z) < (v.props ~= nil and 2 or 0.5) and v.instance == dataPlayer.Instance then
                    indexLoop = k
                elseif k == indexLoop then
                    indexLoop = nil
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(0)
            if indexLoop ~= nil then
                if not isCommandAdded then
                    commandHelp.text = "Ouvrir " .. DataCoffre[indexLoop].nom
                    TriggerEvent("Commands:Add", commandHelp)
                    isCommandAdded = indexLoop
                end
                if IsControlJustPressed(1, Keys["E"]) and GetLastInputMethod(2) then
                    TriggerServerEvent("Coffre:CheckWhitelist", indexLoop)
                    coffre_index = indexLoop
                end
            elseif isCommandAdded then
                TriggerEvent("Commands:Remove", commandHelp.id)
                isCommandAdded = nil
            end
        end
    end
)

RegisterNetEvent("Coffre:Open")
AddEventHandler(
    "Coffre:Open",
    function(id)
        OpenCoffre(id)
    end
)

RegisterNetEvent("venatoSpawn")
AddEventHandler(
    "venatoSpawn",
    function()
        TriggerServerEvent("Coffre:CallData")
    end
)

RegisterNetEvent("Coffre:CallData:cb")
AddEventHandler(
    "Coffre:CallData:cb",
    function(Coffre, user)
        DataCoffre = Coffre
        DataUser = user or {}
        if coffre_index > 0 then
            TriggerEvent("Menu:Clear")
            TriggerEvent(
                "Menu:Init",
                DataCoffre[coffre_index].nom,
                "Coffre",
                "rgba(" ..
                    DataCoffre[coffre_index].red ..
                        "," .. DataCoffre[coffre_index].green .. "," .. DataCoffre[coffre_index].blue .. ", 0.75)",
                "https://cap.img.pmdstatic.net/fit/http.3A.2F.2Fprd2-bone-image.2Es3-website-eu-west-1.2Eamazonaws.2Ecom.2Fcap.2F2017.2F05.2F09.2F1c21c36a-b809-4662-bf09-1068218410b9.2Ejpeg/750x375/background-color/ffffff/quality/70/fichet-bauche-la-success-story-du-roi-du-coffre-fort-1123519.jpg"
            )
            Menu.setTitle(DataCoffre[coffre_index].nom)
            Menu.setSubtitle("Coffre :")
            TriggerEvent(
                "Menu:AddButton2",
                "Parametres",
                "CoffreParametre",
                coffre_index,
                "",
                "https://i.ibb.co/cQmJ84r/icons8-administrative-tools-96px.png"
            )

            if DataCoffre[coffre_index].argentcapacite ~= 0 then
                TriggerEvent(
                    "Menu:AddButton2",
                    venato.FormatMoney(DataCoffre[coffre_index].argent, 2) ..
                        "€ / " .. venato.FormatMoney(DataCoffre[coffre_index].argentcapacite, 2) .. "€",
                    "CoffreMenuMoney",
                    coffre_index,
                    "",
                    "https://i.ibb.co/rZfQxnn/icons8-banknotes-96px.png"
                )
            end

            if DataCoffre[coffre_index].maxWeapon ~= 0 then
                TriggerEvent(
                    "Menu:AddButton2",
                    "Armes",
                    "CoffreWeapon",
                    coffre_index,
                    "",
                    "https://i.ibb.co/xfFb7R6/icons8-gun-96px.png"
                )
            end

            if DataCoffre[coffre_index].itemcapacite ~= 0 then
                TriggerEvent(
                    "Menu:AddButton2",
                    "Déposer des objets",
                    "CoffreAddItem",
                    coffre_index,
                    "",
                    "https://i.ibb.co/CQjDCTX/icons8-safe-in-96px-1.png"
                )
                for k, v in pairs(DataCoffre[coffre_index].inventaire) do
                    if v.quantity ~= 0 then
                        TriggerEvent(
                            "Menu:AddShopButton",
                            v.libelle,
                            "CoffreTakeItem",
                            {coffre_index, k},
                            v.picture,
                            v.quantity,
                            "",
                            true
                        )
                    end
                end
            end
            TriggerEvent("Menu:CreateMenu")
            TriggerEvent("Menu:Open")
        end
    end
)

RegisterNetEvent("Coffre:CallData:init")
AddEventHandler(
    "Coffre:CallData:init",
    function(Coffre)
        DataCoffre = Coffre        
        for k, v in pairs(DataCoffre) do       
            if v.props ~= nil then
                RequestModel(v.props)
                while not HasModelLoaded(v.props) do
                    Wait(1)
                end

                local coffre = CreateObject(GetHashKey(v.props), v.x, v.y, v.z, true, true, false)
                SetEntityHeading(coffre, v.h)
                PlaceObjectOnGroundProperly(coffre)
                SetEntityAsMissionEntity(coffre, true, true)
                FreezeEntityPosition(coffre, true)
                SetModelAsNoLongerNeeded(v.props)

                if (v.instance) then
                    TriggerServerEvent("instance:addEntity", v.instance, NetworkGetNetworkIdFromEntity(coffre))
                end
            end
        end
    end
)

function OpenCoffre(index)
    TriggerEvent("Menu:Close")
    Menu.clearMenu()
    coffre_index = index
    TriggerServerEvent("Coffre:CallData")
    Citizen.Wait(0)
end
