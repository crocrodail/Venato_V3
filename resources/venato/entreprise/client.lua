local enterprisePDG = {}
local enterprise = {}

Citizen.CreateThread(function() 
    Citizen.Wait(500)
    while true do
      Citizen.Wait(0)  
      local j = InitEnterprise()
      if IsControlJustPressed(1,168) then --F7
        if j >= 2 then
            OpenChoixMenu()
        else
            for k, v in pairs(enterprise) do
                OpenEntrepriseMenu(k)
            end
        end
      end
    end
  end)

  function InitEnterprise()
    local ped = Venato.GetPlayerPed()
    local j = 0
    -- Detect Employé    
    for k, v in pairs(employes) do
        if Venato.HasJob(k) then
            enterprise[k] = employes[k]
            j = j+1
        end
    end
    return j
  end


  function OpenChoixMenu()
    TriggerEvent('Menu:Init', "Choisir une entreprise", "Options", "#0556BD99", "https://image.shutterstock.com/image-vector/abstract-textured-polygonal-background-vector-260nw-375261961.jpg")
    Menu.clearMenu()
    for k, v in pairs(enterprise) do
        Menu.addButton(v, "OpenEntrepriseMenu", k)
    end
    Menu.open()
  end

  function OpenEntrepriseMenu(idEntreprise)
    Menu.close()
    local config = ConfigEnterprise[idEntreprise]
   
    TriggerEvent('Menu:Init', config.Title, "Options", config.Color, config.Background)
    Menu.clearMenu()
    Menu.addButton("Ouvrir/Fermer l'établissement", "OpenClose", idEntreprise)
    if Venato.HasJob(config.PDG) then
        Menu.addButton("Embaucher quelqu'un", "Hire", idEntreprise)
        Menu.addButton("Liste du personnel", "EmployeList", idEntreprise)
    end
    Menu.open()
  end

  function Hire(idEntreprise)
    Menu.clearMenu()
    local name =  Venato.OpenKeyboard('', '', 250,"Nom de la personne à embaucher")
    if name ~= '' then
      TriggerServerEvent("Entreprise:CallHirePlayer", idEntreprise , name)
    else
      Venato.notifyError("Une erreur est survenue.")      
    end
  end
  
  RegisterNetEvent("Entreprise:CallHirePlayer:cb")
  AddEventHandler("Entreprise:CallHirePlayer:cb", function(data)
    Menu.clearMenu()
    Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "OpenEntrepriseMenu", data.idEntreprise)
    if data.users ~= nil then
      for k,v in pairs(data.users) do
        Menu.addButton("Embaucher "..v.prenom.." "..v.nom, "HirePlayer", {data.idEntreprise, v.identifier, v.prenom.." "..v.nom})
      end 
    end  
    Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "OpenEntrepriseMenu", data.idEntreprise)
  end)

  function EmployeList(idEntreprise)
    TriggerServerEvent("Entreprise:ListEmployee", idEntreprise)
  end

  function HirePlayer(data)
    TriggerServerEvent("Entreprise:HirePlayer", data[1], data[2])
  end

  function MenuEmploye(data)
    Menu.setTitle(data[3])
    Menu.clearMenu()
    Menu.addButton("Verser un salaire", "Pay", data)
    Menu.addButton("Licencier", "Fire", data)
    Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "OpenEntrepriseMenu", data[1])
  end

  function Pay(data)
    Menu.clearMenu()
    local pay =  Venato.OpenKeyboard('', '', 250,"Entrez le salaire à verser")
    if pay ~= '' and tonumber(pay) > 0 then
      TriggerServerEvent("Entreprise:PayPlayer", data , tonumber(pay))
    else
      Venato.notifyError("Une erreur est survenue.")      
    end
  end

  function Fire(data)
    Menu.clearMenu()
    print(Venato.dump(data))
    Menu.addButton("Confirmer le licenciement", "ConfirmFire", data)
    Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "OpenEntrepriseMenu", data[1])
  end

  function ConfirmFire(data)
    TriggerServerEvent("Entreprise:FirePlayer", data)
  end

  RegisterNetEvent("Entreprise:ListEmployee:cb")
  AddEventHandler("Entreprise:ListEmployee:cb", function(data)
    Menu.clearMenu()
    Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "OpenEntrepriseMenu", data.idEntreprise)
    if data.users ~= nil then
      for k,v in pairs(data.users) do
        Menu.addButton(v.prenom.." "..v.nom, "MenuEmploye", {data.idEntreprise, v.identifier, v.prenom.." "..v.nom})
      end 
    end  
    Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "OpenEntrepriseMenu", data.idEntreprise)
  end)

  RegisterNetEvent("Entreprise:HirePlayer:cb")
  AddEventHandler("Entreprise:HirePlayer:cb", function(idEntreprise)
    Menu.close()
    OpenEntrepriseMenu(idEntreprise)
  end)

  RegisterNetEvent("Entreprise:FirePlayer:cb")
  AddEventHandler("Entreprise:FirePlayer:cb", function(idEntreprise)
    Menu.close()
    OpenEntrepriseMenu(idEntreprise)
  end)