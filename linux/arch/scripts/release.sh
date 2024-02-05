#!/bin/bash

CPU_ARCH=$(uname -m)

cd ${CPU_ARCH}
rm -rf *.db.*
rm -rf *.db
rm -rf *.files.*
rm -rf *.files

if [[ "$CPU_ARCH" = "x86_64" ]]; then
    repo-add --sign --new --remove vineelsai-arch-repo.db.tar.gz *.pkg.tar.zst
elif [[ "$CPU_ARCH" = "aarch64" ]]; then
    repo-add --sign --new --remove vineelsai-arch-repo.db.tar.gz *.pkg.tar.xz
fi
