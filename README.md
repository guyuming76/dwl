This repository is used for my testing and fixing "text input and input method" PR for DWL and other misc. works related as well:


The command i use to start dwl from tty:

```
dbus-run-session dwl -s ~/dwlstart.sh
dbus-run-session dwl -s ~/dwlstart.sh 2>/tmp/dwlerr.log
dbus-run-session dwl -s ~/dwlstart.sh -i 2>/tmp/dwlerr.log
dbus-run-session dwl -s ~/dwlstart.sh -d 2>/tmp/dwlerr.log
```


the content of dwlstart script:

```
#!/bin/sh

fname="$HOME"/.cache/dwltags

gentoo-pipewire-launcher &

#fcitx5 -d
fcitx5 -d --disable dbus
#https://github.com/fcitx/fcitx5/discussions/523
#in /etc/environment, i have GTK_IM_MODULE="wayland"
#and in .xinitrc, i have export GTK_IM_MODULE="fcitx"

#fcitx5 --verbose "*=5" -d

waybar &

while
	read line; do echo $line >> ${fname} ;
done
```


-------------------------------------------------------------------------------------------

i put waybar related scripts in the following link, i think better way to clean the ~/.cache/dwltags file should be provided.

https://gitee.com/guyuming76/personal/tree/dwl/gentoo/waybar-dwl

1. copy the config and style.css files to override the waybar defaults, in my case, /etc/xdg/waybar/config  /etc/xdg/waybar/style.css
2. copy waybar-dwl.sh to ~/waybar-dwl.sh, which is referenced in the config file above
3. copy dwlstart.sh to ~/dwlstart.sh and modify it as you need, waybar is started in it
4. the config file depends on wtype package(from gentoo guru repository in my case) in on-click event, if you don't want to use it, you can remove all those on-click lines. And the MOD key is default to alt here, if you have customized the MOD key in dwl config.h, change alt to your custom MOD key here in config accordingly.

run dbus-run-session dwl -s ~/dwlstart.sh to start dwl. you might find that the current selected tag for waybar is not highlighted, you can run ~/.cache/dwltags, the first column contains the name of your monitor. Then you can edit the waybar-dwl.sh, find the monitor= line and assign it with your monitor name.

-------------------------------------------------------------------------------------------

DWL下设置投影仪，用wlr-randr,我在gentoo上是从guru仓库安装的。wlr-randr 没有--left-of 参数，但可以用--pos设置输出起始坐标，如果投影仪和显示器起始坐标都是0,0,效果就相当于“双屏复制”显示

    wlr-randr --output HDMI-A-1 --mode 1360x768
    wlr-randr --output HDMI-A-1 --pos 0,0
-------------------------------------------------------------------------------------------

History :

https://gitee.com/guyuming76/dwl/commit/59328d6ecbbef1b1cd6e5ea8d90d78ccddd5c263 （中文摘要）

https://gitlab.freedesktop.org/wlroots/wlroots/-/issues/3433

https://github.com/djpohly/dwl/pull/235

https://gitee.com/guyuming76/dwl/tree/guyuming4/   (summary for phase PR12)

https://gitlab.freedesktop.org/wlroots/wlroots/-/issues/3427

https://gitlab.freedesktop.org/wlroots/wlroots/-/issues/3422

https://github.com/djpohly/dwl/issues/231

https://github.com/djpohly/dwl/issues/224

https://github.com/fcitx/fcitx5/discussions/481

https://github.com/djpohly/dwl/pull/12



一些包含截屏的文档记录： https://gitee.com/guyuming76/personal/commits/dwl
