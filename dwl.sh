#!/bin/sh

xdg_run_user

export XDG_RUNTIME_DIR=/run/user/$(id -u)
export GTK_IM_MODULE="wayland"
export _JAVA_AWT_WM_NONREPARENTING=1

dbus-run-session dwl -s /usr/bin/dwlstart.sh  2>/tmp/dwl.log
#WAYLAND_DEBUG=server dbus-run-session dwl -s ~/dwlstart.sh -d  2>/tmp/dwl.log
