#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/hyprpaper.conf"
TEMP_CONFIG="/tmp/hyprpaper_temp.conf"
WINDOW_TITLE="Selector de Fondo de Pantalla"

set_wallpaper() {
  selected_file="$1"

  if [ -f "$CONFIG_FILE" ]; then
    grep -v -e '^wallpaper =' -e '^preload =' "$CONFIG_FILE" >"$TEMP_CONFIG"
  else
    touch "$TEMP_CONFIG"
  fi

  echo "preload = $selected_file" >>"$TEMP_CONFIG"
  echo "wallpaper = ,$selected_file" >>"$TEMP_CONFIG"

  mv "$TEMP_CONFIG" "$CONFIG_FILE"
  killall hyprpaper 2>/dev/null
  hyprpaper &
}

selected_file=$(yad --file --title="$WINDOW_TITLE" \
  --width=800 --height=600 \
  --window-icon="preferences-desktop-wallpaper" \
  --file-filter="Imágenes | *.jpg *.jpeg *.png *.webp *.bmp" \
  --filename="$HOME/Imágenes/" \
  --center)

if [ $? -eq 0 ] && [ -f "$selected_file" ]; then
  set_wallpaper "$selected_file"
  notify-send "Wallpaper updated" "New wallpaper: $(basename "$selected_file")" \
    -i "$selected_file" -t 3000
else
  notify-send "This was stopped" "The wallpaper wasn't updated" -t 2000
fi
