_VERSION = 0.3.1-dev
VERSION  = `git describe --long --tags --dirty 2>/dev/null || echo $(_VERSION)`

PKG_CONFIG = pkg-config

# paths
PREFIX = /usr/local
MANDIR = $(PREFIX)/share/man

CFLAGS = -g -O0

XWAYLAND =
#XWAYLAND = -DXWAYLAND
XLIBS =
#XLIBS = xcb
#IM =
IM = -DIM
