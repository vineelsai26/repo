#!/bin/bash

REPO_URL="https://github.com/eza-community/eza"
NAME="eza"
DESTDIR=usr/bin
DOCDIR=usr/share/man
CPU_ARCH=$(dpkg --print-architecture)

cd build
if [ -d "eza" ]; then
    cd eza
    git pull
else
    git clone $REPO_URL
    cd eza
fi

echo "build man pages"
just man

echo "building ${CPU_ARCH} package:"
VERSION="$(git describe --tags --abbrev=0 | cut -c2-)"
DEB_PACKAGE_DIR="${NAME}_${VERSION}_${CPU_ARCH}"

if [ "$CPU_ARCH" = "amd64" ]; then
    TARGET="x86_64-unknown-linux-gnu"
elif [ "$CPU_ARCH" = "arm64" ]; then
    TARGET="aarch64-unknown-linux-gnu"
else
    echo "unsupported architecture: ${CPU_ARCH}"
    exit 1
fi

echo " -> downloading ${CPU_ARCH} archive"
wget -q -O "${CPU_ARCH}.tar.gz" "${REPO_URL}/releases/latest/download/eza_${TARGET}.tar.gz"

echo " -> creating directory structure"
mkdir -p "${DEB_PACKAGE_DIR}"
mkdir -p "${DEB_PACKAGE_DIR}/${DESTDIR}"
mkdir -p "${DEB_PACKAGE_DIR}/${DOCDIR}"
mkdir -p "${DEB_PACKAGE_DIR}/${DOCDIR}/man1"
mkdir -p "${DEB_PACKAGE_DIR}/${DOCDIR}/man5"
mkdir -p "${DEB_PACKAGE_DIR}/DEBIAN"
mkdir -p "${DEB_PACKAGE_DIR}/usr/share/doc/${NAME}"
mkdir -p "${DEB_PACKAGE_DIR}/usr/share/bash-completion/completions/"
mkdir -p "${DEB_PACKAGE_DIR}/usr/share/fish/vendor_completions.d/"
mkdir -p "${DEB_PACKAGE_DIR}/usr/share/zsh/vendor-completions/"
chmod 755 -R "${DEB_PACKAGE_DIR}"

echo " -> extract executable"
tar -xzf "${CPU_ARCH}.tar.gz"
cp ${NAME} "${DEB_PACKAGE_DIR}/${DESTDIR}"
chmod 755 "${DEB_PACKAGE_DIR}/${DESTDIR}/${NAME}"

echo " -> compress man pages"
gzip -cn9 target/man/eza.1 >"${DEB_PACKAGE_DIR}/${DOCDIR}/man1/eza.1.gz"
gzip -cn9 target/man/eza_colors.5 >"${DEB_PACKAGE_DIR}/${DOCDIR}/man5/eza_colors.5.gz"
gzip -cn9 target/man/eza_colors-explanation.5 >"${DEB_PACKAGE_DIR}/${DOCDIR}/man5/eza_colors-explanation.5.gz"
chmod 644 "${DEB_PACKAGE_DIR}/${DOCDIR}"/**/*.gz

echo " -> copy completions"
cp completions/bash/eza "${DEB_PACKAGE_DIR}/usr/share/bash-completion/completions/"
cp completions/fish/eza.fish "${DEB_PACKAGE_DIR}/usr/share/fish/vendor_completions.d/"
cp completions/zsh/_eza "${DEB_PACKAGE_DIR}/usr/share/zsh/vendor-completions/"

echo " -> create control file"
touch "${DEB_PACKAGE_DIR}/DEBIAN/control"
cat >"${DEB_PACKAGE_DIR}/DEBIAN/control" <<EOM
Package: ${NAME}
Version: ${VERSION}
Section: utils
Priority: optional
Architecture: ${CPU_ARCH}
Depends: libc6
Maintainer: Vineel Sai <mail@vineelsai.com>
Description: eza is a modern replacement for ls.
EOM
chmod 644 "${DEB_PACKAGE_DIR}/DEBIAN/control"

echo " -> build ${CPU_ARCH} package"
dpkg-deb --build --root-owner-group "${DEB_PACKAGE_DIR}"
cp "${DEB_PACKAGE_DIR}.deb" ../../pool/main
