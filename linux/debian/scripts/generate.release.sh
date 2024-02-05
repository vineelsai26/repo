#!/bin/bash

set -e

do_hash() {
    path=$(pwd)
    parentdir="$(dirname "$path")"
    HASH_NAME=$1
    HASH_CMD=$2
    echo "${HASH_NAME}:"
    for f in $(find "./dists/stable" -type f); do
        f=$(echo $f | cut -c3-) # remove ./ prefix
        if [ "$f" = "Release" ]; then
            continue
        fi
        echo "  $(${HASH_CMD} ${f} | cut -d" " -f1) $(echo "$(wc -c $f)" | sed "s/dists\/stable\///g")"
    done
}

cat <<EOF
Origin: Vineel Sai Repository
Label: Vineel Sai
Suite: stable
Codename: stable
Version: 1.0
Architectures: amd64, arm64
Components: main
Description: A software repository by Vineel Sai
Date: $(date -Ru)
EOF
do_hash "MD5Sum" "md5sum"
do_hash "SHA1" "sha1sum"
do_hash "SHA256" "sha256sum"
do_hash "SHA512" "sha512sum"
