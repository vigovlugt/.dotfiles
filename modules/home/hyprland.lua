-- Loaded by wayland.windowManager.hyprland.extraLuaFiles in hyprland.nix.
-- Reference: https://wiki.hypr.land/Configuring/Start/

local mod = "SUPER"
local terminal = "ghostty"
local fileManager = "dolphin"
local menu = "vicinae toggle"
local browser = "firefox"
local colorpicker = "hyprpicker --autocopy"

hl.config({
    general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 0,
        layout = "master",
    },

    animations = {
        enabled = false,
    },

    input = {
        force_no_accel = true,
    },

    cursor = {
        no_hardware_cursors = true,
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
    },
})

---- Workspaces ----

for i = 0, 9 do
    hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

---- Programs ----

hl.bind(mod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mod .. " + Space", hl.dsp.exec_cmd(menu))
hl.bind(mod .. " + apostrophe", hl.dsp.exec_cmd(browser))
hl.bind(mod .. " + L", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd("grimblast copy area"))
hl.bind(mod .. " + SHIFT + C", hl.dsp.exec_cmd(colorpicker))

---- Windows ----

hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mod .. " + P", hl.dsp.window.pseudo())
hl.bind(mod .. " + SHIFT + Space", hl.dsp.window.float({ action = "toggle" }))

hl.bind(mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.window_rule({
    match = { class = "^(discord)$" },
    workspace = "2 silent",
})

hl.window_rule({
    match = { class = "^(Code|code|code-url-handler|Cursor|cursor|cursor-url-handler)$" },
    workspace = "4 silent",
})

---- Autostart ----

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("mako")
    hl.exec_cmd("vicinae server")
    hl.exec_cmd("firefox", { workspace = "1 silent" })
    hl.exec_cmd("discord", { workspace = "2 silent" })
    hl.exec_cmd(terminal, { workspace = "3 silent" })
end)
