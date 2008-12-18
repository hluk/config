-- Include awesome libraries, with lots of useful function!
require("awful")
require("beautiful")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
-- The default is a dark theme
--theme_path = "/usr/share/awesome/themes/default/theme"
theme_path = awful.util.getdir("config") .. "/mytheme"
-- Uncommment this for a lighter theme
-- theme_path = "@AWESOME_THEMES_PATH@/sky/theme"

-- Actually load theme
beautiful.init(theme_path)

-- This is used later as the default terminal and editor to run.
terminal = "urxvtc -e $HOME/screen"
editor_cmd = "gvim"
filemanager = "EDITOR=vim urxvtc -e screen mc -x"
calc = "/home/lukas/apps/speedcrunch/build/speedcrunch"
bindir = "/home/lukas/dev/bin/"
osd = "conky -c "
menu = "/home/lukas/dev/menus/"

function volumeup()
	awful.util.spawn(bindir .. "volume.sh 1%+")
end

function volumedown()
	awful.util.spawn(bindir .. "volume.sh 1%-")
end

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
history = awful.client.focus.history

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
	"max",
	"tilebottom",
	"tiletop",
	"tile",
	"tileleft",
	"fairh",
	"fairv",
	"magnifier",
	"spiral",
	"dwindle",
	"floating"
}

-- Table of clients that should be set floating. The index may be either
-- the application class or instance. The instance is useful when running
-- a console app in a terminal like (Music on Console)
floatapps =
{
	MPlayer = true,
	Smplayer = true,
	gimp = true,
	pidgin = true,
	--Conky_panel = true,
	speedcrunch = true,
	rxvtpopup = true,
	designer = true,
	Wine = true
}

-- Applications to be moved to a pre-defined tag by class or instance.
-- Use the screen and tags indices.
apptags =
{
	Firefox = { screen = 1, tag = 2 },
	Krusader = { screen = 1, tag = 3 },
	mocp = { screen = 1, tag = 4 },
	["beep-media-player-2-bin"] = { screen = 1, tag = 4 },
	pidgin = { screen = 1, tag = 3 },
	korganizer = { screen = 1, tag = 3 },
	designer = { screen = 1, tag = 5 }
}

-- Define if we want to use titlebar on all applications.
use_titlebar = false
-- }}}

-- {{{ Tags
-- Define tags table.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = {}
    -- Create 9 tags per screen.
    for tagnumber = 1, 9 do
        tags[s][tagnumber] = tag({ name = tagnumber, layout = layouts[1] })
        -- Add tags to screen one by one
        tags[s][tagnumber].screen = s
    end
    -- I'm sure you want to see at least one tag.
    tags[s][1].selected = true
end
-- }}}

-- {{{ Wibox
-- Create a laucher widget and a main menu
--myawesomemenu = {
--   { "manual", terminal .. " -e man awesome" },
--   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
--   { "restart", awesome.restart },
--   { "quit", awesome.quit }
--}

--mymainmenu = awful.menu.new({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
--                                        { "open terminal", terminal }
--                                      }
--                            })
--
--mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
--                                     menu = mymainmenu })

-- Create a systray
mysystray = widget({ type = "systray", align = "right" })

-- Create a wibox for each screen and add it
mywibox = {}
mywibox2 = {}
mypromptbox = {}
mytaglist = {}
mytaglist.buttons = { button({ }, 1, awful.tag.viewonly),
                      button({ modkey }, 1, awful.client.movetotag),
                      button({ }, 3, function (tag) tag.selected = not tag.selected end),
                      button({ modkey }, 3, awful.client.toggletag),
                      button({ }, 4, awful.tag.viewnext),
                      button({ }, 5, awful.tag.viewprev) }
