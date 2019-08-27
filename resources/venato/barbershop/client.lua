--
-- User: KRIS
-- Date: 21/05/2017
-- Time: 12:57
--

--------- CREATE SKIN OBJECT ---------
skinChooser =  {}
skinChooser.__index = skinChooser
function skinChooser:create()
    -- our new object
    local self = {}
    -- make Account handle lookup
    setmetatable(self,skinChooser)

    self.hair                       = 0
    self.hair_color                 = 0
    self.beard                      = 0
    self.beard_color                = 0
    self.eyebrows                   = 0
    self.eyebrows_color             = 0
    self.makeup                     = 0
    self.lipstick                   = 0
    self.lipstick_color             = 0

    self.hair_price_selected            = 0
    self.hair_color_price_selected      = 0
    self.beard_price_selected           = 0
    self.beard_color_price_selected     = 0
    self.eyebrows_price_selected        = 0
    self.eyebrows_color_price_selected  = 0
    self.makeup_price_selected          = 0
    self.makeup_opacity_price_selected  = 0
    self.lipstick_price_selected        = 0
    self.lipstick_color_price_selected  = 0
    return self
end

local hair_price            = 250
local hair_color_price      = 150
local beard_price           = 250
local beard_color_price     = 150
local eyebrows_price        = 250
local eyebrows_color_price  = 150
local makeup_price          = 250
local makeup_opacity_price  = 150
local lipstick_price        = 250
local lipstick_color_price  = 150

--------------- VARS -----------------
local new_skin      = skinChooser:create()
local spacebetween  = "        "
local barbersStores = {
    { ['x'] = 1210.57580566406, ['y'] = -473.20849609375, ['z'] = 66.2178421020508, ['markerWidth'] = 6.0001,  ['activationDist'] = 5.5},
    { ['x'] = -33.4022, ['y'] = -151.078, ['z'] = 57.007, ['markerWidth'] = 6.0001,  ['activationDist'] = 3.5 },
    { ['x'] = -1284.36450195313, ['y'] = -1118.19641113281, ['z'] = 7.00012540817261, ['markerWidth'] = 6.0001,  ['activationDist'] = 5.5},
    { ['x'] = 136.758850097656, ['y'] = -1709.80529785156, ['z'] = 29.3015365600586, ['markerWidth'] = 6.0001,  ['activationDist'] = 5.5},
    { ['x'] = 1933.10852050781, ['y'] = 3729.515625,   ['z'] = 32.8533821105957, ['markerWidth'] = 5.0001,  ['activationDist'] = 5.5},
    { ['x'] = 1864.4403076172, ['y'] = 3747.3469238281, ['z'] = 33.031894683838, ['markerWidth'] = 6.0001,  ['activationDist'] = 5.5 },
    { ['x'] = -293.516662597656, ['y'] = 6199.3486328125, ['z'] = 31.4879970550537, ['markerWidth'] = 6.0001,  ['activationDist'] = 5.5}
}

----------------------------------------------------- HELPERS ----------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

function freeze(freeze)
    local player = PlayerId()
    local ped = GetPlayerPed(player)
    if not freeze then

        if not IsPedInAnyVehicle(ped) then
     --       SetEntityCollision(ped, true)
        end
        FreezeEntityPosition(ped, false)
        SetPlayerInvincible(player, false)
    else
      --  SetEntityCollision(ped, false)
        FreezeEntityPosition(ped, true)
        SetPlayerInvincible(player, true)
    end
end

function DrawMarkers(d, markerType, markerColorRed, markerColorGreen, markerColorBlue, markerAlpha)
    -- drawMarker(type, posX, posY, posZ, dirX, dirY, dirZ, rotX, rotY, rotZ, scaleX, scaleY, scaleZ, colorR, colorG, colorB, alpha, bobUpAndDown, faceCamera, p19, rotate, textureDict, textureName, drawOnEnts);
    DrawMarker(markerType, d.x, d.y, d.z - 1, 0, 0, 0, 0, 0, 0, d.markerWidth, d.markerWidth, d.markerWidth, 1.5001, markerColorRed, markerColorGreen, markerColorBlue,markerAlpha, 0,0, 0,0)
