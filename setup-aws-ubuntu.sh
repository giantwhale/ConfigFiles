BASEDIR=`pwd`
echo $BASEDIR

# Argument Parse
# =================================================
WITH_PYTHON3=false

for arg in "$@"
do
    if [ "$arg" == "--with-python3" ]; then
	echo 'Install anaconda3: yes'
	WITH_PYTHON3=true
    fi
done

# Basic setup
# =================================================
mkdir -p ~/apps/bin
cp ~/.bashrc ~/.bashrc_bk

sudo apt install -y emacs

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

# gcc, java, etc
sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
sudo apt-get update -y && apt upgrade -y && apt-get autoremove && apt-get autoclean
sudo apt install -y build-essential gcc libevent-dev libncurses5-dev gfortran libreadline-dev xorg xorg-dev
sudo apt install -y liblzma-dev libblas-dev libbz2-dev libpcre3-dev libcurl4-openssl-dev
sudo apt install -y texlive-base texlive-latex-base #texlive-fonts-recommended texlive-fonts-extra
sudo apt install -y default-jre default-jdk

# Enable X for R Plotting
# per https://unix.stackexchange.com/questions/31283/error-in-r-unable-to-open-connection-to-x11
sudo apt install -y xvfb xauth xfonts-base
# Xvfb :0 -ac -screen 0 1960x2000x24 &  # add a virtual X env

# install font for R so ggplot can be properly displayed
sudo apt install -y t1-xfree86-nonfree ttf-xfree86-nonfree ttf-xfree86-nonfree-syriac xfonts-75dpi xfonts-100dpi


# tmux
cd "$BASEDIR/src"
wget https://github.com/tmux/tmux/releases/download/2.4/tmux-2.4.tar.gz
tar xf tmux-2.4.tar.gz
cd tmux-2.4
./configure --prefix="$HOME/apps"
make && make install
cd "$BASEDIR/src"
rm -rf tmux-2.4*

# ananconda3
# enable by passing --with-python3, in case you use AMI with preinstalled python.
if $WITH_PYTHON3 ; then
    cd "$BASEDIR/src"
    wget https://repo.continuum.io/archive/Anaconda3-4.4.0-Linux-x86_64.sh
    bash Anaconda3-4.4.0-Linux-x86_64.sh -b -p "$HOME/apps/anaconda3"
    declare -a executables=("python" "ipython" "jupyter" "pip" "conda")
    for exec in "${executables[@]}"
    do
	rm -f "${HOME}/apps/bin/$exec"
	ln -s "${HOME}/apps/anaconda3/bin/$exec" "${HOME}/apps/bin/$exec"
    done     
    rm -f Anaconda3-*sh

    conda upgrade -y numba
    conda upgrade -y numpy pandas scikit-learn
fi


# R
cd "$BASEDIR/src"
wget https://cloud.r-project.org/src/base/R-3/R-3.4.0.tar.gz
tar xf R-3.4.0.tar.gz
cd R-3.4.0
./configure --prefix="$HOME/apps/R-3.4.0" --enable-R-shlib
make && make install

declare -a executables=("R" "Rscript")
for exec in "${executables[@]}"
do
    ln -s "${HOME}/apps/R-3.4.0/bin/$exec" "${HOME}/apps/bin/$exec"
done     
cd "$BASEDIR"
rm -rf src/R-3.4.0
Rscript install_R_packages.R

mkdir -p "$HOME/pkglib/R-3.4.0"
echo ".libPaths('$HOME/pkglib/R-3.4.0')" > "${HOME}/.Rprofile"
Rscript "${BASEDIR}/install_R_pkgs.R"

# Rstudio Server
sudo apt install -y gdebi-core
sudo mkdir -p /etc/rstudio
echo 'rsession-which-r=/home/ubuntu/apps/bin/R' > /etc/rstudio/rserver.conf
cd "${BASEDIR}/src"
wget https://download2.rstudio.org/rstudio-server-1.0.143-amd64.deb
sudo gdebi rstudio-server-1.0.143-amd64.deb
sudo systemctl restart rstudio-server.service
rm -f rstudio-server-1.0.143-amd64.deb
cd "${BASEDIR}"


