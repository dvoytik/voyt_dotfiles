#!/bin/bash
# 
# Set laptop backlight level in percent.
# first paramater is % of max backlight level

sp=${1:-100}
max_backlight=$(cat /sys/class/backlight/intel_backlight/max_brightness)
s=$(($sp*$max_backlight/100))
sudo sh -c "echo $s > /sys/class/backlight/intel_backlight/brightness"
b=$(cat /sys/class/backlight/intel_backlight/actual_brightness)
echo Setting $b/$max_backlight
