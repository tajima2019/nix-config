{ config, pkgs, username, ... }:
let
  repo = "${config.home.homeDirectory}/nix-config";
  link = path: config.lib.file.mkOutOfStoreSymlink "${repo}/config/${path}";
in
{
  xdg.configFile = {
    "hypr".source = link "hypr";
    "waybar".source = link "waybar";
    "wofi".source = link "wofi";
    "rofi".source = link "rofi";
  };
}
