{ pkgs, username, ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  nix.enable = false;

  system.stateVersion = 7;
  system.primaryUser = username;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "none";
    };

    taps = [
      { name = "nikitabobko/tap"; trusted = true; } # aerospace
    ];

    brews = [
      # nixpkgs に無い
      "thefuck"
      "cloudflared"
      "node"
      "nvm"
      "pnpm"
    ];

    casks = [
      # ウィンドウ管理・ターミナル
      "aerospace"
      "alt-tab"
      "ghostty"
      "raycast"
      "keycastr"

      # ブラウザ・コミュニケーション
      "zen"
      "slack"
      "discord"
      "notion"

      # 開発
      "visual-studio-code"
      "docker-desktop"

      # 文書
      "mactex"
      "latexit"
      "skim"

      # フォント・シンボル
      "sf-symbols"
      "font-hack-nerd-font"
      "font-sf-pro"
      "font-sf-mono"
    ];
  };

  # sketchybar
  services.sketchybar.enable = true;
  launchd.user.agents.sketchybar.path = [ "/opt/homebrew/bin" ];

  # macOS システム設定
  system.defaults = {
    NSGlobalDomain = {
      KeyRepeat = 2;                         # キーリピート速度
      InitialKeyRepeat = 15;                 # リピート開始までの待ち
      ApplePressAndHoldEnabled = false;      # 長押しでアクセント記号を出さない
      AppleShowAllExtensions = true;
      NSAutomaticSpellingCorrectionEnabled = false;
    };

    dock = {
      autohide = true;
      show-recents = false;
      mru-spaces = false;
    };

    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "Nlsv";
      ShowPathbar = true;
    };

    screencapture.location = "~/Downloads";
  };
}


