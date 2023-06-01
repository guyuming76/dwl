#!/bin/sh

#fname="$HOME"/.cache/dwltags$1
fname="$HOME"/.cache/dwltags
#TODO: https://github.com/Alexays/Waybar/issues/1538

rm ${fname}

gentoo-pipewire-launcher &

fcitx5 -d
#fcitx5 --verbose "*=5" -d

waybar &
#waybar --log-level debug > /tmp/waybar.log &

#eval "/usr/bin/HDMI.sh dwl"

while 
	read line; do echo $line >> ${fname} ; 
done
