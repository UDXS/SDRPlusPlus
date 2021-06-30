#!/bin/sh

echo "SDR++ Packager for macOS"
echo

echo "Retrieving information about the current build..."
COMMIT=`git rev-parse --short HEAD`
DATE=`date +"%B %d, %Y"`
ARCH=`uname -m`


ORIG_DIR=$PWD
PACK_DIR=$ORIG_DIR/macos_packaging
BUILD_DIR=$PACK_DIR/build
BUND_DIR=$PACK_DIR/bundle_root

echo "Producing clean build environment..."
rm -rf $BUILD_DIR
mkdir $BUILD_DIR

echo "Building SDR++ root..."
ROOT_DIR=$BUILD_DIR/sdrpp
mkdir sdrpp

cd $1
make install DESTDIR=$ROOT_DIR
cd $BUILD_DIR

#echo "Copying Application Bundle into Root..."
#cp -a $BUND_DIR/* $BUILD_DIR/sdrpp/

echo "Requesting creation of initial Installer Package from productbuild..."

productbuild --root sdrpp / "sdrpp_raw.pkg"

echo "Asking pkgutil to expand Installer Package..."
pkgutil --expand sdrpp_raw.pkg sdrpp_exp
cd sdrpp_exp

echo "Removing unneeded configuration..."
rm Distribution

echo "Copying modified configuration..."
cp -a $PACK_DIR/pkg/. ./
#cp $PACK_DIR/pkg/Distribution Distribution

echo "Filling out architecture information for Installer Configuration..."
sed -i -E "s/SDRPP_MAC_ARCH/$ARCH/g" Distribution
rm "Distribution-E"

echo "Filling out architecture, commit & date information for Welcome Screen..."
cd Resources/en.lproj
sed -i -E "s/SDRPP_MAC_CMT/$COMMIT/g" welcome.html
sed -i -E "s/SDRPP_MAC_DATE/$DATE/g" welcome.html
sed -i -E "s/SDRPP_MAC_ARCH/$ARCH/g" welcome.html

echo "Asking pkgutil to repackage Installer..."
cd $BUILD_DIR
pkgutil --flatten sdrpp_exp sdrpp.pkg

echo "Assigning Proper Name..."
cp -a sdrpp.pkg "SDR++ for macOS on `uname -m`.pkg"

echo
echo "Installer creation complete. Find it at $BUILD_DIR/SDR++ for macOS on `uname -m`.pkg."