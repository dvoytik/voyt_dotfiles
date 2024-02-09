# print current boot order and boot entries:
efibootmgr

# TODO: check disk dev path with lsblk
sudo efibootmgr \
  --create \
  --disk /dev/nvme1n1p1 \
  --label "ArchLinux Work" \
  --loader \\EFI\\ArchLinuxWrk\\grubx64.efi

# TODO: check disk dev path with lsblk
sudo efibootmgr \
  --create \
  --disk /dev/nvme0n1p1 \
  --label "ArchLinux Home" \
  --loader \\EFI\\ArchLinuxHome\\grubx64.efi

# change boot order:
sudo efibootmgr \
  --bootorder \
  0008,0001,0000
