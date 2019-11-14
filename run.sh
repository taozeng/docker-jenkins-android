#!/bin/bash

echo "====== Starting ======"

echo "Preparing file system, it may take a while..."

mkdir -p $ANDROID_HOME
chown -R jenkins:jenkins $JENKINS_HOME
chown -R jenkins:jenkins $ANDROID_HOME

# generate keystore from cert & key certificate
if [ ! -z "$SSL_CERT" ] && [ ! -z "$SSL_KEY" ] && [ ! -z "$SSL_DEST" ] && [ ! -z "$SSL_NEW_PASS" ]; then
	/usr/local/cert.sh $SSL_CERT $SSL_KEY $SSL_DEST $SSL_NEW_PASS
fi

echo "Install/Upgrade Android environment..."
chroot --userspec=jenkins / \
/usr/local/install.sh $ANDROID_NDK_VERSION $ANDROID_CMAKE_VERSION
