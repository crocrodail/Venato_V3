DataCoffre = {}

function reloadDataCoffre()
  Citizen.CreateThread(function()
    DataCoffre = {}
    local start_time = os.clock()
    local Cof = {}
    local inCof = {}   
    
    MySQL.Async.fetchAll("SELECT coffres.*, coffre_pack.Capacite, coffre_pack.ArgentMax, coffre_pack.QtyWeapon FROM coffres JOIN coffre_pack ON coffres.Pack = coffre_pack.Id", {}, function(result)
      if result[1] ~= nil then
        for k,v in pairs(result) do
          Cof = {
            ["id"] = v.Id,
            ["nom"] = v.Nom,
            ["description"] = v.Description,
            ["x"] = v.PositionX,
            ["y"] = v.PositionY,
            ["z"] = v.PositionZ,
            ["h"] = v.PositionH,
            ["pack"] = v.Pack,
            ["argent"] = v.Argent,
            ["red"] = v.CouleurRouge,
            ["green"] = v.CouleurVert,
            ["blue"] = v.CouleurBleu,
            ["showname"] = v.showname,
            ["nbItems"] = 0,
            ["nbWeapon"] = 0,
            ["itemcapacite"] = v.Capacite,
            ["argentcapacite"] = v.ArgentMax,
            ["maxWeapon"] = v.QtyWeapon,
            ["props"] = v.props,
            ["instance"] = v.instance,
            ["inventaire"] = {nil},
            ["weapon"] = {nil},
            ["whitelist"] = {nil}
          }
          DataCoffre[v.Id] = Cof          
        end

        MySQL.Async.fetchAll("SELECT * FROM coffres_contenu JOIN items ON coffres_contenu.ItemId = items.id", {}, function(resultContenu)          
          if resultContenu[1] ~= nil then
            for k2,v2 in pairs(resultContenu) do
              inCof = {            
                ["coffreId"] = v2.CoffreId,
                ["itemsId"] = v2.ItemId,
                ["libelle"] = v2.libelle,
                ["quantity"] = math.floor(v2.Quantity),
                ["uPoid"] = v2.poid,
                ["picture"] = v2.picture
              }      
              DataCoffre[v2.CoffreId].inventaire[v2.ItemId] = inCof
              DataCoffre[v2.CoffreId].nbItems = DataCoffre[v2.CoffreId].nbItems + math.floor(v2.Quantity)
            end            
          end
          MySQL.Async.fetchAll("SELECT CW.Id, CW.CoffreId, W.libelle, CW.balles, W.poids, W.id as weaponId, W.weapon_id FROM coffres_weapons CW JOIN weapon W ON CW.Weapon = W.id", {}, function(resultweapon)
            if resultweapon[1] ~= nil then
              local qtyWp = 0
              Citizen.Wait(100)
              for k3,v3 in pairs(resultweapon) do
                CofWp = {
                  ["weaponId"] = v3.weaponId,
                  ["weaponModel"] = v3.weapon_id,
                  ["libelle"] = v3.libelle,
                  ["balles"] = math.floor(v3.balles),
                  ["poids"] = v3.poids
                }
                DataCoffre[v3.CoffreId].weapon[v3.Id] = CofWp
                DataCoffre[v3.CoffreId].nbWeapon = DataCoffre[v3.CoffreId].nbWeapon + 1
              end 
            end          
            local end_time = os.clock()    
            print("^2Coffre Loaded :^7 "..round((end_time-start_time),2).."ms")
            TriggerClientEvent('Coffre:CallData:init', -1, DataCoffre)
          end)
        end)
      end      
    end)
  end)
end

RegisterServerEvent("Coffre:CallData")
AddEventHandler("Coffre:CallData", function()
  source = source
  TriggerClientEvent("Coffre:CallData:cb",source, DataCoffre, DataPlayers[tonumber(source)])
end)

RegisterServerEvent("Coffre:ReloadCoffre")
AddEventHandler("Coffre:ReloadCoffre", function()
  reloadDataCoffre()
end)