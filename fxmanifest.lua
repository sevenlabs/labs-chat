fx_version 'bodacious'
game 'gta5'
author 'nano11bravo'
description 'An updated chat theme based on Chat resource for FiveM.'
url 'https://www.github.com/nano11bravo/'
version '1.0.1'
lua54 'yes'

server_script 'server/main.lua'
client_script 'client/main.lua'

dependency 'chat'

file 'theme/style.css'

chat_theme 'labs-chat' {
    styleSheet = 'theme/style.css',
    msgTemplates = {
        labsChat = '<div id="notification" class="noisy"><div id="color-box" style="background-color: {0} !important;" class="noisy"></div><div id="info"><div id="top-info"><div id="left-info"><h1 id="title"><i class="{1}"></i></h1><h2 id="sub-title">{2}</h2></div><h2 id="time">{3}</h2></div><div id="bottom-info"><br><p id="text">{4}</p></div></div>'
    }
}

exports {
    'getTimestamp'
}

