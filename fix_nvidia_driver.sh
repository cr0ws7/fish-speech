#!/bin/bash

set -e

SRC_VERSION="570.172.08"
DST_VERSION="570.169"
LIB_DIR="/usr/lib/x86_64-linux-gnu"

echo "Searching for NVIDIA libraries with version $SRC_VERSION to symlink as $DST_VERSION..."

for src in "$LIB_DIR"/*nvidia*.so.$SRC_VERSION "$LIB_DIR"/libcuda.so.$SRC_VERSION "$LIB_DIR"/libnvoptix.so.$SRC_VERSION; do
    [ -e "$src" ] || continue
    base=$(basename "$src")
    dst="$LIB_DIR/${base/$SRC_VERSION/$DST_VERSION}"
    if [ ! -e "$dst" ]; then
        echo "Creating symlink: $dst -> $src"
        sudo ln -s "$src" "$dst"
    else
        echo "Already exists: $dst"
    fi
done

# Add symlink for vdpau lib if needed
VDPAU_DIR="$LIB_DIR/vdpau"
SRC_VDPAU="$VDPAU_DIR/libvdpau_nvidia.so.$SRC_VERSION"
DST_VDPAU="$VDPAU_DIR/libvdpau_nvidia.so.$DST_VERSION"

if [ -e "$SRC_VDPAU" ]; then
    if [ ! -e "$DST_VDPAU" ]; then
        echo "Creating VDPAU symlink: $DST_VDPAU -> $SRC_VDPAU"
        sudo ln -s "$SRC_VDPAU" "$DST_VDPAU"
    else
        echo "VDPAU symlink already exists: $DST_VDPAU"
    fi
else
    echo "Source VDPAU library not found: $SRC_VDPAU"
fi

# Add symlink for Xorg extension libglxserver_nvidia if needed
XORG_EXT_DIR="/usr/lib/xorg/modules/extensions"
SRC_GLX="$XORG_EXT_DIR/libglxserver_nvidia.so.$SRC_VERSION"
DST_GLX="$XORG_EXT_DIR/libglxserver_nvidia.so.$DST_VERSION"

if [ -e "$SRC_GLX" ]; then
    if [ ! -e "$DST_GLX" ]; then
        echo "Creating Xorg extension symlink: $DST_GLX -> $SRC_GLX"
        sudo ln -s "$SRC_GLX" "$DST_GLX"
    else
        echo "Xorg extension symlink already exists: $DST_GLX"
    fi
else
    echo "Source Xorg extension not found: $SRC_GLX"
fi

# Add symlinks for all firmware .bin files if needed
FIRMWARE_DIR="/lib/firmware/nvidia"
SRC_FW_DIR="$FIRMWARE_DIR/$SRC_VERSION"
DST_FW_DIR="$FIRMWARE_DIR/$DST_VERSION"

if [ -d "$SRC_FW_DIR" ]; then
    if [ ! -d "$DST_FW_DIR" ]; then
        echo "Creating firmware directory: $DST_FW_DIR"
        sudo mkdir -p "$DST_FW_DIR"
    fi
    for src_fw in "$SRC_FW_DIR"/*.bin; do
        [ -e "$src_fw" ] || continue
        fw_file=$(basename "$src_fw")
        dst_fw="$DST_FW_DIR/$fw_file"
        if [ ! -e "$dst_fw" ]; then
            echo "Creating firmware symlink: $dst_fw -> $src_fw"
            sudo ln -s "$src_fw" "$dst_fw"
        else
            echo "Firmware already exists: $dst_fw"
        fi
    done
else
    echo "Source firmware directory not found: $SRC_FW_DIR"
fi

echo "Done."