end

function setMapMarkers(stores, blipIcon, blipColor, blipName)
    for k,v in ipairs(stores)do
        local blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(blip, blipIcon)
        SetBlipColour(blip, blipColor)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(blipName)
        EndTextCommandSetBlipName(blip)
    end
end

function ShowNotification(text)
  local notif = {
    title= "Hair' Max",
    type = "info", --  danger, error, alert, info, success, warning
    logo = "https://icon-library.net/images/salon-icon-png/salon-icon-png-0.jpg",
    message = text,
  }
  TriggerEvent("Venato:notify", notif)
end

------------------------------------------------------ LISTENERS -------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent('barber:getOldSkinFromServer')
AddEventHandler('barber:getOldSkinFromServer', function(skin)
    new_skin.hair           = skin.hair
    new_skin.hair_color     = skin.hair_color
    new_skin.beard          = skin.beard
    new_skin.beard_color    = skin.beard_color
    new_skin.eyebrows       = skin.eyebrows
    new_skin.eyebrows_color = skin.eyebrows_color
    new_skin.makekup        = skin.makekup
    new_skin.makekup_opacity= skin.makekup_opacity
    new_skin.lipstick       = skin.lipstick
    new_skin.lipstick_color = skin.lipstick_color
end)

RegisterNetEvent('barber:closeMenu')
AddEventHandler('barber:closeMenu', function(status)
    freeze(false)
    Menu.hidden = true
    if status.transaction then
        ShowNotification(' Vous avez payé '..status.price..'€')
    else
        ShowNotification(" Vous n'avez pas assez d'argent !")
    end
    TriggerServerEvent('skin:loadSkinAndPosition')
end)

Citizen.CreateThread(function()
    setMapMarkers(barbersStores, 71, 21, "Hair' Max - Coiffure / Barbe")
    while true do
        Citizen.Wait(0)
        local pos = GetEntityCoords(GetPlayerPed(-1), false)
        for _,d in ipairs( barbersStores )do
            if Vdist(d.x, d.y, d.z, pos.x, pos.y, pos.z) < 20.0 then
                DrawMarkers(d, 71, 255, 255, 0, 155)
            end
            if(Vdist(d.x, d.y, d.z, pos.x, pos.y, pos.z) < d.activationDist ) then
                SetTextComponentFormat("STRING")
                AddTextComponentString("Appuyez sur la touche ~INPUT_CONTEXT~ pour ouvrir le magasin.")
                DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            end
            if(IsControlJustPressed(1, 51) and Vdist(d.x, d.y, d.z, pos.x, pos.y, pos.z) <  d.activationDist ) then
                TriggerServerEvent('barber:getOldSkin', source)
                clearAllProperties()

                new_skin = skinChooser:create()
                BarberShopMenu() -- Menu to draw
                Menu.toggle()
            end
        end
    end
end)

------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------- MENU ---------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

function BarberShopMenu()
  TriggerEvent('Menu:Init', "Hair' Max", "Categories", '#FB28EF99', "https://fotomelia.com/wp-content/uploads/edd/2015/11/banque-d-images-gratuites-libres-de-droits711-1560x490.jpg")
    Menu.setTitle("Hair' Max")
    Menu.setSubtitle("Bienvenue")
    local price =  new_skin.hair_price_selected
            + new_skin.hair_color_price_selected
            + new_skin.eyebrows_price_selected
            + new_skin.eyebrows_color_price_selected
            + new_skin.beard_price_selected
            + new_skin.beard_color_price_selected
            + new_skin.makeup_price_selected
            + new_skin.makeup_opacity_price_selected
            + new_skin.lipstick_price_selected
            + new_skin.lipstick_color_price_selected

    Menu.clearMenu()
    Menu.addButton("Coupe de cheveux       - prix : ".. hair_price+hair_color_price.." €", "hairCutMenu", nil)
    Menu.addButton("Coupe des sourcils     - prix : ".. eyebrows_price+eyebrows_color_price.." €", "eyebrowsMenu", nil)
    Menu.addButton("Coupe de la barbe      - prix : ".. beard_price+beard_color_price.." €", "beardCutMenu", nil)
    Menu.addButton("Maquillage             - prix : ".. makeup_price+makeup_opacity_price.." €", "makeupMenu", nil)
    Menu.addButton("Rouge à lèvres         - prix : ".. lipstick_price+lipstick_color_price.." €", "lipstickMenu", nil)
    Menu.addButton("Payer"..spacebetween..""..tostring(price).." €", "barberPayMenu", price)
