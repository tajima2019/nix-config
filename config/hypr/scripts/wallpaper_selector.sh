#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

MENU_STRING=""
for file in "$WALLPAPER_DIR"/*; do
  if [ -f "$file" ]; then
    filename=$(basename "$file")
    MENU_STRING+="${filename}\0icon\x1f${file}\n"
  fi
done

# Rofiを起動して壁紙を選択
SELECTED_WALLPAPER=$(echo -e -n "$MENU_STRING" | rofi -dmenu -i -p "Wallpapers" -show-icons -theme ~/.config/rofi/wallpaper.rasi)

if [ -n "$SELECTED_WALLPAPER" ]; then
  awww img "$WALLPAPER_DIR/$SELECTED_WALLPAPER" --transition-type grow --transition-pos center --transition-step 100

  notify-send "Wallpaper Changed" "$SELECTED_WALLPAPER"
fi

