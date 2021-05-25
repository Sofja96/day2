#!/usr/bin/env bash

sudo umount /mnt/storage

read -p "Введите название Volume Group: " vgname
read -p "Введите название Logical Volume: " lvname
sudo lvdisplay
sudo lvremove /dev/$vgname/$lvname
sudo vgdisplay
sudo vgremove $vgname
read -p "Введите название диска sd{b,c,d}: " diskname
sudo pvremove /dev/$diskname
sudo pvdisplay

