-- Standard awesome library
require("awful")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

-- {{{ Variable definitions
-- Defaul apps and paths
home = os.getenv("HOME")
terminal = "sakura -e "..home.."/screen"
calc = home.."/apps/speedcrunch/src/speedcrunch"
bindir = home.."/dev/bin/"
menu = home.."/dev/menus/"
--foobar = "wine 'C:/Program Files/foobar2000/foobar2000.exe'"

-- THEME
theme_path = home.."/.config/awesome/mytheme.lua"
beautiful.init(theme_path)

function spawn(cmd, startup_notification)
	awful.util.spawn(cmd, startup_notification or false)
end

-- run command if not running
function runonce(cmd, restart)
	psname = string.gsub(cmd, " .*", "")
	if restart then
		spawn("/bin/sh -c 'killall "..psname.." 2>&1 >/dev/null; "..cmd.."'")
	else
		spawn("/bin/sh -c 'pidof "..psname.." 2>&1 >/dev/null || "..cmd.."'")
	end
end

-- VOLUME
function volumeup()
	spawn(bindir .. "volume.sh 1%+")
end

function volumedown()
	spawn(bindir .. "volume.sh 1%-")
end

-- MODKEY
modkey = "Mod4"
history = awful.client.focus.history

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{	awful.layout.suit.max
,	awful.layout.suit.tile.bottom
,	awful.layout.suit.tile.top
,	awful.layout.suit.tile
,	awful.layout.suit.tile.left
,	awful.layout.suit.fair
,	awful.layout.suit.fair.horizontal
,	awful.layout.suit.max.fullscreen
,	awful.layout.suit.floating
}

floatapps =
{	MPlayer = true
,	["NO$GBA.EXE"] = true
,	Conky_panel = true
,	gimp = true
,	speedcrunch = true
,	["desmume-cli"] = true
,	["sun-awt-X11-XFramePeer"] = true
}

apptags =
{	Firefox = { tag = 2 }
,	chrome = { tag = 2 }
,	pidgin = { tag = 3 }
}

-- NOTIFICATIONS
naughty.config.timeout          = 5
naughty.config.screen           = 1
naughty.config.position         = "top_right"
naughty.config.margin           = 4
naughty.config.height           = 24
naughty.config.width            = 500
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
tag_count = 5
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = {}
    -- Create 9 tags per screen.
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
mysystray = widget({ type = "systray", align = "left" })

-- Create a wibox for each screen and add it
mywibox = {}
mywibox2 = {}
mypromptbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
	awful.button({ }, 1, awful.tag.viewonly),
	awful.button({ modkey }, 1, awful.client.movetotag),
	awful.button({ }, 3, function (tag) tag.selected = not tag.selected end),
	awful.button({ modkey }, 3, awful.client.toggletag),
	awful.button({ }, 4, awful.tag.viewnext),
	awful.button({ }, 5, awful.tag.viewprev)
)

mytasklist = {}
mytasklist.buttons = awful.util.table.join(
	awful.button({ }, 1, function (c)
		if not c:isvisible() then
			awful.tag.viewonly(c:tags()[1])
		end
		client.focus = c
		c:raise()
	end),
	awful.button({ }, 4, function ()
		awful.client.focus.byidx(1)
		if client.focus then client.focus:raise() end
	end),
	awful.button({ }, 5, function ()
		awful.client.focus.byidx(-1)
		if client.focus then client.focus:raise() end
	end)
)

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ align = "left" })
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = wibox({ position = "top", height=20 })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = { mysystray,
                           mytaglist[s],
                           mytasklist[s],
                           mypromptbox[s] }
    mywibox[s].screen = s
    
    -- Create the wibox2
    mywibox2[s] = wibox({ position = "bottom", bg = '#00000000', align="right", height=20 })
    mywibox2[s].screen = s
