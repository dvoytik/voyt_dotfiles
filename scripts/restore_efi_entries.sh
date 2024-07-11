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

function restore_laptop_arch_efi_entry() {
  disk=/dev/nvme0n1p1
  label="ArchLinux"
sudo -E efibootmgr \
  --create \
  --disk $disk \
  --label $label \
  --unicode \
  --loader \\EFI\\ArchLinux\\grubx64.efi
}

# change boot order:
function change_boot_order() {
sudo efibootmgr \
  --bootorder \
  0008,0001,0000
}
