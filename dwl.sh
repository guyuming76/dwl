#!/bin/sh

set -x

export XDG_RUNTIME_DIR="/run/user/$(id -u)"
xdg_run_user


export GTK_IM_MODULE="wayland"
export _JAVA_AWT_WM_NONREPARENTING=1

echo "export WLR_NO_HARDWARE_CURSORS=1    # try this if you don't see cursor in dwl"
#in my virtualbox guest cursor won't display in dwl. i need to set this to fix

dwl -s /usr/bin/dwlstart.sh  2>/tmp/dwl.log
#dbus-run-session dwl -s /usr/bin/dwlstart.sh  2>/tmp/dwl.log
#WAYLAND_DEBUG=server dbus-run-session dwl -s ~/dwlstart.sh -d  2>/tmp/dwl.log
