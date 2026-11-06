#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/wallpaper-thumbs"
mkdir -p "$CACHE_DIR"

# 1回の走査で「壁紙一覧」と「サムネイル未作成/更新が必要なもの」を集める
# (外部コマンドを使わず bash だけで判定するので、キャッシュ済みなら一瞬で終わる)
names=()
missing=()
for file in "$WALLPAPER_DIR"/*; do
  [ -f "$file" ] || continue
  name=${file##*/}
  names+=("$name")
  [ "$CACHE_DIR/$name.png" -nt "$file" ] || missing+=("$file")
done

# 足りないサムネイルだけ並列で生成
if [ "${#missing[@]}" -gt 0 ]; then
  make_thumb() {
    src=$1
    magick "$src[0]" -thumbnail 384x384^ -gravity center -extent 384x384 "$CACHE_DIR/${src##*/}.png"
  }
  export -f make_thumb
  export CACHE_DIR
  printf '%s\0' "${missing[@]}" \
    | xargs -0 -P "$(nproc)" -I{} bash -c 'make_thumb "$1"' _ {}
fi

SELECTED_WALLPAPER=$(
  for name in "${names[@]}"; do
    printf '%s\0icon\x1f%s\n' "$name" "$CACHE_DIR/$name.png"
  done | rofi -dmenu -i -p "Wallpapers" -show-icons \
    -kb-row-left "h" -kb-row-right "l" -kb-row-up "k" -kb-row-down "j" \
    -theme ~/.config/rofi/wallpaper.rasi
)

if [ -n "$SELECTED_WALLPAPER" ]; then
  awww img "$WALLPAPER_DIR/$SELECTED_WALLPAPER" --transition-type grow --transition-pos center --transition-step 100
  notify-send "Wallpaper Changed" "$SELECTED_WALLPAPER"
fi
