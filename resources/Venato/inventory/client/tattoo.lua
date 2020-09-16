RegisterNetEvent("Inventory:RefreshTattoo:cb")
AddEventHandler(
    "Inventory:RefreshTattoo:cb",
    function(Data)
        DataUser.Tattoos = Data
    end
)
