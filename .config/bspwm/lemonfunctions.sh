function getColor()
{
    xrdb -query -all | grep "*.$1:" | sed "s/\*.$1:\t//"
}

function getWorkspaces() {
    wm="%{B$color4} "
    IFS=':'
    foreground=$color0
    foregroundalt=$color0
    urgent=$color1
    set -- $1
    while [ "$#" -gt 0 ] ; do
	item="$1"
	name="${item#?}"
	FG="$foregroundalt" # needed to avoid invalid colour error
	case "$item" in
	    [mMfFoOuULG]*)
		case "$item" in
		    [mM]*)
			# monitor
			name=
			;;
		    # {Free,Occupied,Urgent} focused
		    F*)
			name=" %{+u}${name}%{-u}"
			FG="$foreground"
			;;
		    O*)
			name=" %{+u +o}${name}%{-u -o}"
			FG="$foreground"
			;;
		    U*)
			name=" %{+u +o}${name}%{-u -o}"
			FG="$urgent"
			;;
		    # {free,occupied,urgent} unfocused
		    f*)
			FG="$foregroundalt"
			name=" ${name}"
			;;
		    o*)
			FG="$foregroundalt"
			name=" %{+o}${name}%{-o}"
			;;
		    u*)
			FG="$urgent"
			name=" ${name}"
			;;
		    # desktop layout for monocle and node flags
		    LM|G*?)
		    FG="$foreground"
		    name="${name/*/ $name}"
		    ;;
		    *)
			FG="$foregroundalt"
			name="${name/*/ *}"
			;;
		esac
		wm="${wm}%{F$FG}${name}%{F-}"
		;;
	esac
	shift
    done
    wm+=" %{F$color4 B$color0}${lefthard}%{F- B-} "

    echo $wm
}

function batteryStatus() {
    pct=$(cat ~/share/battery | cut -d' ' -f 1)
    state=$(cat ~/share/battery | cut -d' ' -f 2)
    if [ $state = "discharging" ]; then
	echo -n "%{F$color1}$righthard%{B$color0 R}"
    else
	echo -n "%{F$color2}$righthard%{B$color0 R}"
    fi
    echo " $pct%"
}

function getDate() {
    echo -n "%{F$color4}$righthard%{B$color0 R} "
    date +%Y-%m-%d
}

function getTime() {
    echo -n "%{F$color2}${righthard}%{B$color0 R} "
    date +%H:%M:%S
}

function keyboardLayout() {
    LAYOUT="$(setxkbmap -query | sed '/^layout/!d ; s,^.*:[\ ]*,,g')"
    echo -n "%{F$color4}${righthard}%{B$color0}%{R} "
    echo $LAYOUT
}
