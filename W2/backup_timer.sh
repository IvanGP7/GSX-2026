#!/bin/bash

set -euo pipefail

# 1. Definir rutas (Asegúrate de que /path/to/your/backup_script.sh existe)
POS_ACT=$(pwd)
cd ../W1
SCRIPT_PATH="$(pwd)/backup.sh"
cd $POS_ACT
SERVICE_FILE="/etc/systemd/system/backup-semana1.service"
TIMER_FILE="/etc/systemd/system/backup-semana1.timer"

# 2. Revisar si el script existe y sinó salimos (Idempotencia)
if [ ! -f "$SCRIPT_PATH" ]; then
    echo "[!] No Existe el archivo '$SCRIPT_PATH'"
    exit 1
fi

# 3. Crear el archivo del SERVICIO (.service)
echo -e "\nConfigurando systemd service..."
sudo bash -c "cat << EOF > $SERVICE_FILE
[Unit]
Description=Servicio de Backup Semana 1
After=network.target

[Service]
Type=oneshot
ExecStart=$SCRIPT_PATH
User=root

[Install]
WantedBy=multi-user.target
EOF"

# 4. Crear el archivo del TEMPORIZADOR (.timer)
# Configurado para ejecutarse diariamente
echo -e "\nConfigurando systemd timer..."
sudo bash -c "cat << EOF > $TIMER_FILE
[Unit]
Description=Ejecuta el backup de la Semana 1 diariamente

[Timer]
OnCalendar=*-*-* 02:00:00
Persistent=true
Unit=backup-semana1.service

[Install]
WantedBy=timers.target
EOF"

# 5. Cargar y activar
echo -e "\nActivando temporizador..."
sudo systemctl daemon-reload
sudo systemctl enable --now backup-semana1.timer

# 6. Verificación
echo -e "\n------------------------------------------------"
echo "Estado del Timer:"
systemctl status backup-semana1.timer | grep "Active"
echo "Próxima ejecución:"
systemctl list-timers --all | grep "backup-semana1"
echo "------------------------------------------------"
