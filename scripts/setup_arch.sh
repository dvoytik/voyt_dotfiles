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

function setup_nvim_my_config() {
  mkdir -p ~/.config/
  ln -s $PWD/dotfiles/nvim  ~/.config/
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
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/CascadiaCode.zip
  unzip CascadiaCode.zip
  sudo mkdir -p /usr/local/share/fonts/OTF
  sudo cp 'Caskaydia Cove Nerd Font Complete Mono Bold.otf' \
           'Caskaydia Cove Nerd Font Complete Mono Italic.otf' \
           'Caskaydia Cove Nerd Font Complete Mono Regular.otf' \
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

function setup_nvim_astronvim() {
  backup_dir ~/.config/nvim
  set -ex
  cargo install tree-sitter-cli
  #install_lazygit

  git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim
  pushd ~/.config/nvim
  git checkout v3.4.1
  ln -s $PWD/dotfiles/astronvim_user ~/.config/nvim/lua/user
  nvim +PackerSync
  set +ex

  # Post installation setup in nvim
  nvim '+AstroUpdate'
  nvim '+TSInstall rust lua c' # install tree sitter language parsers
  nvim '+LspInstall rust c' # install laguage server
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

function install_clapboard() {
  pushd /tmp
  git clone https://github.com/bjesus/clapboard.git
  pushd clapboard
  cargo build --release
  sudo cp target/release/clapboard /usr/local/bin/

  ln -s $PWD/dotfiles/clapboard ~/.config/clapboard
}

# setup audio
function setup_pipewire() {
  # add user to audio group
  sudo usermod -a -G audio $USER

  backup_dir ~/.config/pipewire
  ln -s $PWD/dotfiles/pipewire ~/.config/pipewire

  sudo pacman -S \
    pipewire \
    wireplumber \
    pipewire-pulse \
    noise-suppression-for-voice

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

  # disable pipewire auto-suspend
  sudo mkdir -p /etc/wireplumber/main.lua.d/
  sudo cp -a \
    /usr/share/wireplumber/main.lua.d/50-alsa-config.lua \
    /etc/wireplumber/main.lua.d/50-alsa-config.lua
  ORIG_STR='\["session\.suspend-timeout-seconds"\]'
  REPL_STR='\["session\.suspend-timeout-seconds"\] \= 7200'
  sudo -E sed -i "/${ORIG_STR}/c${REPL_STR}" /etc/wireplumber/main.lua.d/50-alsa-config.lua
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
#setup_nvim_my_config
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
