#!/usr/bin/env bash

git clone --depth=50 --branch=master https://github.com/a1ive/grub2-filemanager.git grub2-filemanager
git submodule update --init --recursive

sudo apt-get install -y gettext grub2-common genisoimage p7zip-full xorriso  mtools
cd grub2-filemanager
bash -x ./update_grub2.sh
sed -i '/cp grubfm/d;/ \+cp/s/^/    cp grubfm\*\.\* releases\/\n/' release.sh
sed -i '/7z a \.\.\/grubfm/s/7z a \.\.\/grubfm/7z a \.\.\/gfm/' release.sh
bash -x ./release.sh
cp gfm-zh_CN.7z ../$APPVEYOR_JOB_ID/
cp gfm-en_US.7z ../$APPVEYOR_JOB_ID/
