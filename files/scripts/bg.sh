#!/bin/bash

wal -c
wal -i $1
cp $1 ~/.config/background.jpg
node ~/.config/polybar/wal.js &
pkill dunst
pkill polybar
i3-msg "exec dunst &" > /dev/null
i3-msg "exec polybar &" > /dev/null
betterlockscreen -u $1 > /dev/null  &
