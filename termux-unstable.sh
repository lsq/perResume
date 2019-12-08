arch="aarch64"
package_name=geckodriver
git clone https://github.com/termux/unstable-packages
cd ./unstable-packages
#curl -vOJL https://hg.mozilla.org/mozilla-central/archive/tip.zip/testing/geckodriver
# use -I only print response head
# use -D dump respose head
geckodriver_version="v0.26.0"
curl -vD ./gecko_header.txt -o m.zip https://hg.mozilla.org/mozilla-central/archive/tip.zip/testing/geckodriver
unzip -o m.zip 
# eval $(gawk -F';' '/content-disposition/{printf $2}' gecko_header.txt)
eval $(sed -rn 's/(.*; *)(filename=.*\>).*/\2/p' gecko_header.txt)
[ -d "${filename/%.zip}/testing/geckodriver" ] && mv "${filename/%.zip}/testing/geckodriver" geckodriver-$geckodriver_version || exit 1
tar cvzf geckodriver-$geckodriver_version.tar.gz geckodriver-$geckodriver_version
cp geckodriver-$geckodriver_version.tar.gz termux-packages/
pwd && ls -al
tarhash=$(sha256sum geckodriver-$geckodriver_version.tar.gz | cut -f 1 -d ' ')
sed -i 's/^\(TERMUX_PKG_SHA256=\).*/\1'"$tarhash"'/
        s/TERMUX_PKG_VERSION=0.25.0/TERMUX_PKG_VERSION='"${geckodriver_version/#v}"'/
' disabled-packages/geckodriver/build.sh

sed -i '/for.* do/,/done/{
  /if curl/i \  if [[ $URL ~= geckodriver-'"${geckodriver_version}"' ]];then\
    cp $TERMUX_SCRIPTDIR/'"geckodriver-$geckodriver_version.tar.gz"' "$DESTINATION"\
    return\
  else
  /done/i \  fi
}' termux-packages/scripts/build/termux_download.sh
: <<'COMMENTSBLOCK'
sed -i '$a \
  echo $CARGO_TARGET_NAME' disabled-packages/geckodriver/build.sh
COMMENTSBLOCK
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
# disabled-packages/geckodriver/build.sh
: <<'COMMENTSBLOCK'
TERMUX_PKG_HOMEPAGE=https://github.com/mozilla/geckodriver
TERMUX_PKG_DESCRIPTION="Proxy for using W3C WebDriver-compatible clients to interact with Gecko-based browsers"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=0.25.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/mozilla/geckodriver/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=9ba9b1be1a2e47ddd11216ce863903853975a4805e72b9ed5da8bcbcaebbcea9
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	install -Dm700 \
		"$TERMUX_PKG_SRCDIR/target/$CARGO_TARGET_NAME"/release/geckodriver \
		"$TERMUX_PREFIX"/bin/
}
COMMENTSBLOCK

