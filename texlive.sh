
basename() {
    # Usage: basename "path" ["suffix"]
    local tmp

    #echo "${1##*[!/]}"
    tmp=${1%"${1##*[!/]}"}
    tmp=${tmp##*/}
    tmp=${tmp%"${2/"$tmp"}"}

    printf '%s\n' "${tmp:-/}"
}

### only for iso file on unix
#mount -t iso9660 -o ro,loop,noauto /your/texlive.iso /mnt
iso_install(){
  creat_profile
  wget -c -o texlive.iso $1
  sudo mount -t iso9660 -o ro,loop,noauto ./texlive.iso /mnt
  cd /mnt
  sudo ./install-tl -profile $APPVEYOR_BUILD_FOLDER/install_texlive.profile
}

### for network install
creat_profile(){
  touch install_texlive.profile
}
download_source(){
  wget -c "$1"
}
install_texlive(){
  local sr_url="$1"
  local tar_file="${sr_url##*/}"
  creat_profile
  [ -n "$tar_file" ] && download_source $sr_url
  #local sr_dir=$(basename "$tar_file" .tar.gz)
  [ -f "$tar_file" ] && local sr_dir=$(tar tf "$tar_file" | head -1)
  [ $? -ne 0 -o -z "$sr_dir" ] && exit 1
  tar xf "$tar_file" && cd "$sr_dir"
  sudo ./install-tl -profile install_texlive.profile
}

# https://mirror.bjtu.edu.cn/ctan/systems/texlive/tlnet/tlpkg/
echo "====================="
echo "begin install........"
#net_install http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
#iso_install http://mirror.ctan.org/systems/texlive/Images/texlive.iso
ls /
ls /mnt
cat $APPVEYOR_BUILD_FOLDER/install_texlive.profile
pwd
ls -al
ls -al /usr/local/texlive/2019/bin/x86_64-linux

# Add /usr/local/texlive/2019/texmf-dist/doc/man to MANPATH.
# Add /usr/local/texlive/2019/texmf-dist/doc/info to INFOPATH.
# Most importantly, add /usr/local/texlive/2019/bin/x86_64-linux
# to your PATH for current and future sessions.
# Logfile: /usr/local/texlive/2019/install-tl.log

