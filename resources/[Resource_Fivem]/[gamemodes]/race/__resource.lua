resource_type 'gametype' { name = 'Race' }

dependencies {
    "mapmanager"
}

client_script 'race_client.lua'
server_script 'race_server.lua'
