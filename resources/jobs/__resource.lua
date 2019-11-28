resource_manifest_version "05cfa83c-a124-4cfa-a768-c24a5811d8f9"

client_script {
  '@platypus/client/function.lua',
  '@platypus/client/menu.lua',
  '/main/config.lua',
  '/delivery/config.lua',
  '/main/client/tools.lua',
  '/main/client/events.lua',
  '/main/client/client.lua',
  '/delivery/client/client.lua',
  '/delivery/client/events.lua',
  '/lsmc/ambulancier_client.lua',
  '/lsmc/ambulancier_Menu.lua',
  '/mecano/mecano_client.lua',
  '/mecano/mecano_Menu.lua',
  '/taxi/taxi_client.lua',
  '/taxi/taxi_Menu.lua',
  '/vigneron/vigneron_client.lua',
  '/vigneron/vigneron_config.lua',
  '/pompiste/pompiste_client.lua',
  '/pompiste/pompiste_config.lua',
  '/brasseur/brasseur_client.lua',
  '/brasseur/brasseur_config.lua'
}

server_script {
  '@mysql-async/lib/MySQL.lua',
  '/main/config.lua',
  '/delivery/config.lua',
  '/main/server/server.lua',
  '/main/server/events.lua',
  '/main/server/db.lua',
  '/delivery/server/server.lua',
  '/delivery/server/events.lua',
  '/delivery/server/db.lua',
  '/lsmc/ambulancier_server.lua',
  '/mecano/mecano_server.lua',
  '/taxi/taxi_server.lua',
  '/vigneron/vigneron_server.lua',
  '/vigneron/vigneron_config.lua',
  '/pompiste/pompiste_server.lua',
  '/pompiste/pompiste_config.lua',
  '/brasseur/brasseur_server.lua',
  '/brasseur/brasseur_config.lua'
}
