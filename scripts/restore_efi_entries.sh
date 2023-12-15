
sudo efibootmgr \
  --active \
  --create \
  --disk /dev/nvme1n1p1 \
  --label "ArchLinux Work" \
  --loader \\EFI\\ArchLinuxWrk\\grubx64.efi

sudo efibootmgr \
  --active \
  --create \
  --disk /dev/nvme0n1p1 \
  --label "ArchLinux Home" \
  --loader \\EFI\\ArchLinuxHome\\grubx64.efi
