require("awful")
require("beautiful")
require('naughty')

-- THEME
theme_path = awful.util.getdir("config") .. "/mytheme"
beautiful.init(theme_path)

-- move mouse to corner
mouse.coords({x=0,y=1200})

-- {{{ Variable definitions
--theme_path = "/usr/share/awesome/themes/default/theme"

-- Defaul apps and paths
terminal = "urxvtc -geometry 141x57 -e $HOME/screen"
editor_cmd = "gvim"
filemanager = "(cd ~/down; EDITOR=vim urxvtc -e screen mc -x)"
calc = "/home/lukas/apps/speedcrunch/build/speedcrunch"
bindir = "/home/lukas/dev/bin/"
osd = "conky -c "
menu = "/home/lukas/dev/menus/"
foobar = "wine 'C:/Program Files/foobar2000/foobar2000.exe'"

-- VOLUME
function volumeup()
	awful.util.spawn(bindir .. "volume.sh 1%+")
end

function volumedown()
	awful.util.spawn(bindir .. "volume.sh 1%-")
end

-- moc player: currently player song
function mocinfo()
	awful.util.spawn(bindir .. "awesome_moc.sh")
end

-- MODKEY
modkey = "Mod4"
history = awful.client.focus.history

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.max,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.magnifier,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.floating
}

-- Table of clients that should be set floating. The index may be either
-- the application class or instance. The instance is useful when running
-- a console app in a terminal like (Music on Console)
floatapps =
{
	Conky_panel = true,
	MPlayer = true,
	Smplayer = true,
	gimp = true,
	speedcrunch = true,
	rxvtpopup = true,
	designer = true,
	["NO$GBA.EXE"] = true
}

tag_count = 5
-- Applications to be moved to a pre-defined tag by class or instance.
-- Use the screen and tags indices.
apptags =
{
	Firefox = { screen = 1, tag = 2 },
	mocp = { screen = 1, tag = 4 },
	["beep-media-player-2-bin"] = { screen = 1, tag = 4 },
	["NO$GBA.EXE"] = { screen = 1, tag = 5 },
	pidgin = { screen = 1, tag = 3 },
	designer = { screen = 1, tag = 5 }
}

-- NOTIFICATIONS
naughty.config.timeout          = 5
naughty.config.screen           = 1
naughty.config.position         = "top_right"
naughty.config.margin           = 4
naughty.config.height           = 16
naughty.config.width            = 400
naughty.config.gap              = 1
naughty.config.ontop            = true
naughty.config.font             = beautiful.font or "Verdana 8"
naughty.config.icon             = "/usr/share/icons/gnome/32x32/emblems/emblem-important.png"
naughty.config.icon_size        = 32
naughty.config.fg               = beautiful.fg_focus or '#ffffff'
naughty.config.bg               = beautiful.bg_focus or '#535d6c'
naughty.config.border_color     = beautiful.border_focus or '#535d6c'
naughty.config.border_width     = 1
naughty.config.hover_timeout    = nil
-- USAGE:
--naughty.notify({ text = '<span color="#ffff99" font_desc="14">Notification</span> ...and its text!', icon="/usr/share/icons/gnome/48x48/actions/appointment-new.png", icon_size=48 })
-- }}}

-- {{{ Tags
-- Define tags table.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = {}
    -- Create tag_count tags per screen.
    for tagnumber = 1, tag_count do
        tags[s][tagnumber] = tag(tagnumber)
        -- Add tags to screen one by one
        tags[s][tagnumber].screen = s
        awful.layout.set(layouts[1], tags[s][tagnumber])
    end
    -- I'm sure you want to see at least one tag.
    tags[s][1].selected = true
end
-- }}}

-- {{{ Wibox
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
    mywibox2[s] = wibox({ position = "bottom", bg = '#00000000', align="right", height=20, width=80})
    mywibox2[s].widgets = { mysystray }
    mywibox2[s].screen = s

end
-- }}}

-- {{{ Mouse bindings
root.buttons({
    button({ }, 4, awful.tag.viewnext),
    button({ }, 5, awful.tag.viewprev)
})
-- }}}

