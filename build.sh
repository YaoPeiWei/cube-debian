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
        --binary-filesystem ext4 \
        --binary-image iso-hybrid \
        --chroot-filesystem squashfs \
        --security false \
        --mode debian \
        --architectures amd64 \
        --debug \
        --color \
        --clean \
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

function qemu_run () {
    qemu-system-x86_64 -m 4096 -cdrom live-image-amd64.hybrid.iso -smp 4
}

case $1 in
    config)
        lb_config_init
        ;;
    build)
        lb_build
        ;;
    clean)
        if [ -n "$2" ]; then
            shift
            lb_clean "${@}"
        else
            lb_clean
        fi
        ;;
    run)
        qemu_run
        ;;
    *)
        echo "Usage: $0 {config|build|clean}"
        ;;
esac    