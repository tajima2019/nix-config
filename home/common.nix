{ pkgs, username, ... }:
{
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "26.11";

  home.packages = with pkgs; [
    hyperfine
    procs
    tokei
  ];

  programs.home-manager.enable = true;
}
