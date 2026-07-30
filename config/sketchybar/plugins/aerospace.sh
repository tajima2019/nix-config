#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

source "$CONFIG_DIR/icons.sh"
source "$CONFIG_DIR/colors.sh"

# ワークスペースID ($1) に応じてアイコンを決める
case "$1" in
  "N")
    ICON=$ICON_NOTION # Notion
    ;;
  "S")
    ICON=$ICON_SLACK # Slack
    ;;
  "Z")
    ICON=$ICON_ZOOM # Zoom
    ;;
esac

# リロード直後にフォーカスされているワークスペースを取得
if [ -z "$FOCUSED_WORKSPACE" ]; then
    FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
fi

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME \
      icon="$ICON" \
      icon.color=$COLOR_ACCENT \
      label.color=$COLOR_ACCENT \
      label.font="Hack Nerd Font:Bold:16.0"
else
    sketchybar --set $NAME \
      icon="$ICON" \
      icon.color=$COLOR_INACTIVE \
      label.color=$COLOR_INACTIVE \
      label.font="Hack Nerd Font:Bold:14.0"
fi
