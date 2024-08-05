fx_version("cerulean")
author("Koid Development")
game("gta5")
lua54("yes")

shared_scripts({
	"config.lua",
})

client_scripts({
	"src/client/*.lua",
})

ui_page("src/web/index.html")

files({
	"src/web/img/logo.png",
	"src/web/index.html",
	"src/web/style.css",
	"src/web/script.js",
	"src/web/font/bankgothic.ttf",
})
