{ config, pkgs, username, ... }:
let
  repo = "${config.home.homeDirectory}/nix-config";
  link = path: config.lib.file.mkOutOfStoreSymlink "${repo}/config/${path}";
in
{
  home.username = username;
  home.stateVersion = "26.11";

  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

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
    imagemagick

    # git / dev
    lazygit
    lazydocker
    gh
    delta
    neovim
    tree-sitter
    uv
    nodejs_22
    
    # ツール
    navi
    nb
    sheldon
    marp-cli
    pay-respects
    herdr
    claude-code
    qwen-code

    # クラウド
    awscli2

    # LSP サーバ
    gopls
    lua-language-server
    typescript-language-server
    pyright
    yaml-language-server
    vscode-langservers-extracted

    # フォーマッタ
    stylua
    prettier
    gotools

    # その他
    fastfetch
    figlet
    lolcat
    cmatrix
    cava
    typst
  ];

  # ~/ に置く設定
  home.file = {
    # 頻繁に編集する / ツールが書き込む
    ".zshrc".source         = link "shell/.zshrc";
    ".zsh_prompt".source    = link "shell/.zsh_prompt";
    ".zsh_plugins".source   = link "shell/.zsh_plugins";
    ".zsh_functions".source = link "shell/.zsh_functions";
    ".nbrc".source          = link "nb/.nbrc";
    
    # 安定していて書き込まれない
    ".hushlogin".source = ../config/.hushlogin;
  };

  # ~/.config に置く設定
  xdg.configFile = {
    # out-of-store: lazy/nvim が lazy-lock.json を書く
    "nvim".source = link "nvim";

    "ghostty/config".source = link "ghostty/config";
    "ghostty/keybindings".source = link "ghostty/keybindings";

    # store 管理
    "sheldon/plugins.toml".source = ../config/sheldon/plugins.toml;
    "fastfetch/config.jsonc".source = ../config/fastfetch/config.jsonc;

    "herdr/config.toml".source = link "herdr/config.toml";
  };

  # ~/.local/share に置く設定
  xdg.dataFile = {
    "navi/cheats/custom_cheats".source = link "cheats"; # cheat を随時追加
  };
}
