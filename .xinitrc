#!/bin/bash

status () { 
    echo -n "VOL: $(awk -F"[][]" '/Left:/ { print $2 }' <(amixer sget Master)) | MUTE: $(pacmd list-sinks | awk '/muted/ { print $2 }') | BAT: $(acpi | awk '{print $4}' | sed s/,//) | $(date '+%Y-%m-%d %H:%M')"
}


if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

feh --bg-fill $HOME/wallpaper.jpeg
setxkbmap -option caps:escape


while true; do
    xprop -root -set WM_NAME "$(status)"
  sleep 3
done &


exec dwm
