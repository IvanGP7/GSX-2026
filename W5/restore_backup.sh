#!/bin/bash
# Script de Recuperación de Emergencia - GreenDevCorp

BACKUP_DIR="/mnt/data_storage/backups_greendevcorp/latest"
RESTORE_DEST="/home/greendevcorp"
PRE_RESTORE_BAK="/mnt/data_storage/pre_restore_old_data_$(date +%Y%m%d_%H%M%S)"
LOG="/admin/logs/restore_operations.log"

echo "[$(date)] --- INICIANDO PROCEDIMIENTO DE RESTAURACIÓN ---" | tee -a $LOG

# 1. Verificación de Seguridad: ¿Existe el backup?
if [ ! -d "$BACKUP_DIR/" ]; then
    echo "[CRÍTICO] No hay ningún backup en $BACKUP_DIR para restaurar." | tee -a $LOG
    exit 1
fi

# 2. Salvaguarda: Mover datos actuales a una carpeta temporal por si acaso
echo "[1/3] Creando copia de seguridad de los datos actuales en $PRE_RESTORE_BAK..." | tee -a $LOG
sudo mkdir -p "$PRE_RESTORE_BAK"
sudo mv "$RESTORE_DEST/"* "$PRE_RESTORE_BAK/" 2>/dev/null

# 3. Restauración: Copiar desde el backup al destino
echo "[2/3] Restaurando archivos desde el punto de control 'latest'..." | tee -a $LOG
if sudo rsync -av "$BACKUP_DIR/" "$RESTORE_DEST/"; then
    echo "[3/3] [ÉXITO] Restauración completada." | tee -a $LOG
else
    echo "[ERROR] Fallo durante la sincronización de restauración." | tee -a $LOG
    exit 1
fi

# 4. Ajuste de permisos (Garantizar que los desarrolladores puedan trabajar)
sudo chown -R root:greendevcorp "$RESTORE_DEST"
chmod -R 775 "$RESTORE_DEST"

echo "[$(date)] --- Fin del Procedimiento ---" | tee -a $LOG