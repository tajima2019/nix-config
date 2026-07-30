{ pkgs, username, ... }:
{
  home.username = username;
  home.stateVersion = "26.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # 検索・ファイル操作
    ripgrep
    fd
    fzf
    zoxide
    eza
    bat
    jq
    yazi
    ffmpegthumbnailer
    unar
    poppler

    # git / dev
    lazygit
    lazydocker
    gh
    delta
    neovim
    tree-sitter
    
    # ツール
    navi
    nb
    sheldon
    marp-cli

    # その他
    fastfetch
    figlet
    lolcat
    cmatrix
    cava
  ];

}
