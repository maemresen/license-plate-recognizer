# This script is creatd based on the gist on the following link.
# https://gist.github.com/braitsch/ee5434f91744026abb6c099f98e67613
#

# Options
TESSERACT_INSTALL_DIR=${TESSERACT_INSTALL_DIR:-"$HOME"}
LEPTONICA_INSTALL_DIR=${LEPTONICA_INSTALL_DIR:-"$HOME"}
OPENALPR_INSTALL_DIR=${OPENALPR_INSTALL_DIR:-"$HOME"}

# Temp directory for downloads
TEMP_DIR=$(mktemp -d -t openalpr-installer-XXXXXXXXXXXX)
mkdir -p $TEMP_DIR

echo "
############################################################
# 1. Remove any previously installed versions of 
#    Tesseract & Leptonica and install all required 
#    dependencies and build tools.
############################################################
"
apt update -y #fetch list of available updates
apt upgrade -y #install updates – does not remove packages
apt autoremove -y #removes unused/outdated packages

# remove any tesseract binaries and languages
apt remove -y tesseract-ocr*

# remove any previously installed leptonica
apt remove -y libleptonica-dev

# make sure other dependencies are removed too
apt autoclean -y
apt autoremove -y --purge

# install libtool m4 automake cmake & pkg-config
apt install -y libtool m4 automake cmake pkg-config

# install opencv
apt install -y libopencv-dev

# install liblog4cplus-dev, liblog4cplus-1.1-9 and build-essential:
apt -y install liblog4cplus-1.1-9 liblog4cplus-dev build-essential

apt -y install wget

echo "
############################################################
# 2. Download & install leptonica 1.74.1
############################################################
"
cd $TEMP_DIR
wget https://github.com/DanBloomberg/leptonica/archive/1.74.1.tar.gz

# unpack tarball and cd into leptonica directory
mkdir -p $LEPTONICA_INSTALL_DIR
cd $LEPTONICA_INSTALL_DIR
tar -xvzf "$TEMP_DIR/1.74.1.tar.gz"
cd leptonica-1.74.1

# build leptonica
./autobuild
./configure
make
make install


echo "
############################################################
# 3. Download & install tesseract 3.0.5
############################################################
"
cd $TEMP_DIR
wget https://github.com/tesseract-ocr/tesseract/archive/3.05.02.tar.gz

# unpack tarball and cd into tesseract directory
mkdir -p $TESSERACT_INSTALL_DIR
cd $TESSERACT_INSTALL_DIR
tar -xvzf "$TEMP_DIR/3.05.02.tar.gz"
cd tesseract-3.05.02/

# build tesseract
./autogen.sh
./configure --enable-debug LDFLAGS="-L/usr/local/lib" CFLAGS="-I/usr/local/include"
make
make install
make install-langs
ldconfig

# check everything worked
tesseract --version

echo "
############################################################
# 4. Install libcurl3 & update libcurl4
############################################################
"
apt install -y software-properties-common
apt install -y libcurl4 libcurl4-openssl-dev  


echo "
############################################################
# 5. Download and install OpenALPR
############################################################
"
cd $TEMP_DIR
apt install -y unzip
wget https://github.com/openalpr/openalpr/archive/master.zip 

# unpack
mkdir -p $OPENALPR_INSTALL_DIR
cd $OPENALPR_INSTALL_DIR
unzip "$TEMP_DIR/master.zip"

cd openalpr-master/src 
mkdir build
cd build

# setup the compile environment
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_INSTALL_SYSCONFDIR:PATH=/etc ..

# and compile the library
make && make install


echo "
############################################################
# Cleaning up files
############################################################
"
rm -rf $TEMP_DIR