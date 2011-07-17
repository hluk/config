#!/usr/bin/make -f
MOUSE_ID = "Genius Ergo Mouse"
TOUCHPAD_ID = "ImPS/2 Generic Wheel Mouse"
MONITORS = LVDS1 --mode 1366x768; HDMI1 --right-of LVDS1; HDMI1 --mode 1920x1080 --primary

LABEL = @printf '\n%s\n'

all: keyboard xbindkeys mouse touchpad wallpaper

start:
	$(LABEL) "Hardware setup script"
	@date

monitor: start
	$(LABEL) "** setting monitor layout"
	[ -n "$(MONITORS)" ] && \
		$(subst ;,; xrandr --output ,xrandr --output $(MONITORS))

keyboard: start
	$(LABEL) "** setting keyboard"
	setxkbmap -model evdev us
	#xmodmap ~/.Xmodmap
	numlockx &
	xset r rate 200 40

mouse: start
	$(LABEL) "** setting mouse"
	xinput set-prop $(MOUSE_ID) "Device Accel Constant Deceleration" 2

touchpad: start
	$(LABEL) "** setting touchpad"
	xinput set-prop $(TOUCHPAD_ID) "Device Accel Profile" 3
	xinput set-prop $(TOUCHPAD_ID) "Device Accel Constant Deceleration" 1
	xinput set-prop $(TOUCHPAD_ID) "Device Accel Velocity Scaling" 20

xbindkeys: start keyboard
	$(LABEL) "** restarting xbindkeys"
	killall xbindkeys; xbindkeys &

wallpaper: start monitor
	$(LABEL) "** setting wallpaper"
	~/dev/bin/set_wallpaper.sh &
