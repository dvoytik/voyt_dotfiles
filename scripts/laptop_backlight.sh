#!/bin/bash
# 
# Set laptop backlight level in percent.
# first command line parameter is % of max backlight level

model=amdgpu_bl2
# model=intel_backlight
sp=${1:-100}
max_backlight=$(cat /sys/class/backlight/$model/max_brightness)
echo Max: $max_backlight
s=$(($sp*$max_backlight/100))
echo Setting $s
sudo sh -c "echo $s > /sys/class/backlight/$model/brightness"
actual=$(cat /sys/class/backlight/$model/actual_brightness)
echo Actual: $actual
