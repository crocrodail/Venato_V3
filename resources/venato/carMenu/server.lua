
RegisterServerEvent("CarMenu:SetSpeedmeter")
AddEventHandler(
    "CarMenu:SetSpeedmeter",
    function(source, style)
        DataPlayers[source].Speedmeter = style
        local source = source
        UpdateSpeedmeter(source, style)
    end
)

function UpdateSpeedmeter(style)    

  local source = source  
    MySQL.Sync.execute(
        "UPDATE users SET speedometer = @speedmeter WHERE identifier = @identifier",
        {
            ["@speedmeter"] = style,
            ["@identifier"] = DataPlayers[source].SteamId
        }
    )
end
