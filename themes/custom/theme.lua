-------------------------------

local themes_path = "~/.config/awesome/themes/"

-- {{{ Main
local theme = {}
theme.wallpaper = themes_path .. "custom/wallpaper.jpg"
-- }}}

-- {{{ Styles
theme.font      = "xos4 Terminus 8"

-- {{{ Colors
theme.fg_normal  = "#DCDCCC"
theme.fg_focus   = "#00b9cd"
theme.fg_urgent  = "#CC9393"
theme.bg_normal  = "#3F3F3F"
theme.bg_focus   = "#3F3F3F"
theme.bg_urgent  = "#3F3F3F"
theme.bg_systray = "#1E2320"
-- }}}
-- {{{ Notifications
theme.notification_width = 350
theme.notification_bg = "#888888"
theme.notification_fg = "#ffffff"
-- }}}

-- {{{ Powerline colors
theme.powerline = {
    cpu = {
        bg = "#CB755B",
        fg = "#fff",
    },
    cpu_package_temp = {
        bg = "#84b97c",
        fg = "#fff",
    },
    mem = {
        bg = "#4B696D",
        fg = "#fff",
    },
    clock = {
        bg = "#777E76",
    },
    volume = {
        bg = "#4B696D",
    },

    -- weather = {
    --     bg = "#4B696D",
    --     fg = "#1E2320",
    -- },
    layout = {
        bg = "#4B696D"
    },
    tasklist = {
        bg = theme.bg_focus,
    },
    bat = {
        bg = "#777E76",
        fg = "#ffffff"
    }
}
--     "#CB755B",
--     "#4B3B51",
--     "#4B696D",
--     "#777E76",
--     "#8DAA9A",
--     "#84b97c",
-- }}}

-- {{{ Borders
theme.useless_gap   = 0
theme.border_width  = 1
theme.border_normal = "#5F5F5F"
theme.border_focus  = "#00b9cd"
theme.border_marked = "#CC9393"
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = "#3F3F3F"
theme.titlebar_bg_normal = "#5F5F5F"
-- }}}

-- {{{ Prompt
theme.prompt_bg = "#3F3F3F"
theme.prompt_fg = "#00ff00"
-- we don't need cursor, prompt is for quick commands
theme.prompt_bg_cursor = theme.prompt_bg
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#CC9393"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#AECF96"
--theme.fg_center_widget = "#88A175"
--theme.fg_end_widget    = "#FF5656"
--theme.bg_widget        = "#494B4F"
--theme.border_widget    = "#3F3F3F"
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = 20
theme.menu_width  = 100
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel   = themes_path .. "custom/taglist/squarefz.png"
theme.taglist_squares_unsel = themes_path .. "custom/taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon           = themes_path .. "custom/icons/awesome-icon.png"
theme.menu_submenu_icon      = themes_path .. "custom/icons/submenu.png"
theme.widget_mem             = themes_path .. "custom/icons/mem.png"
theme.widget_cpu             = themes_path .. "custom/icons/cpu.png"
theme.widget_cpu_temp        = themes_path .. "custom/icons/cpu_temp.png"
theme.widget_ac              = themes_path .. "custom/icons/ac.png"
theme.widget_battery         = themes_path .. "custom/icons/battery.png"
theme.widget_battery_low     = themes_path .. "custom/icons/battery_low.png"
theme.widget_battery_empty   = themes_path .. "custom/icons/battery_empty.png"

theme.volhigh                = themes_path .. "custom/icons/volume-high.png"
theme.vollow                 = themes_path .. "custom/icons/volume-low.png"
theme.volmed                 = themes_path .. "custom/icons/volume-medium.png"
theme.volmutedblocked        = themes_path .. "custom/icons/volume-muted-blocked.png"
theme.volmuted               = themes_path .. "custom/icons/volume-muted.png"
theme.voloff                 = themes_path .. "custom/icons/volume-off.png"

-- }}}

-- {{{ Layout
theme.layout_tile       = themes_path .. "custom/layouts/tile.png"
theme.layout_tileleft   = themes_path .. "custom/layouts/tileleft.png"
theme.layout_tilebottom = themes_path .. "custom/layouts/tilebottom.png"
theme.layout_tiletop    = themes_path .. "custom/layouts/tiletop.png"
theme.layout_fairv      = themes_path .. "custom/layouts/fairv.png"
theme.layout_fairh      = themes_path .. "custom/layouts/fairh.png"
theme.layout_spiral     = themes_path .. "custom/layouts/spiral.png"
theme.layout_dwindle    = themes_path .. "custom/layouts/dwindle.png"
theme.layout_max        = themes_path .. "custom/layouts/max.png"
theme.layout_fullscreen = themes_path .. "custom/layouts/fullscreen.png"
theme.layout_magnifier  = themes_path .. "custom/layouts/magnifier.png"
theme.layout_floating   = themes_path .. "custom/layouts/floating.png"
theme.layout_cornernw   = themes_path .. "custom/layouts/cornernw.png"
theme.layout_cornerne   = themes_path .. "custom/layouts/cornerne.png"
theme.layout_cornersw   = themes_path .. "custom/layouts/cornersw.png"
theme.layout_cornerse   = themes_path .. "custom/layouts/cornerse.png"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus  = themes_path .. "custom/titlebar/close_focus.png"
theme.titlebar_close_button_normal = themes_path .. "custom/titlebar/close_normal.png"

theme.titlebar_minimize_button_normal = themes_path .. "default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path .. "default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_focus_active  = themes_path .. "custom/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = themes_path .. "custom/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path .. "custom/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = themes_path .. "custom/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = themes_path .. "custom/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = themes_path .. "custom/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path .. "custom/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = themes_path .. "custom/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = themes_path .. "custom/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = themes_path .. "custom/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = themes_path .. "custom/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = themes_path .. "custom/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = themes_path .. "custom/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = themes_path .. "custom/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path .. "custom/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = themes_path .. "custom/titlebar/maximized_normal_inactive.png"
-- }}}
-- }}}

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
