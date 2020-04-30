Crafts = {
    { nom = 'un joint', x= -64.606,  y = 62.401,  z = -78.061, distance = 0.5, recipeItems = {[29] = 1}, resultItems = {[8] = 1}, animLib = "missheistfbisetup1", animName = "unlock_enter_janitor", animTimeout = 3333 },
}

local indexLoop = nil
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local x,y,z = table.unpack(GetEntityCoords(venato.GetPlayerPed(), true))
    for k,v in pairs(Crafts) do
      if Vdist(x, y, z, v.x, v.y, v.z) < v.distance then
        indexLoop = k
      elseif k == indexLoop then
        indexLoop = nil
      end
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if indexLoop ~= nil then
        local craft = Crafts[indexLoop];
      venato.InteractTxt('Appuyez sur ~INPUT_PICKUP~ pour fabriquer '..craft.nom..'.')
      if IsControlJustPressed(1, Keys['INPUT_CONTEXT']) and GetLastInputMethod(2) then
        venato.Craft(craft.recipeItems, craft.resultItems, craft.animLib, craft.animName, craft.animTimeout) 
      end
    end
 end
end)