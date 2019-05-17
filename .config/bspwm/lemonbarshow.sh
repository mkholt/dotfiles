#!/bin/bash

lefthard=""
leftsoft=""
righthard=""
rightsoft=""
color0=""
color1=""
color2=""
color3=""
color4=""
color5=""
color6=""
color7=""
color8=""

function setColors() {
    color0=$(xrdb -query -all | grep "*.color0:" | sed "s/\*.color0:\t//")
    color1=$(xrdb -query -all | grep "*.color1:" | sed "s/\*.color1:\t//")
    color2=$(xrdb -query -all | grep "*.color2:" | sed "s/\*.color2:\t//")
    color3=$(xrdb -query -all | grep "*.color3:" | sed "s/\*.color3:\t//")
    color4=$(xrdb -query -all | grep "*.color4:" | sed "s/\*.color4:\t//")
    color5=$(xrdb -query -all | grep "*.color5:" | sed "s/\*.color5:\t//")
    color6=$(xrdb -query -all | grep "*.color6:" | sed "s/\*.color6:\t//")
    color7=$(xrdb -query -all | grep "*.color7:" | sed "s/\*.color7:\t//")
    color8=$(xrdb -query -all | grep "*.color8:" | sed "s/\*.color8:\t//")
}

function getWorkspaces() {
    wrkspc=$(i3-msg -t get_workspaces | jq '.[].name' | sed s/\"// | sed s/\"//)
    echo -n "%{A5:i3-msg -q workspace next:}%{A4:i3-msg -q workspace prev:}"
    for i in $wrkspc ; do
	focused=$(i3-msg -t get_workspaces | jq ".[] | select(.name==\"$i\").focused")
	urgent=$(i3-msg -t get_workspaces | jq ".[] | select(.name==\"$i\").urgent")
	if $focused ; then
	    echo -n "%{B$color4 F$color7} $i %{B$color0 F$color7}"
	else
	    if $urgent ; then
		echo -n "%{B$color7 F$color0}"
                echo -n "%{A:i3-msg -q workspace number $i:} $i %{A}"
                echo -n "%{B$color0 F$color7}"
	    else
		echo -n "%{B$color0 F$color4}"
                echo -n "%{A:"i3-msg -q workspace number $i":} $i %{A}"
                echo -n "%{B$color0 F$color7}"
	    fi
	fi
    done
    echo -n "%{A}%{A}%{r}"
}

function batteryStatus() {
    pct=$(cat ~/share/battery | cut -d' ' -f 1)
    state=$(cat ~/share/battery | cut -d' ' -f 2)
    if [ $state = "discharging" ]; then
	echo -n "%{F$color7}$righthard%{B$color0 R}"
    else
	echo -n "%{F$color2}$righthard%{B$color0 R}"
    fi
    echo -n " BAT: $pct"
    echo -n " %{F$color4}$righthard%{R}%{F$color0 B$color4}"
}

function showDateTime() {
    echo -n " $(date +%Y-%m-%d) "
    echo -n "%{F$color2}${righthard}%{B$color0}%{R}"
    echo -n " $(date +%H:%M:%S)"
}

function windowTitle() {
    xtitle
}

while true
do 
    setColors

    BATTERY=$(batteryStatus)
    DATETIME=$(showDateTime)
    TITLE=$(windowTitle)
    
    echo " %{B$color0 F$color7}WORKSPACES%{c}${TITLE}%{r}${BATTERY} ${DATETIME} %{B$color0 F$color7}"
    
    wait
done