end

------------------------------------------------------ HAIR ------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

------------ HAIRCUT ---------
function hairCutMenu()
    Menu.setSubtitle("Coupe")
    Menu.clearMenu()
    Menu.addButton("Retour", "BarberShopMenu", nil)
    for i = 0, GetNumberOfPedDrawableVariations(GetPlayerPed(-1), 2) -1 do
        if i ~= new_skin.hair then
            Menu.addButton("Coupe n°"..i.."     - prix : ".. hair_price.." €", "hairCutMenuAction", {id = i, price = hair_price}, "hairCutMenuSelected")
        else
            Menu.addButton("Coupe n°"..i..spacebetween.." ACTUEL", "hairCutMenuAction", {id = i, price = 0}, "hairCutMenuSelected")
        end
    end
    Menu.addButton("Retour", "BarberShopMenu", nil)
end
function hairCutMenuSelected(item)
    SetPedComponentVariation(GetPlayerPed(-1), 2, item.id, 0, 0)
end
function hairCutMenuAction(item)
    new_skin.hair = item.id
    new_skin.hair_price_selected = item.price
    hairColorMenu()
end

----------- HAIR COLOR ----------
function hairColorMenu()

    Menu.setSubtitle("Couleur")
    Menu.clearMenu()
    Menu.addButton("Retour", "BarberShopMenu", nil)
    for i = 0,  GetNumHairColors() do
        if i ~= new_skin.hair_color then
            Menu.addButton("Couleur n°"..i.."     - prix : ".. hair_color_price.." €", "hairColorMenuAction", {id = i, price = hair_color_price}, "hairColorMenuSelected")
        else
            Menu.addButton("Couleur n°"..i..spacebetween.." ACTUEL", "hairColorMenuAction", {id = i, price = 0}, "hairColorMenuSelected")
        end
    end
    Menu.addButton("Retour", "BarberShopMenu", nil)
end
function hairColorMenuSelected(item)
    SetPedHairColor(GetPlayerPed(-1), item.id,4)
end
function hairColorMenuAction(item)
    SetPedHairColor(GetPlayerPed(-1), item.id,4)
    new_skin.hair_color = item.id
    new_skin.hair_color_price_selected = item.price
    BarberShopMenu()
end

------------------------------------------------------ EYEBROWS --------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

------------ HAIRCUT ---------
function eyebrowsMenu()
    Menu.setSubtitle("Sourcils")
    Menu.clearMenu()
    Menu.addButton("Retour", "BarberShopMenu", nil)
    for i = 0, GetNumHeadOverlayValues(2) do
        if i ~= new_skin.eyebrows then
            Menu.addButton("Forme n°"..i.."     - prix : ".. eyebrows_price.." €", "eyeBrowsMenuAction", {id = i, price = eyebrows_price}, "eyeBrowsMenuSelected")
        else
            Menu.addButton("Forme n°"..i..spacebetween.." ACTUEL", "eyeBrowsMenuAction", {id = i, price = 0}, "eyeBrowsMenuSelected")
        end
    end
    Menu.addButton("Retour", "BarberShopMenu", nil)
end
function eyeBrowsMenuSelected(item)
    SetPedHeadOverlay(GetPlayerPed(-1),  2,  item.id, 1.0)
end
function eyeBrowsMenuAction(item)
    new_skin.eyebrows = item.id
    new_skin.eyebrows_price_selected = item.price
    eyebrowsColorMenu()
end

