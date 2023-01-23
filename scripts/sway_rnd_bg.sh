#!/bin/bash

wallpapers=${1:-~/Pictures/dark_wallpapers}
wallpaper=$(find $wallpapers -type f | shuf -n1)
echo $wallpaper
swaymsg output \* bg $wallpaper fill
