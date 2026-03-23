#!/bin/bash
# Script de Verificación Idempotente - GreenDevCorp

ORIGEN="/home/greendevcorp"
BACKUP="/mnt/data_storage/backups_greendevcorp/latest"
LOG="/admin/logs/integrity_check.log"
BACKUP_SCRIPT="/admin/config/backup_manager.sh"

echo "[$(date)] --- Iniciando Auditoría ---" >> $LOG

# 1. AUTOCORRECCIÓN: Si no hay backup previo, lo ejecutamos primero
if [ ! -d "$BACKUP/" ]; then
    echo "[INFO] No se detectó backup previo. Ejecutando backup_manager..." >> $LOG
    if [ -f "$BACKUP_SCRIPT" ]; then
        sudo bash "$BACKUP_SCRIPT" >> $LOG 2>&1
    else
        echo "[ERROR] No se encuentra el script de backup en $BACKUP_SCRIPT" >> $LOG
        exit 1
    fi
fi

# 2. CONTEO DE ARCHIVOS (Con la barra '/' mágica para entrar en el link)
count_orig=$(sudo find "$ORIGEN/" -type f | wc -l)
count_back=$(sudo find "$BACKUP/" -type f | wc -l)

# 3. RESULTADO DE INTEGRIDAD
if [ "$count_orig" -eq "$count_back" ]; then
    echo "[OK] Integridad Garantizada: $count_orig archivos en ambos lados." >> $LOG
else
    echo "[WARN] Discrepancia detectada: Origen $count_orig vs Backup $count_back" >> $LOG
fi

echo "[$(date)] --- Fin de Auditoría ---" >> $LOG

tail -n 5 /admin/logs/integrity_check.log