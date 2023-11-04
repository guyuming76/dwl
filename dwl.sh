#!/bin/sh

set -x

export XDG_RUNTIME_DIR="/tmp/XDG_RUNTIME_DIR_$(id -u)_$$"
xdg_run_user
# you don't need the above two lines to set XDG_RUNTIME_DIR if you use systemd or elogind. I use seatd, so i have the above two linesl


export GTK_IM_MODULE="wayland"
export _JAVA_AWT_WM_NONREPARENTING=1

echo "export WLR_NO_HARDWARE_CURSORS=1    # try this if you don't see cursor in dwl"
#in my virtualbox guest cursor won't display in dwl. i need to set this to fix

WLR_DRM_DEVICES=/dev/dri/card0 dwl -s /usr/bin/dwlstart.sh  2>/tmp/dwl_$(id -u)_$$.log
#https://github.com/swaywm/sway/issues/7240

#dwl -s /usr/bin/dwlstart.sh  2>/tmp/dwl.log
#dbus-run-session dwl -s /usr/bin/dwlstart.sh  2>/tmp/dwl.log
#WAYLAND_DEBUG=server dbus-run-session dwl -s ~/dwlstart.sh -d  2>/tmp/dwl.log
