#!/bin/bash

# vim: expandtab shiftwidth=2

function backup_file() {
  f=$1
  test -f $f && echo "WARNING: $f exists. Backing up..." \
    && mv $f ${f}_$(date +%y%m%d_%H%M)
}

function backup_dir() {
  d=$1
  new_dir=${d}_$(date +%y%m%d_%H%M)
  test -d $d && echo "WARNING: $d exists. Backing up to $new_dir ..." \
    && mv $f $new_dir
}

# Print all manually installed packages:
# pacman -Qnqtt | nvim -

function install_system_packages() {
  sudo pacman -Syyu
  sudo pacman -S \
    make autoconf automake bison flex m4 patch texinfo \
    sudo \
    polkit \
    man-db man-pages \
    wget \
    unzip \
    pkgstats \
    noto-fonts noto-fonts-emoji ttf-liberation \
    libnotify \
    pavucontrol \
    network-manager-applet \
    xdg-desktop-portal \
    pacman-contrib \
    alsa-utils \
    usbutils

  # openssh
}

function install_user_packages() {
  sudo pacman -Syyu
  sudo pacman -S \
    neovim \
    git \
    tmux \
    fish \
    ripgrep \
    fd \
    tree \
    htop \
    starship \
    btop \
    exa \
    alacritty \
    firefox \
    blueman \
    zoxide \
    vimiv \
    cozy-desktop \
    pass \
    git-delta \
    handlr \
    guvcview \
    zathura zathura-pdf-mupdf \
    bottom
    #ncal \
    #fzf \
    #gdu \
    #vlc \
    #gimp
  # gcc cmake g++ pkg-config \
  paru -S \
    brave-bin \
    pass-coffin \
    xdg-utils-handlr \
    warpd-wayland

  # for laptop:
    #tlp \
    #tlp-rdw

}

function arch_system_setup() {
  sudo systemctl enable fstrim.timer    # send TRIM command to the disks once per week
  sudo systemctl enable paccache.timer  # clean up package cache once per week
  # TODO manually:
# * nmcli device wifi connect <SSID_or_BSSID> password <password>
# * set paralleld download in /etc/pacman.conf
# * set up /etc/hosts
# * secure ssh server: nvim /etc/ssh/sshd_config
# * nvim /etc/security/faillock.conf
}

# setup sandboxing - improves security
function arch_setup_firejail_apparmor() {
  sudo pacman -S firejail apparmor
  sudo systemctl enable apparmor

  # ↪ zgrep CONFIG_LSM= /proc/config.gz
  # sudo nvim /etc/default/grub
  # change:
  # GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"
  # to:
  # GRUB_CMDLINE_LINUX_DEFAULT="lsm=landlock,lockdown,yama,integrity,apparmor,bpf loglevel=3 quiet"

  #
  # grub-mkconfig -o /boot/grub/grub.cfu
  # reboot
  # check by running:
  # aa-enabled
  # Should return: Yes

  # edit
  # sudo nvim /etc/apparmor.d/local/firejail-default
  # uncomment "brave + tor"

  sudo sh -c 'cat > /usr/local/bin/brave << EOF
#!/bin/sh
firejail --profile=brave /usr/bin/brave
EOF
'
  sudo chmod +x /usr/local/bin/brave

  sudo sh -c 'cat > /usr/local/bin/telegram << EOF
#!/bin/sh
firejail --profile=telegram /usr/local/bin/Telegram
EOF
'
  sudo chmod +x /usr/local/bin/telegram
}

# function setup_microcode() {
  # check AMD ucode:
  # journalctl -k --grep='microcode:'
  # Should return:
  # kernel: microcode: Current revision: 0x0a500011
  # kernel: microcode: Updated early from: 0x0a50000b
# }


function install_setup_keyd() {
  # laptop keyboard
  sudo cp dotfiles/keyd/keyd.conf /etc/keyd/default.conf
  # kinesis keyboard
  #sudo cp dotfiles/keyd/keyd.conf_KINESYS /etc/keyd/default.conf
  paru keyd
  sudo systemctl enable keyd
  sudo systemctl start keyd
}