mytasklist = {}
mytasklist.buttons = { button({ }, 1, function (c) client.focus = c; c:raise() end),
                       button({ }, 3, function () awful.menu.clients({ width=250 }) end),
                       button({ }, 4, function () awful.client.focus.byidx(1) end),
                       button({ }, 5, function () awful.client.focus.byidx(-1) end) }

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = widget({ type = "textbox", align = "left" })
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist.new(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist.new(function(c)
                                                  return awful.widget.tasklist.label.currenttags(c, s)
                                              end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = wibox({ position = "top", height=16, fg = beautiful.fg_normal, bg = beautiful.bg_normal })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = { mylauncher,
                           mytaglist[s],
                           mytasklist[s],
                           mypromptbox[s] }
    mywibox[s].screen = s
    
    -- Create the wibox2
    mywibox2[s] = wibox({ position = "bottom", bg = '#00000000', align="right", height=18, width=80})
    mywibox2[s].widgets = { mysystray }
    mywibox2[s].screen = s

end
-- }}}

-- {{{ Mouse bindings
awesome.buttons({
--    button({ }, 3, function () mymainmenu:toggle() end),
    button({ }, 4, awful.tag.viewnext),
    button({ }, 5, awful.tag.viewprev)
})
-- }}}

-- {{{ Key bindings

-- Bind keyboard digits
-- Compute the maximum number of digit we need, limited to 9
numkeys = {"plus", "ecaron", "scaron", "ccaron", "rcaron", "zcaron", "yacute", "aacute", "iacute"}

for i = 1, 9 do
    keybinding({ modkey }, numkeys[i],
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           awful.tag.viewonly(tags[screen][i])
                       end
                   end):add()
    keybinding({ modkey, "Control" }, numkeys[i],
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           tags[screen][i].selected = not tags[screen][i].selected
                       end
                   end):add()
    keybinding({ modkey, "Shift" }, numkeys[i],
                   function ()
                       if client.focus then
                           if tags[client.focus.screen][i] then
                               awful.client.movetotag(tags[client.focus.screen][i])
                           end
                       end
                   end):add()
    keybinding({ modkey, "Control", "Shift" }, numkeys[i],
                   function ()
                       if client.focus then
                           if tags[client.focus.screen][i] then
                               awful.client.toggletag(tags[client.focus.screen][i])
                           end
                       end
                   end):add()
end

keybinding({ modkey }, "Left", awful.tag.viewprev):add()
keybinding({ modkey }, "Right", awful.tag.viewnext):add()
keybinding({ modkey }, "Up",  function () awful.client.focus.byidx(-1) end):add()
keybinding({ modkey }, "Down", function () awful.client.focus.byidx(1) end):add()
keybinding({ modkey }, "Escape", awful.tag.history.restore):add()

-- Standard program
keybinding({ modkey }, "q", function () awful.util.spawn(terminal) end):add()
keybinding({ modkey }, "e", function () awful.util.spawn(filemanager) end):add()
keybinding({ modkey }, "c", function () awful.util.spawn(calc) end):add()
keybinding({ modkey }, "x", function () awful.util.spawn("xkill") end):add()
keybinding({ modkey }, "f", function () awful.util.spawn("firefox") end):add()
keybinding({}, "Menu", function () awful.util.spawn("$HOME/dev/invert_colors/invert") end):add()

keybinding({ modkey, "Control" }, "r", function ()
                                           mypromptbox[mouse.screen].text =
                                               awful.util.escape(awful.util.restart())
                                        end):add()
keybinding({ modkey, "Shift" }, "q", function () awful.util.spawn("~/shutdown.sh") end):add()
keybinding({ modkey, "Control" }, "e", function () awful.util.spawn("gvim $HOME/.config/awesome/rc.lua") end):add()

-- menus
keybinding({ modkey }, "r", function () awful.util.spawn(menu .. "runmenu.sh") end):add()
keybinding({ modkey }, "s", function () awful.util.spawn(menu .. "translatemenu.sh") end):add()
keybinding({ modkey }, "semicolon", function () awful.util.spawn(menu .. "vimmenu.sh") end):add()
keybinding({ modkey }, "g", function () awful.util.spawn(menu .. "gamemenu.sh") end):add()

-- mocp
keybinding({ modkey }, "p", function () awful.spawn("urxvtc -name mocp -title mocp -e mocp") end):add()
keybinding({ modkey }, "minus", function () awful.util.spawn("mocp -G") end):add()
keybinding({ modkey }, "period", function () awful.util.spawn("mocp -f") end):add()
keybinding({ modkey }, "comma", function () awful.util.spawn("mocp -r") end):add()

-- volume up/down
keybinding({ modkey }, "parenright", volumeup):add()
keybinding({ modkey }, "section", volumedown):add()

-- Client manipulation
keybinding({ modkey }, "m", awful.client.maximize):add()
keybinding({ modkey }, "Return", function () if client.focus then client.focus.fullscreen = not client.focus.fullscreen end end):add()
keybinding({ modkey, "Shift" }, "c", function () if client.focus then client.focus:kill() end end):add()
keybinding({ modkey }, "j", function () awful.client.focus.byidx(1); if client.focus then client.focus:raise() end end):add()
keybinding({ modkey }, "k", function () awful.client.focus.byidx(-1);  if client.focus then client.focus:raise() end end):add()
keybinding({ modkey, "Shift" }, "j", function () awful.client.swap.byidx(1) end):add()
keybinding({ modkey, "Shift" }, "k", function () awful.client.swap.byidx(-1) end):add()
keybinding({ modkey, "Control" }, "j", function () awful.screen.focus(1) end):add()
keybinding({ modkey, "Control" }, "k", function () awful.screen.focus(-1) end):add()
keybinding({ modkey, "Control" }, "space", awful.client.togglefloating):add()
keybinding({ modkey, "Control" }, "Return", function () if client.focus then client.focus:swap(awful.client.getmaster()) end end):add()
keybinding({ modkey }, "o", awful.client.movetoscreen):add()
keybinding({ modkey }, "u", awful.client.urgent.jumpto):add()
keybinding({ modkey, "Shift" }, "r", function () if client.focus then client.focus:redraw() end end):add()
keybinding({ modkey }, "Tab", history.previous):add()

-- Layout manipulation
keybinding({ modkey }, "l", function () awful.tag.incmwfact(0.05) end):add()
keybinding({ modkey }, "h", function () awful.tag.incmwfact(-0.05) end):add()
keybinding({ modkey, "Shift" }, "h", function () awful.tag.incnmaster(1) end):add()
keybinding({ modkey, "Shift" }, "l", function () awful.tag.incnmaster(-1) end):add()
keybinding({ modkey, "Control" }, "h", function () awful.tag.incncol(1) end):add()
keybinding({ modkey, "Control" }, "l", function () awful.tag.incncol(-1) end):add()
keybinding({ modkey }, "space", function () awful.layout.inc(layouts, 1) end):add()
keybinding({ modkey, "Shift" }, "space", function () awful.layout.inc(layouts, -1) end):add()

-- Prompt
keybinding({ modkey }, "F1", function ()
                                 awful.prompt.run({ prompt = "Run: " }, mypromptbox[mouse.screen], awful.util.spawn, awful.completion.bash,
                                                  awful.util.getdir("cache") .. "/history")
                             end):add()
keybinding({ modkey }, "F4", function ()
                                 awful.prompt.run({ prompt = "Run Lua code: " }, mypromptbox[mouse.screen], awful.util.eval, awful.prompt.bash,
                                                  awful.util.getdir("cache") .. "/history_eval")
                             end):add()

keybinding({ modkey, "Ctrl" }, "i", function ()
                                        local s = mouse.screen
                                        if mypromptbox[s].text then
                                            mypromptbox[s].text = nil
                                        elseif client.focus then
                                            mypromptbox[s].text = nil
                                            if client.focus.class then
                                                mypromptbox[s].text = "Class: " .. client.focus.class .. " "
                                            end
                                            if client.focus.instance then
                                                mypromptbox[s].text = mypromptbox[s].text .. "Instance: ".. client.focus.instance .. " "
                                            end
                                            if client.focus.role then
                                                mypromptbox[s].text = mypromptbox[s].text .. "Role: ".. client.focus.role
                                            end
                                        end
                                    end):add()

-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them
keybinding({ modkey }, "t", awful.client.togglemarked):add()

for i = 1, 9 do
    keybinding({ modkey, "Shift" }, "F" .. i,
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           for k, c in pairs(awful.client.getmarked()) do
                               awful.client.movetotag(tags[screen][i], c)
                           end
                       end
                   end):add()
end
-- }}}

