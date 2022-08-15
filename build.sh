#!/bin/bash


function compile() 
{

git clone --depth=1 https://github.com/weixy56/kernel_realme_RM6785.git
cd android_kernel_realme_RM6785


source ~/.bashrc && source ~/.profile
export LC_ALL=C && export USE_CCACHE=1 ccache -M 100G
export ARCH=arm64
export KBUILD_BUILD_HOST=Anupam_Roy
export KBUILD_BUILD_USER="Gorilla669"
git clone --depth=1 https://github.com/vijaymalav564/vortex-clang.git clang

[ -d "out" ] && rm -rf AnyKernel && rm -rf out || mkdir -p out
make clean && make mrproper
make 0=out ARCH=arm64 RM6785_defconfig

PATH="${PWD}/clang/bin:${PATH}:${PWD}/clang/bin:${PATH}:${PWD}/clang/bin:${PATH}" \
make -j$(nproc --all) 0=out \
                      ARCH=arm64 \
                      CC="clang" \
                      LD=ld.lld \
		      AR=llvm-ar \
		      NM=llvm-nm \
		      OBJCOPY=llvm-objcopy \
		      OBJDUMP=llvm-objdump \
                      CLANG_TRIPLE=aarch64-linux-gnu- \
                      CROSS_COMPILE="${PWD}/clang/bin/aarch64-linux-gnu-" \
                      CROSS_COMPILE_ARM32="${PWD}/clang/bin/arm-linux-gnueabi-" \
                      CONFIG_NO_ERROR_ON_MISMATCH=y
}

function zupload()
{
git clone --depth=1 https://github.com/Johny8988/AnyKernel3.git AnyKernel
cp out/arch/arm64/boot/Image.gz-dtb AnyKernel
cd AnyKernel
date=$(date "+%Y-%m-%d")
zip -r9 ThunderStorm-lto-KERNEL-RM6785-$date.zip *
curl -sL https://git.io/file-transfer | sh
./transfer wet ThunderStorm-lto-KERNEL-RM6785-$date.zip
}

compile
zupload
