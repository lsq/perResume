wget -c https://dl.google.com/android/repository/android-ndk-r20-linux-x86_64.zip
unzip -oq android-ndk-r20-linux-x86_64.zip

java -version

sudo apt install android-sdk -y


which sdkmanager
To install it on a Debian based system simply do

# Install latest JDK
# sudo apt install default-jdk

# install unzip if not installed yet
# sudo apt install unzip

# get latest sdk tools - link will change. go to https://developer.android.com/studio/#downloads to get the latest one
cd ~
curl -vLSs https://dl.google.com/android/repository
wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip

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

# sdkmanager "platform-tools" "platforms;android-28"

# Now you have adb, fastboot and the latest sdk tools installed

# Fixes sdkmanager error with java versions higher than java 8
# export JAVA_OPTS='-XX:+IgnoreUnrecognizedVMOptions --add-modules java.se.ee'
git clone https://github.com/mozilla-mobile/fenix
cd fenix
./gradlew clean app:assembleGeckoBetaDebug
find . -name '*.apk'
