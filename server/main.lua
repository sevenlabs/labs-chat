local svConfig = {}

-- Configuration
 svConfig.versionChecker = true -- Version Checker
 svConfig.supportChecker = true -- Support Checker (If you use exports, it is recommended that you leave this on)

-- Script
AddEventHandler('onResourceStart', function(resourceName)
    updateLogFile('Resource Started')
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    if GetCurrentResourceName() ~= 'labs-chat' and svConfig.supportChecker == true then
        print('^6[Warning]^0 For better support, it is recommended that "'..GetCurrentResourceName().. '" be renamed to "labs-chat"')
    end
    if svConfig.versionChecker == true then
        PerformHttpRequest('https://api.github.com/repos/sevenlabs/labs-chat/releases/latest', function (err, data, headers)
            if data == nil then
                print('An error occurred while checking the version. Your firewall may be blocking access to "github.com". Please check your firewall settings and ensure that "github.com" is allowed to establish connections.')
                return
            end
            local data = json.decode(data)
            if data.tag_name ~= 'v'..GetResourceMetadata(GetCurrentResourceName(), 'version', 0) then
                print('\n^1================^0')
                print('^1Labs Chat ('..GetCurrentResourceName()..') is outdated!^0')
                print('Current version: (^1v'..GetResourceMetadata(GetCurrentResourceName(), 'version', 0)..'^0)')
                print('Latest version: (^2'..data.tag_name..'^0) '..data.html_url)
                print('Release notes: '..data.body)
                print('^1================^0')
            end
        end, 'GET', '')
    end
end)

AddEventHandler('chatMessage', function(source, author, message)
    local formattedMessage = author .. ': ' .. message
    updateLogFile(formattedMessage)
end)

function updateLogFile(v)
    if LoadResourceFile(GetCurrentResourceName(), 'chat_log.log') == nil then
        SaveResourceFile(GetCurrentResourceName(), 'chat_log.log', '')
    end
    local logFile = LoadResourceFile(GetCurrentResourceName(), 'chat_log.log')
    local logFile = logFile .. os.date("[%H:%M:%S] ") .. v .. '\n'
    SaveResourceFile(GetCurrentResourceName(), 'chat_log.log', logFile)
end

-- Antispam System (Beta)
local users = {}
function checkSpam(source, message)
    local BlockedStatus = false

    -- Checks if the user has sent a message before
    if users[source] == nil then
        users[source] = {time = os.time()}
        return false
    end

    -- Check if the user has sent messages too quickly
    if os.time() - users[source].time < 2 then
        BlockedStatus = true
    end

    -- Check if the message is a repeat of the last message
    if message == users[source].lastMessage then
        BlockedStatus = true
    end

    -- Update the user's information in the table
    users[source] = {lastMessage = message, time = os.time()}

    return BlockedStatus
end

exports('checkSpam', checkSpam)