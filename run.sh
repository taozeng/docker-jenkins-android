#!/bin/bash

echo "====== Starting ======"

echo "Preparing file system, it may take a while..."

mkdir -p $SDK_PATH
mkdir -p $NDK_PATH

chown -R jenkins:jenkins /var/jenkins_home
chown -R jenkins:jenkins $SDK_PATH
chown -R jenkins:jenkins $NDK_PATH

if [ -z "$ANDROID_NDK" ]; then
	export ANDROID_NDK=android-ndk-r12b
fi
echo "ANDROID_NDK: $ANDROID_NDK"

if [ -z "$ANDROID_SDK" ]; then
	export ANDROID_SDK=r25.2.2
fi
echo "ANDROID_SDK: $ANDROID_SDK"

# generate keystore from cert & key certificate
if [ ! -z "$SSL_CERT" ] && [ ! -z "$SSL_KEY" ] && [ ! -z "$SSL_DEST" ] && [ ! -z "$SSL_NEW_PASS" ]; then
	/usr/local/cert.sh $SSL_CERT $SSL_KEY $SSL_DEST $SSL_NEW_PASS
fi

echo "Install/Upgrade Android environment..."
chroot --userspec=jenkins / /usr/local/install.sh $SDK_PATH $NDK_PATH $ANDROID_SDK $ANDROID_NDK