end
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
	awful.key({ modkey }, "Left", awful.tag.viewprev),
	awful.key({ modkey }, "Right", awful.tag.viewnext),
	awful.key({ modkey }, "Up",  function ()
		awful.client.focus.byidx(-1)
                if client.focus then client.focus:raise() end
	end),
	awful.key({ modkey }, "Down", function ()
		awful.client.focus.byidx(1)
                if client.focus then client.focus:raise() end
	end),
	awful.key({ modkey }, "Escape", awful.tag.history.restore),
	
	-- Standard program
	awful.key({ modkey }, "q", function () spawn(terminal) end),
	awful.key({ modkey }, "c", function () spawn(calc) end),
	awful.key({ modkey }, "x", function () spawn("xkill") end),
	awful.key({ modkey }, "f", function () spawn("firefox") end),
	awful.key({ modkey }, "w", function () spawn(home.."/chromium.sh") end),
	awful.key({}, "Menu", function () spawn(home.."/dev/invert_colors/invert") end),
	awful.key({ modkey }, "KP_Divide", function () spawn("xrandr -s 1024x768") end),
	awful.key({ modkey }, "KP_Multiply", function () spawn("xrandr -s 1920x1200") end),
	awful.key({ modkey }, "t", function () spawn(home.."/apps/xviservicethief/bin/xvst") end),
	awful.key({ modkey }, "d", function () spawn("java -jar '"..home.."/apps/JDownloader 0.7/JDownloader.jar'") end),
	
	awful.key({ modkey, "Control" }, "r", function ()
	                                           mypromptbox[mouse.screen].text =
	                                               awful.util.escape(awful.util.restart())
	                                end),
	awful.key({ modkey, "Shift" }, "q", function () spawn("sakura -e "..home.."/shutdown.sh") end),
	awful.key({ modkey, "Control" }, "e", function () spawn("gvim "..home.."/.config/awesome/rc.lua") end),
	awful.key({ modkey }, "s", function () spawn(home.."/dev/qt/qdict/qdict") end),
	
	-- menus
	awful.key({ modkey }, "r", function () spawn(menu .. "runmenu.sh") end),
	--awful.key({ modkey }, "s", function () spawn(menu .. "translatemenu.sh") end),
	awful.key({ modkey }, "semicolon", function () spawn(menu .. "vimmenu.sh") end),
	awful.key({ modkey }, "g", function () spawn(menu .. "gamemenu.sh") end),
	
	-- xmms2
	--awful.key({ modkey }, "p", function () spawn("xmms2-launcher") end),
	--awful.key({ modkey }, "minus", function () spawn("xmms2 toggleplay") end),
	--awful.key({ modkey }, "period", function () spawn("xmms2 next") end),
	--awful.key({ modkey }, "comma", function () spawn("xmms2 prev") end),
	--awful.key({ modkey, "Control" }, "period", function () spawn("xmms2 seek +10") end),
	--awful.key({ modkey, "Control" }, "comma", function () spawn("xmms2 seek -10") end),

	-- mpd
	awful.key({ modkey }, "o", function () spawn("ario") end),
	awful.key({ modkey }, "uacute", function () spawn(menu .. "mpd.sh") end),
	awful.key({ modkey }, "p", function () spawn("/bin/sh -c 'pidof mpd && killall mpd || mpd'") end),
	awful.key({ modkey }, "minus", function () spawn("mpc toggle") end),
	awful.key({ modkey }, "period", function () spawn("mpc next") end),
	awful.key({ modkey }, "comma", function () spawn("mpc prev") end),
	awful.key({ modkey, "Control" }, "period", function () spawn("mpc seek +10") end),
	awful.key({ modkey, "Control" }, "comma", function () spawn("mpc seek -10") end),

	-- foobar2000 (wine),
	--awful.key({ modkey }, "p", function () spawn(foobar) end),
	--awful.key({ modkey }, "minus", function () spawn(foobar .. " /playpause") end),
	--awful.key({ modkey }, "period", function () spawn(foobar .. " /next") end),
	--awful.key({ modkey }, "comma", function () spawn(foobar .. " /prev") end),
	
	-- volume up/down
	awful.key({ modkey }, "parenright", volumeup),
	awful.key({ modkey }, "section", volumedown),
	
	-- Client manipulation
	awful.key({ modkey }, "j", function () awful.client.focus.byidx(1); if client.focus then client.focus:raise() end end),
	awful.key({ modkey }, "k", function () awful.client.focus.byidx(-1);  if client.focus then client.focus:raise() end end),
	awful.key({ modkey, "Shift" }, "j", function () awful.client.swap.byidx(1) end),
	awful.key({ modkey, "Shift" }, "k", function () awful.client.swap.byidx(-1) end),
	awful.key({ modkey, "Control" }, "j", function () awful.screen.focus(3) end),
	awful.key({ modkey, "Control" }, "k", function () awful.screen.focus(-1) end),
	awful.key({ modkey }, "Tab",
        function ()
	    history.previous()
	    if client.focus then
		client.focus:raise()
	    end
        end),
	
	-- Layout manipulation
	awful.key({ modkey }, "l", function () awful.tag.incmwfact(0.05) end),
	awful.key({ modkey }, "h", function () awful.tag.incmwfact(-0.05) end),
	awful.key({ modkey, "Shift" }, "h", function () awful.tag.incnmaster(1) end),
	awful.key({ modkey, "Shift" }, "l", function () awful.tag.incnmaster(-1) end),
	awful.key({ modkey, "Control" }, "h", function () awful.tag.incncol(1) end),
	awful.key({ modkey, "Control" }, "l", function () awful.tag.incncol(-1) end),
	awful.key({ modkey }, "space", function () awful.layout.inc(layouts, 1) end),
	awful.key({ modkey, "Shift" }, "space", function () awful.layout.inc(layouts, -1) end),
	
	-- Prompt
	awful.key({ modkey }, "F1", function () mypromptbox[mouse.screen]:run() end),
	awful.key({ modkey }, "F4", function ()
	                                 awful.prompt.run({ prompt = "Run Lua code: " }, mypromptbox[mouse.screen], awful.util.eval, awful.prompt.bash,
	                                                  awful.util.getdir("cache") .. "/history_eval")
	                             end),
	
	awful.key({ modkey, "Ctrl" }, "i", function ()
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
)

