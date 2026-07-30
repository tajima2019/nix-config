#!/usr/bin/env bash

source "$CONFIG_DIR/icons.sh" 

WIFI_DEVICE=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')

if [ -z "$WIFI_DEVICE" ]; then
    WIFI_DEVICE="en0" # 見つからなければデフォルトをen0にする
fi

# ipconfig getsummary は詳細な接続情報を出すので、そこから SSID をgrepで抽出する
SSID=$(ipconfig getsummary "$WIFI_DEVICE" | awk -F ' SSID : '  '/ SSID : / {print $2}')

if [ -z "$SSID" ]; then
    IP=$(ipconfig getifaddr "$WIFI_DEVICE")
    if [ -n "$IP" ]; then
        SSID="Connected" # 名前は取れないが繋がってはいる
    else
        SSID=""
    fi
fi

# 表示ロジック
if [ "$SSID" = "" ]; then
  sketchybar --set $NAME label="Disconnected" icon="$ICON_WIFI_OFF"
else
  sketchybar --set $NAME label="$SSID" icon="$ICON_WIFI"
fi
