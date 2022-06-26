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

waybar --log-level trace &

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

--------------------------------------------------------------------------------------------
合并上游更新操作步骤：

1.从 https://github.com/guyuming76/dwl  可以看出上游 https://github.com/djpohly/dwl 有没有新的commit, 如有，可以通过 FetchUpstream 同步;

2.本地remote设置如下(remote 名称可以随意取，比如我在另一台机器上github对应的叫origin)：

```
gym@gymDeskGentoo ~/dwl $ git remote -v
github	https://github.com/guyuming76/dwl.git (fetch)
github	https://github.com/guyuming76/dwl.git (push)
origin	https://gitee.com/guyuming76/dwl.git (fetch)
origin	https://gitee.com/guyuming76/dwl.git (push)
```

3. 第1步FetchUpstream后，本地 git pull github main 获取， 再通过 git push origin main 推送到 gitee，
   也可先通过 git log origin/main..github/main 查看 gitee 和 github有啥不同;
   (https://www.cnblogs.com/wentaos/p/7567502.html)


4. 再切换到一个分支，比如 git checkout PR235_10, 可以先通过 git log main ^PR235_10 查看 PR235_10 里缺哪些commit,也就是将要merge 的commit,
   然后 git merge main 来合并上游的更新，可能会要手工解决一些冲突.