clientkeys = awful.util.table.join(
    awful.key({ modkey }, "Return", function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c", function (c) c:kill() end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    --awful.key({ modkey }, "o", awful.client.movetoscreen),
    awful.key({ modkey }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey, "Shift" }, "r", function (c) c:redraw() end),
    awful.key({ modkey }, "t", awful.client.togglemarked),
    awful.key({ modkey }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to tag_count
numkeys = {"plus", "ecaron", "scaron", "ccaron", "rcaron", "zcaron", "yacute", "aacute", "iacute"}

for i = 1, tag_count do
	globalkeys = awful.util.table.join(globalkeys,
	awful.key({ modkey }, numkeys[i],
	function ()
		awful.tag.viewonly(tags[mouse.screen][i])
	end),
	awful.key({ modkey, "Control" }, numkeys[i],
	function ()
		local screen = mouse.screen
		if tags[screen][i] then
			tags[screen][i].selected = not tags[screen][i].selected
		end
	end),
	awful.key({ modkey, "Shift" }, numkeys[i],
	function ()
		if client.focus and tags[client.focus.screen][i] then
			awful.client.movetotag(tags[client.focus.screen][i])
		end
	end),
	awful.key({ modkey, "Control", "Shift" }, numkeys[i],
	function ()
		if client.focus and tags[client.focus.screen][i] then
			awful.client.toggletag(tags[client.focus.screen][i])
		end
	end)
	)
end

-- layouts
for i=0,9 do
	globalkeys = awful.util.table.join(globalkeys,
	awful.key({ modkey }, "KP_"..i,
	function ()
		awful.layout.set(i==0 and awful.layout.suit.floating or layouts[i])
	end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

root.keys(globalkeys)
-- }}}

-- {{{ Hooks
-- Hook function to execute when focusing a client.
awful.hooks.focus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_focus
    end
end)

-- Hook function to execute when unfocusing a client.
awful.hooks.unfocus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_normal
    end
end)

-- Hook function to execute when marking a client
awful.hooks.marked.register(function (c)
    c.border_color = beautiful.border_marked
end)

-- Hook function to execute when unmarking a client.
awful.hooks.unmarked.register(function (c)
    c.border_color = beautiful.border_focus
end)

-- Hook function to execute when the mouse enters a client.
awful.hooks.mouse_enter.register(function (c)
    -- Sloppy focus, but disabled for magnifier layout
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

-- Hook function to execute when a new client appears.
awful.hooks.manage.register(function (c, startup)
    -- If we are not managing this application at startup,
    -- move it to the screen where the mouse is.
    -- We only do it for filtered windows (i.e. no dock, etc).
    if not startup and awful.client.focus.filter(c) then
        c.screen = mouse.screen
    end

    if use_titlebar then
        -- Add a titlebar
        awful.titlebar.add(c, { modkey = modkey })
    end
    -- Add mouse bindings
    c:buttons(awful.util.table.join(
        awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
        awful.button({ modkey }, 1, awful.mouse.client.move),
        awful.button({ modkey }, 3, awful.mouse.client.resize)
    ))
    -- New client may not receive focus
    -- if they're not focusable, so set border anyway.
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_normal

    -- Check if the application should be floating.
    local cls = c.class
    local inst = c.instance
    if floatapps[cls] ~= nil then
	awful.client.floating.set(c, floatapps[cls])
    elseif floatapps[inst] ~= nil then
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
        c.screen = target.screen or 1
        awful.client.movetotag(tags[c.screen][target.tag], c)
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
end)

-- Hook function to execute when arranging the screen.
-- (tag switch, new client, etc)
awful.hooks.arrange.register(function (screen)
    -- Give focus to the latest client in history if no window has focus
    -- or if the current window is a desktop or a dock one.
    if not client.focus then
        local c = awful.client.focus.history.get(screen, 0)
        if c then client.focus = c end
    end
end)
-- }}}

-- {{{ Autostart
-- autorepeat
spawn("xset r 113 r 115 r 116 r rate 250 30")
runonce(home.."/apps/easystroke/easystroke")
runonce("parcellite")
runonce("conky -q",true)
-- }}}

