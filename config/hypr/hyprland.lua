-- {{#each MONITORS}}
hl.monitor({
    output = "{{this.name}}",
    mode = "{{this.width}}x{{this.height}}@{{this.refresh_rate}}",
    position = "{{this.x}}x{{this.y}}",
    scale = 1.0
})
-- {{/each}}

local terminal = "kitty"
local fileManager = terminal .. " yazi"
local menu = "fuzzel"

hl.exec_cmd("killall mprisence; sleep 0.1; mprisence")
hl.exec_cmd("killall waybar; sleep 0.1; waybar")
hl.exec_cmd("killall cava")
hl.exec_cmd("sunsetr restart")
-- {{#if LAPTOP}}
hl.exec_cmd("~/bin/laptop_visualizer")
-- {{else}}
hl.exec_cmd("~/bin/desktop_visualizer")
-- {{/if}}

hl.on("hyprland.start", function ()
    hl.exec_cmd("hyprctl dispatch workspace 1")
    hl.exec_cmd("hyprlock")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("wl-paste --watch cliphist store")
    hl.exec_cmd("hyprpm reload")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
--  {{#unless LAPTOP}}
    hl.exec_cmd("gpu-screen-recorder -w {{MONITORS.2.name}} -r 60 -f 30 -a 'default_output|default_input' -c mp4 -o ~/Videos/Replays -bm cbr -q 12000")
--  {{/unless}}
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("EDITOR", "nvim")

hl.config({
    general = {
        gaps_in  = 4,
        gaps_out = 12,

        border_size = 2,

        col = {
            active_border   = "rgba(4060ffff)",
            inactive_border = "rgba(80808080)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 8,
        rounding_power = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 0.92,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled   = true,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },
    animations = {
        enabled = true,
    },
})

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

hl.animation({ leaf = "global",         enabled = true, speed = 10,   bezier = "default" })

hl.animation({ leaf = "windows",        enabled = true, speed = 2,    bezier = "easeInOutCubic" })
hl.animation({ leaf = "windowsIn",      enabled = true, speed = 4.1,  bezier = "easeOutQuint",  style = "slide" })
hl.animation({ leaf = "windowsOut",     enabled = true, speed = 1.49, bezier = "linear",        style = "slide" })

hl.animation({ leaf = "layers",         enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",       enabled = true, speed = 4,    bezier = "easeOutQuint",  style = "fade" })
hl.animation({ leaf = "layersOut",      enabled = true, speed = 1.5,  bezier = "linear",        style = "fade" })

hl.animation({ leaf = "fade",           enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "fadeSwitch",     enabled = true, speed = 5, bezier = "quick" })
hl.animation({ leaf = "fadeIn",         enabled = true, speed = 2, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",        enabled = true, speed = 2, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersIn",   enabled = true, speed = 2, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut",  enabled = true, speed = 2, bezier = "almostLinear" })

hl.animation({ leaf = "border",         enabled = true, speed = 3, bezier = "linear" })

hl.animation({ leaf = "workspaces",     enabled = true, speed = 6, bezier = "easeOutQuint",  style = "slide 150%" })
hl.animation({ leaf = "zoomFactor",     enabled = true, speed = 7,    bezier = "quick" })

-- {{#each WORKSPACES}}
-- {{#if this.default}}
hl.workspace_rule({workspace = '{{math @index "+" 1}}', monitor = "{{this.name}}", persistent = true, default = true})
-- {{else}}
hl.workspace_rule({workspace = '{{math @index "+" 1}}', monitor = "{{this.name}}", persistent = true})
-- {{/if}}
-- {{/each}}

hl.config({
    dwindle = {
        preserve_split = true,
    },
})

hl.config({
    misc = {
        allow_session_lock_restore = 1,
        force_default_wallpaper = 0,
        disable_hyprland_logo = false,
    },
})

hl.config({
    input = {
        kb_layout = "us",
        follow_mouse = 2,
        sensitivity = 0,

        touchpad = {
            natural_scroll = false,
            tap_to_click = true,
            clickfinger_behavior = true
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})

hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})

local mainMod = "SUPER"

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(menu))

hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("crt_manager"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("hyprpicker"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("hyprshot -m output --clipboard-only"), { locked = true })
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only --freeze"), { locked = true })
hl.bind(mainMod .. " + ALT + S", hl.dsp.exec_cmd("pkill -SIGUSR1 -f '^gpu-screen-recorder' & notify-send 'Saved replay!'"), { locked = true})

hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + K", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.kill())
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("cliphist-fuzzel-img"))
hl.bind(mainMod .. " + W", hl.dsp.window.float())

hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))

-- {{#each WORKSPACES}}
hl.bind(mainMod .. ' + {{math @index "+" 1}}', hl.dsp.focus({ workspace = '{{this.str}}{{math @index "+" 1}}' }))
hl.bind(mainMod .. ' + SHIFT + {{math @index "+" 1}}', hl.dsp.window.move({ workspace = '{{this.str}}{{math @index "+" 1}}' }))
-- {{/each}}

-- {{#each MONITORS}}
hl.bind(mainMod .. ' + ALT + {{math @index "+" 1}}', hl.dsp.window.move({ monitor = "{{this.name}}" }))
-- {{/each}}

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 10%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 10%-"), { locked = true, repeating = true })

-- {{#if LAPTOP}}
hl.bind("pause",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind(mainMod .. " + pause",  hl.dsp.exec_cmd("audacious cdda://"), { locked = true })
-- {{else}}
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind(mainMod .. " + XF86AudioPlay",  hl.dsp.exec_cmd("audacious cdda://"), { locked = true })
-- {{/if}}
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

hl.window_rule({
	name = "sound_control",
	match = { class = "org.pulseaudio.pavucontrol" },

	float = true,
	size = "{800, 600}",
	center = true
})

hl.window_rule({
	name = "bt_control",
	match = { class = "blueman-manager" },

	float = true,
	size = "{800, 600}",
	center = true
})

hl.window_rule({
    name = "minecraft",
    match = {class = "^.*Minecraft.*$"},

    monitor = "HDMI-A-1",
    fullscreen = true
})
