{ config, pkgs, username, ... }:
let
  repo = "${config.home.homeDirectory}/nix-config";
  link = path: config.lib.file.mkOutOfStoreSymlink "${repo}/config/${path}";
in
{
  home.homeDirectory = "/home/${username}";

  targets.genericLinux.enable = true; # 非NixOS Linux で必須

  xdg.configFile = {
    "ghostty/local".source = link "ghostty/local_linux";
  };
}
