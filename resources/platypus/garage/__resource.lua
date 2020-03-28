client_script "client.lua"
server_script '@VNT_ScriptCoreplatypus/sfunction.lua'
server_script "@mysql-async/lib/MySQL.lua"
client_script '@VNT_ScriptCoreplatypus/menu.lua'
client_script 'table.lua'
server_script "server.lua"

export 'GetBlacklistedList'
export 'GetBalancedList'
export 'GetBalancedCatList'
