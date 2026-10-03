
--  _   _  __   __  ____    ____    _          _      _   _  ____
-- | | | | \ \ / / |  _ \  |  _ \  | |        / \    | \ | ||  _ \
-- | |_| |  \ V /  | |_) | | |_) | | |       / _ \   |  \| || | | |
-- |  _  |   | |   |  __/  |  _ <  | |___   / ___ \  | |\  || |_| |
-- |_| |_|   |_|   |_|     |_| \_\ |_____| /_/   \_\ |_| \_||____/
--

---@module 'hl'

-- --- SYSTEM SETTINGS (AMD) -------------------------------------------------

hl.env("LIBVA_DRIVER_NAME", "radeonsi")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- --- MONITOR CONFIGURATION --------------------------------------------------------

hl.monitor({
    output   = "DP-1",
    mode     = "1920x1080@200",
    position = "0x0",
    scale    = 1
})

-- --- LOOK & FEEL ------------------------------------------------------------------

hl.config({
    general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 1,
        resize_on_border = true,
        layout = "dwindle",
        col = {
            active_border = "rgba(ffffffee)",
          inactive_border = "rgba(595959ee)",
        },
    },
})

--hl.config({
    --decoration = {
        --screen_shader = "/home/rixard/.config/hypr/shaders/vibrance.glsl",
    --},
--})

hl.config({
    decoration = {
        blur = {
            enabled = false,
        },
    },
})

hl.config({
    misc = {
        force_default_wallpaper = 0,
            disable_hyprland_logo = true,
            disable_splash_rendering = true,
            background_color = "rgb(000000)",
          vrr = 1,
    },
})

hl.config({
    animations = {
        enabled = false,
    },
})

hl.animation({ leaf = "windows", enabled = false })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 5, bezier = "default", style = "fade" })

-- --- INPUT SETTINGS --------------------------------------------------------------

hl.config({
    input = {
        kb_layout = "us",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = false,
            disable_while_typing = false
        },
    },
})

-- --- KEYBINDINGS -----------------------------------------------------------------

local mod = "SUPER"

-- Mouse bindings to move and resize floating windows

hl.bind(mod .. " + " .. "mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + " .. "mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Toggle system tray overlay window

hl.bind(mod .. " + " .. "r", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"))

-- Terminal & Apps

hl.bind(mod .. " + " .. "Return", hl.dsp.exec_cmd("kitty"))
hl.bind(mod .. " + " .. "x", hl.dsp.exec_cmd("pkill hyprpicker || hyprpicker -a"))
hl.bind(mod .. " + " .. "e", hl.dsp.exec_cmd("thunar"))
hl.bind(mod .. " + " .. "d", hl.dsp.exec_cmd("pkill tofi || tofi-drun --drun-launch=true"))

-- Clipboard history

hl.bind(mod .. " + " .. "c", hl.dsp.exec_cmd("pkill tofi || cliphist list | tofi | cliphist decode | wl-copy"))

-- Window Management

hl.bind(mod .. " + " .. "q", hl.dsp.window.close())
hl.bind(mod .. " + " .. "SHIFT" .. " + " .. "q", hl.dsp.exec_cmd("kill -9 $(hyprctl activewindow | grep 'pid:' | awk '{print $2}')"))
hl.bind(mod .. " + " .. "f", hl.dsp.window.fullscreen())
hl.bind(mod .. " + " .. "space", hl.dsp.window.float())

-- Focus movement

hl.bind(mod .. " + " .. "left", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + " .. "right", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + " .. "up", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + " .. "down", hl.dsp.focus({ direction = "down" }))

-- Screenshot Logic

hl.bind(mod .. " + " .. "z", hl.dsp.exec_cmd("pkill slurp || grim -g \"$(slurp)\" ~/Pictures/last-screenshot.png && wl-copy < ~/Pictures/last-screenshot.png"))
hl.bind(mod .. " + " .. "SHIFT" .. " + " .. "z", hl.dsp.exec_cmd("grim - | tee ~/Pictures/screenshot-$(date +%s).png | wl-copy"))

hl.bind("print", hl.dsp.exec_cmd("pkill slurp || grim -g \"$(slurp)\" ~/Pictures/last-screenshot.png && wl-copy < ~/Pictures/last-screenshot.png"))
hl.bind("SHIFT" .. " + " .. "print", hl.dsp.exec_cmd("grim - | tee ~/Pictures/screenshot-$(date +%s).png | wl-copy"))

hl.bind(mod .. " + " .. "s", hl.dsp.exec_cmd("pkill swappy || swappy -f ~/Pictures/last-screenshot.png"))

-- --- WORKSPACES ------------------------------------------------------------------

-- Toggle the hidden scratchpad view on/off

hl.bind(mod .. " + " .. "v", hl.dsp.workspace.toggle_special("magic"))

-- Move the currently active window into the scratchpad

hl.bind(mod .. " + " .. "SHIFT" .. " + " .. "v", hl.dsp.window.move({ workspace = "special:magic" }, { follow = false }))

for i = 1, 10 do
    local key = i % 10
    hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- --- LOCK & EXIT -----------------------------------------------------------------

hl.bind(mod .. " + " .. "l", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mod .. " + " .. "SHIFT" .. " + " .. "e", hl.dsp.exec_cmd("hyprctl dispatch exit"))

-- --- WINDOW RULES -----------------------------------------------------------------

hl.window_rule({
    name  = "suppress_event_maxim",
    match = {
        class = ".*",
    },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "no_focus_1",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})

hl.window_rule({
    name  = "opacity_0_85_0_85",
    match = {
        workspace = "special:magic",
    },
    opacity = "0.85 0.85",
})

hl.window_rule({
    name  = "no_float",
    match = {
        workspace = "special:magic",
    },
    float = false,
})

--hl.window_rule({
    --name = "thunar_opacity",
    --match = { class = "thunar" },
    --opacity = "0.85 0.85",
--})

-- --- STARTUP / AUTO-EXEC -----------------------------------------------------------

hl.on("hyprland.start", function()
hl.exec_cmd("playerctld daemon")
hl.exec_cmd("waybar")
hl.exec_cmd("blueman-applet")
hl.exec_cmd("nm-applet")
hl.exec_cmd("/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh")
hl.exec_cmd("mako")
hl.exec_cmd("wl-paste --type text --watch cliphist store")
hl.exec_cmd("wl-paste --type image --watch cliphist store")
hl.exec_cmd("easyeffects --gapplication-service")
hl.exec_cmd("solaar -w hide")
hl.exec_cmd("hyprpaper")
hl.exec_cmd("hypridle")
end)
