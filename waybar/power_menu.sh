#!/usr/bin/env bash

# 电源菜单脚本
choice=$(printf "关机\n重启\n挂起\n休眠\n取消" | wofi -d -p "电源菜单:")

case "$choice" in
    "关机") systemctl poweroff ;;
    "重启") systemctl reboot ;;
    "挂起") systemctl suspend ;;
    "休眠") systemctl hibernate ;;
    *) exit 0 ;;
esac
