java_version=8
openjdk=java-${java_version}-openjdk-amd64
patht=$(sed -n 's@java-[0-9]\{1,2\}-openjdk-amd64@'$openjdk'@p' <<< "$PATH")
export PATH=$patht 
echo $patht 

java -version

update-alternatives --display java
update-java-alternatives -l


 echo $JAVA_HOME
 
# sudo apt install android-sdk -y


# which sdkmanager
# To install it on a Debian based system simply do

# Install latest JDK
# sudo apt install default-jdk -y
# apt search openjdk
# java -version
ls -ahl /usr/lib/jvm/
for i in /usr/lib/jvm/*; do
  #[ -d "$i/bin" ] && ls -alh $i/bin
  $i/bin/java -version
done
if update-alternatives --list java|grep $openjdk; then
  export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
  echo $JAVA_HOME
  echo $CLASSPATH
fi

echo $PATH

update-java-alternatives -l
update-alternatives --list java
# install unzip if not installed yet
# sudo apt install unzip

# get latest sdk tools - link will change. go to https://developer.android.com/studio/#downloads to get the latest one
cd ~
# curl -vLSs https://dl.google.com/android/repository

wget -c https://dl.google.com/android/repository/android-ndk-r20-linux-x86_64.zip
unzip -oq android-ndk-r20-linux-x86_64.zip

 wget -c https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip

# unpack archive
unzip -oq sdk-tools-linux-4333796.zip

rm sdk-tools-linux-4333796.zip

mkdir android-sdk
mv tools android-sdk/tools

# Export the Android SDK path 
export ANDROID_HOME=$HOME/android-sdk
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Show all available sdk packages
which  sdkmanager
sdkmanager --list

# Identify latest android platform (here it's 28) and run

yes|sdkmanager "platform-tools" "platforms;android-29"
yes | sdkmanager --licenses

# Now you have adb, fastboot and the latest sdk tools installed

# Fixes sdkmanager error with java versions higher than java 8
# export JAVA_OPTS='-XX:+IgnoreUnrecognizedVMOptions --add-modules java.se.ee'
git clone https://github.com/mozilla-mobile/fenix
cd fenix
./gradlew clean app:assembleGeckoBetaDebug
find . -name '*.apk' -exec cp  {} $APPVEYOR_BUILD_FOLDER/$APPVEYOR_JOB_ID/ \;
