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
    noto-fonts ttf-liberation \
    libnotify \
    pipewire-pulse pipewire-media-session \
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
  gsettings set org.gnome.desktop.interface font-name 'Cantarell 16'
  gsettings set org.gnome.desktop.interface document-font-name 'Cantarell 16'
  gsettings set org.gnome.desktop.interface monospace-font-name 'Source Code Pro 16'
}

function install_rust() {
  pacman -Syu rustup
  rustup default stable
  rustup component add rust-analyzer
  mkdir -p ~/.cargo/bin
  ln -s $(rustup which --toolchain stable rust-analyzer) ~/.cargo/bin
}

function ARCH_DOESNOT_NEED_install_alacritty() {
  cargo >/dev/null || echo "ERROR: cargo is not installed" || exit
  sudo apt install gcc g++ cmake pkg-config libfreetype6-dev libfontconfig1-dev \
                   libxcb-xfixes0-dev libxkbcommon-dev python3
  cd ~/p
  git clone https://github.com/alacritty/alacritty.git
  pushd alacritty
  cargo build --release --no-default-features --features=wayland
  sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
  sudo cp target/release/alacritty /usr/local/bin
  sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
  sudo desktop-file-install extra/linux/Alacritty.desktop
  sudo update-desktop-database
  sudo mkdir -p /usr/local/share/man/man1
  gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
  gzip -c extra/alacritty-msg.man | \
    sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null

  mkdir -p $HOME/.config/fish/completions/
  cp extra/completions/alacritty.fish $HOME/.config/fish/completions/alacritty.fish

  popd
}

function setup_alacritty() {
  mkdir -p $HOME/.config/alacritty/
  ln -s $PWD/dotfiles/alacritty.yml $HOME/.config/alacritty/alacritty.yml
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
  pushd ~/.confg/nvim
  git checkout v2.11.8
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
function install_swappy() {
  sudo apt install grimshot slurp build-essential meson libcairo2-dev libpango1.0-dev \
    libgtk-3-dev scdoc gettext
  pushd /tmp
  git clone https://github.com/jtheoof/swappy
  cd swappy
  meson setup build
  ninja -C build
  ninja -C build
  sudo ninja -C build install
  popd
}

function install_clapboard() {
  pushd /tmp
  git clone https://github.com/bjesus/clapboard.git
  pushd clapboard
  cargo build --release
  sudo cp target/release/clapboard /usr/local/bin/

  ln -s $PWD/dotfiles/clapboard ~/.config/clapboard
}

function setup_audio() {
  # add user to audio group
  sudo usermod -a -G audio $USER
}

function setup_microphone() {
  #sudo pacman -S noise-suppression-for-voice
  #backup_dir ~/.config/pipewire
  ln -s $PWD/dotfiles/pipewire ~/.config/pipewire

  mkdir -p ~/.config/systemd/user/
  ln -s $PWD/dotfiles/systemd/user/pipewire-input-filter-chain.service ~/.config/systemd/user/
  systemctl --user daemon-reload
  systemctl --user enable pipewire-input-filter-chain.service
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
#ARCH_DOESNOT_NEED_install_alacritty
#setup_nvim_my_config
#setup_gnome_terminal
#install_setup_wezterm
#install_lazygit
#install_swappy
#install_clapboard
#setup_audio
#setup_microphone
#disk_encryption
#setup_grub
#
