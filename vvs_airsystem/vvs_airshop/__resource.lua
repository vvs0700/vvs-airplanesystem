resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

version '1.0.0'

author 'LEAKED BY NJODA AND ROLCIKA'

description 'LEAKED BY NJODA AND ROLCIKA, ali fakat'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'config.lua',
	'client/utils.lua',
	'client/main.lua'
}

ui_page "HTML/ui.html"

files {
    "HTML/ui.html",
    "HTML/ui.css",
	"HTML/ui.js",
	"HTML/img/gore.svg",
	"HTML/img/dole.svg",
	"HTML/img/logo-big.png",
}

export 'GeneratePlate'