{ pkgs, username, ... }:
{
  home.homeDirectory = "/Users/${username}";

  home.packages = with pkgs; [
    pngpaste
  ];
}
