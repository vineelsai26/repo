CPU_ARCH=$(dpkg --print-architecture)

cd build
if [ -d "neovim" ]; then
    cd neovim
    git pull
    git checkout stable
else
    git clone https://github.com/neovim/neovim
    cd neovim
    git checkout stable
fi
git config --global --add safe.directory /home/build/repo/build/neovim

make CMAKE_BUILD_TYPE=Release

version="$(echo $(git tag --points-at HEAD) | sed 's/stable //' | sed 's/v//')"
cd build
cpack -G DEB
mv nvim-linux*.deb nvim_${version}_${CPU_ARCH}.deb
cp nvim_${version}_${CPU_ARCH}.deb ../../../pool/main
