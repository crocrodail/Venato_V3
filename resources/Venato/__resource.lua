resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

client_script {
  '/client/menu.lua',
  '/client/function.lua',
  '/inventory/client.lua'
}
server_script {
  '@mysql-async/lib/MySQL.lua',
  '/server/login.lua',
  '/server/function.lua',
  '/inventory/server.lua'
}
