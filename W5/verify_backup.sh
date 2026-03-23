#!/bin/bash
# Script de Verificación de Integridad GreenDevCorp

ORIGEN="/home/greendevcorp"
BACKUP="/mnt/data_storage/backups_greendevcorp/latest"
LOG="/admin/logs/integrity_check.log"

echo "[$(date)] Iniciando test de integridad..." >> $LOG

# Comparamos el número de archivos
count_orig=$(sudo find $ORIGEN -type f | wc -l)
count_back=$(sudo find $BACKUP/ -type f | wc -l)

if [ "$count_orig" -eq "$count_back" ]; then
    echo "[OK] Cantidad de archivos coincide ($count_orig)." >> $LOG
else
    echo "[WARN] Discrepancia en cantidad: Origen $count_orig vs Backup $count_back" >> $LOG
fi

# Verificación aleatoria de Checksum (MD5) de un archivo crítico
archivo_test="shared/documento_importante.txt" # Cambia por uno que exista
if [ -f "$ORIGEN/$archivo_test" ]; then
    hash_orig=$(md5sum "$ORIGEN/$archivo_test" | awk '{print $1}')
    hash_back=$(md5sum "$BACKUP/$archivo_test" | awk '{print $1}')

    if [ "$hash_orig" == "$hash_back" ]; then
        echo "[OK] Integridad de datos verificada para $archivo_test" >> $LOG
    else
        echo "[ERROR] CORRUPCIÓN DETECTADA en $archivo_test" >> $LOG
    fi
fi

cat /admin/logs/integrity_check.log | tail -n 10
