#!/bin/zsh

echo "SDR++ Packager for macOS"
echo

echo "Retrieving information about the current build..."
COMMIT=`git rev-parse --short HEAD`
DATE=`date +"%B %d, %Y"`
ARCH=`uname -m`


ORIG_DIR=$PWD
PACK_DIR=$ORIG_DIR/macos_packaging
BUILD_DIR=$PACK_DIR/build
BUND_DIR=$PACK_DIR/bundle

echo "Producing clean build environment..."
rm -rf $BUILD_DIR
mkdir $BUILD_DIR

echo "Building SDR++ root..."
ROOT_DIR=$BUILD_DIR/sdrpp
mkdir $ROOT_DIR

cd $1
make install DESTDIR=$ROOT_DIR
cd $BUILD_DIR

echo "Building App Skeleton..."
APP_DIR=$BUILD_DIR/SDR++.app
CONTENTS_DIR=$APP_DIR/Contents

mkdir $APP_DIR
mkdir $APP_DIR/Contents
mkdir $CONTENTS_DIR/MacOS
mkdir $CONTENTS_DIR/Plugins
mkdir $CONTENTS_DIR/Resources

echo "Copying bundle configuration..."
cp -a $BUND_DIR/.  $APP_DIR

echo "Copying executables..."
DATA_DIR=$ROOT_DIR/usr/local
cp -a $DATA_DIR/bin/. $CONTENTS_DIR/MacOS

echo "Copying dynamic libraries..."
cp -a $DATA_DIR/lib/sdrpp/plugins/. $CONTENTS_DIR/Plugins

echo "Copying resources..."
cp -a $DATA_DIR/share/sdrpp/. $CONTENTS_DIR/Resources