-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
local lain = require("lain")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- For powerline style
local separators = lain.util.separators
local arrow = separators.arrow_left

-- internal helpers for development
function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) == 'function' then k = 'func'
         elseif type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end
function print_table(node)
    -- to make output beautiful
    local function tab(amt)
        local str = ""
        for i=1,amt do
            str = str .. "\t"
        end
        return str
    end

    local cache, stack, output = {},{},{}
    local depth = 1
    local output_str = "{\n"

    while true do
        local size = 0
        for k,v in pairs(node) do
            size = size + 1
        end

        local cur_index = 1
        for k,v in pairs(node) do
            if (cache[node] == nil) or (cur_index >= cache[node]) then

                if (string.find(output_str,"}",output_str:len())) then
                    output_str = output_str .. ",\n"
                elseif not (string.find(output_str,"\n",output_str:len())) then
                    output_str = output_str .. "\n"
                end

                -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                table.insert(output,output_str)
                output_str = ""

                local key
                if (type(k) == "number" or type(k) == "boolean") then
                    key = "["..tostring(k).."]"
                else
                    key = "['"..tostring(k).."']"
                end

                if (type(v) == "number" or type(v) == "boolean") then
                    output_str = output_str .. tab(depth) .. key .. " = "..tostring(v)
                elseif (type(v) == "table") then
                    output_str = output_str .. tab(depth) .. key .. " = {\n"
                    table.insert(stack,node)
                    table.insert(stack,v)
                    cache[node] = cur_index+1
                    break
                else
                    output_str = output_str .. tab(depth) .. key .. " = '"..tostring(v).."'"
                end

                if (cur_index == size) then
                    output_str = output_str .. "\n" .. tab(depth-1) .. "}"
                else
                    output_str = output_str .. ","
                end
            else
                -- close the table
                if (cur_index == size) then
                    output_str = output_str .. "\n" .. tab(depth-1) .. "}"
                end
            end

            cur_index = cur_index + 1
        end

        if (size == 0) then
            output_str = output_str .. "\n" .. tab(depth-1) .. "}"
        end

        if (#stack > 0) then
            node = stack[#stack]
            stack[#stack] = nil
            depth = cache[node] == nil and depth + 1 or depth - 1
        else
            break
        end
    end

    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
    table.insert(output,output_str)
    output_str = table.concat(output)

    return output_str
end

-- Enable VIM help for hotkeys widget when client with matching name is opened:
require("awful.hotkeys_popup.keys.vim")

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
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/themes/custom/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "termite"
editor = os.getenv("EDITOR") or "nvim"
-- editor_cmd = terminal .. " -e " .. editor
editor_cmd = "nvim-qt"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() return false, hotkeys_popup.show_help end},
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end}
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
-- mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock("%H:%M:%S", 1)

-- Calendar
lain.widget.calendar({
  attach_to = { mytextclock },
  notification_preset = {
    font = beautiful.font
  }
})

-- MEM
local memicon = wibox.widget.imagebox(beautiful.widget_mem)
local mem = lain.widget.mem({
    settings = function()
        widget:set_markup(lain.util.markup.fontfg(
          beautiful.font,
          beautiful.powerline.mem.fg,
          " " .. mem_now.used .. "MB "
        ))
    end
})

-- CPU
local cpuicon = wibox.widget.imagebox(beautiful.widget_cpu)
local cpu = lain.widget.cpu({
    settings = function()
        local formatted_data = {}
        for k,v in pairs(cpu_now) do
          if k ~= 0 and k ~= 'usage' then
            table.insert(formatted_data, string.format("% 3s", v.usage) .. "%")
          end
        end
        widget:set_markup(lain.util.markup.fontfg(
          beautiful.font,
          beautiful.powerline.cpu.fg,
          table.concat(formatted_data)
        ))
    end
})
-- CPU temperature widget
-- local cputemp = awful.widget.watch('bash -c "sensors | grep Package | sed -E \'s/^.*?: +\\+([0-9.]+°C).+/\\1/\'"', 10)
local cputemp_icon = wibox.widget.imagebox(beautiful.widget_cpu_temp)

local cputemp_graph = wibox.widget {
    max_value = 100,
    widget = wibox.widget.graph
}
-- local f = io.open("~/debuglua", "w")
-- f:write(print_table(cpuicon))
-- f:close()
-- file:write(print_table(cputemp_graph))
-- closes the open file
-- cputemp_graph.add_value(50)
local cputemp = awful.widget.watch('bash -c "sensors | grep Package | sed -E \'s/^.*?: +\\+([0-9.]+)°C.*$/\\1/\'"', 10, function(widget, value)
    -- cputemp_graph:add_value(tonumber(value))
    widget:set_markup(lain.util.markup.fontfg(
      beautiful.font,
      beautiful.powerline.cpu_package_temp.fg,
      string.format("% 5s%s", tonumber(value), "°C")
    ))
    return
end)

-- Battery
local baticon = wibox.widget.imagebox(beautiful.widget_battery)
local bat = lain.widget.bat({
    battery = "BAT0",
    settings = function()
        if bat_now.status ~= "N/A" then
            if bat_now.ac_status == 1 then
                widget:set_markup(lain.util.markup.font(beautiful.font, " AC "))
                baticon:set_image(beautiful.widget_ac)
                return
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 5 then
                baticon:set_image(beautiful.widget_battery_empty)
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 15 then
                baticon:set_image(beautiful.widget_battery_low)
            else
                baticon:set_image(beautiful.widget_battery)
            end
            widget:set_markup(lain.util.markup.font(beautiful.font, " " .. bat_now.perc .. "% "))
        else
            widget:set_markup()
            baticon:set_image(beautiful.widget_ac)
        end
    end
})
-- Volume
local volicon = wibox.widget.imagebox()
local voltooltip = awful.tooltip({ objects = { volicon } })
local volume = lain.widget.pulseaudio({
    settings = function()
        if volume_now.left == volume_now.right then
          vlevel = volume_now.left .. "%"
        else
          vlevel = volume_now.left .. "-" .. volume_now.right .. "%"
        end
        if volume_now.muted == "yes" then
            vlevel = vlevel .. " Muted"
        end

        local index, perc = "", tonumber(volume_now.left) or 0

        if volume_now.muted == "yes" then
            index = "volmutedblocked"
        else
            if perc <= 5 then
                index = "volmuted"
            elseif perc <= 25 then
                index = "vollow"
            elseif perc <= 75 then
                index = "volmed"
            else
                index = "volhigh"
            end
        end
        voltooltip:set_text(vlevel)
        volicon:set_image(beautiful[index])
    end
})
volume.sink = 0

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.fit(wallpaper, s,'#000')

    end
end
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "browser", "editor", "other", "chat", "gimp", "office", "virtualbox" }, s,
    {
      awful.layout.suit.max, -- browser
      awful.layout.suit.tile, -- editor
      awful.layout.suit.floating, -- other
      awful.layout.suit.tile, -- chat
      awful.layout.suit.max, -- gimp
      awful.layout.suit.max, -- office
      awful.layout.suit.floating -- virtualbox
    })

    -- Create a promptbox for each screen
    -- CRUTCH: and set spaces
    s.mypromptbox = awful.widget.prompt({ prompt = " Run: " })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.topwibox = awful.wibar({ position = "top", screen = s })
    s.bottomwibox = awful.wibar({ position = "bottom", screen = s })

    -- Add widgets to the wibox
    s.topwibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            -- mylauncher,
            s.mytaglist,
            s.mypromptbox,
            arrow("alpha", beautiful.powerline.layout.bg),
            wibox.container.background(wibox.container.margin(wibox.widget { nil, s.mylayoutbox, layout = wibox.layout.align.horizontal }, 4, 4), beautiful.powerline.layout.bg),
            arrow(beautiful.powerline.layout.bg, beautiful.powerline.tasklist.bg),
        },
        wibox.container.background(wibox.container.margin(wibox.widget { nil, s.mytasklist, layout = wibox.layout.align.horizontal }, 4, 4), beautiful.powerline.tasklist.bg),
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            arrow(beautiful.powerline.tasklist.bg, beautiful.powerline.volume.bg),
            wibox.container.background(wibox.container.margin(wibox.widget { nil, volicon, layout = wibox.layout.align.horizontal }, 4, 4), beautiful.powerline.volume.bg),
            arrow(beautiful.powerline.volume.bg, beautiful.bg_systray),
            wibox.container.background(wibox.container.margin(wibox.widget { nil, wibox.widget.systray(), layout = wibox.layout.align.horizontal }, 4, 4), beautiful.bg_systray),
            arrow(beautiful.bg_systray, beautiful.powerline.clock.bg),
            wibox.container.background(wibox.container.margin(wibox.widget { nil, mytextclock, layout = wibox.layout.align.horizontal }, 4, 4), beautiful.powerline.clock.bg),
        },
    }

    s.bottomwibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
        },
        { -- Middle widgets
            layout = wibox.layout.fixed.horizontal,
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            -- arrow("alpha", beautiful.powerline.weather.bg),
            -- wibox.container.background(wibox.container.margin(wibox.widget { cpuicon, cpu.widget, layout = wibox.layout.align.horizontal }, 3, 4), beautiful.powerline.weather.bg),
            arrow("alpha", beautiful.powerline.cpu_package_temp.bg),
            wibox.container.background(wibox.container.margin(wibox.widget { cputemp_icon, cputemp, layout = wibox.layout.align.horizontal }, 3, 4), beautiful.powerline.cpu_package_temp.bg),
            arrow(beautiful.powerline.cpu_package_temp.bg, beautiful.powerline.cpu.bg),
            wibox.container.background(wibox.container.margin(wibox.widget { cpuicon, cpu.widget, layout = wibox.layout.align.horizontal }, 3, 4), beautiful.powerline.cpu.bg),
            arrow(beautiful.powerline.cpu.bg, beautiful.powerline.mem.bg),
            wibox.container.background(wibox.container.margin(wibox.widget { memicon, mem.widget, layout = wibox.layout.align.horizontal }, 4, 4), beautiful.powerline.mem.bg),
            arrow(beautiful.powerline.mem.bg, beautiful.powerline.bat.bg),
            wibox.container.background(wibox.container.margin(wibox.widget { baticon, bat.widget, layout = wibox.layout.align.horizontal }, 4, 4), beautiful.powerline.bat.bg),
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
volicon:buttons(awful.util.table.join(
    awful.button({}, 1, function() -- left click
        awful.util.spawn_with_shell("pavucontrol")
    end),
    awful.button({}, 2, function() -- middle click
        awful.util.spawn_with_shell(string.format("pactl set-sink-volume %d 100%%", volume.sink))
        volume.update()
    end),
    awful.button({}, 3, function() -- right click
        awful.util.spawn_with_shell(string.format("pactl set-sink-mute %d toggle", volume.sink))
        volume.update()
    end),
    awful.button({}, 4, function() -- scroll up
        awful.util.spawn_with_shell(string.format("pactl set-sink-volume %d +5%%", volume.sink))
        volume.update()
    end),
    awful.button({}, 5, function() -- scroll down
        awful.util.spawn_with_shell(string.format("pactl set-sink-volume %d -5%%", volume.sink))
        volume.update()
    end)
))
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "F2",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),
    -- because of office keyboard :(
    awful.key({ modkey },            "F1",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),
    -- Volume
    awful.key({ }, "XF86AudioRaiseVolume",  function()
        awful.util.spawn_with_shell(string.format("pactl set-sink-volume %d +5%%", volume.sink))
        volume.update()
    end),
    awful.key({ }, "XF86AudioLowerVolume",  function()
        awful.util.spawn_with_shell(string.format("pactl set-sink-volume %d -5%%", volume.sink))
        volume.update()
    end),
    awful.key({}, "XF86AudioMute", function()
        awful.util.spawn_with_shell(string.format("pactl set-sink-mute %d toggle", volume.sink))
        volume.update()
    end),

    awful.key({ }, "XF86MonBrightnessDown", function ()
        awful.util.spawn("brightnessctl s 2%-")
    end),
    awful.key({ }, "XF86MonBrightnessUp", function ()
        awful.util.spawn("brightnessctl s +2%")
    end),
    awful.key({ modkey }, "F12", function()
        awful.util.spawn_with_shell("xrandr-invert-colors")
    end),
    awful.key({ }, "Print", function()
        awful.util.spawn_with_shell("shutter -s")
    end)
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 7 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    { rule = { class = "Firefox" },
      properties = { screen = 1, tag = "browser", titlebars_enabled = false } },
    { rule = { class = "Chromium" },
      properties = { screen = 1, tag = "browser", titlebars_enabled = false } },

    { rule = { class = "Spacefm" },
      properties = { screen = 1, tag = "other", titlebars_enabled = false } },

    { rule = { class = "nvim-qt" },
      properties = { screen = 1, tag = "editor", titlebars_enabled = false } },

    { rule = { class = "Gimp" },
      properties = { screen = 1, tag = "gimp", titlebars_enabled = false } },

    { rule = { class = "Git-gui" },
      properties = { screen = 1, tag = "other", titlebars_enabled = false } },
    { rule = { class = "Slack" },
      properties = { screen = 1, tag = "chat", titlebars_enabled = false } },
    { rule = { class = "libreoffice" },
      properties = { screen = 1, tag = "office", titlebars_enabled = false } },
    { rule = { class = "VirtualBox" },
      properties = { screen = 1, tag = "virtualbox", titlebars_enabled = false } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}


-- AUTOSTART
awful.util.spawn_with_shell("~/.config/awesome/autorun.sh")
