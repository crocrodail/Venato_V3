
RegisterServerEvent("CarMenu:SetSpeedmeter")
AddEventHandler("CarMenu:SetSpeedmeter",function(style)
  local source = source
  DataPlayers[tonumber(source)].Speedmeter = style
  UpdateSpeedmeter(source, style)
end)

function UpdateSpeedmeter(style)
  local source = source
    MySQL.Sync.execute(
        "UPDATE users SET speedometer = @speedmeter WHERE identifier = @identifier",
        {
            ["@speedmeter"] = style,
            ["@identifier"] = DataPlayers[tonumber(source)].SteamId
        }
    )
end
