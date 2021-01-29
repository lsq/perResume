#!/usr/bin/env bash -e

git clone https://github.com/lhelontra/tensorflow-on-arm
cd tensorflow-on-arm/build_tensorflow/
sed -i '/^RUN git checkout v2.3.0/s/RUN git checkout v2.3.0/RUN git checkout master/' ./Dockerfile.bullseye
docker build -t tf-arm -f Dockerfile.bullseye .
# rpi.conf, rk3399.conf ...
docker run -it -v /tmp/tensorflow_pkg/:/tmp/tensorflow_pkg/ --env TF_PYTHON_VERSION=3.9 tf-arm ./build_tensorflow.sh configs/rk3399.conf 