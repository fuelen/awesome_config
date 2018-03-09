#!/usr/bin/env bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}
# increase trackpoint sensitivity
xinput set-prop "PS/2 Generic Mouse" "Device Accel Constant Deceleration" 0.5
# set backlight to 50%, because of nvidia driver
xbacklight -set 50

run compton -CG
run copyq
run nm-applet
run qxkb
run guake
run hamster
run shutter --min_at_startup
run conky
run indicator-kdeconnect
# run indicator-cpufreq
run slack
run cantata