function setup_tmux() {
  backup_file $HOME/.tmux.conf
  ln -s $PWD/dotfiles/tmux.conf ~/.tmux.conf
}

function setup_fish_shell() {
  backup_file $HOME/.config/fish/config.fish
  mkdir -p ~/.config/fish/
  ln -s $PWD/dotfiles/config.fish  ~/.config/fish/
  echo "Changing default shell"
  chsh -s /usr/bin/fish
}

function setup_starship() {
  backup_file $HOME/.config/starship.toml
  ln -s $PWD/dotfiles/starship.toml ~/.config/
}

function setup_tlp() {
  sudo systemctl enable tlp
  sudo systemctl start tlp
  sudo systemctl status tlp
}

function setup_gnome_terminal() {
  # Gnome Terminal color scheme
  mkdir ~/p/
  git clone https://github.com/arcticicestudio/nord-gnome-terminal.git
  cd nord-gnome-terminal
  ./src/nord.sh
  cd ..
  rm -rf nord-gnome-terminal

  # Default:
  #gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 30
  #gsettings set org.gnome.desktop.peripherals.keyboard delay 500
  gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 30
  gsettings set org.gnome.desktop.peripherals.keyboard delay 200
}

# AUR helper
function install_paru() {
  sudo pacman -Syu pkg-config gcc git fakeroot
  cd /var/tmp
  git clone https://aur.archlinux.org/paru.git
  cd paru
  makepkg -si
  cd
  rm -rf /var/tmp
}

function install_fonts() {
  cd /var/tmp
  mkdir -p c && cd c
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/CascadiaCode.zip
  unzip CascadiaCode.zip
  sudo mkdir -p /usr/local/share/fonts/OTF
  sudo cp CaskaydiaCoveNerdFontMono-Regular.ttf \
    CaskaydiaCoveNerdFontMono-Italic.ttf \
    CaskaydiaCoveNerdFontMono-Bold.ttf \
    /usr/local/share/fonts/OTF

  cd ..
  rm -rf c CascadiaCode.zip
}

function setup_fonts() {
  gsettings set org.gnome.desktop.interface font-name 'Cantarell 14'
  gsettings set org.gnome.desktop.interface document-font-name 'Cantarell 14'
  gsettings set org.gnome.desktop.interface monospace-font-name 'Source Code Pro 14'
}

function install_rust() {
  pacman -Syu rustup
  rustup default stable
  rustup component add rust-analyzer
  mkdir -p ~/.cargo/bin
  ln -s $(rustup which --toolchain stable rust-analyzer) ~/.cargo/bin
}

function setup_alacritty() {
  mkdir -p $HOME/.config/alacritty/
  ln -s $PWD/dotfiles/alacritty.toml $HOME/.config/alacritty/alacritty.toml
}

function install_setup_wezterm() {
  set -ex
  cd /tmp
  git clone --depth=1 --branch=main --recursive \
    https://github.com/wez/wezterm.git
  cd wezterm
  git submodule update --init --recursive
  ./get-deps
  cargo build --release
  #cargo run --release --bin wezterm -- start
  set +ex
}

function install_lazygit() {
  cd /tmp
  LAZYGIT_VERSION="0.36.0"
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"

  sudo tar xf lazygit.tar.gz -C /usr/local/bin lazygit

  #mkdir -p ~/.config/
  #ln -s $PWD/dotfiles/nvim  ~/.config/
}

# neovim with Astronvim distro in 2024
function setup_nvim_astronvim() {
  backup_dir ~/.config/nvim
  cargo install tree-sitter-cli
  #install_lazygit

  ln -s /home/voyt/p/voyt_dotfiles/dotfiles/nvim_astronvim/ ~/.config/nvim

  # Post installation setup in nvim
  nvim '+LspInstall rust' # install Rust laguage server
  # nvim '+LspInstall c' # install C laguage server
  # nvim '+LspInstall lua_ls'
  # nvim '+TSInstall rust lua c' # install tree sitter language parsers
}

