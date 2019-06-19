resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'


ui_page 'bank/html/index.html'

client_script {
  '/client/menu.lua',
  '/client/function.lua',
  '/inventory/client.lua',
  '/bank/client.lua',
  '/bank/config.lua'
}
server_script {
  '@mysql-async/lib/MySQL.lua',
  '/server/login.lua',
  '/server/function.lua',
  '/inventory/server.lua',
  '/bank/server.lua'
}

files {
	'bank/html/assets/images/fleeca.png',
	'bank/html/assets/images/blaine.png',
	'bank/html/assets/images/pacific.png',
	'bank/html/assets/images/background.png',
	'bank/html/assets/images/button.png',
	'bank/html/assets/images/button_active.png',
	'bank/html/assets/images/button_cancel.png',
	'bank/html/assets/images/button_cancel_active.png',
	'bank/html/assets/images/button_done.png',
	'bank/html/assets/images/button_done_active.png',
	'bank/html/assets/images/button_wrong.png',
	'bank/html/assets/images/button_wrong_active.png',
	'bank/html/assets/images/card.png',
	'bank/html/assets/images/cardflash.gif',
	'bank/html/assets/images/code_background.png',
	'bank/html/assets/images/error.png',
	'bank/html/assets/images/loading.png',
	'bank/html/assets/images/logo.png',
	'bank/html/assets/images/money.gif',
	'bank/html/assets/images/receipt.gif',
	'bank/html/assets/images/welcome.png',
	'bank/html/assets/images/welcome_code.png',
	'bank/html/assets/sounds/click.ogg',
	'bank/html/assets/sounds/insert.ogg',
	'bank/html/assets/sounds/money.ogg',
	'bank/html/assets/sounds/error.ogg',
	'bank/html/assets/fonts/roboto/Roboto-Bold.woff',
	'bank/html/assets/fonts/roboto/Roboto-Bold.woff2',
	'bank/html/assets/fonts/roboto/Roboto-Light.woff',
	'bank/html/assets/fonts/roboto/Roboto-Light.woff2',
	'bank/html/assets/fonts/roboto/Roboto-Medium.woff',
	'bank/html/assets/fonts/roboto/Roboto-Medium.woff2',
	'bank/html/assets/fonts/roboto/Roboto-Regular.woff',
	'bank/html/assets/fonts/roboto/Roboto-Regular.woff2',
	'bank/html/assets/fonts/roboto/Roboto-Thin.woff',
	'bank/html/assets/fonts/roboto/Roboto-Thin.woff2',
	'bank/html/assets/css/materialize.min.css',
	'bank/html/assets/css/style.css',
	'bank/html/assets/css/bank.css',
	'bank/html/assets/js/jquery.js',
	'bank/html/assets/js/materialize.js',
	'bank/html/assets/js/init.js',
	'bank/html/assets/js/bank.js',
	'bank/html/index.html',
	'bank/html/bank.html',
}
