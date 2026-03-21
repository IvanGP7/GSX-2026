#!/bin/bash
set -euo pipefail

# Definir el dispositivo (ajustar según lsblk, suele ser /dev/sdb)
DISK="/dev/sdb"
MOUNT_POINT="/mnt/data_storage"
UUID_FILE="/etc/fstab"

echo "[+] Configurando nuevo disco en $DISK..."

# 1. Crear tabla de particiones y partición única (idempotente)
if ! sudo fdisk -l $DISK | grep -q "${DISK}1"; then
    # el formato ",," indica: usa todo el espacio disponible
    echo ",," | sudo sfdisk --force $DISK

    # Informar al kernel del cambio de particiones
    sudo partprobe $DISK
    sleep 2

    sudo mkfs.ext4 -F "${DISK}1"
fi

# 2. Crear punto de montaje
sudo mkdir -p $MOUNT_POINT

# 3. Montaje persistente en /etc/fstab
PART_UUID=$(sudo blkid -s UUID -o value "${DISK}1")

if ! grep -q "$PART_UUID" $UUID_FILE; then
    echo "UUID=$PART_UUID  $MOUNT_POINT  ext4  defaults  0  2" | sudo tee -a $UUID_FILE
    sudo mount -a
    echo "[v] Disco montado permanentemente en $MOUNT_POINT"
else
    echo "[i] El disco ya está configurado en /etc/fstab"
fi

echo -e "\n[i] Discos del sistema:"
lsblk
