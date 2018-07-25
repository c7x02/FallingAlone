--[[
    dogs.lua
    Returns photos of dogs from thedogapi.com.

    Copyright 2016 topkecleon <drew@otou.to>
    This code is licensed under the GNU AGPLv3. See /LICENSE for details.
]]--

-- local HTTP = require('socket.http')
local HTTPS = require('ssl.https')
local utilities = require('otouto.utilities')
local bindings = require('otouto.bindings')
local json = require('cjson')

local dogs = {}

function dogs:init()
    if not self.config.thedogapi_key then
        print('Missing config value: thedogapi_key.')
        print('dogs.lua will be enabled, but there are more features with a key.')
    end
    -- dogs.url = 'https://api.thedogapi.com/v1/images/search?mime_types=jpg&format'
    dogs.url = 'https://dog.ceo/api/breeds/image/random'
    if self.config.thedogapi_key then
        dogs.url = dogs.url .. '&api_key=' .. self.config.thedogapi_key
    end
    dogs.triggers = utilities.triggers(self.info.username, self.config.cmd_pat):t('dog').table
    dogs.command = 'dog'
    dogs.doc = 'Returns a dog!'
end

function dogs:action(msg)
    local str, res = HTTPS.request(dogs.url)
    local jObject = json.decode(str)
    
    if res ~= 200 then
        utilities.send_reply(msg, self.config.errors.connection)
        return
    end
    str = jObject.message
    bindings.sendPhoto{chat_id = msg.chat.id, photo = str}
end

return dogs
