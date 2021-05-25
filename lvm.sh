#!/usr/bin/env bash
#проверяем диски
sudo fdisk -l
read -p "Введите название диска sd{b,c,d}: " diskname
#готовим диск к LVM
sudo pvcreate /dev/$diskname
#проверяем физический том
sudo pvdisplay
read -p "Введите название Volume Group: " vgname
#создаем группу томов
sudo vgcreate $vgname /dev/$diskname
#выводим информацию о созданном томе
sudo vgdisplay
read -p "Введите название Logical Volume: " lvname
read -p "Введите размер логического тома: " lvsize
#создаем логический том
sudo lvcreate -n $lvname -L +$lvsize $vgname
#выводим информацию о созданном томе
sudo lvdisplay
echo "Выбрана файловя система ext4!"
sudo mkfs.ext4 /dev/$vgname/$lvname
#Если монтирование выполняется от супер пользователя, то монтирование будет постоянным, иначе монтирование - разовое!
echo "Выполняется монтирование"
echo "/dev/$vgname/$lvname /mnt/storage ext4   defaults 0 0" >> /etc/fstab 2> /dev/null 
if [ $? -eq 1 ]
then
echo "Выполняется разовое монтирование!"
sudo mount /dev/$vgname/$lvname /mnt/storage
else
sudo mount -a
fi
df -hT
