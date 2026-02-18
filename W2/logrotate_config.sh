#!/bin/bash

# 1. Definición de variables
LOG_DIR="/admin/logs"
BACKUP_DIR="/admin/logs/backups"
CONFIG_PATH="/admin/config/custom_logs.conf"
SYSTEM_LINK="/etc/systemd/system/logrotate.d/admin-logs" # Enlace en el sistema
USER_OWNER="gsx"
GROUP_OWNER="gsx"

echo "Iniciando configuración de gestión de logs..."

# 2. Crear estructura de carpetas
# Creamos la carpeta de logs y la de backups si no existen
if [ ! -d "$BACKUP_DIR" ]; then
    echo "Creando directorios en $LOG_DIR..."
    sudo mkdir -p "$BACKUP_DIR"
    sudo mkdir -p "/admin/config"
fi

# 3. Generar archivo de configuración
echo "Generando archivo de configuración en $CONFIG_PATH..."
sudo bash -c "cat << EOF > $CONFIG_PATH
$LOG_DIR/*.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    olddir $BACKUP_DIR
    create 0640 $USER_OWNER $GROUP_OWNER
}
EOF"

# 4. Vincular con el sistema logrotate
# Creamos un enlace simbólico en /etc/logrotate.d/ para que el sistema lo reconozca
if [ ! -L "/etc/logrotate.d/admin-logs" ]; then
    echo "Vinculando configuración con el sistema logrotate..."
    sudo cp "$CONFIG_PATH" "/etc/logrotate.d/admin-logs"
    sudo chown root:root /etc/logrotate.d/admin-logs
    sudo chmod 644 /etc/logrotate.d/admin-logs
else
    echo "El archivo ya existe."
fi

# 5. Verificación de seguridad
echo "--- Verificación de sintaxis ---"
# Ejecutamos logrotate en modo debug (-d) para validar que no haya errores
sudo logrotate -d "/etc/logrotate.d/admin-logs"

echo "--------------------------------------------------"
echo "Configuración completada con éxito."
echo "Los logs de $LOG_DIR se rotarán diariamente y se guardarán en $BACKUP_DIR."
echo "--------------------------------------------------"
