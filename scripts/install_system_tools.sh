#!/bin/bash

set -e
set -x


# Restore man pages
yes | unminimize

apt-get update
apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages --allow-unauthenticated --no-install-recommends --no-upgrade \
  aria2 \
  apt-transport-https \
  awscli \
  bat \
  build-essential \
  byobu \
  ccache \
  cmake \
  coinor-libcgl-dev \
  coinor-libsymphony-dev \
  coinor-symphony \
  cron \
  curl \
  dirmngr \
  fish \
  fzf \
  git-core \
  git-crypt \
  global \
  gpg \
  gnupg \
  gnupg2 \
  gocryptfs \
  golang-go \
  graphviz \
  grass \
  grass-dev \
  grass-doc \
  htop \
  jags \
  language-pack-en \
  libavfilter-dev \
  libclang-dev \
  libncursesw5 \
  libglpk-dev \
  libgoogle-perftools-dev \
  libleptonica-dev \
  libnlopt-dev \
  libopenmpi-dev \
  libpoppler-cpp-dev \
  libprotobuf-dev \
  libprotoc-dev \
  libsecret-1-dev \
  libsodium-dev \
  libtesseract-dev \
  lsb-release \
  lsof \
  micro \
  man \
  man-db \
  mosh \
  multitail \
  nano \
  ncdu \
  nnn \
  p7zip-full \
  parallel \
  postgresql-client \
  protobuf-compiler \
  pv \
  rclone \
  rename  \
  rsync \
  secure-delete \
  silversearcher-ag \
  software-properties-common \
  openssh-server \
  tesseract-ocr-eng \
  tig \
  tmux \
  tree \
  whois \
  xclip \
  zsh 

apt-get clean
rm -rf /var/lib/apt/lists/

## GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh

### Docker
curl -sSL https://get.docker.com/ | sh
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo curl -L https://raw.githubusercontent.com/docker/compose/1.26.1/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose

# Dive (for exploring docker images)
wget https://github.com/wagoodman/dive/releases/download/v0.9.2/dive_0.9.2_linux_amd64.deb
apt install ./dive_0.9.2_linux_amd64.deb

### Z
wget https://raw.githubusercontent.com/rupa/z/master/z.sh -O /usr/bin/z

### Linuxbrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/null

# Set the Homebrew prefix to the default location
export HOMEBREW_PREFIX=/home/linuxbrew/.linuxbrew

# Install required packages
sudo apt-get update && sudo apt-get install -y build-essential

# Add Homebrew to your PATH
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bash_profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Create a default Brewfile
cat > ~/Brewfile <<EOF
brew "dolt"
brew "mrbayes"
brew "eccodes"
EOF

# Install packages using Homebrew
brew bundle --file=~/Brewfile