
This repository is used for my testing and fixing "text input and input method" PR for DWL.

DWL使用和配置方法类似DWM:https://ratfactor.com/dwm


**sreenshots**
------------------------
![输入图片说明](20220908_16h12m06s_grim.png)
![输入图片说明](20220917_18h37m45s_grim.png)

geogebra 目前用xwayland,和fcitx5拼音输入的通讯依靠dbus。不过我觉得在xwayland下用，xwayland和wayland的交互看上去还是挺复杂的，如果遇到啥问题，我也是觉得在另外的TTY里打开一个DWM用比较省事，也就懒得琢磨DWL里xwayland这一块了。

![输入图片说明](20220910_10h16m58s_grim.png)
kde, gnome下的文件管理器通常会带很多桌面环境依赖项.我除了用ranger,发现rfm挺好的，suckless的风格。配合imv看图,我做了一个小的配置改动，添加了一段小脚本，以便每次双击图片缩略图时不用打开新的IMV窗口，而是刷新现有窗口 : https://gitee.com/guyuming76/rfm/commit/c2bdc92c6b50f578032f2986dc40db8781dfb8ac 。我觉得这个例子比较好地体现了我对动态平铺窗口管理的理解：把传统的庞大的GUI应用分拆成小的独立应用。
（更新2022/10/11：深入阅读rfm代码后，发觉同步线程时没用锁，用了几个变量设置状态，[我觉得有些不保险](https://github.com/padgettr/rfm/issues/3)，考虑要不要重写这一块，不知道其他主流文件管理器这一块怎么做的）


**在Gentoo上安装**
--------------------------------
可以使用我创建的自定义仓库安装运行dwl安装. 我的dwl-9999.ebuild使用USE flag控制，默认安装了一些dwl上常用的应用，比如状态栏waybar,虚拟终端foot等. 除gentoo官方仓库外，还引用了 gentoo-zh 仓库里的fcitx5安装，和guru仓库里的wtype命令。

至于gentoo环境，只需要安装完stage3,内核，设置完网络，启动，locale 等，无需xorg及其他桌面环境，也就是说gentoo stage3只需要一个不带desktop的openrc包就可以. dwl安装会使用依赖安装wlroots. 为了运行一些只支持x 的应用，我还会另外安装xorg和DWM,而不是在DWL里使用xwayland.

安装完成后，在tty里运行dwl.sh启动图形界面。

```
# cd /var/db/repos
# git clone https://gitee.com/guyuming76/suckless_wl_zh.git
# eselect repository enable guru
# eselect repository enable gentoo-zh
# emerge --sync guru
# emerge --sync gentoo-zh
# emerge --ask --verbose --autounmask=y gui-wm/dwl::suckless_wl_zh
# dispatch-conf
# emerge --ask --verbose --autounmask=y gui-wm/dwl::suckless_wl_zh

```

**How to start dwl**
--------------------

The command i use to start dwl from tty:

```
guyuming@localhost ~/dwl $ cat ~/xdg_run_user
# Configuration  because seatd does not do this for wayland compositor
YOUR_USER=$(id -u)
YOUR_GROUP=$(id -g)

XDG_RUNTIME_DIR=/run/user/$YOUR_USER

## Delete existing directory, create a new one and set permissions
sudo rm -rf $XDG_RUNTIME_DIR
sudo mkdir -p $XDG_RUNTIME_DIR
sudo chown $YOUR_USER:$YOUR_GROUP $XDG_RUNTIME_DIR
sudo chmod 700 $XDG_RUNTIME_DIR

gym@gymDeskGentoo ~ $ cat ./dwl.sh

~/xdg_run_user
export XDG_RUNTIME_DIR=/run/user/$(id -u)
#我今天把系统从 openrc+elogind 换成openrc+seatd,结果发现系统启动后没有 /run/user 目录，也没有设置XDG_RUNTIME_DIR,所以添加了上面两行。不是这个情况得话，上面可以注释掉

export GTK_IM_MODULE="wayland"
export QT_IM_MODULE=compose
export XMODIFIERS=@im=none

export LC_TIME="zh_CN.utf8"

export _JAVA_AWT_WM_NONREPARENTING=1

dbus-run-session dwl -s ~/dwlstart.sh -d  2>/tmp/dwl.log
# 可以在一个命令行窗口运行 tail -f /tmp/dwl.log 查看日志

#dbus-run-session dwl -s ~/dwlstart.sh -i  2>/tmp/dwl.log
# -d level log add the keypress events based on -i level, which is large in quantity
# -d 参数在 -i 水平的基础上再加上 keypress 事件，日志量会大许多

#WAYLAND_DEBUG=1 dbus-run-session dwl -s ~/dwlstart.sh -i  2>/tmp/dwl.log
#dbus-run-session dwl -s ~/dwlstart.sh -i
#dbus-run-session dwl -s ~/dwlstart.sh -i 2>/dev/tty2

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

waybar --log-level debug > /tmp/waybar.log  &
#i cloned waybar project here:https://gitee.com/guyuming76/dwl
#all i did is adding spdlog entries to help me understand how waybar works.

eval "/home/guyuming/HDMI.sh dwl" &
#调用脚本，用wlr-randr命令设置多显示器模式，比如让投影仪复制显示主屏幕

while
	read line; do echo $line >> ${fname} ;
done
```


-------------------------------------------------------------------------------------------
**How to install my waybar script**
-----------------------------------
i put waybar related scripts in the following link, i think better way to clean the ~/.cache/dwltags file should be provided.

https://gitee.com/guyuming76/personal/tree/dwl/gentoo/waybar-dwl

1. copy the config and style.css files to override the waybar defaults, in my case, /etc/xdg/waybar/config  /etc/xdg/waybar/style.css
2. copy waybar-dwl.sh to ~/waybar-dwl.sh, which is referenced in the config file above
3. copy dwlstart.sh to ~/dwlstart.sh and modify it as you need, waybar is started in it
4. the config file depends on wtype package(from gentoo guru repository in my case) in on-click event, if you don't want to use it, you can remove all those on-click lines. And the MOD key is default to alt here, if you have customized the MOD key in dwl config.h, change alt to your custom MOD key here in config accordingly.

run dbus-run-session dwl -s ~/dwlstart.sh to start dwl. you might find that the current selected tag for waybar is not highlighted, you can run ~/.cache/dwltags, the first column contains the name of your monitor. Then you can edit the waybar-dwl.sh, find the monitor= line and assign it with your monitor name.

-------------------------------------------------------------------------------------------
Waybar用到 spdlog ,  http://t.zoukankan.com/shuqin-p-12214439.html 提到“多生产者多消费者队列 默认为阻塞模式，也可以设置为非阻塞，不过这个非阻塞的处理非常简单粗暴，就是简单的丢弃最老的日志，推荐是不要这样设置滴，一般产生阻塞的情况大概是磁盘IO打满了，出现这个情况一般是别的地方出问题了。


-------------------------------------------------------------------------------------------------


**DWL下设置投影仪**
--------------------------------
用wlr-randr,我在gentoo上是从guru仓库安装的。wlr-randr 貌似没有--left-of 参数，但可以用--pos设置输出起始坐标，如果投影仪和显示器起始坐标都是0,0,效果就相当于“双屏复制”显示

```
cat ~/HDMI.sh

sleep 10
#当本脚本是从 dwl -s 参数中启动得话，需要等待dwl 中 wayland 事件循环启动后才能执行 wlr-randr,所以这里sleep一会儿 https://github.com/djpohly/dwl/issues/266

if [[ ${1} == "dwl" ]];then
      wlr-randr --output HDMI-A-1 --mode 1360x768
      wlr-randr --output HDMI-A-1 --pos 0,0
      #wlr-randr --output HDMI-A-1 --scale 1.5
      # https://github.com/fcitx/fcitx5/discussions/551
elif [[ ${1} == "dwm" ]];then
      xrandr --output HDMI-1 --mode 1360x768
      #xrandr --output HDMI-1 --left-of LVDS-1
      #xrandr --output HDMI-1 --scale 0.5x0.5
      xrandr --output HDMI-1 --pos 0x0
      xrandr --output LVDS-1 --pos 0x0
else
     echo "usage: HDMI.sh dwl"
     echo "       HDMI.sh dwm"
fi
```

--------------------------------------------------------------------------------------------
**MISC**
---------------
[合并上游更新操作步骤](stepsToMergeUpstreamMain.md)

 **另外，我不一定能及时合并Upstream的更新，关于输入法的那个pull request的代码，我加了#ifdef IM 这个编译条件，找到这个编译条件包含的代码，手工复制到上游代码理论上也行。** 

在wayland下使用 sudo 运行图形界面程序，比如当我用guyuming登录时,wpa_gui里面控件显示数据为空，而 `sudo wpa_gui` 会报错，但是 `sudo -EH wpa_gui` 就可以了。[参见](https://unix.stackexchange.com/questions/422040/will-wayland-ever-support-graphical-sudo) 


[History](History.md) 

fixDnD 是最后一个支持 wlroots 0.15 的分支，后面的分支，比如V0.4, 基于wlroots 0.16

看图片软件:imv
看视频软件:mpv
