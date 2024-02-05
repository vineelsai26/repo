CPU_ARCH=$(dpkg --print-architecture)

dpkg-scanpackages --arch ${CPU_ARCH} pool/ >dists/stable/main/binary-${CPU_ARCH}/Packages
cat dists/stable/main/binary-${CPU_ARCH}/Packages | gzip -9 >dists/stable/main/binary-${CPU_ARCH}/Packages.gz
