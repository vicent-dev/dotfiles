#!/bin/bash

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

feh --bg-fill $HOME/wallpaper.jpg
setxkbmap -option caps:escape


while true; do
  xprop -root -set WM_NAME "`date \"+ %d/%m/%Y -%k:%M\"`"
  sleep 5
done &


exec dwm
