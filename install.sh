#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/tajima2019/nix-config"
REPO_DIR="$HOME/nix-config"

# Nix
if ! command -v nix > /dev/null 2>&1; then
  echo "==> Installing Nix..."

  if [ "$(uname)" = "Darwin" ]; then
    xcode-select --install 2>/dev/null || true
  fi

  curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install

  set +u
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  set -u
fi

# repo
[ -d "$REPO_DIR" ] || git clone "$REPO_URL" "$REPO_DIR"
cd "$REPO_DIR"

case "$(uname)" in

# macOS
Darwin)
  echo "==> macOS (nix-darwin)"
  if command -v darwin-rebuild > /dev/null 2>&1; then
    sudo darwin-rebuild switch --flake .#mac
  else
    nix build .#darwinConfigurations.mac.system
    sudo ./result/sw/bin/darwin-rebuild switch --flake .#mac
    rm -f result
  fi
  ;;

# Linux
Linux)
  . /etc/os-release

  case "${ID:-}" in
    arch)
      echo "==> Arch: system layer (pacman)"

      read -ra PACMAN_PKGS <<< "$(nix eval --raw -f arch/packages.nix --apply 'p: builtins.concatStringsSep " " p.pacman')"
      read -ra AUR_PKGS    <<< "$(nix eval --raw -f arch/packages.nix --apply 'p: builtins.concatStringsSep " " p.aur')"

      [ ${#PACMAN_PKGS[@]} -gt 0 ] && [ ${#AUR_PKGS[@]} -gt 0 ] || {
        echo "ERORR: arch/packages.nix からパッケージリストを読めませんでした"; exit 1
      }

      sudo pacman -Syu --needed --noconfirm "${PACMAN_PKGS[@]}"

      if ! command -v paru > /dev/null 2>&1; then
        echo "==> Installing paru"
        tmp=$(mktemp -d)
        git clone https://aur.archlinux.org/paru.git "$tmp"
        (cd "$tmp" && makepkg -si --noconfirm)
        rm -rf "$tmp"
      fi
      paru -S --needed "${AUR_PKGS[@]}"

      echo "==> sddm"
      sudo install -Dm644 config/sddm/sddm.conf /etc/sddm.conf
      sudo systemctl enable sddm

      HM_TARGET="arch"
      ;;

    ubuntu|debian)
      echo "==> Ubuntu/Debian: system layer (apt)"
      read -ra APT_PKGS <<< "$(nix eval --raw -f ubuntu/packages.nix --apply 'p: builtins.concatStringsSep " " p.apt')"

      [ ${#APT_PKGS[@]} -gt 0 ] || {
        echo "ERROR: ubunt/packages.nix からパッケージリストを読めませんでした"; exit 1
      }

      sudo apt-get update
      sudo apt-get install -y "${APT_PKGS[@]}"

      HM_TARGET="ubuntu"
      ;;
    *)
      echo "Unsupported distro: ${ID:-unknown}"; exit 1 ;;
  esac

  echo "==> default shell"
  ZSH_PATH="$(command -v zsh)"
  [ "${SHELL:-}" = "$ZSH_PATH" ] || chsh -s "$ZSH_PATH"

  echo "==> home-manager"
  if command -v home-manager > /dev/null 2>&1; then
    home-manager switch --flake ".#$(whoami)@$HM_TARGET"
  else
    nix run home-manager/master -- switch --flake ".#$(whoami)@$HM_TARGET" -b hm-bak
  fi
  ;;

*)
  echo "Unsupported OS: $(uname)"; exit 1 ;;
esac

echo "Done!"

chmod +x ~/nix-config/install.sh





