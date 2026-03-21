#!/bin/bash
# Ubicación: ~/GSX-2026/W5/setup_backup_service.sh

ADMIN_DIR="/admin/config"
SCRIPT_PATH="$ADMIN_DIR/backup_manager.sh"

echo "[+] Creando directorio de configuración si no existe..."
sudo mkdir -p "$ADMIN_DIR"

echo "[+] Copiando script de backup a $ADMIN_DIR..."
# (Suponiendo que tienes el script de arriba como un archivo local)
sudo cp backup_manager.sh "$SCRIPT_PATH"
sudo chmod +x "$SCRIPT_PATH"
sudo chown root:root "$SCRIPT_PATH"

echo "[+] Creando unidad de servicio de Systemd..."
sudo bash -c "cat > /etc/systemd/system/greendev-backup.service" <<EOF
[Unit]
Description=Servicio de Backup Automatizado GreenDevCorp
After=mnt-data_storage.mount

[Service]
Type=oneshot
ExecStart=$SCRIPT_PATH
User=root

[Install]
WantedBy=multi-user.target
EOF

echo "[+] Creando temporizador (Timer) diario..."
sudo bash -c "cat > /etc/systemd/system/greendev-backup.timer" <<EOF
[Unit]
Description=Ejecutar backup diariamente a las 02:00 AM

[Timer]
OnCalendar=*-*-* 02:00:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

echo "[+] Activando automatización..."
sudo systemctl daemon-reload
sudo systemctl enable --now greendev-backup.timer

echo "[v] Sistema de backup automatizado y centralizado en $ADMIN_DIR"
