client_script "client.lua"
server_script '@VNT_ScriptCorevenato/sfunction.lua'
server_script "@mysql-async/lib/MySQL.lua"
client_script '@VNT_ScriptCorevenato/menu.lua'
client_script 'table.lua'
server_script "server.lua"

export 'GetBlacklistedList'
export 'GetBalancedList'
export 'GetBalancedCatList'
