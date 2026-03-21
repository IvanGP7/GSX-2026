#!/bin/bash

SOURCE="/home/greendevcorp"
DEST="/mnt/data_storage/backups_greendevcorp"
LATEST="$DEST/latest"
LOG_FILE="/admin/logs/greendev_backup.log"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

mkdir -p "$DEST"
echo "--- Inicio de Backup: $TIMESTAMP ---" >> "$LOG_FILE"

# LÓGICA DE CONTROL PARA EL PRIMER BACKUP
OPCIONES="-av --delete"
if [ -d "$LATEST" ]; then
    # Si existe el último backup, lo usamos para crear hard links y ahorrar espacio
    OPCIONES="$OPCIONES --link-dest=$LATEST"
fi

# Ejecutar rsync hacia la nueva carpeta del día
if rsync $OPCIONES "$SOURCE/" "$DEST/backup_$TIMESTAMP/" >> "$LOG_FILE" 2>&1; then
    # Actualizar el enlace 'latest' para que apunte al backup que acabamos de hacer
    rm -f "$LATEST"
    ln -s "backup_$TIMESTAMP" "$LATEST"
    echo "[SUCCESS] Backup finalizado: backup_$TIMESTAMP" >> "$LOG_FILE"
else
    echo "[ERROR] Fallo en rsync. Revisa $LOG_FILE" >> "$LOG_FILE"
    exit 1
fi

# Retención (opcional): borrar backups de más de 7 días
find "$DEST" -maxdepth 1 -name "backup_*" -type d -mtime +7 -exec rm -rf {} +
