
# list boot entries:
# efibootmgr -v
efibootmgr --bootnum 0 --delete-bootnum

git clone https://github.com/WoeUSB/WoeUSB.git
cd ~/p/WoeUSB/
# show SSD model names:
# lsblk -o name,fstype,label,mountpoint,size,model

sudo ./sbin/woeusb --device /home/voyt/Downloads/Win11_23H2_EnglishInternational_x64v2.iso /dev/sdd
