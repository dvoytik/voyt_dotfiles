#!/bin/bash
wallpapers=${1:-~/Pictures/wallpapers}
wallpaper=$(find $wallpapers -type f | shuf -n1)
exec swaylock -k -F -e -l -f -i $wallpaper
