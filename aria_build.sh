#!/usr/bin/env bash

git clone --recurse-submodules https://github.com/devgianlu/aria2-android.git

cd  aria2-android
ls -al

./build_all.sh
cp -rf ./bin/armeabi-v7a/bin/aria2c    $APPVEYOR_JOB_ID
cp -rf ./bin/arm64-v8a/bin/aria2c      $APPVEYOR_JOB_ID
cp -rf ./bin/armeabi-x86/bin/aria2c    $APPVEYOR_JOB_ID
cp -rf ./bin/armeabi-x86_64/bin/aria2c $APPVEYOR_JOB_ID
