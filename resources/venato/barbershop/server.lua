------------------------------------------------------- HELPERS --------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

function getPlayerID(source)
    return DataPlayers[source].SteamId
end


------------------------------------------------------ LISTENERS -------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

local notif = {
    title= "Coiffeur",
    logo = "https://i.ibb.co/mTQr11C/icons8-barbershop-96px.png",
    message = "",
} 

RegisterServerEvent("barber:getOldSkin")
AddEventHandler("barber:getOldSkin", function()
	trigger = source

        local players    = getPlayerID(trigger)
        local skin      = getCurrentSkin(players)

		MySQL.Async.fetchAll("SELECT * FROM skin WHERE `identifier` = @username", {['@username'] = player}, function(outfits)
		local outfitsList = {}

					TriggerClientEvent('barber:getOldSkinFromServer', trigger, outfits)
		end)
end)

RegisterServerEvent('barber:pay')
AddEventHandler('barber:pay', function(price, newSkin)
	trigger = source
    local paymentCB = exports.venato:ExportPaymentCB(trigger, price)
        if paymentCB.status then
            TriggerClientEvent('barber:closeMenu', trigger, {transaction = true, price = price})
            TriggerEvent('barber:saveHeadSkin', getPlayerID(trigger), {
                hair = newSkin.hair or nil,
                hair_color= newSkin.hair_color or nil,
				        eyebrows = newSkin.eyebrows or nil,
                eyebrows_color= newSkin.eyebrows_color or nil,
                beard = newSkin.beard or nil,
                beard_color = newSkin.beard_color or nil,
                lipstick = newSkin.lipstick or nil,
                lipstick_color = newSkin.lipstick_color or nil,
                makeup = newSkin.makeup or nil,
                makeup_opacity = newSkin.makeup_opacity or nil
            })
            notif.message = "Vous avez payé <span class='green--text'>"..price.."€</span> au coiffeur."
            TriggerClientEvent("Venato:notify", source, notif)   
        else  
            notif.message = paymentCB.status
            TriggerClientEvent("Venato:notify", source, notif)          
            TriggerClientEvent('barber:closeMenu', trigger, {transaction = false, price = price})
        end
end)

RegisterServerEvent("barber:saveHeadSkin")
AddEventHandler('barber:saveHeadSkin', function(player, newSkin)
    if newSkin.hair then
        saveHeadSkin(player, { type = 'hair', val = newSkin.hair })
    end
    if newSkin.hair_color then
        saveHeadSkin(player, { type = 'hair_color', val = newSkin.hair_color })
    end
	if newSkin.eyebrows then
        saveHeadSkin(player, { type = 'eyebrows', val = newSkin.eyebrows })
    end
    if newSkin.eyebrows_color then
        saveHeadSkin(player, { type = 'eyebrows_color', val = newSkin.eyebrows_color })
    end
    if newSkin.beard then
        saveHeadSkin(player, { type = 'beard', val = newSkin.beard })
    end
    if newSkin.beard_color then
        saveHeadSkin(player, { type = 'beard_color', val = newSkin.beard_color })
    end
    if newSkin.makeup then
        saveHeadSkin(player, { type = 'makeup', val = newSkin.makeup })
    end
    if newSkin.makeup_opacity then
        saveHeadSkin(player, { type = 'makeup_opacity', val = newSkin.makeup_opacity })
    end
    if newSkin.lipstick then
        saveHeadSkin(player, { type = 'lipstick', val = newSkin.lipstick })
    end
    if newSkin.lipstick_color then
        saveHeadSkin(player, { type = 'lipstick_color', val = newSkin.lipstick_color })
    end
    TriggerClientEvent('bs:notifs', source, "Nouveau skin enregistré!")
end)

------------------------------------------------------ FUNCTIONS -------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

function getCurrentSkin(player)
    local skin = MySQL.Async.fetchAll("SELECT * FROM skin WHERE `identifier` = @username", {['@username'] = player})
    if skin then
        return skin
    end

end

function saveHeadSkin(player,skin)
    MySQL.Async.execute("UPDATE skin SET "..skin.type.."=@a WHERE `identifier`=@id",
        {
            ['@id'] = player,
            ['@a']  = tonumber(skin.val)
        })
end
