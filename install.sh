#!/bin/sh
# upm install script for linux and macos
cd ~
git clone https://github.com/sctech-tr/upm.git
cd upm
sudo mv upm.sh /usr/bin/upm
sudo mv upm-version /etc/upm-version
sudo chmod +x /usr/bin/upm