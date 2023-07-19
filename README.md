
This repository is used for my testing and fixing "text input and input method" PR for DWL.

DWL使用和配置方法类似DWM:https://ratfactor.com/dwm


**sreenshots**
------------------------
![输入图片说明](20220908_16h12m06s_grim.png)
![输入图片说明](20220917_18h37m45s_grim.png)

geogebra 目前用xwayland,和fcitx5拼音输入的通讯依靠dbus。不过我觉得在xwayland下用，xwayland和wayland的交互看上去还是挺复杂的，如果遇到啥问题，我也是觉得在另外的TTY里打开一个DWM用比较省事，也就懒得琢磨DWL里xwayland这一块了。

![输入图片说明](20220910_10h16m58s_grim.png)
我在rfm基础上的定制，方便看图，调用shell脚本进行文件操作：  https://gitee.com/guyuming76/rfm

**安装**
------------------------
像DWL这种suckless风格的程序通过源码编译安装其实还是比较容易的，git clone源码，准备好为数不多的依赖项后，make install 就可以了。并且这个Makefile也相对比较简单（这可能是我看懂的第一个Makefile）。但是为了自动装几个依赖项及常用包，特别是waybar的几个脚本及配置文件，[我还是在gentoo上做了自定义仓库](https://gitee.com/guyuming76/suckless_wl_zh) 和dwl-9999.ebuild安装脚本：使用USE flag控制，默认安装了状态栏waybar,虚拟终端foot等. 除gentoo官方仓库外，还引用了 gentoo-zh 仓库里的fcitx5拼音输入法安装，和guru仓库里的wtype命令。这个ebuild文件最初我是复制了gentoo guru仓库的dwl安装脚本，但是guru仓库的脚本仅仅安装了dwl本身，如上所述，源码编译安装dwl本身很简单，可以不用ebuild，麻烦的是安装配置waybar及常用软件，这是我做了自己的ebuild的原因,类似“装机一条龙”，今后随着我对平台的更多了解，还会修改添加更多的默认安装项。如果你使用别的linux发行版，这个ebuild文件也可以作为安装配置的参考文档。

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
我在另一台机器上按照上面脚本同步了suckless_wl_zh仓库后，emerge 命令还是找不到包，后来发现要在 /etc/portage/repos.conf/eselect-repo.conf 文件中加入下面内容：
```
[suckless_wl_zh]
location = /var/db/repos/suckless_wl_zh
sync-type = git
sync-uri = https://gitee.com/guyuming76/suckless_wl_zh.git
```
然后 `sudo eix-update`(这一步我不确定是否必要)


我尝试过在virtualbox里面安装，我的设置是：
virtualbox setting->Display里面 Graphic Controller 选的是VMSVGA，要设置enable 3D accelerate;
gentoo /etc/portage/make.conf里，要设置 VIDEO_CARDS="vmware".

和 gentoo openrc 搭配，我并没有选elogind,而是选了简单的seatd,[需要配置](https://wiki.gentoo.org/wiki/Seatd), 并且在dwl启动脚本里面[需要设置XDG_RUNTIME_DIR](https://forums.gentoo.org/viewtopic-p-8790881-highlight-.html), 这个体现在下面的启动dwl的脚本里面，如果你使用的是systemd或elogind,XDG_RUNTIME_DIR 将会由系统自动设置。

在openrc seatd环境下查看seatd的日志, 日志在/tmp/seatdstderr文件里:
```
#cat /etc/init.d/seatd

#!/sbin/openrc-run
supervisor=supervise-daemon
command="seatd"
command_args="-g video -l debug"
start_stop_daemon_args="--stdout /tmp/seatdstdout  --stderr /tmp/seatdstderr"
```

配置完locale,还要用fcitx5-configtool 配置拼音输入法，安装脚本里我默认添加了文泉驿正黑中文字体安装


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
