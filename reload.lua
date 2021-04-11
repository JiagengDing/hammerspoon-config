-- auto reload config

local alert = require "hs.alert"
local hotkey = require "hs.hotkey"

function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
-- hs.alert.show("Config loaded")

-- alt + R reload
hotkey.bind("alt", "R", function() hs.reload() end)
alert.show("🤓.🛠.🤓, config succesfully")
