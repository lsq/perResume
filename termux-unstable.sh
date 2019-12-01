arch="aarch64"
package_name=geckodriver
git clone https://github.com/termux/unstable-packages
cd ./unstable-packages
cp -rf disabled-packages/geckodriver/ packages/
cp -rf disabled-packages/geckodriver/ $APPVEYOR_JOB_ID
ls -al packages/geckodriver/
sed -i '/docker exec --interactive --tty/s/--interactive --tty//' start-builder.sh
source ./start-builder.sh
docker exec --tty "$CONTAINER_NAME" pwd
docker exec --tty "$CONTAINER_NAME" ls -al
docker exec --tty "$CONTAINER_NAME" ./build-package.sh -a ${arch} ${package_name}
docker exec --tty "$CONTAINER_NAME" ls -al
pwd
ls -al
ls -al termux-packages/debs
