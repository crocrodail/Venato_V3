local DataCoffre = {}
local isInit = false

local coffre_index = -1

RegisterNetEvent("venatoSpawn")
AddEventHandler("venatoSpawn", function()
  print("Craft:CallData")
  TriggerServerEvent("Craft:CallData")
end)


RegisterNetEvent("Craft:CallData:cb")
AddEventHandler("Craft:CallData:cb", function(CraftData)
end)



-- local commandHelp = {
--   id = "craft",
--   command = "E",
--   icon = "https://i.ibb.co/DzZxq0K/icons8-handle-with-care-48px.png",
--   text = "Fabriquer"
-- }

-- local isCommandAdded = nil;

-- local indexLoop = nil
-- Citizen.CreateThread(function()
--   while true do
--     Citizen.Wait(0)
--     local x,y,z = table.unpack(GetEntityCoords(venato.GetPlayerPed(), true))
--     for k,v in pairs(Crafts) do
--       if Vdist(x, y, z, v.x, v.y, v.z) < v.distance then
--         indexLoop = k
--       elseif k == indexLoop then
--         indexLoop = nil
--       end
--     end
--   end
-- end)

-- Citizen.CreateThread(function()
--   while true do
--     Citizen.Wait(0)
--     if indexLoop ~= nil then
--         local craft = Crafts[indexLoop];
--         if not isCommandAdded then
--           TriggerEvent('Commands:Add', commandHelp)
--           isCommandAdded = indexLoop
--         end
--       if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
--         -- venato.Craft(craft.recipeItems, craft.resultItems, craft.animLib, craft.animName, craft.animTimeout) 
--       end
--     elseif isCommandAdded then
--       TriggerEvent('Commands:Remove', commandHelp.id)
--       isCommandAdded = nil
--     end
--  end
-- end)