resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

version '1.0.6'

client_scripts {
	'@es_extended/locale.lua',
	'client/misc.lua',
	'client/main.lua',
	'locales/en.lua',
	'config.lua'
}

server_scripts {
	'@es_extended/locale.lua',
	'server/main.lua',
	'locales/en.lua',
	'config.lua'
}

--### Requirements
--* es_extended
--* esx_billing
--* esx_skin
--* skinchanger