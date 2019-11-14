#!/bin/bash -e

export NDK_VERSION=$1
export CMAKE_VERSION=$2
export ANDROID_NDK_HOME=${ANDROID_HOME}/ndk/${NDK_VERSION}
export ANDROID_CMAKE_HOME=$ANDROID_HOME/cmake/$CMAKE_VERSION

: "${ANDROID_SDK_ROOT:="$ANDROID_HOME"}"

echo "JENKINS_HOME     : $JENKINS_HOME"
echo "ANDROID_HOME     : $ANDROID_HOME"
echo "NDK_VERSION      : $NDK_VERSION"
echo "CMAKE_VERSION    : $CMAKE_VERSION"

export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_NDK_HOME
export PATH=$PATH:$ANDROID_CMAKE_HOME/bin

# create cfg file to depress warnings
mkdir -p $JENKINS_HOME/.android && touch $JENKINS_HOME/.android/repositories.cfg

# cp licenses
mkdir -p "$ANDROID_HOME/licenses" || true
echo -e "\n8933bad161af4178b1185d1a37fbf41ea5269c55" > "$ANDROID_HOME/licenses/android-sdk-license"
echo -e "\n84831b9409646a918e30573bab4c9c91346d8abd" > "$ANDROID_HOME/licenses/android-sdk-preview-license"

# check if SDK manager is present
if hash sdkmanager 2>/dev/null; then
    echo "SDK TOOL already exists"
else
	echo "downloading SDK TOOL..."
	wget --no-verbose https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -O ${ANDROID_HOME}/sdk.zip
	echo y | unzip ${ANDROID_HOME}/sdk.zip -d ${ANDROID_HOME} && rm ${ANDROID_HOME}/sdk.zip
	echo "Android SDK TOOL has been installed to ${ANDROID_HOME}"
	echo "download platform support..."
	echo y | sdkmanager "platform-tools" "platforms;android-28" "build-tools;28.0.3"
fi

# always update tools
echo "updating SDK tools..."
sdkmanager --install tools

# check ndk
if [ -d "$ANDROID_NDK_HOME" ]; then
    echo "Android NDK already exists"
else
	echo "downloading NDK..."
	echo y | sdkmanager --install "ndk;$NDK_VERSION"
fi

#check cmake
if [ -d "$ANDROID_CMAKE_HOME" ]; then
    echo "Android CMAKE already exists"
else
	echo "downloading cmake..."
	echo y | sdkmanager --install "cmake;$CMAKE_VERSION"
fi

/sbin/tini -- /usr/local/bin/jenkins.sh
