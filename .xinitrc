#!/bin/bash

status () { 
	echo -n "BAT: $(acpi | awk '{print $4}' | sed s/,//) | $(date '+%Y-%m-%d %H:%M:%S')"
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
  sleep 5
done &


exec dwm
