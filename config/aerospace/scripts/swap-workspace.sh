#!/usr/bin/env bash
# 現在のワークスペースと指定ワークスペース（既定: 10）の中身を丸ごと入れ替える。
# AeroSpace にワークスペース同士を交換するコマンドは無いので、
# 両方の window-id を先に控えてから相互に move-node-to-workspace する。
#
# 使い方:  swap-workspace.sh [対象ワークスペース]
#          DRY_RUN=1 swap-workspace.sh 10   # 実際には動かさず確認だけ
set -euo pipefail

TARGET="${1:-10}"
DRY_RUN="${DRY_RUN:-0}"

# AeroSpace から起動されると PATH が最小限なので絶対パスで拾う
AEROSPACE="$(command -v aerospace || echo /opt/homebrew/bin/aerospace)"

CURRENT="$("$AEROSPACE" list-workspaces --focused)"

if [ "$CURRENT" = "$TARGET" ]; then
  echo "現在のワークスペースが $TARGET です。何もしません。" >&2
  exit 0
fi

ids_of() {
  "$AEROSPACE" list-windows --workspace "$1" --format '%{window-id}'
}

# 移動を始める前に両方の一覧を確定させる。
# 先に片方を移してから取得すると、移動済みのウィンドウを拾ってしまう。
CURRENT_IDS="$(ids_of "$CURRENT")"
TARGET_IDS="$(ids_of "$TARGET")"

move() {
  if [ "$DRY_RUN" = "1" ]; then
    echo "would: window $1 -> workspace $2"
  else
    "$AEROSPACE" move-node-to-workspace --window-id "$1" "$2"
  fi
}

# window-id は数値のみなので単語分割で問題ない（bash 3.2 でも動くよう mapfile は使わない）
for id in $CURRENT_IDS; do move "$id" "$TARGET"; done
for id in $TARGET_IDS;  do move "$id" "$CURRENT"; done
