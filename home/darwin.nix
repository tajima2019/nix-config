{ config, pkgs, username, ... }:
let
  repo = "${config.home.homeDirectory}/nix-config";
  link = path: config.lib.file.mkOutOfStoreSymlink "${repo}/config/${path}";
in
{
  home.homeDirectory = "/Users/${username}";

  home.packages = with pkgs; [
    pngpaste
    matlab-language-server
  ];

  xdg.configFile = {
    "sketchybar".source = link "sketchybar";

    # store 管理
    "aerospace/aerospace.toml".source = ../config/aerospace/aerospace.toml;
    "ghostty/local".source            = ../config/ghostty/local_mac;
  };
}
