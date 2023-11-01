#!/bin/sh

#fname="$HOME"/.cache/dwltags$1
fname="$HOME"/.cache/dwltags
#TODO: https://github.com/Alexays/Waybar/issues/1538

rm ${fname}

#gentoo-pipewire-launcher &

fcitx5 -d --disable dbus
#fcitx5 --verbose "*=5" -d

waybar -c /etc/xdg/waybar/config_dwl -s /etc/xdg/waybar/style_dwl.css &
#waybar --log-level debug > /tmp/waybar.log &

#eval "/usr/bin/HDMI.sh dwl"

foot rfm  &

while 
	read line; do echo $line >> ${fname} ; 
done
