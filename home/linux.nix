{ config, pkgs, username, ... }:
let
  repo = "${config.home.homeDirectory}/nix-config";
  link = path: config.lib.file.mkOutOfStoreSymlink "${repo}/config/${path}";
in
{
  home.homeDirectory = "/home/${username}";

  targets.genericLinux.enable = true; # 非NixOS Linux で必須

  xdg.configFile = {
    "hypr".source = link "hypr";
    "waybar".source = link "waybar";
    "wofi".source = link "wofi";
    "rofi".source = link "rofi";

    "ghostty/local".source = ../config/ghostty/local_arch;
  };
}