----------- HAIR COLOR ----------
function eyebrowsColorMenu()

    Menu.setSubtitle("Couleur des sourcils")
    Menu.clearMenu()
    Menu.addButton("Retour", "BarberShopMenu", nil)
    for i = 0,  GetNumHairColors() do
        if i ~= new_skin.eyebrows_color then
            Menu.addButton("Couleur n°"..i.."     - prix : ".. eyebrows_color_price.." €", "eyeBrowsColorMenuAction", {id = i, price = eyebrows_color_price}, "eyeBrowsColorMenuSelected")
        else
            Menu.addButton("Couleur n°"..i..spacebetween.." ACTUEL", "eyeBrowsColorMenuAction", {id = i, price = 0}, "eyeBrowsColorMenuSelected")
        end
    end
    Menu.addButton("Retour", "BarberShopMenu", nil)
end
function eyeBrowsColorMenuSelected(item)
    SetPedHeadOverlay(GetPlayerPed(-1),  2,  new_skin.eyebrows, 1.0)
    SetPedHeadOverlayColor(GetPlayerPed(-1),  2, 1,item.id, 1.0 )
end
function eyeBrowsColorMenuAction(item)
    new_skin.eyebrows_color = item.id
    new_skin.eyebrows_color_price_selected = item.price
    BarberShopMenu()
end

-------------------------------------------------------- BEARD ---------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

---------- CUT -----------
function beardCutMenu()

    Menu.setSubtitle("Barbe")
    Menu.clearMenu()
    Menu.addButton("Retour", "BarberShopMenu", nil)
    for i = 0, GetNumHeadOverlayValues(1) do
        if i ~= new_skin.beard then
            Menu.addButton("Coupe n°"..i.."     - prix : ".. beard_price.." €", "beardCutMenuAction", {id = i, price = beard_price}, "beardCutMenuSelected" )
        else
            Menu.addButton("Coupe n°"..i..spacebetween.." ACTUEL", "beardCutMenuAction", {id = i, price = 0}, "beardCutMenuSelected")
        end
    end
    Menu.addButton("Retour", "BarberShopMenu", nil)
end
function beardCutMenuSelected(item)
    SetPedHeadOverlay(GetPlayerPed(-1),  1,  item.id,  (item.id / 10) + 0.0)
    SetPedHeadOverlayColor(GetPlayerPed(-1),  1,  1,  1, 1)
end
function beardCutMenuAction(item)
    new_skin.beard = item.id
    new_skin.beard_price_selected = item.price
    beardColorMenu()
end

------- BEARD COLOR -------
function beardColorMenu()
    Menu.setSubtitle("Couleur de la barbe")
    Menu.clearMenu()
    Menu.addButton("Retour", "BarberShopMenu", nil)
    for i = 0, GetNumHairColors() do
        if i ~= new_skin.beard_color then
            Menu.addButton("Couleur n°"..i.."     - prix : ".. beard_color_price.." €", "beardColorMenuAction", {id = i, price = beard_color_price}, "beardColorMenuSelected")
        else
            Menu.addButton("Couleur n°"..i..spacebetween.." ACTUEL", "beardColorMenuAction", {id = i, price = 0}, "beardColorMenuSelected")
        end
    end
    Menu.addButton("Retour", "BarberShopMenu", nil)
end
function beardColorMenuSelected(item)
    SetPedHeadOverlay(GetPlayerPed(-1),  1,  new_skin.beard ,  (new_skin.beard  / 10) + 0.0)
    SetPedHeadOverlayColor(GetPlayerPed(-1),  1,  1,  item.id, 1.0)
end
function beardColorMenuAction(item)
    new_skin.beard_color = item.id
    new_skin.beard_color_price_selected = item.price
    BarberShopMenu()
end

------------------------------------------------------ MAKEUP ----------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

------- MAKEUP  -------
function makeupMenu()
    Menu.setSubtitle("Maquillage")
     Menu.clearMenu()
    Menu.addButton("Retour", "BarberShopMenu", nil)
    for i = 0, GetNumHairColors() do
        if i ~= new_skin.makeup then
            Menu.addButton("Couleur n°"..i.."     - prix : ".. makeup_price.." €", "makeupMenuAction", {id = i, price = makeup_price}, "makeupMenuSelected")
        else
            Menu.addButton("Couleur n°"..i..spacebetween.." ACTUEL", "makeupMenuAction", {id = i, price = 0}, "makeupMenuSelected")
        end
    end
    Menu.addButton("Retour", "BarberShopMenu", nil)
