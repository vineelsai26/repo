#!/bin/bash

CPU_ARCH=$(uname -m)

cd packages

# build Checkout
cd Checkout
rm -rf pkg src checkout
makepkg --clean --force --sign
cp *.pkg.tar.* ../../${CPU_ARCH}/
cp *.pkg.tar.*.sig ../../${CPU_ARCH}/
cd ..

# build RCE
cd RCE
rm -rf pkg src rce
makepkg --clean --force --sign
cp *.pkg.tar.* ../../${CPU_ARCH}/
cp *.pkg.tar.*.sig ../../${CPU_ARCH}/
cd ..

# build VMN
cd VMN
rm -rf pkg src vmn
makepkg --clean --force --sign
cp *.pkg.tar.* ../../${CPU_ARCH}/
cp *.pkg.tar.*.sig ../../${CPU_ARCH}/
cd ..

# build yay
mkdir -p yay
cd yay
rm -rf pkg src yay
curl -Lsm 10 -o PKGBUILD "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=yay-bin" || exit 1
sed -i PKGBUILD \
    -e 's|^pkgname=yay-bin$|pkgname=yay|' \
    -e '/^conflicts=/a \conflicts+=(yay-git yay-bin)' \
    -e '/^package() {$/a \  rm -f ../${pkgname}_${pkgver}_$CARCH.tar.gz'
makepkg --clean --force --sign
cp *.pkg.tar.* ../../${CPU_ARCH}/
cp *.pkg.tar.*.sig ../../${CPU_ARCH}/
cd ..
rm -rf yay
