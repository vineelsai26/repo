VERSION="0.0.1"
CPU_ARCH=$(dpkg --print-architecture)

CONTROL="Package: checkout
Version: ${VERSION}
Architecture: ${CPU_ARCH}
Maintainer: Vineel Sai <mail@vineelsai.com>
Description: A Program to checkout to Projects in different directories to your workspace
"

cd build
if [ -d "Checkout" ]; then
    cd Checkout
    git pull
else
    git clone https://github.com/vineelsai26/Checkout
    cd Checkout
fi

go build -buildvcs=false

mkdir -p checkout_${VERSION}_${CPU_ARCH}/usr/local/bin && mkdir -p checkout_${VERSION}_${CPU_ARCH}/DEBIAN
cp checkout checkout_${VERSION}_${CPU_ARCH}/usr/local/bin
printf "$CONTROL" >checkout_${VERSION}_${CPU_ARCH}/DEBIAN/control
chmod -R 0775 checkout_${VERSION}_${CPU_ARCH}
dpkg-deb --build --root-owner-group checkout_${VERSION}_${CPU_ARCH}
cp checkout_${VERSION}_${CPU_ARCH}.deb ../../pool/main
