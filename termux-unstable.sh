arch="aarch64"
package_name=geckodriver
git clone https://github.com/termux/unstable-packages
cd ./unstable-packages
sed -i 's/^\(TERMUX_PKG_SHA256=\).*/\1c6acabacf8063ff59926f6b8721968a6eaaa35050b2988868a2d8d37ef7c90dd/;
        s/TERMUX_PKG_VERSION=0.25.0/TERMUX_PKG_VERSION=0.26.0/
' disabled-packages/geckodriver/build.sh
cp -rf disabled-packages/geckodriver/ packages/
cp -rf disabled-packages/geckodriver/ $APPVEYOR_BUILD_FOLDER/$APPVEYOR_JOB_ID/
ls -al packages/geckodriver/
sed -i '/docker exec --interactive --tty/s/--interactive --tty//' start-builder.sh
source ./start-builder.sh
docker exec --tty "$CONTAINER_NAME" pwd
docker exec --tty "$CONTAINER_NAME" ls -al
docker exec --tty "$CONTAINER_NAME" bash -x ./build-package.sh -a ${arch} ${package_name}
docker exec --tty "$CONTAINER_NAME" ls -al
pwd
ls -al
ls -al termux-packages/debs
cp termux-packages/debs/* $APPVEYOR_BUILD_FOLDER/$APPVEYOR_JOB_ID/