end
function makeupMenuSelected(item)
    SetPedHeadOverlay(GetPlayerPed(-1), 4, item.id, 1.0)
end
function makeupMenuAction(item)
    new_skin.makeup = item.id
    new_skin.makeup_price_selected = item.price
    makeupOpacityMenu()
end

---------- MAKEUP OPACITY -----------
function makeupOpacityMenu()
    Menu.setSubtitle("Opacite du Maquillage")
    Menu.clearMenu()
    Menu.addButton("Retour", "BarberShopMenu", nil)
    for i = 0, 10 do
        if i ~= new_skin.makeup_opacity then
            Menu.addButton("Couleur n°"..i.."     - prix : ".. makeup_opacity_price.." €", "makeupOpacityMenuAction", {id = i, price = makeup_opacity_price}, "makeupOpacityMenuSelected")
        else
            Menu.addButton("Couleur n°"..i..spacebetween.." ACTUEL", "makeupOpacityMenuAction", {id = i, price = 0}, "makeupOpacityMenuSelected")
        end
    end
    Menu.addButton("Retour", "BarberShopMenu", nil)
end
function makeupOpacityMenuSelected(item)

    SetPedHeadOverlay(GetPlayerPed(-1), 4, new_skin.makeup, item.id / 10)
end
function makeupOpacityMenuAction(item)
    new_skin.makeup_opacity = item.id
    new_skin.makeup_opacity_price_selected = item.price
    BarberShopMenu()
end

------------------------------------------------------ LIPSTICK --------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

------- LIPSTICK  -------
function lipstickMenu()
    Menu.setSubtitle("Rouge à lèvres")
    Menu.clearMenu()
    Menu.addButton("Retour", "BarberShopMenu", nil)
    for i = 0, GetNumHairColors() do
        if i ~= new_skin.lipstick then
            Menu.addButton("Couleur n°"..i.."     - prix : ".. lipstick_price.." €", "lipstickMenuAction", {id = i, price = lipstick_price}, "lipstickMenuSelected")
        else
            Menu.addButton("Couleur n°"..i..spacebetween.." ACTUEL", "lipstickMenuAction", {id = i, price = 0}, "lipstickMenuSelected")
        end
    end
    Menu.addButton("Retour", "BarberShopMenu", nil)
end
function lipstickMenuSelected(item)
    SetPedHeadOverlay(GetPlayerPed(-1), 8, item.id, 1.0)
end
function lipstickMenuAction(item)
    new_skin.lipstick = item.id
    new_skin.lipstick_price_selected = item.price
    lipstickColorMenu()
end

---------- LIPSTICK COLOR -----------
function lipstickColorMenu()
    Menu.setSubtitle("Couleur rouge à lèvres")
    Menu.clearMenu()
    Menu.addButton("Retour", "BarberShopMenu", nil)
    for i = 0,  GetNumHairColors() do
        if i ~= new_skin.makeup_opacity then
            Menu.addButton("Couleur n°"..i.."     - prix : ".. lipstick_color_price.." €", "lipstickColorMenuAction", {id = i, price = lipstick_color_price}, "lipstickColorMenuSelected")
        else
            Menu.addButton("Couleur n°"..i..spacebetween.." ACTUEL", "lipstickColorMenuAction", {id = i, price = 0}, "lipstickColorMenuSelected")
        end
    end
    Menu.addButton("Retour", "BarberShopMenu", nil)
end
function lipstickColorMenuSelected(item)
    SetPedHeadOverlayColor(GetPlayerPed(-1), 8, 1, item.id, 1.0)
end
function lipstickColorMenuAction(item)
    new_skin.lipstick_color = item.id
    new_skin.lipstick_color_price_selected = item.price
    BarberShopMenu()
end

------------------------------------------------------ PAY EVENT -------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

function barberPayMenu(price)
    TriggerServerEvent('barber:pay', price, new_skin)
    Menu.toggle()
end

function clearAllProperties()
    ClearPedProp(GetPlayerPed(-1),0)
    ClearPedProp(GetPlayerPed(-1),1)
    ClearPedProp(GetPlayerPed(-1),2)
    SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0)
end
