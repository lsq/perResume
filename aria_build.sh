#!/usr/bin/env bash

git clone --recurse-submodules https://github.com/devgianlu/aria2-android.git

wget https://dl.google.com/android/repository/android-ndk-r20-linux-x86_64.zip
unzip -q android-ndk-r20-linux-x86_64.zip

cd  aria2-android
ls -al

./build_all.sh
cp -rf ./bin    ../$APPVEYOR_JOB_ID/aria2-android
