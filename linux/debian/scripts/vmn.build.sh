CPU_ARCH=$(dpkg --print-architecture)

cd build
if [ -d "VMN" ]; then
    cd VMN
    git pull
else
    git clone https://github.com/vineelsai26/VMN
    cd VMN
fi

VERSION="$(git describe --tags --abbrev=0 | cut -c2-)"

CONTROL="Package: vmn
Version: ${VERSION}
Architecture: ${CPU_ARCH}
Maintainer: Vineel Sai <mail@vineelsai.com>
Description: A Program to manage Node.js versions
"

go build -buildvcs=false

mkdir -p vmn_${VERSION}_${CPU_ARCH}/usr/local/bin && mkdir -p vmn_${VERSION}_${CPU_ARCH}/DEBIAN
cp vmn vmn_${VERSION}_${CPU_ARCH}/usr/local/bin
printf "$CONTROL" >vmn_${VERSION}_${CPU_ARCH}/DEBIAN/control
chmod -R 0775 vmn_${VERSION}_${CPU_ARCH}
dpkg-deb --build --root-owner-group vmn_${VERSION}_${CPU_ARCH}
cp vmn_${VERSION}_${CPU_ARCH}.deb ../../pool/main
