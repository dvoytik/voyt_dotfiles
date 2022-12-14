#!/bin/bash

# vim: expandtab shiftwidth=2

function install_packages() {
  sudo apt install \
    git \
    tmux \
    fish \
    neovim \
    tree \
    htop \
    tlp \
    tlp-rdw \
    vlc \
    gimp

  sudo snap instal starship
}

function install_setup_keyd() {
  sudo cp dotfiles/keyd.conf /etc/keyd/default.conf
  set -ex
  sudo apt install gcc make
  cd ~/p/
  git clone https://github.com/rvaiya/keyd
  cd keyd
  make && sudo make install
  sudo systemctl enable keyd && sudo systemctl start keyd
  set +ex
}

function setup_tmux() {
  test -f ~/.tmux.conf && echo "ERROR: tmux.conf exists" && exit
  ln -s $PWD/dotfiles/tmux.conf ~/.tmux.conf
}

function setup_fish_shell() {
  test -f ~/.config/fish/config.fish && echo "ERROR: config.fish exists" && exit
  mkdir -p ~/.config/fish/
  ln -s $PWD/dotfiles/config.fish  ~/.config/fish/
}

function setup_starship() {
  ln -s $PWD/dotfiles/starship.toml ~/.config/
}

function setup_tlp() {
  sudo systemctl enable tlp
  sudo systemctl start tlp
  sudo systemctl status tlp
}

function ssetup_nvim() {
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

function setup_fonts() {
  cd /tmp
  mkdir -p c && cd c
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/CascadiaCode.zip
  unzip CascadiaCode.zip
  sudo cp 'Caskaydia Cove Nerd Font Complete Regular.otf' /usr/local/share/fonts
  cd ..
  rm -rf c CascadiaCode.zip
}

function setup_rust() {
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

function setup_alarcity() {
  echo
}

#install_setup_keyd
#install_packages
#setup_tmux
#setup_fish_shell
#setup_starship
#ssetup_nvim
#setup_fonts
#setup_tlp
#setup_rust
#setup_gnome_terminal
