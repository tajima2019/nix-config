# nix-config

macOS (nix-darwin) と Linux (home-manager) を1つの flake で管理する設定。

## Setup

```bash
curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
git clone git@github.com:tajima2019/nix-config.git ~/nix-config
cd ~/nix-config && ./install.sh
```

`install.sh` が OS とディストリを判定して、システム層（Homebrew / pacman / apt）と
home-manager をまとめて適用する。

> `~/nix-config` に clone すること。設定の一部は
> `~/nix-config/config/...` への絶対パス symlink になっている。

## Usage

| | |
|---|---|
| macOS | `sudo darwin-rebuild switch --flake ~/nix-config#mac` |
| Arch | `home-manager switch --flake ~/nix-config#$(whoami)@arch` |
| Ubuntu | `home-manager switch --flake ~/nix-config#$(whoami)@ubuntu` |
| 更新 | `nix flake update` → 上記を実行 |
| 巻き戻し | macOS: `--rollback` / Linux: `home-manager generations` |
| お試し | `nix shell nixpkgs#<pkg>`（インストールせず実行） |

パッケージのバージョンは `flake.lock` に固定されている。
`nix flake update` しない限り上がらない。

## Structure

| | |
|---|---|
| `flake.nix` | 構成の入口。`mac` / `<user>@arch` / `<user>@ubuntu` |
| `user.nix` | ユーザー名。別マシン / フォークではここだけ書き換える |
| `home/common.nix` | **両OS共通**のパッケージと dotfiles 配置 |
| `home/darwin.nix` | macOS 固有 |
| `home/linux.nix` | Linux 共通 |
| `home/hyprland.nix` | Hyprland 環境固有（hypr / waybar / wofi / rofi） |
| `darwin/default.nix` | macOS システム層（Homebrew cask, defaults, sketchybar） |
| `arch/packages.nix` | Arch のシステム層パッケージ（pacman / paru が適用） |
| `ubuntu/packages.nix` | Ubuntu のシステム層パッケージ（apt が適用） |
| `config/` | 設定ファイル実体 |

環境はモジュールの足し算で表現する。

```
mac    = common + darwin
arch   = common + linux + hyprland
ubuntu = common + linux
```

## どこに何を置くか

- **両OSで使うもの** → `home/common.nix`。片方のOSでしか使わないものを nix に移しても管理箇所が増えるだけ
- **macOS で TCC 権限（アクセシビリティ等）が要る GUI** → Homebrew cask。nixpkgs は ad-hoc 署名になり、更新のたびに権限付与が必要になる（aerospace, alt-tab, raycast, keycastr）
- **Linux で GPU / コンポジタと密結合するもの** → pacman / apt。nix ビルドは `/run/opengl-driver` を見つけられない（hyprland, waybar, wofi, rofi）
- **GUI アプリやコンポジタから呼ばれるコマンド** → 絶対パスで書く。それらの PATH に nix は入らない
  - 例: `aerospace.toml` は `/run/current-system/sw/bin/sketchybar` を呼ぶ
  - Hyprland の keybind が使う `grim` / `slurp` / `wl-clipboard` は pacman 側に置く
- **ツールが書き戻すファイル / 頻繁に編集するもの** → `mkOutOfStoreSymlink`（nvim, shell, sketchybar, hypr, cheats, .nbrc）
  それ以外は store 管理（ghostty, sheldon, fastfetch, aerospace）

## Notes

- `git add` していないファイルは flake から見えない。新規ファイルを作ったら必ず `git add`
- `nix eval .#homeConfigurations."$(whoami)@arch".activationPackage.drvPath` で、
  適用せずに設定の記述ミスを検出できる
- nixpkgs に無い / broken: `thefuck`, `tty-clock`, `zen`, darwin の `ghostty`
