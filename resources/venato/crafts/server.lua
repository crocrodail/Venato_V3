CraftsTables = {}
Recipes = {}

recipeInit = false
craftTableInit = false

function reloadDataCraftRecipe()
    Citizen.CreateThread(function()
        local start_time = os.clock()
        MySQL.Async.fetchAll("SELECT CR.id, CR.label, CR.animLib, CR.animName, CR.animTimeout, cri.item_id, i.picture, i.libelle, cri.quantity FROM craft_recipe CR INNER JOIN craft_recipe_ingredents cri on CR.id = cri.recipe_id INNER JOIN items i on cri.item_id = i.id", {}, function(result)
            if result[1] ~= nil then
                for k,v in pairs(result) do 
                    if not Recipes[v.id] then                  
                        Recipe = {
                        ["id"] = v.id,
                        ["label"] = v.label,
                        ["animLib"] = v.animLib,
                        ["animName"] = v.animName,
                        ["animTimeout"] = v.animTimeout,
                        ["ingredients"] = {nil},
                        ["results"] = {nil},
                        } 
                        Recipes[v.id] = Recipe           
                    end
                    Recipes[v.id].ingredients[v.item_id] = {
                        ["libelle"] = v.libelle,
                        ["picture"] = v.picture,
                        ["quantity"] = v.quantity
                    }
                end                
                local start_time2 = os.clock()
                MySQL.Async.fetchAll("SELECT CR.id, crr.item_id, i.picture, i.libelle, crr.quantity FROM craft_recipe CR INNER JOIN craft_recipe_result crr on CR.id = crr.recipe_id INNER JOIN items i on crr.item_id = i.id", {}, function(result)
                    if result[1] ~= nil then
                        for k,v in pairs(result) do
                            Recipes[v.id].results[v.item_id] = {
                                ["libelle"] = v.libelle,
                                ["picture"] = v.picture,
                                ["quantity"] = v.quantity
                            }              
                        end                        
                    end                    
                    local end_time2 = os.clock()    
                    print("^2Craft Recipes Result Loaded :^7 "..round((end_time2-start_time2),2).."ms") 
                    local end_time = os.clock()    
                    print("^2Craft Recipes Loaded :^7 "..round((end_time-start_time),2).."ms")            
                    reloadDataCraft();
                end)
            end
        end)        
    end)
end

function reloadDataCraft()
    Citizen.CreateThread(function()
        local start_time = os.clock()
        MySQL.Async.fetchAll("SELECT * FROM craft_table", {}, function(result)
            if result[1] ~= nil then
                for k,v in pairs(result) do                    
                    Table = {
                    ["id"] = v.id,
                    ["positionX"] = v.positionX,
                    ["positionY"] = v.positionY,
                    ["positionZ"] = v.positionZ,
                    ["distance"] = v.distance,
                    ["recipes"] = {nil},
                    }
                    CraftsTables[v.id] = Table                    
                end
                craftTableInit = true
                MySQL.Async.fetchAll("SELECT * FROM craft_table_recipe", {}, function(result)
                    if result[1] ~= nil then
                        for k,v in pairs(result) do
                            CraftsTables[v.craft_table_id].recipes[v.craft_recipe_id] = Recipes[v.craft_recipe_id]                
                        end                        
                    end
                    recipeInit = true
                    local end_time = os.clock()    
                    print("^2Craft Loaded :^7 "..round((end_time-start_time),2).."ms")
                end)
            end
        end)        
    end)
end

reloadDataCraftRecipe();

RegisterNetEvent("Craft:CallData")
AddEventHandler("Craft:CallData", function()
    source = source
    if recipeInit == true and craftTableInit == true then
        TriggerClientEvent("Craft:CallData:cb",source, CraftsTables, Recipes)  
    end
end)     