#!/usr/bin/env bash

git clone --recurse-submodules https://github.com/devgianlu/aria2-android.git

cd  aria2-android
ls -al

./build_all.sh
cp -rf ./bin    $APPVEYOR_JOB_ID/aria2-android
