arch="aarch64"
package_name=geckodriver
git clone https://github.com/termux/unstable-packages
cd ./unstable-packages
mv disabled-packages/geckodriver/ packages/
ls -al packages/geckodriver/
sed -i '/docker exec --interactive --tty/s/--interactive//' start-builder.sh
source ./start-builder.sh
docker exec --tty "$CONTAINER_NAME" pwd
#./build-package.sh -a ${arch} ${package_name}
ls -al
