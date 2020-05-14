CraftsTables = {}
Recipes = {}
local isInit = false

local coffre_index = -1

RegisterNetEvent("Craft:CallData:cb")
AddEventHandler("Craft:CallData:cb", function(tables, recipes)  
  CraftsTables = tables
  Recipes = recipes
  isInit = true
end)


local commandHelp = {
  id = "craft",
  command = "E",
  icon = "https://i.ibb.co/DzZxq0K/icons8-handle-with-care-48px.png",
  text = "Fabriquer"
}

local isCommandAdded = nil;

local indexLoop = nil

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if isInit then
      local x,y,z = table.unpack(GetEntityCoords(venato.GetPlayerPed(), true))
      for k,v in pairs(CraftsTables) do
        if Vdist(x, y, z, v.positionX, v.positionY, v.positionZ) < v.distance then
          indexLoop = k
        elseif k == indexLoop then
          indexLoop = nil
        end
      end     
    else
      TriggerServerEvent("Craft:CallData")
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if indexLoop ~= nil then
        local craft = CraftsTables[indexLoop];
        if not isCommandAdded then
          TriggerEvent('Commands:Add', commandHelp)
          isCommandAdded = indexLoop
        end
      if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
        CreateMenuCraft(indexLoop)        
      end
    elseif isCommandAdded then
      TriggerEvent('Commands:Remove', commandHelp.id)
      isCommandAdded = nil      
      TriggerEvent('Menu:Close')
    end
 end
end)


function CreateMenuCraft(index)
  TriggerEvent('Menu:Clear')
  TriggerEvent('Menu:Init', "Établie", "Choisir une recette", 'rgba(46,125,50, 0.75)', "https://i.ibb.co/NtgnGgq/etabli-en-hetre-massif-equipe-dune-presse-de-menuisier-plateau-de-160-m.png")
  for k,v in pairs(CraftsTables[index].recipes) do
    ingredients = ''
    results = ''
    results_image = ''
    index = 0
    for k1,v1 in pairs(v.ingredients) do
      ingredients = ingredients ..v1.quantity .. ' ' ..v1.libelle
      if index < #v.ingredients then
        ingredients = ingredients .. ', '
        index = index + 1
      end
    end
    index = 0
    for k1,v1 in pairs(v.results) do
      results = v1.quantity .. ' ' ..v1.libelle
      if(results_image == '') then
        results_image = v1.picture
      end
      if index < #v.results then
        results = results .. ', '
        index = index + 1
      end
    end
    TriggerEvent('Menu:AddShopButton', results, "CallCraft", {craftTable = index+1, recipe = k}, results_image, ingredients, 0)
  end
  TriggerEvent('Menu:CreateMenu')
  TriggerEvent('Menu:Open')
end

function CallCraft(data)
  venato.Craft(CraftsTables[data.craftTable].recipes[data.recipe]) 
end