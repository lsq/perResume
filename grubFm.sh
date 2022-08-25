#!/usr/bin/env bash

git clone --depth=50 --branch=master https://github.com/a1ive/grub2-filemanager.git grub2-filemanager
git submodule update --init --recursive
sudo apt-get install -y gettext grub2-common genisoimage p7zip-full xorriso  mtools
cd grub2-filemanager
./release.sh
