#!/bin/bash

set -e

function lb_config_init () {
    lb config --distribution bookworm \
        --archive-areas "main contrib" \
        --mirror-bootstrap "http://mirrors.ustc.edu.cn/debian" \
        --mirror-binary "http://mirrors.ustc.edu.cn/debian" \
        --mirror-binary-security "http://mirrors.ustc.edu.cn/debian" \
        --mirror-chroot "http://mirrors.ustc.edu.cn/debian" \
        --mirror-chroot-security "http://mirrors.ustc.edu.cn/debian" \
        --initramfs none \
        --binary-filesystem ext4 \
        --binary-image iso \
        --chroot-filesystem squashfs \
        --security false \
        --mode debian \
        --architectures amd64 \
        --debug \
        --apt aptitude  
}


function lb_build () {
    sudo lb build
}

function lb_clean () {
    if [ -n "$1" ]; then
        sudo lb clean "${@}"
    else
        sudo lb clean --all
    fi
}

case $1 in
    config)
        lb_config_init
        ;;
    build)
        lb_build
        ;;
    clean)
        lb_clean
        ;;
    *)
        echo "Usage: $0 {config|build|clean}"
        ;;
esac    