#!/bin/sh

cd /tmp
git clone https://github.com/hasse69/rar2fs.git
cd rar2fs
wget http://www.rarlab.com/rar/unrarsrc-5.4.5.tar.gz
tar -xvzf unrarsrc-5.4.5.tar.gz
cd unrar
make lib
make install-lib
cd ..
autoreconf -f -i
./configure && make
make install
cd /