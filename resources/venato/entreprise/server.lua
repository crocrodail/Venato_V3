local defaultNotification = {
  title ="Entrepise",
  logo = "https://i.ibb.co/CMFQmq2/icons8-briefcase-96px.png"
}

RegisterServerEvent("Entreprise:CallHirePlayer")
AddEventHandler("Entreprise:CallHirePlayer", function(idEntreprise, name)
  
  local source = source
  local users = {}
  MySQL.Async.fetchAll("SELECT * FROM users WHERE CONCAT(nom,prenom) LIKE '%"..name.."%' AND identifier NOT IN (SELECT UserId FROM user_job WHERE JobId = "..idEntreprise..")", {}, function(result)
    if result ~= nil then
      for k,v in pairs(result) do
        users[v.identifier] = {
          ["identifier"] = v.identifier,
          ["nom"] = v.nom,
          ["prenom"] = v.prenom
        }
      end
      TriggerClientEvent("Entreprise:CallHirePlayer:cb", source, {idEntreprise= idEntreprise, users = users})
    end  
  end)
  
end)

RegisterServerEvent("Entreprise:NewGrade")
AddEventHandler("Entreprise:NewGrade", function(identifier, grade)
  MySQL.Async.execute("UPDATE police SET `rank` = @grade WHERE identifier = @identifier", {    
    ["@grade"] = grade,
    ["@identifier"] = identifier,
  })
end)


RegisterServerEvent("Entreprise:ListEmployee")
AddEventHandler("Entreprise:ListEmployee", function(idEntreprise, name)
  
  local source = source
  local users = {}
  MySQL.Async.fetchAll("SELECT * FROM user_job INNER JOIN users ON user_job.UserId = users.identifier WHERE user_job.JobId = "..idEntreprise, {}, function(result)
    if result ~= nil then
      for k,v in pairs(result) do
        users[v.identifier] = {
          ["identifier"] = v.identifier,
          ["nom"] = v.nom,
          ["prenom"] = v.prenom
        }
      end
      TriggerClientEvent("Entreprise:ListEmployee:cb", source, {idEntreprise= idEntreprise, users = users})
    end  
  end)
  
end)

RegisterServerEvent("Entreprise:HirePlayer")
AddEventHandler("Entreprise:HirePlayer", function(idEntreprise, identifier)  
  local source = source
  if not ConfigEnterprise[idEntreprise].Gang then
    if Venato.CheckChomage(identifier) then
      Venato.RemoveChomage(identifier)
    end  
  end

  if (idEntreprise == 2) then
    MySQL.Async.execute("INSERT INTO police(`identifier`, `rank`) VALUES (@identifier, 'Cadet')", {    
        ["@identifier"] = identifier,
    })
  end

  TriggerEvent("Venato:AddJob", idEntreprise, identifier)
  TriggerClientEvent("Entreprise:HirePlayer:cb", source, idEntreprise)
end)

RegisterServerEvent("Entreprise:FirePlayer")
AddEventHandler("Entreprise:FirePlayer", function(data)  
  local source = source
  if not ConfigEnterprise[data[1]].Gang then  
    if Venato.NbJob(data[2]) <= 1 then
      Venato.AddChomage(data[2])
    end  
  end
  
  if (idEntreprise == 2) then
    MySQL.Async.execute("DELETE FROM police WHERE identifier = @identifier", {    
        ["@identifier"] = data[2],
    })
  end
  
  TriggerEvent("Venato:RemoveJob", data)
  TriggerClientEvent("Entreprise:FirePlayer:cb", source, data[1])
end)

RegisterServerEvent("Entreprise:PayPlayer")
AddEventHandler("Entreprise:PayPlayer", function(data, pay)  
  local source = source
  local date = os.date("%Y/%m/%d")
  local enterpriseName = ConfigEnterprise[data[1]].Title
  MySQL.Async.execute("INSERT INTO user_document (`identifier`, `type`, `nom`, `prenom`, `montant`, `numero_de_compte`, `nom_du_factureur`,`prenom_du_factureur`, `date`) VALUES (@identifier, @type, @nom, @prenom, @montant, @numero_de_compte, @nom_du_factureur, @prenom_du_factureur, @date)",
    {
      ["@identifier"] = data[2],
      ["@type"] = "cheque",
      ["@nom"] = enterpriseName,
      ["@prenom"] = "",
      ["@montant"] = pay,
      ["@numero_de_compte"] = "Entreprise",
      ["@nom_du_factureur"] = enterpriseName,
      ["@prenom_du_factureur"] = "",
      ["@date"] = date,
    }, function(cheque)
      defaultNotification.message = "Vous avez payer " .. pay .. " € de salaire à "..data[3].."."
      TriggerClientEvent('Venato:notify', source, defaultNotification)
      TriggerClientEvent("Entreprise:HirePlayer:cb", source, data[1])
      MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier",{["@identifier"]=data[2]}, function(result)
        if result[1] ~= nil then
            if result[1].source ~= 'disconnect' then
              defaultNotification.message = "Vous avez reçu " .. pay .. " € de salaire de la part de "..enterpriseName.."."
              TriggerClientEvent('Venato:notify', source, defaultNotification)
              print(cheque[1])
              print(Venato.dump(cheque))
              DataPlayers[result[1].source].Documents[cheque[1]] = cheque
            end
        end
      end)
    end)
  
end)