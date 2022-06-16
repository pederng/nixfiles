#!/bin/sh

userresources=$XDG_CONFIG_HOME/X11/xresources
usercolors=$XDG_CONFIG_HOME/X11/xcolors
usermodmap=$XDG_CONFIG_HOME/X11/xmodmap
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f "$usercolors" ]; then
    xrdb -merge "$usercolors"
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

slstatus &
setxkbmap -layout us -variant altgr-intl -option ctrl:nocaps
test -f "$XDG_CONFIG_HOME"/X11/xrandr_settings && "$XDG_CONFIG_HOME"/X11/xrandr_settings
xbindkeys -f "$XDG_CONFIG_HOME"/xbindkeys/config
sh ~/.local/bin/fehbg
xset s 600
xss-lock slock &
dunst &
unclutter &
exec dwm
