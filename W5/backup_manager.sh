#!/bin/bash
SOURCE="/home/greendevcorp"
DEST="/mnt/data_storage/backups_greendevcorp"
LATEST="$DEST/latest"
LOG_FILE="/admin/logs/greendev_backup.log"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# 1. Verificar si hay cambios (Dry-run)
# -n: dry-run (no hace nada)
# i: itemize-changes (lista qué cambiaría)
CAMBIOS=$(rsync -n -ri --delete "$SOURCE/" "$LATEST/" | wc -l)

if [ "$CAMBIOS" -eq 0 ]; then
    echo "[$(date)] Sin cambios detectados. No se crea backup." >> "$LOG_FILE"
    exit 0
fi

# 2. Si llegamos aquí, es que SÍ hay cambios. Procedemos:
echo "[$(date)] Cambios detectados ($CAMBIOS ítems). Iniciando backup..." >> "$LOG_FILE"

mkdir -p "$DEST"
OPCIONES="-av --delete"
[ -d "$LATEST" ] && OPCIONES="$OPCIONES --link-dest=$LATEST"

if rsync $OPCIONES "$SOURCE/" "$DEST/backup_$TIMESTAMP/" >> "$LOG_FILE" 2>&1; then
    rm -f "$LATEST"
    ln -s "backup_$TIMESTAMP" "$LATEST"
    echo "[SUCCESS] Backup creado: backup_$TIMESTAMP" >> "$LOG_FILE"
else
    echo "[ERROR] Fallo en rsync" >> "$LOG_FILE"
    exit 1
fi
