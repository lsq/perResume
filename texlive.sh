
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
  [ -n "$tar_file" ] && download_source $sr_url
  #local sr_dir=$(basename "$tar_file" .tar.gz)
  [ -f "$tar_file" ] && local sr_dir=$(tar tf "$tar_file" | head -1)
  [ $? -ne 0 -o -n "$sr_dir" ] && exit 1
  tar xf "$tar_file" && cd "$sr_dir"
  creat_profile
  ./install-tl -profile install_texlive.profile
  cat tlpkg/texlive.profile
}

# https://mirror.bjtu.edu.cn/ctan/systems/texlive/tlnet/tlpkg/
echo "====================="
echo "begin install........"
install_texlive http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
