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

ShopsTools = {}
function ShopsTools.OpenKeyboard(title, defaultText, maxlength, TextEntrynote)
  local TextEntry = TextEntrynote
  AddTextEntry('FMMC_MPM_NA', TextEntry)
  DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", defaultText or "", "", "", "", maxlength or 20)
  while (UpdateOnscreenKeyboard() == 0) do
    DisableAllControlActions(0);
    Wait(0);
  end
  if (GetOnscreenKeyboardResult()) then
    return GetOnscreenKeyboardResult()
  end
  return nil
end
