This repository is used for my testing and fixing "text input and input method" PR for DWL and other misc. works related as well:


The command i use to start dwl from tty:

```
dbus-run-session dwl -s ~/dwlstart
```
`dbus-run-session dwl -s ~/dwlstart 2>/tmp/dwlerr.log`


the content of dwlstart script:

```
#!/bin/sh

fname="$HOME"/.cache/dwltags

gentoo-pipewire-launcher &
fcitx5 -d
waybar &

while
	read line; do echo $line >> ${fname} ;
done
```


-------------------------------------------------------------------------------------------

i put waybar related scripts in the following link, i think better way to clean the ~/.cache/dwltags file should be provided.

https://gitee.com/guyuming76/personal/tree/dwl/gentoo/waybar-dwl

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