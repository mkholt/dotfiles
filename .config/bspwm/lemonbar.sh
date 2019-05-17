#!/bin/bash

color0=$(xrdb -query -all | grep "*.color0" | sed "s/\*.color0:\t//")
color7=$(xrdb -query -all | grep "*.color7" | sed "s/\*.color7:\t//")

echo Launching script

~/.config/bspwm/lemonbarshow.sh | lemonbar -a 20 -B $color0 -F $color7 -f "FiraCode-11" -g x18 -p | sh
