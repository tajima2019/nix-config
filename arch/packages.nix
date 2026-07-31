{
  pacman = [
    # base
    "git" "zsh" "unzip" "wget" "less" "tar" "gzip" "base-devel"

    # wayland / hyprland
    "hyprland" "hyprlock" "waybar" "wofi" "awww"

    # display manager
    "sddm"

    # audio
    "pipewire" "pipewire-pulse" "wireplumber" "pavucontrol"

    # input method
    "fcitx5-im" "fcitx5-mozc" "fcitx5-configtool"

    # bluethooth
    "bluez" "bluez-utils"

    # gui
    "ghostty" "imv"

    # languages
    "nodejs" "npm" "go" "python" "python-pip" "python-pynvim" "typst"

    # nixpkgs
    "thefuck"
  ];

  aur = [
    "rofi-wayland"
    "blueman"
    "tty-clock"
    "zen-browser-bin"
  ];
}
