#!/bin/bash

# Simple power menu using rofi or wofi
choice=$(echo -e "Lock\nLogout\nReboot\nShutdown" | wofi --dmenu -i -p "Power Options" --style ~/.config/wofi/style.css --conf ~/.config/wofi/power-config)

case $choice in
    "Lock")
        hyprlock
        ;;
    "Logout")
        hyprctl dispatch exit
        ;;
    "Reboot")
        systemctl reboot
        ;;
    "Shutdown")
        systemctl poweroff
        ;;
esac
