resource_manifest_version "05cfa83c-a124-4cfa-a768-c24a5811d8f9"

client_script {
  '/main/config.lua',
  '/delivery/config.lua',
  '/main/client/tools.lua',
  '/main/client/events.lua',
  '/main/client/client.lua',
  '/delivery/client.lua',
}

server_script {
  '@mysql-async/lib/MySQL.lua',
  '/main/config.lua',
  '/main/server/server.lua',
  '/main/server/events.lua',
  '/main/server/db.lua',
  '/delivery/server.lua',
}
