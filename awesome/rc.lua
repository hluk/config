-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.add_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
beautiful.init( awful.util.getdir("config") .. "/theme.lua" )

-- Notifications
--naughty.config.default_preset.timeout          = 5
--naughty.config.default_preset.screen           = 1
naughty.config.default_preset.position         = "bottom_right"
naughty.config.default_preset.margin           = 12
--naughty.config.default_preset.height           = 16
--naughty.config.default_preset.width            = 300
--naughty.config.default_preset.gap              = 1
--naughty.config.default_preset.ontop            = true
naughty.config.default_preset.font             = "Ubuntu 11"
--naughty.config.default_preset.icon             = nil
naughty.config.default_preset.icon_size        = 32
--naughty.config.default_preset.fg               = beautiful.fg_focus or '#ffffff'
--naughty.config.default_preset.bg               = beautiful.bg_focus or '#535d6c'
--naughty.config.presets.normal.border_color     = beautiful.border_focus or '#535d6c'
--naughty.config.default_preset.border_width     = 1
--naughty.config.default_preset.hover_timeout    = nil

modkey = "Mod4"

layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.max,
    awful.layout.suit.floating,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.magnifier,
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4 }, s, layouts[1])
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    --awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    --awful.key({ modkey,           }, "m", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ "Mod1",           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    --awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey            }, "Return", function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ "Mod1"            }, "F4",     function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    --awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "s",      function (c) c.sticky = not c.sticky          end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = {
          border_color = beautiful.border_normal,
          focus = true,
          keys = clientkeys,
          buttons = clientbuttons,
          -- remove gaps around urxvt window
          size_hints_honor = false,
      } },
    { rule = { class = "VirtualBox" },
      properties = {
          -- FIXME: keys are not pass through
          tag = tags[1][3],
          floating = true,
          size_hints_honor = true,
      } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "Chromium" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "Pidgin" },
      properties = {
          tag = tags[1][4],
          floating = true,
      } },
    { rule = { class = "Copyq" },
      properties = {
          floating = true,
          -- fix position restoring
          border_width = 0,
      } },
}
-- }}}

-- {{{ Signals
-- {{{ Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)
-- }}}

-- {{{ Arrange signal handler
for s = 1, screen.count() do screen[s]:add_signal("arrange",
    function ()
        local clients = awful.client.visible(s)
        local layout = awful.layout.getname(awful.layout.get(s))
        for _, c in pairs(clients) do
            local w = beautiful.border_width

            if c.fullscreen or (layout == "max" and not awful.client.floating.get(c)) then
                w = 0
            else
                local cg = c:geometry()
                local sg = screen[s].geometry

                if cg.width > sg.width - 64 and cg.height > sg.height - 64 then
                    w = 0
                end
            end

            c.border_width = w
            if c.class == "MPlayer" then
                naughty.notify({
                    preset = naughty.config.presets.critical,
                    title = "DEBUG",
                    text = w .. "," .. c.border_width })
            end
        end
    end)
end
-- }}}

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
