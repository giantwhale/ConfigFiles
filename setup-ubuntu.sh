BASEDIR=`pwd`
echo $BASEDIR
HOMEDIR=/home/ubuntu

mkdir -p ~/apps/bin
cp ~/.bashrc ~/.bashrc_bk

sudo apt install emacs

# setting up config file
# =================================================
cat .profile >> ~/.bashrc
echo 'export PATH=/home/ubuntu/apps/bin:$PATH' >> ~/.bashrc
export PATH="/home/ubuntu/apps/bin:$PATH"

cp .emacs ~/.emacs
cp -r .emacs.d ~/.emacs.d

cp .tmux.conf ~/.tmux.conf

# Install softwares
# =================================================
mkdir -p src

# gcc
sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
sudo apt-get update -y && apt upgrade -y && apt-get autoremove && apt-get autoclean
sudo apt-get install -y build-essential gcc libevent-dev libncurses5-dev

# tmux
cd "$BASEDIR/src"
wget https://github.com/tmux/tmux/releases/download/2.4/tmux-2.4.tar.gz
tar xf tmux-2.4.tar.gz
cd tmux-2.4
./configure --prefix="$HOMEDIR/apps"
make && make install
cd "$BASEDIR/src"
rm -rf tmux-2.4*

# ananconda3
cd "$BASEDIR/src"
wget https://repo.continuum.io/archive/Anaconda3-4.3.1-Linux-x86_64.sh
bash Anaconda3-4.3.1-Linux-x86_64.sh -b -p "$HOMEDIR/apps/anaconda3"
