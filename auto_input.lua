---------------------------
-- auto change input method
-- ------------------------

local alert = require "hs.alert"
local application = require "hs.application"

----------------
--This is your config
----------------
en = "com.apple.keylayout.Colemak"
zh = "com.apple.inputmethod.SCIM.Shuangpin"
en_ = "Colemak"
zh_ = " 双 拼 "

----------------------------
----------------------------

local function Chinese()
    -- shuangpin
    hs.keycodes.currentSourceID(zh)
end

local function English()
    -- Colemak
    hs.keycodes.currentSourceID(en)
end

-- app to expected ime config
local app2Ime = {
--English
    {'/Applications/Terminal.app', 'English'},
    {'/Applications/iTerm.app', 'English'},
		{'/Applications/Alfred 4.app', 'English'},
		{'/Applications/Alacritty.app', 'English'},
    {'/Applications/Visual Studio Code.app', 'English'},
    {'/Applications/MacVim.app', 'English'},
    {'/Applications/Safari.app', 'English'},
    {'/Applications/PyCharm.app', 'English'},
    {'/System/Library/CoreServices/Finder.app', 'English'},
--Chinese
    {'/Applications/WeChat.app', 'Chinese'},
    {'/Applications/QQ.app', 'Chinese'},
    {'/Applications/Microsoft Word.app', 'Chinese'},
    {'/Applications/Messages.app', 'Chinese'},
}

function updateFocusAppInputMethod(appObject)
    local ime = 'English'
    local focusAppPath = appObject:path()
    for index, app in pairs(app2Ime) do
        local appPath = app[1]
        local expectedIme = app[2]

        if focusAppPath == appPath then
            ime = expectedIme
            break
        end
    end

    if ime == 'English' then
        English()
				alert.show(en_)
    else
        Chinese()
				alert.show(zh_)
    end
end

-- helper hotkey to figure out the app path and name of current focused window
-- 当选中某窗口按下ctrl+command+.时会显示应用的路径等信息
hs.hotkey.bind({'ctrl', 'cmd'}, ".", function()
    hs.alert.show("App path:        "
    ..hs.window.focusedWindow():application():path()
    .."\n"
    .."App name:      "
    ..hs.window.focusedWindow():application():name()
    .."\n"
    .."BundleID:    "
    ..hs.window.focusedWindow():application():bundleID()
    .."\n"
    .."IM source id:  "
    ..hs.keycodes.currentSourceID())
end)

-----------------------------------
--auto show input method when change source
-----------------------------------
function inputchange()
		if hs.keycodes.currentSourceID() == en then
			alert.show(en_)
		elseif hs.keycodes.currentSourceID() == zh then
			alert.show(zh_)
		end
end


-- Handle cursor focus and application's screen manage.
-- 窗口激活时自动切换输入法
function applicationWatcher(appName, eventType, appObject)
    if eventType == hs.application.watcher.activated then
        updateFocusAppInputMethod(appObject)
				-- alert.show(hs.keycodes.currentLayout())
		else
				hs.keycodes.inputSourceChanged(inputchange)
    end
end

appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()
