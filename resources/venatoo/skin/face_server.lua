RegisterServerEvent('face:save')
AddEventHandler('face:save',function(data)
  local source = source
    local identifier = getSteamID(source)
    MySQL.Async.execute('update skin set face = @data WHERE identifier = @identifier', {
        ['@data'] = json.encode(data),
        ['@identifier'] = identifier
    })
end)
