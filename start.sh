#!/usr/bin/env bash

set -e

# Check for KVM support
if [ -e /dev/kvm ]; then
    echo "[INFO] KVM acceleration available"
    KVM_ARG="-enable-kvm"
    CPU_ARG="host"
    MEMORY="4G"
    SMP_CORES=4
else
    echo "[WARNING] KVM not available - using slower emulation mode"
    KVM_ARG=""
    CPU_ARG="qemu64"
    MEMORY="2G"
    SMP_CORES=1
fi

# Check ISO available
if [ ! -f "/iso/os.iso" ]; then
    echo "[ERROR] ISO is not aivailable in /iso directory"
    exit 1
fi

# Create disk image if not exists
if [ ! -f "/data/disk.qcow2" ]; then
  echo "[INFO] Creating 100GB virtual disk..."
  qemu-img create -f qcow2 "/data/disk.qcow2" 100G
fi

# Windows-specific boot parameters
BOOT_ORDER="-boot order=c,menu=on"
if [ ! -s "/data/disk.qcow2" ] || [ $(stat -c%s "/data/disk.qcow2") -lt 1048576 ]; then
  echo "[INFO] First boot - installing Windows from ISO"
  BOOT_ORDER="-boot order=d,menu=on"
fi

echo "[INFO] Starting Windows 10 VM with ${SMP_CORES} CPU cores and ${MEMORY} RAM"

# Start QEMU with Windows-optimized settings
qemu-system-x86_64 \
  $KVM_ARG \
  -machine q35,accel=kvm:tcg \
  -cpu $CPU_ARG \
  -m $MEMORY \
  -smp $SMP_CORES \
  -vga std \
  -usb -device usb-tablet \
  $BOOT_ORDER \
  -drive file=/data/disk.qcow2,format=qcow2 \
  -drive file=/iso/os.iso,media=cdrom \
  -netdev user,id=net0,hostfwd=tcp::3389-:3389 \
  -device e1000,netdev=net0 \
  -display vnc=:0 \
  -name "Windows10_VM" &

# Start noVNC
sleep 5
websockify --web /novnc 6080 localhost:5900 &

echo "======================================================="
echo "> Connect via VNC: http://localhost:6080"
echo "> After install, use RDP: localhost:3389"
echo "> First boot may take 20-30 minutes for Windows install"
echo "======================================================="

tail -f /dev/null