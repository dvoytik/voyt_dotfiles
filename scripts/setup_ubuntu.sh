#!/bin/bash

# vim: expandtab shiftwidth=2

function backup_file() {
  f=$1
  test -f $f && echo "WARNING: $f exists. Backing up..." \
    && mv $f ${f}_$(date +%y%m%d_%H%M)
}

function install_packages() {
  sudo apt update
  sudo apt install \
    git \
    tmux \
    fish \
    ripgrep \
    fd-find \
    tree \
    htop \
    exa \
    zoxide \
    ncal \
    fzf \
    gdu \
    vlc \
    gimp
  # gcc cmake g++ pkg-config \
  # for laptop:
    #tlp \
    #tlp-rdw

  sudo snap install --classic nvim
  sudo snap install \
    starship \
    btop
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

function install_fonts() {
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
  rustup component add rust-analyzer
  ln -s $(rustup which --toolchain stable rust-analyzer) ~/.cargo/bin
}

function install_alacritty() {
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
  test -d ~/.config/nvim && echo "ERROR: back up nvim config!" && exit
  #mv ~/.local/share/nvim/ ~/.local/share/nvim_BAK_$(date +%Y%m%d)
  #mv ~/.confi/nvim/ ~/.config/nvim_BAK_$(date +%Y%m%d)
  cargo install tree-sitter-cli
  #install_lazygit

  git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim
  ln -s $PWD/dotfiles/astronvim_user ~/.config/nvim/lua/user
  nvim +PackerSync
}

function setup_git() {
  backup_file $HOME/.gitconfig
  ln -s $PWD/dotfiles/gitconfig $HOME/.gitconfig
}


#install_fonts
#install_packages
#setup_rust
#install_alacritty
#setup_alacritty
#install_setup_keyd
#setup_tmux
#setup_fish_shell
#setup_starship
#setup_nvim_my_config
#setup_tlp
#setup_gnome_terminal
#install_setup_wezterm
#setup_nvim_astronvim
#install_lazygit
#setup_git
