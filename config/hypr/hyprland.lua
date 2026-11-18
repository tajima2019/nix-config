-- Hyprland 0.57+ の設定(0.57で hyprland.conf 形式は廃止)
-- https://wiki.hypr.land/configuring/

-- 入力メソッド(fcitx5)
hl.env("GTK_IM_MODULE", "fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("GLFW_IM_MODULE", "fcitx")

------------------
---- MONITORS ----
------------------

-- ノートPC本体(mac)
hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 2 })

-- 外部モニター
hl.monitor({ output = "DP-1", mode = "preferred", position = "auto", scale = 1 })

---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "ghostty"
local fileManager = "dolphin"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("blueman-applet") -- Bluetoothマネージャーの常駐
    hl.exec_cmd("waybar")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("fcitx5 -d --replace")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 20,

        border_size = 2,

        col = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = false,
        allow_tearing    = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = false,
    },
})

hl.curve("easeOutQuint",   { type = "bezier", points = { { 0.23, 1 },    { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear",         { type = "bezier", points = { { 0, 0 },       { 1, 1 } } })
hl.curve("almostLinear",   { type = "bezier", points = { { 0.5, 0.5 },   { 0.75, 1 } } })
hl.curve("quick",          { type = "bezier", points = { { 0.15, 0 },    { 0.1, 1 } } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })

---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout = "jp",
        kb_model  = "apple_laptop",

        follow_mouse = 1,

        sensitivity   = -0.1,
        scroll_factor = 0.5, -- スクロールを遅くする

        touchpad = {
            natural_scroll = true,
            scroll_factor  = 0.3, -- スクロールを遅くする
            tap_to_click   = false,
        },
    },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Commandキー

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + space",  hl.dsp.exec_cmd("pkill wofi || wofi --show drun"))
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + Q",      hl.dsp.window.close())
hl.bind(mainMod .. " + B",      hl.dsp.exec_cmd("zen-browser"))
hl.bind(mainMod .. " + W",      hl.dsp.exec_cmd("pkill rofi || ~/.config/hypr/scripts/wallpaper_selector.sh"))
hl.bind(mainMod .. " + M",      hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + T", hl.dsp.layout("togglesplit")) -- 分割方向の切り替え

-- フォーカス移動(Vimスタイル: HJKL)
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- ウィンドウ自体の移動(Cmd + Shift + HJKL)
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

-- ワークスペース切り替え(Cmd + 0-9) / ウィンドウをワークスペースへ移動(Cmd + Shift + 0-9)
for i = 1, 10 do
    local key = i % 10 -- 10 は 0 キー
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- サイズ変更(Cmd + - で縮小, Cmd + Shift + - で拡大)
hl.bind(mainMod .. " + minus",         hl.dsp.window.resize({ x = -40, y = -40, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + minus", hl.dsp.window.resize({ x = 40, y = 40, relative = true }),   { repeating = true })

-- スクリーンショット
local screenshot = '"$HOME/Pictures/Screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"'
hl.bind(mainMod .. " + CTRL + S",         hl.dsp.exec_cmd("grim - | wl-copy"))                     -- 全画面(クリップボード)
hl.bind(mainMod .. " + SHIFT + CTRL + S", hl.dsp.exec_cmd("grim " .. screenshot))                  -- 全画面(ファイル保存)
hl.bind(mainMod .. " + CTRL + 3",         hl.dsp.exec_cmd('grim -g "$(slurp)" ' .. screenshot))    -- 範囲選択(ファイル保存)
hl.bind(mainMod .. " + CTRL + 4",         hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))       -- 範囲選択(クリップボード)

-- スクラッチパッド(Cmd + Tab で表示/非表示, Cmd + Shift + Tab で送る)
hl.bind(mainMod .. " + Tab",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.window.move({ workspace = "special:magic" }))

-- ロック画面
hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd("hyprlock"))

-- 音量・輝度
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),          { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),               { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),              { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),            { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                           { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                           { locked = true, repeating = true })
hl.bind("XF86KbdBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -d apple::kbd_backlight set 20%+"),          { locked = true, repeating = true })
hl.bind("XF86KbdBrightnessDown", hl.dsp.exec_cmd("brightnessctl -d apple::kbd_backlight set 20%-"),          { locked = true, repeating = true })

-- メディアキー(playerctl)
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- 蓋を閉じた時: ロック + 画面オフ + 省電力
-- (dpmsをバインドから直接呼ぶと不安定なのでwiki推奨どおりタイマー経由にする)
hl.bind("switch:on:Lid Switch", function()
    hl.exec_cmd("hyprlock")
    hl.exec_cmd("powerprofilesctl set power-saver")
    hl.timer(function()
        hl.dispatch(hl.dsp.dpms({ action = "disable" }))
    end, { timeout = 500, type = "oneshot" })
end, { locked = true })

-- 蓋を開けた時: 画面オン + 通常モード
hl.bind("switch:off:Lid Switch", function()
    hl.exec_cmd("powerprofilesctl set balanced")
    hl.timer(function()
        hl.dispatch(hl.dsp.dpms({ action = "enable" }))
    end, { timeout = 500, type = "oneshot" })
end, { locked = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- zenはアクティブ時1.0, 非アクティブ時0.8の透明度
hl.window_rule({
    name    = "zen-opacity",
    match   = { class = "zen" },
    opacity = "1.0 override 0.8 override",
})

hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    -- XWaylandのドラッグ不具合対策
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
