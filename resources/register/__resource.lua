ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/style.css',
	'html/script.js',
	'html/cursor.png'
}

client_script {
	"client.lua"
}
server_script '@mysql-async/lib/MySQL.lua'
server_script "server.lua"

