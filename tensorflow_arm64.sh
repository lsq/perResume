#!/usr/bin/env bash -e

git clone https://github.com/lhelontra/tensorflow-on-arm
cd tensorflow-on-arm/build_tensorflow/
sed -i '/^RUN git checkout v2.3.0/s/RUN git checkout v2.3.0/RUN git checkout master/' ./Dockerfile.bullseye
sed -i "31s@^@RUN sed -i '/wget/s/wget/wget -nv/' ./build_tensorflow.sh\n@" ./Dockerfile.bullseye
sed -i "31s@^@RUN sed -i '/unzip/s/unzip/unzip -q/' ./build_tensorflow.sh\n@" ./Dockerfile.bullseye
sed -i '15,18s/^/#/'  ./Dockerfile.bullseye
docker build -t tf-arm -f Dockerfile.bullseye .
# rpi.conf, rk3399.conf ...
docker run -i -v /tmp/tensorflow_pkg/:/tmp/tensorflow_pkg/ --env TF_PYTHON_VERSION=3.9 tf-arm bash -x ./build_tensorflow.sh configs/rk3399.conf 
