fx_version "cerulean"
game "gta5"
author "Dark-https://github.com/Collela"

client_scripts {
    "@vrp/lib/utils.lua",
    "client-side/*.lua"
}

server_scripts {
   "@vrp/lib/utils.lua",
   "server-side/*.lua"
}

ui_page "nui/menu.html"

files {
    "nui/menu.css",
    "nui/menu.html",
    "nui/menu.js",
    "nui/images/dollars.png",
    "nui/images/*",
}
