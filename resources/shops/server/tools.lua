--[[
  Tools for shops

  @author Astymeus
  @date 2019-07-11
  @version 1.0
--]]

-- Wrapper for button actions
RegisterNetEvent("Menu:Execute")
AddEventHandler("Menu:Execute", function(params)
  _ = _G[params.fn] and _G[params.fn](params.args)
end)

function getIdentifiant(id)
  for _, v in ipairs(id) do
    return v
  end
end

ShopsTools = {}
function ShopsTools.getSteamID(source)
  local identifiers = GetPlayerIdentifiers(source)
  local player = getIdentifiant(identifiers)
  return player
end
