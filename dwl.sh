#!/bin/sh

xdg_run_user

export XDG_RUNTIME_DIR=/run/user/$(id -u)
export GTK_IM_MODULE="wayland"
export _JAVA_AWT_WM_NONREPARENTING=1

#export WLR_NO_HARDWARE_CURSORS=1
#in my virtualbox guest, i need to have the above uncommented, otherwise, cursor won't display in dwl

dbus-run-session dwl -s /usr/bin/dwlstart.sh  2>/tmp/dwl.log
#WAYLAND_DEBUG=server dbus-run-session dwl -s ~/dwlstart.sh -d  2>/tmp/dwl.log