-- {{{ Hooks
-- Hook function to execute when focusing a client.
awful.hooks.focus.register(function (c)--{{{
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_focus
    end
end)--}}}

-- Hook function to execute when unfocusing a client.
awful.hooks.unfocus.register(function (c)--{{{
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_normal
    end
end)--}}}

-- Hook function to execute when marking a client
awful.hooks.marked.register(function (c)--{{{
    c.border_color = beautiful.border_marked
end)--}}}

-- Hook function to execute when unmarking a client.
awful.hooks.unmarked.register(function (c)--{{{
    c.border_color = beautiful.border_focus
end)--}}}

-- Hook function to execute when the mouse enters a client.
awful.hooks.mouse_enter.register(function (c)--{{{
    -- Sloppy focus, but disabled for magnifier layout
    if awful.layout.get(c.screen) ~= "magnifier"
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)--}}}

-- Hook function to execute when a new client appears.
awful.hooks.manage.register(function (c)--{{{
    if use_titlebar then
        -- Add a titlebar
        awful.titlebar.add(c, { modkey = modkey })
    end
    -- Add mouse bindings
    c:buttons({
        button({ }, 1, function (c) client.focus = c; c:raise() end),
        button({ modkey }, 1, function (c) c:mouse_move() end),
        button({ modkey }, 3, function (c) c:mouse_resize() end)
    })
    -- New client may not receive focus
    -- if they're not focusable, so set border anyway.
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_normal
    client.focus = c

    -- Check if the application should be floating.
    local cls = c.class
    local inst = c.instance
    if floatapps[cls] then
        c.floating = floatapps[cls]
    elseif floatapps[inst] then
        c.floating = floatapps[inst]
    end

    -- Check application->screen/tag mappings.
    local target
    if apptags[cls] then
        target = apptags[cls]
    elseif apptags[inst] then
        target = apptags[inst]
    end
    if target then
        c.screen = target.screen
        awful.client.movetotag(tags[target.screen][target.tag], c)
    end
   
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- awful.client.setslave(c)

    -- Honor size hints: if you want to drop the gaps between windows, set this to false.
    -- c.honorsizehints = false
end)--}}}

-- Hook function to execute when arranging the screen.
-- (tag switch, new client, etc)
awful.hooks.arrange.register(function (screen)--{{{
    local layout = awful.layout.get(screen)

    -- Give focus to the latest client in history if no window has focus.
    if not client.focus then
	local c = history.get(screen, 0)
        if c and awful.client.focus.filter(c) then client.focus = c end
    end

    -- Uncomment if you want mouse warping
    --[[
    if client.focus then
        local c_c = client.focus:fullgeometry()
        local m_c = mouse.coords()

        if m_c.x < c_c.x or m_c.x >= c_c.x + c_c.width or
            m_c.y < c_c.y or m_c.y >= c_c.y + c_c.height then
            if table.maxn(m_c.buttons) == 0 then
                mouse.coords({ x = c_c.x + 5, y = c_c.y + 5})
            end
        end
    end
    ]]
end)--}}}

-- Hook called every second
--awful.hooks.timer.register(1, function ()
--end)
-- }}}

-- {{{ Autostart
awful.util.spawn("xrdb -merge /home/lukas/.Xresources")
awful.util.spawn("pidof urxvtd >/dev/null || urxvtd -q")
awful.util.spawn("pidof conky >/dev/null || conky")
awful.util.spawn("pidof pidgin >/dev/null || pidgin")
awful.util.spawn("pidof easystroke >/dev/null || /home/lukas/apps/easystroke/easystroke")
-- }}}

