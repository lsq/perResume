arch="aarch64"
package_name=geckodriver
git clone https://github.com/termux/unstable-packages
cd ./unstable-packages
./start-builder.sh
mv disabled-packages/geckodriver/ packages/
ls -al packages/geckodriver/
ls -al
./build-package.sh -a ${arch} ${package_name}

ls -al
