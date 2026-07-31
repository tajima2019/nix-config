{ config, pkgs, username, ... }:
{
  home.homeDirectory = "/home/${username}";

  targets.genericLinux.enable = true; # 非NixOS Linux で必須

  xdg.configFile = {
    "ghostty/local".source = ../config/ghostty/local_linux;
  };
}
