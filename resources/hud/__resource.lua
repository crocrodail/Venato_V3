resource_manifest_version "05cfa83c-a124-4cfa-a768-c24a5811d8f9"

ui_page '/html/index.html'

client_script {
    'client.lua'
}

server_script {
    'server.lua'
}

files { 
    '/html/index.html',
    '/html/hud.js',
    '/html/scss/hud.css',
    '/html/scss/fonts/Circular-Bold.ttf',
    '/html/scss/fonts/Circular-Bold.woff',
    '/html/scss/fonts/Circular-Bold.woff2',
    '/html/scss/fonts/Circular-Book.ttf',
    '/html/scss/fonts/Circular-Book.woff',
    '/html/scss/fonts/Circular-Book.woff2',
}