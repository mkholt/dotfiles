#!/bin/bash

source ~/.config/bar/lemonfunctions.sh

function buildStream() {
    while true
    do
	echo "K$(keyboardLayout)"
	echo "B$(batteryStatus)"
	echo "D$(getDate)"
	echo "C$(getTime)"
	sleep 1s
    done
}

# Define separators and colors
lefthard=""
leftsoft=""
righthard=""
rightsoft=""
color0=$(getColor color0)
color1=$(getColor color1)
color2=$(getColor color2)
color3=$(getColor color3)
color4=$(getColor color4)
color5=$(getColor color5)
color6=$(getColor color6)
color7=$(getColor color7)
color8=$(getColor color8)

# Remove any existing pipe
fifo='/tmp/panel.fifo'
[ -e "$fifo" ] && rm "$fifo"

# Create FIFO pipe
mkfifo "$fifo"

# Pipe the output, and bspwm status to FIFO
buildStream > "$fifo" &
bspc subscribe report > "$fifo" &

# Listen for window title changes, and pipe to FIFO
xtitle -sf "T%{F$color1}%s\n" -t 100 > "$fifo" &

function panel() {
    while read -r line
    do
	case $line in
	    T*)
		# Window Title
		title="${line#?}"
		;;
	    D*)
		# Date
		date="${line#?}"
		;;
	    C*)
		# Time
		time="${line#?}"
		;;
	    K*)
		# Keyboard layout
		kbd="${line#?}"
		;;
	    B*)
		# Battery level
		bat="${line#?}"
		;;
	    W*)
		# bspwm's state
		wm=$(getWorkspaces ${line#?})
	esac

	function panel_layout() {
	    echo "%{l}$wm%{c}$title%{r}$bat $date $time "
	}

	printf "%s%s%s\n" "%{B$color0 F$color7}" "$(panel_layout)" "%{B$color0 F$color7}"
    done
}

panel < "$fifo"