-- {{{ Key bindings
globalkeys = {
	key({ modkey }, "Left", awful.tag.viewprev),
	key({ modkey }, "Right", awful.tag.viewnext),
	key({ modkey }, "Up",  function ()
		awful.client.focus.byidx(-1)
                if client.focus then client.focus:raise() end
	end),
	key({ modkey }, "Down", function ()
		awful.client.focus.byidx(1)
                if client.focus then client.focus:raise() end
	end),
	key({ modkey }, "Escape", awful.tag.history.restore),
	
	-- Standard program
	key({ modkey }, "q", function () awful.util.spawn(terminal) end),
	key({ modkey }, "e", function () awful.util.spawn(filemanager) end),
	key({ modkey }, "c", function () awful.util.spawn(calc) end),
	key({ modkey }, "x", function () awful.util.spawn("xkill") end),
	key({ modkey }, "f", function () awful.util.spawn("firefox") end),
	key({}, "Menu", function () awful.util.spawn("$HOME/dev/invert_colors/invert") end),
	key({modkey}, "KP_Divide", function () awful.util.spawn("xrandr -s 640x480") end),
	key({modkey}, "KP_Multiply", function () awful.util.spawn("xrandr -s 1920x1200") end),
	
	key({ modkey, "Control" }, "r", function ()
	                                           mypromptbox[mouse.screen].text =
	                                               awful.util.escape(awful.util.restart())
	                                end),
	key({ modkey, "Shift" }, "q", function () awful.util.spawn("~/shutdown.sh") end),
	key({ modkey, "Control" }, "e", function () awful.util.spawn("gvim $HOME/.config/awesome/rc.lua") end),
	
	-- menus
	key({ modkey }, "r", function () awful.util.spawn(menu .. "runmenu.sh") end),
	key({ modkey }, "s", function () awful.util.spawn(menu .. "translatemenu.sh") end),
	key({ modkey }, "semicolon", function () awful.util.spawn(menu .. "vimmenu.sh") end),
	key({ modkey }, "g", function () awful.util.spawn(menu .. "gamemenu.sh") end),
	
	-- mocp
	--key({ modkey }, "p", function () awful.util.spawn("urxvtc -name mocp -title mocp -e mocp") end),
	--key({ modkey }, "minus", function () awful.util.spawn("mocp -G") end),
	--key({ modkey }, "period", function () awful.util.spawn("mocp -f") end),
	--key({ modkey }, "comma", function () awful.util.spawn("mocp -r") end),
	--key({ modkey }, "dead_diaeresis", mocinfo),
	
	-- foobar2000 (wine),
	key({ modkey }, "p", function () awful.util.spawn(foobar) end),
	key({ modkey }, "minus", function () awful.util.spawn(foobar .. " /playpause") end),
	key({ modkey }, "period", function () awful.util.spawn(foobar .. " /next") end),
	key({ modkey }, "comma", function () awful.util.spawn(foobar .. " /prev") end),
	
	-- volume up/down
	key({ modkey }, "parenright", volumeup),
	key({ modkey }, "section", volumedown),
	
	-- Client manipulation
	key({ modkey }, "j", function () awful.client.focus.byidx(1); if client.focus then client.focus:raise() end end),
	key({ modkey }, "k", function () awful.client.focus.byidx(-1);  if client.focus then client.focus:raise() end end),
	key({ modkey, "Shift" }, "j", function () awful.client.swap.byidx(1) end),
	key({ modkey, "Shift" }, "k", function () awful.client.swap.byidx(-1) end),
	key({ modkey, "Control" }, "j", function () awful.screen.focus(3) end),
	key({ modkey, "Control" }, "k", function () awful.screen.focus(-1) end),
	key({ modkey }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

	
	-- Layout manipulation
	key({ modkey }, "l", function () awful.tag.incmwfact(0.05) end),
	key({ modkey }, "h", function () awful.tag.incmwfact(-0.05) end),
	key({ modkey, "Shift" }, "h", function () awful.tag.incnmaster(1) end),
	key({ modkey, "Shift" }, "l", function () awful.tag.incnmaster(-1) end),
	key({ modkey, "Control" }, "h", function () awful.tag.incncol(1) end),
	key({ modkey, "Control" }, "l", function () awful.tag.incncol(-1) end),
	key({ modkey }, "space", function () awful.layout.inc(layouts, 1) end),
	key({ modkey, "Shift" }, "space", function () awful.layout.inc(layouts, -1) end),
	
	-- Prompt
	key({ modkey }, "F1", function ()
	                                 awful.prompt.run({ prompt = "Run: " }, mypromptbox[mouse.screen], awful.util.spawn, awful.completion.bash,
	                                                  awful.util.getdir("cache") .. "/history")
	                             end),
	key({ modkey }, "F4", function ()
	                                 awful.prompt.run({ prompt = "Run Lua code: " }, mypromptbox[mouse.screen], awful.util.eval, awful.prompt.bash,
	                                                  awful.util.getdir("cache") .. "/history_eval")
	                             end),
	
	key({ modkey, "Ctrl" }, "i", function ()
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
                                    end)
}

clientkeys =
{
    key({ modkey }, "Return", function (c) c.fullscreen = not c.fullscreen  end),
    key({ modkey, "Shift"   }, "c", function (c) c:kill() end),
    key({ modkey, "Control" }, "space",  awful.client.floating.toggle),
    key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    key({ modkey }, "o", awful.client.movetoscreen),
    key({ modkey }, "u", awful.client.urgent.jumpto),
    key({ modkey, "Shift" }, "r", function (c) c:redraw() end),
    key({ modkey }, "t", awful.client.togglemarked),
    key({ modkey }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
}

-- Bind keyboard digits
-- Compute the maximum number of digit we need, limited to tag_count
numkeys = {"plus", "ecaron", "scaron", "ccaron", "rcaron", "zcaron", "yacute", "aacute", "iacute"}

for i = 1, tag_count do
    table.insert(globalkeys,
    	key({ modkey }, numkeys[i],
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           awful.tag.viewonly(tags[screen][i])
                       end
                   end))
    table.insert(globalkeys,
    	key({ modkey, "Control" }, numkeys[i],
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           tags[screen][i].selected = not tags[screen][i].selected
                       end
                   end))
    table.insert(globalkeys,
    	key({ modkey, "Shift" }, numkeys[i],
                   function ()
                       if client.focus then
                           if tags[client.focus.screen][i] then
                               awful.client.movetotag(tags[client.focus.screen][i])
                           end
                       end
                   end))
    table.insert(globalkeys,
    	key({ modkey, "Control", "Shift" }, numkeys[i],
                   function ()
                       if client.focus then
                           if tags[client.focus.screen][i] then
                               awful.client.toggletag(tags[client.focus.screen][i])
                           end
                       end
                   end))
end
		   
for i = 1, tag_count do
    table.insert(globalkeys, key({ modkey, "Shift" }, "F" .. i,
                 function ()
                     local screen = mouse.screen
                     if tags[screen][i] then
                         for k, c in pairs(awful.client.getmarked()) do
                             awful.client.movetotag(tags[screen][i], c)
                         end
                     end
                 end))
end

-- layouts
for i=0,9 do
    table.insert(globalkeys,
	key({ modkey }, "KP_"..i,
		function ()
    			awful.layout.set(i==0 and awful.layout.suit.floating or layouts[i])
		end))
end

root.keys(globalkeys)
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
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)--}}}

-- Hook function to execute when a new client appears.
awful.hooks.manage.register(function (c, startup)--{{{
    -- If we are not managing this application at startup,
    -- move it to the screen where the mouse is.
    -- We only do it for filtered windows (i.e. no dock, etc).
    if not startup and awful.client.focus.filter(c) then
        c.screen = mouse.screen
    end
    -- Add mouse bindings
    c:buttons({
        button({ }, 1, function (c) client.focus = c; c:raise() end),
        button({ modkey }, 1, awful.mouse.client.move),
        button({ modkey }, 3, awful.mouse.client.resize)
    })
    -- New client may not receive focus
    -- if they're not focusable, so set border anyway.
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_normal

    -- Check if the application should be floating.
    local cls = c.class
    local inst = c.instance
    if floatapps[cls] then
        awful.client.floating.set(c, floatapps[cls])
    elseif floatapps[inst] then
        awful.client.floating.set(c, floatapps[inst])
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

    -- Do this after tag mapping, so you don't see it on the wrong tag for a split second.
    client.focus = c

    -- Set key bindings
    c:keys(clientkeys)

    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- awful.client.setslave(c)

    -- Honor size hints: if you want to drop the gaps between windows, set this to false.
    -- c.size_hints_honor = false
end)--}}}

-- Hook function to execute when arranging the screen.
-- (tag switch, new client, etc)
awful.hooks.arrange.register(function (screen)--{{{
    local layout = awful.layout.getname(awful.layout.get(screen))

    -- Give focus to the latest client in history if no window has focus
    -- or if the current window is a desktop or a dock one.
    if not client.focus then
        local c = awful.client.focus.history.get(screen, 0)
        if c then client.focus = c end
    end
end)--}}}

-- Hook called every second
--awful.hooks.timer.register(1, function ()
--end)
-- }}}

-- {{{ Autostart
awful.util.spawn("xrandr --dpi 100")
awful.util.spawn("xrdb -merge /home/lukas/.Xresources")
awful.util.spawn("pidof urxvtd >/dev/null || urxvtd -q")
awful.util.spawn("killall conky >/dev/null; conky")
--awful.util.spawn("pidof pidgin >/dev/null || pidgin")
awful.util.spawn("pidof easystroke >/dev/null || /home/lukas/apps/easystroke/easystroke")
awful.util.spawn("pidof xbindkeys || (sleep 10 && xbindkeys)")
-- }}}

