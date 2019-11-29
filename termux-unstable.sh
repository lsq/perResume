arch="aarch64"
package_name=geckodriver
git clone https://github.com/termux/unstable-packages
cd ./unstable-packages
mv disabled-packages/geckodriver/ packages/
ls -al packages/geckodriver/
bash -x ./start-builder.sh ./build-package.sh -a ${arch} ${package_name}
ls -al
