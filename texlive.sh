
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
  aria2c -c -s 20 -o texlive.iso $1
  [ ! -f texlive.iso ] && exit 1
  file texlive.iso
  #sudo mount -t iso9660 -o ro,loop,noauto ./texlive.iso /mnt
  sudo mount texlive.iso /mnt
  cd /mnt
  ls -al
  sudo ./install-tl -q -profile $APPVEYOR_BUILD_FOLDER/install_texlive.profile
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
  sudo ./install-tl -q -profile install_texlive.profile
}

decrypt()
{
  echo "Decrypting $1..."
  openssl enc -aes-256-cbc -d -a -k $TEX_KEY -in $1 -out $2 || { echo "File not found"; return 1; }
  echo "Successfully decrypted"
}

# https://mirror.bjtu.edu.cn/ctan/systems/texlive/tlnet/tlpkg/
echo "====================="
echo "begin install........"
#net_install http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
#iso_install http://mirror.ctan.org/systems/texlive/Images/texlive.iso

# Add /usr/local/texlive/2019/texmf-dist/doc/man to MANPATH.
# Add /usr/local/texlive/2019/texmf-dist/doc/info to INFOPATH.
# Most importantly, add /usr/local/texlive/2019/bin/x86_64-linux
# to your PATH for current and future sessions.
# Logfile: /usr/local/texlive/2019/install-tl.log

cd $APPVEYOR_BUILD_FOLDER/cv
decrypt  cv.png cv-zh.tex 
decrypt  picture.tex  picture.jpg

tar xf fonts.tar.xz
[ -d fonts ] && cd fonts || exit 1
if [ -d ~/.local/share/fonts ]; then
  cp * ~/.local/share/fonts/
else
  mkdir -p ~/.local/share/fonts
  cp * ~/.local/share/fonts/
fi
cd $APPVEYOR_BUILD_FOLDER/cv

sudo mkfontscale
sudo mkfontdir
sudo fc-cache -fv
cat cv-zh.tex
