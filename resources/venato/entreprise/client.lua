local enterprisePDG = {}
local enterprise = {}
local defaultNotification = {
  title ="Test",
  logo = "https://img.icons8.com/officel/16/000000/bank-euro.png",
  message = "Test",
  event = true
}

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
   
    TriggerEvent('Menu:Init', config.Title, "Options", config.Color, '')
    Menu.clearMenu()
    Menu.addButton("Faire une annonce", "AnnonceMenu", idEntreprise)
    if Venato.HasJob(config.PDG) then
        if ConfigEnterprise[idEntreprise].Gang then
          Menu.addButton("Recruter un nouveau membre", "Hire", idEntreprise)
        else
          Menu.addButton("Embaucher quelqu'un", "Hire", idEntreprise)
        end

        if ConfigEnterprise[idEntreprise].Gang then
          Menu.addButton("Liste des membres", "EmployeList", idEntreprise)
        else
          Menu.addButton("Liste du personnel", "EmployeList", idEntreprise)
        end
        
    end
    Menu.open()
  end

  function AnnonceMenu(idEntreprise)
    Menu.clearMenu()
    if ConfigEnterprise[idEntreprise].Open ~= "" then
    Menu.addButton("Ouvrir", "Annonce", { idEntreprise, "", "", ConfigEnterprise[idEntreprise].Open})
    end    
    if ConfigEnterprise[idEntreprise].Close ~= "" then
    Menu.addButton("Fermer", "Annonce", { idEntreprise, "", "", ConfigEnterprise[idEntreprise].Close})
    end
    if ConfigEnterprise[idEntreprise].NotifBackground ~= "" then
    Menu.addButton("Annonce", "MakeAnnonce", idEntreprise)
    end
  end

  function MakeAnnonce(idEntreprise)    
    Menu.close()
    local title =  Venato.OpenKeyboard('', '', 35,"Titre de l'annonce")
    if title ~= '' then
      local description =  Venato.OpenKeyboard('', '', 200,"Description de l'annonce")
      if description ~= '' then
        Annonce({idEntreprise, title, description, ConfigEnterprise[idEntreprise].NotifBackground})
      else
        Venato.notifyError("Une erreur est survenue.")      
      end
    else
      Venato.notifyError("Une erreur est survenue.")      
    end    
    OpenEntrepriseMenu(idEntreprise)
  end

  function Annonce(data)
    defaultNotification.logo = data[4]
    defaultNotification.message = data[3]
    defaultNotification.title = data[2]
    defaultNotification.timeout = 20000
    defaultNotification.titleFont = ConfigEnterprise[data[1]].TitlePolice
    defaultNotification.descriptionFont = ConfigEnterprise[data[1]].MessagePolice
    defaultNotification.color = ConfigEnterprise[data[1]].Color
    Venato.notify(defaultNotification)    
  end

  function Hire(idEntreprise)
    Menu.clearMenu()
    local name = ''
    if ConfigEnterprise[idEntreprise].Gang then
      name =  Venato.OpenKeyboard('', '', 250,"Nom de la personne à recruter")
    else
      name =  Venato.OpenKeyboard('', '', 250,"Nom de la personne à embaucher")
    end
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
        if ConfigEnterprise[data.idEntreprise].Gang then
          Menu.addButton("Recruter "..v.prenom.." "..v.nom, "HirePlayer", {data.idEntreprise, v.identifier, v.prenom.." "..v.nom})
        else
          Menu.addButton("Embaucher "..v.prenom.." "..v.nom, "HirePlayer", {data.idEntreprise, v.identifier, v.prenom.." "..v.nom})
        end
      end 
    end  
    Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "OpenEntrepriseMenu", data.idEntreprise)
  end)

  function EmployeList(idEntreprise)
    TriggerServerEvent("Entreprise:ListEmployee", idEntreprise)
  end

  function HirePlayer(data)
    TriggerServerEvent("Entreprise:HirePlayer", data[1], data[2])
    for i=1, #ConfigEnterprise[data[1]].Coffres, 1 do
      TriggerServerEvent("Coffre:CoffreWhitelistPlayer", {ConfigEnterprise[data[1]].Coffres[i], data[2]})
    end
    if ConfigEnterprise[data[1]].Gang then
      data[1] = 8
      TriggerServerEvent("Entreprise:HirePlayer", data[1], data[2])
    end
  end

  function MenuEmploye(data)
    Menu.setTitle(data[3])
    Menu.clearMenu()
    if not ConfigEnterprise[data[1]].Gang then
    Menu.addButton("Verser un salaire", "PaySalaire", data)
    end
    if ConfigEnterprise[data[1]].Grade then
      Menu.addButton("Changer grade", "ChangeGrade", data)
    end
    Menu.addButton("Licencier", "Fire", data)
    Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "OpenEntrepriseMenu", data[1])
  end

  function ChangeGrade(data)
    Menu.clearMenu()
    Menu.addButton("Cadet", "NewGrade", {data, "Cadet"})
    Menu.addButton("Agent", "NewGrade", {data, "Agent"})
    Menu.addButton("Sergent", "NewGrade", {data, "Sergent"})
    Menu.addButton("Sergent-Chef", "NewGrade", {data, "Sergent-Chef"})
    Menu.addButton("Lieutenant", "NewGrade", {data, "Lieutnant"})
  end

  function NewGrade(data)
    TriggerServerEvent("Entreprise:NewGrade", data[1][2], data[2])
    Menu.close()
  end

  function PaySalaire(data)
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
    Menu.addButton("Confirmer le licenciement", "ConfirmFire", data)
    Menu.addItemButton("<span class='red--text'>Retour</span>","https://i.ibb.co/GsWgbRb/icons8-undo-96px-1.png", "OpenEntrepriseMenu", data[1])
  end

  function ConfirmFire(data)
    TriggerServerEvent("Entreprise:FirePlayer", data)
    for i=1, #ConfigEnterprise[data[1]].Coffres, 1 do
      TriggerServerEvent("Coffre:UnWhitelist", {ConfigEnterprise[data[1]].Coffres[i], data[2]})
    end
    if ConfigEnterprise[data[1]].Gang then
      data[1] = 8
      TriggerServerEvent("Entreprise:FirePlayer", data)
    end
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