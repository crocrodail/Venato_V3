fx_version 'bodacious'
game 'gta5'


ui_page 'html/index.html'

files {
	'html/index.html',
	'html/static/css/app.css',
	'html/static/js/app.js',
	'html/static/js/manifest.js',
	'html/static/js/vendor.js',
	'html/static/img/tattoo_shop.png',

	'html/static/config/config.json',	

}

client_script {
	"config.lua",
	"client/client.lua",
}

server_script {
	'@mysql-async/lib/MySQL.lua',
	"config.lua",
	"server/server.lua",
}
