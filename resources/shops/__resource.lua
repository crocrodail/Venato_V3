resource_manifest_version "05cfa83c-a124-4cfa-a768-c24a5811d8f9"

client_script {
  "/config.lua",
  "/client/tools.lua",
  "/client/pages.lua",
  "/client/events.lua",
  "/client/client.lua"
}

server_script {
  '@mysql-async/lib/MySQL.lua',
  "/server/tools.lua",
  "/server/db.lua",
  "/server/events.lua",
  "/server/server.lua"
}
