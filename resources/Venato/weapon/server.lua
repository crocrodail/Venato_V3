RegisterServerEvent("Weapon:UpdateAmmo")
AddEventHandler(
  "Weapon:UpdateAmmo",
  function(weapon, ammo, NewSource)
    local source = source
    if NewSource ~= nil then
      source = NewSource
    end

    local identifier = DataPlayers[tonumber(source)].SteamId
    MySQL.Async.fetchScalar(
      "SELECT uw.id FROM user_weapons uw INNER JOIN weapon w ON uw.weapon = w.id WHERE uw.identifier = @identifier AND w.weapon_hash = @weapon",
      {["@identifier"] = identifier, ["@weapon"] = string.upper(weapon)},
      function(result)
        DataPlayers[tonumber(source)].Weapon[result].ammo = ammo
      end
    )
    MySQL.Async.execute(
      "UPDATE user_weapons uw  INNER JOIN weapon w ON uw.weapon = w.id  SET uw.balles = @ammo  WHERE uw.identifier = @index AND w.weapon_hash = @weapon",
      {["@ammo"] = ammo, ["@index"] = identifier, ["@weapon"] = string.upper(weapon)}
    )
  end
)