function setup_git() {
  backup_file $HOME/.gitconfig
  ln -s $PWD/dotfiles/gitconfig $HOME/.gitconfig
}

function install_sway() {
  sudo pacman -Syu \
    sway \
    swayidle \
    swaylock \
    wl-clipboard \
    xdg-desktop-portal-wlr \
    wofi \
    waybar \
    mako \
    slurp \
    grim
  # pulseaudio-utils \
}

function setup_sway() {
  backup_dir ~/.config/sway
  mkdir -p $HOME/.config/sway
  ln -s $PWD/dotfiles/sway/config $HOME/.config/sway/config

  backup_dir ~/.config/waybar
  ln -s $PWD/dotfiles/waybar $HOME/.config/waybar

  backup_dir ~/.config/wofi
  ln -s $PWD/dotfiles/wofi $HOME/.config/wofi

  sudo cp ./scripts/swaylock.sh /usr/local/bin/

  # laptop
  ln -s $PWD/dotfiles/sway/config_laptop $HOME/.config/sway/config_local
}

# listen streaming music
function install_code_radio_cli {
  sudo apt install libasound2-dev libssl-dev
  cargo install code-radio-cli
  # run:
  # code-radio -l # to list radio sources
  # code-radio -s <radio_id>
}

# screenshot tool for sway
function install_screenshot_tools() {
  paru -S grimshot
  sudo pacman -S swappy
}

# cliboard history
function install_clapboard() {
  # pushd /tmp
  # git clone https://github.com/bjesus/clapboard.git
  # pushd clapboard
  # cargo build --release
  # sudo cp target/release/clapboard /usr/local/bin/
  paru -S clapboard-git

  ln -s $PWD/dotfiles/clapboard ~/.config/clapboard
}

# setup audio: pipewire, wireplumber
function setup_pipewire() {
  # add user to audio group
  sudo usermod -a -G audio $USER

  backup_dir ~/.config/pipewire
  ln -s $PWD/dotfiles/pipewire ~/.config/pipewire

  sudo pacman -S \
    pipewire \
    wireplumber \
    pipewire-pulse \
    rtkit \
    noise-suppression-for-voice

  systemctl --user --now enable wireplumber

  # equalizer
  sudo pacman -S \
    lsp-plugins-lv2 \
    easyeffects

  # auto-run easyeffect
  mkdir -p ~/.config/systemd/user/
  ln -s $PWD/dotfiles/systemd/user/easyeffects.service ~/.config/systemd/user/
  systemctl --user daemon-reload
  systemctl --user enable easyeffects.service

  # TODO: manuall run easyeffects, add "Equalizer" effect and load APO preset, e.g
  # audio/Beyerdynamic_DT770_old_earpads.txt
  # safe new Easyeffect preset (e.g., as dt770) and make it default for the preferred audio device

  # How to fix cracking distortion of external audio USB interface - disable wireplumber auto-suspend:
  ln -s $PWD/dotfiles/wireplumber $HOME/.config/wireplumber
  systemctl --user --now restart wireplumber
  # check configuration with:
  systemctl --user status wireplumber
}

function pass_coffin() {
  ln -s $HOME/CozyDrive/.password-store/ ~/.password-store
}

function disk_encryption() {
  paru -S sedutil
}

function setup_printer() {
 sudo pacman -S cups cups-pdf hplip sane xsane
 sudo systemctl enable cups.socket
    # cups: for printing support [installed]
    # sane: for scanner support
    # xsane: sane scanner frontend
    # python-pillow: for commandline scanning support [installed]
    # python-reportlab: for pdf output in hp-scan
    # rpcbind: for network support
    # python-pyqt5: for running GUI and hp-toolbox
    # libusb: for advanced usb support [installed]
    # wget: for network support [installed]
}

