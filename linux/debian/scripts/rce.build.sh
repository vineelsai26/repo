VERSION="0.0.1"
CPU_ARCH=$(dpkg --print-architecture)

CONTROL="Package: rce
Version: ${VERSION}
Architecture: ${CPU_ARCH}
Maintainer: Vineel Sai <mail@vineelsai.com>
Description: A Program to manage Node.js versions
"

cd build
if [ -d "RCE" ]; then
    cd RCE
    git pull
else
    git clone https://github.com/vineelsai26/RCE
    cd RCE
fi

go build -buildvcs=false

mkdir -p rce_${VERSION}_${CPU_ARCH}/usr/local/bin && mkdir -p rce_${VERSION}_${CPU_ARCH}/DEBIAN
cp rce rce_${VERSION}_${CPU_ARCH}/usr/local/bin
printf "$CONTROL" >rce_${VERSION}_${CPU_ARCH}/DEBIAN/control
chmod -R 0775 rce_${VERSION}_${CPU_ARCH}
dpkg-deb --build --root-owner-group rce_${VERSION}_${CPU_ARCH}
cp rce_${VERSION}_${CPU_ARCH}.deb ../../pool/main
