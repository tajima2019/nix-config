#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

source "$CONFIG_DIR/icons.sh"
source "$CONFIG_DIR/colors.sh"

# ワークスペースID ($1) に応じてアイコンを決める
# 数字のワークスペースはアイコン無し (ラベルの番号だけ) なので Nerd Font のまま
ICON_FONT="Hack Nerd Font:Bold:16.0"

case "$1" in
  "N")
    ICON=$ICON_NOTION # Notion
    ICON_FONT=$FONT_APP
    ;;
  "S")
    ICON=$ICON_SLACK # Slack
    ICON_FONT=$FONT_APP
    ;;
  "Z")
    ICON=$ICON_ZOOM # Zoom
    ICON_FONT=$FONT_APP
    ;;
  "F")
    ICON=$ICON_FINDER # Finder
    ICON_FONT=$FONT_APP
    ;;
esac

# リロード直後にフォーカスされているワークスペースを取得
if [ -z "$FOCUSED_WORKSPACE" ]; then
    FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
fi

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME \
      icon="$ICON" \
      icon.font="$ICON_FONT" \
      icon.color=$COLOR_ACCENT \
      label.color=$COLOR_ACCENT \
      label.font="Hack Nerd Font:Bold:16.0"
else
    sketchybar --set $NAME \
      icon="$ICON" \
      icon.font="$ICON_FONT" \
      icon.color=$COLOR_INACTIVE \
      label.color=$COLOR_INACTIVE \
      label.font="Hack Nerd Font:Bold:14.0"
fi