function setup_grub() {
  sudo nvim /etc/default/grub
  #GRUB_THEME="/boot/grub/themes/starfield/theme.txt"
  sudo grub-mkconfig -o /boot/grub/grub.cfg
}

install_ocr() {
  sudo pacman -S tesseract tesseract-data-eng tesseract-data-deu
  # how to OCR an JPEG with german text:
  # tesseract -l deu ~/Downloads/IMG_4071.jpeg out
  # nvim out.txt
}

function setup_time_sync() {
  sudo mkdir -p /etc/systemd/timesyncd.conf.d
  sudo sh -c 'cat > /etc/systemd/timesyncd.conf.d/local.conf << EOF
[Time]
NTP=0.arch.pool.ntp.org 1.arch.pool.ntp.org 2.arch.pool.ntp.org 3.arch.pool.ntp.org
FallbackNTP=0.pool.ntp.org 1.pool.ntp.org 0.fr.pool.ntp.org
RootDistanceMaxSec=1
PollIntervalMinSec=1h
PollIntervalMaxSec=2h
ConnectionRetrySec=30
SaveIntervalSec=1h
EOF
'
  sudo timedatectl set-ntp true
  sudo systemctl restart systemd-timesyncd.service
  sudo systemctl status systemd-timesyncd.service
  timedatectl status
  timedatectl timesync-status
}

function setup_nvidia_proprietary_driver() {
  # list full list of open source video drivers:
  # pacman -Ss xf86-video
  # propriatary video driver for RTX 4070:
  sudo pacman -S nvidia-open nvidia-utils
  # set nvidia_drm.modeset=1
  echo 'options nvidia_drm modeset=1' > /etc/modprobe.d/nvidia.conf
  # this should return Y:
  # sudo cat /sys/module/nvidia_drm/parameters/modeset
  #
  # disable NVIDIA GPU in sway by using only the internal GPU
  sudo sh -c 'echo "WLR_DRM_DEVICES=/dev/dri/card1" >> /etc/environment'
  # ls -l /dev/dri/by-path/pci-0000:00:02.0-card
  #
  # ↪ lspci | grep VGA
  # 00:02.0 VGA compatible controller: Intel Corporation Raptor Lake-S GT1 [UHD Graphics 770] (rev 04)
  # 01:00.0 VGA compatible controller: NVIDIA Corporation AD104 [GeForce RTX 4070] (rev a1)
  #
  # How to disable nouveau kernel module:
  # sudo sh -c 'echo "blacklist nouveau" >> /etc/modprobe.d/blacklist-nouveau.conf'
  # sudo sh -c 'echo "options nouveau modeset=0" >> /etc/modprobe.d/blacklist-nouveau.conf'
  # mkinitcpio -p linux
}

function setup_i3() {
  sudo pacman -S \
    i3 \
    xorg \
    xorg-xinit

  cp /etc/X11/xinit/xinitrc ~/.xinitrc
  ln -s $PWD/dotfiles/i3 ~/.config/i3
  ln -s $PWD/dotfiles/xinitrc ~/.xinitrc
}

# Manually install:
# * mouseless key navigator in browsers:
#   * Surfingkey (alternative - vimium)

# TODO:
# feh - wallpaper
# https://github.com/qutebrowser/qutebrowser

#install_rust
#install_paru
#install_system_packages
#install_user_packages
#install_setup_keyd
#setup_tmux
#setup_fish_shell
#setup_git
#install_sway
#setup_sway
#install_fonts
#setup_fonts
#setup_alacritty
#setup_starship
#setup_tlp
#arch_system_setup
#pass_coffin
#
#setup_nvim_astronvim
#install_code_radio_cli
#
#setup_gnome_terminal
#install_setup_wezterm
#install_lazygit
#install_swappy
#install_clapboard
#setup_pipewire
#disk_encryption
#setup_grub
#install_screenshot_tools
# setup_time_sync
# arch_setup_firejail_apparmor
