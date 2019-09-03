local players = {}
local serverEssenceArray = {}
local StationsPrice = {}

local defaultNotification = {
	type = "alert",
	title ="Station Service",
	logo = "https://i.ibb.co/61pT4gN/icons8-gas-station-96px.png"
  }

RegisterServerEvent("essence:addPlayer")
AddEventHandler("essence:addPlayer", function()
	local _source = source
	TriggerClientEvent("essence:sendPrice", _source, StationsPrice)
	table.insert(players,_source)
end)


RegisterServerEvent("essence:playerSpawned")
AddEventHandler("essence:playerSpawned", function()
	local _source = source
	SetTimeout(2000, function()
		TriggerClientEvent("essence:sendPrice", _source, StationsPrice)
	end)
end)

AddEventHandler("playerDropped", function(reason)
	local _source = source
	local newPlayers = {}
	
	for _,k in pairs(players) do
		if(k~=_source) then
			table.insert(newPlayers, k)
		end
	end

	players = {}
	players = newPlayers
end)


RegisterServerEvent("essence:setToAllPlayerEscense")
AddEventHandler("essence:setToAllPlayerEscense", function(essence, vplate, vmodel)
	local _source = source
	local bool, ind = searchByModelAndPlate(vplate, vmodel)
	if(bool and ind ~= nil) then
		serverEssenceArray[ind].es = essence
	else
		if(vplate ~=nil and vmodel~=nil and essence ~=nil) then
			table.insert(serverEssenceArray,{plate=vplate,model=vmodel,es=essence})
		end
	end
end)


RegisterServerEvent("essence:buy")
AddEventHandler("essence:buy", function(amount, index, e)
	local _source = source


	local price = StationsPrice[index]

	if(e) then
		price = index
	end

	TriggerEvent("es:getPlayerFromId", _source,function(user)

		local toPay = round(amount*price,2)
		if(toPay >= user.getMoney()) then
			TriggerClientEvent("showErrorNotif", _source, "You don't have enought money.")
		else
			user.removeMoney(toPay)
			TriggerClientEvent("essence:hasBuying", _source, amount)
		end
	end)
	
end)


RegisterServerEvent("essence:requestPrice")
AddEventHandler("essence:requestPrice",function()
	TriggerClientEvent("essence:sendPrice", source, StationsPrice)
end)


RegisterServerEvent("vehicule:getFuel")
AddEventHandler("vehicule:getFuel", function(plate,model)
	local _source = source
	local bool, ind = searchByModelAndPlate(plate, model)

	if(bool) then
		TriggerClientEvent("vehicule:sendFuel", _source, 1, serverEssenceArray[ind].es)
	else
		TriggerClientEvent("vehicule:sendFuel", _source, 0, 0)
	end
end)


RegisterServerEvent("advancedFuel:setEssence_s")
AddEventHandler("advancedFuel:setEssence_s", function(percent, vplate, vmodel)
	local bool, ind = searchByModelAndPlate(vplate, vmodel)

	local percentToEs = (percent/100)*0.142

	if(bool) then
		serverEssenceArray[ind].es = percentToEs
	else
		table.insert(serverEssenceArray,{plate=vplate,model=vmodel,es=percentToEs})
	end
end)

RegisterServerEvent("essence:buyCan")
AddEventHandler("essence:buyCan", function()
	local _source = source
	local toPay = petrolCanPrice	
	local paymentCB = Venato.paymentCB(_source, toPay)
	if(paymentCB.status) then
		TriggerClientEvent("essence:buyCan", _source)
	else
		defaultNotification.message = paymentCB.message;
		Venato.notify(_source, defaultNotification);
	end
end)

RegisterServerEvent("essence:refuel:check")
AddEventHandler("essence:refuel:check", function(data)
	local _source = source
	local stationPrice = data.stationNumber == -1 and 2 or StationsPrice[data.stationNumber]
	local toPay = round(stationPrice * data.liter,0)
	local paymentCB = Venato.paymentCB(_source, toPay)
	if paymentCB.status then
		defaultNotification.message = "Distribution en cours ... <br/> Vous avez payé <span class='green--text'>"..toPay.."€</span>"
		Venato.notify(_source, defaultNotification);
		TriggerClientEvent("essence:refuel:ok", _source, data.liter)
	else
		defaultNotification.message = paymentCB.message;
		Venato.notify(_source, defaultNotification);
		TriggerClientEvent("essence:refuel:ko", _source)		
	end
end)


function round(num, dec)
  local mult = 10^(dec or 0)
  return math.floor(num * mult + 0.5) / mult
end


function renderPrice()
    for i=0,34 do
        if(randomPrice) then
            StationsPrice[i] = math.random(15,50)/100
        else
        	StationsPrice[i] = price
        end
    end
end


renderPrice()

function searchByModelAndPlate(plate, model)

	if(plate ~= nil and model ~= nil) then
		for i,k in pairs(serverEssenceArray) do
			if(k.plate == plate and k.model == model) then
				return true, i
			end
		end
	end

	return false, -1
end
