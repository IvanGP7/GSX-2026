#!/bin/bash

set -euo pipefail

# 1. Seguro de vida: Solo ejecutar como root
if [ "$EUID" -ne 0 ]; then 
  echo "Error: Este script debe ejecutarse como root para poder crear servicios y reiniciar."
  echo "Ejecuta 'su -' y vuelve a lanzarlo."
  exit 1
fi

# Variables de control
STATE_FILE="/var/setup_phase.txt"
# Obtenemos la ruta absoluta de este script
SCRIPT_PATH=$(realpath "$0")
BASE_DIR=$(dirname "$SCRIPT_PATH")

# FASE 1: PRIMERA EJECUCIÓN (Pre-Reboot)
if [ ! -f "$STATE_FILE" ]; then
    echo "--- INICIANDO INSTALACIÓN (Fase 1: Pre-Reboot) ---"

    # Pedir contraseña para los backups (Seguridad)
    echo "Configuración de seguridad:"
    mkdir -p /admin/config
    read -s -p "Introduce la contraseña para cifrar los backups (GPG): " GPG_PASS
    echo ""
    echo "$GPG_PASS" > /admin/config/.gpg_pass
    chmod 600 /admin/config/.gpg_pass
    echo "Contraseña guardada de forma segura en /admin/config/.gpg_pass"

    # 1. Crear el archivo de estado
    echo "fase2_pendiente" > "$STATE_FILE"

    # 2. Crear un servicio systemd temporal que ejecute este mismo script al arrancar
    echo "Creando servicio de reanudación automática (resume-setup.service)..."
    cat <<EOF > /etc/systemd/system/resume-setup.service
[Unit]
Description=Reanudar Setup GSX post-reboot
After=network-online.target

[Service]
Type=oneshot
ExecStart=$SCRIPT_PATH
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

    # 3. Activar el servicio temporal
    systemctl daemon-reload
    systemctl enable resume-setup.service

    # 4. Ejecutar el script que reinicia la máquina
    echo "Ejecutando start_enviroment.sh (El sistema se reiniciará pronto)..."
    cd "$BASE_DIR/W1"
    bash start_enviroment.sh

# FASE 2: SEGUNDA EJECUCIÓN
else
    echo "--- REANUDANDO INSTALACIÓN (Fase 2: Post-Reboot) ---"

    # 1. Limpieza: Eliminar el servicio temporal y el archivo de estado para evitar bucles en futuros reinicios
    echo "Limpiando servicio de reanudación..."
    systemctl disable resume-setup.service || true
    rm -f /etc/systemd/system/resume-setup.service
    systemctl daemon-reload
    rm -f "$STATE_FILE"

    # 2. Ejecutar el resto de la Semana 1
    echo "--- Ejecutando resto de la W1 ---"
    cd "$BASE_DIR/W1"
    bash setup_admin.sh
    bash verify_setup.sh

    # 3. Ejecutar la Semana 2
    echo "--- Ejecutando W2 ---"
    cd "$BASE_DIR/W2"
    bash nginx.sh

    # 4. Ejecutar la Semana 4
    echo "--- Ejecutando W4 ---"
    cd "$BASE_DIR/W4"
    bash setup_env.sh
    bash setup_users.sh
    bash setup_group.sh
    bash limit_group.sh

    # 5. Ejecutar la Semana 5
    echo "--- Ejecutando W5 ---"
    cd "$BASE_DIR/W5"
    bash setup_storage.sh
    bash setup_backup_service.sh
    bash verify_backup.sh

    # -----------------------------------------------------
    # Configuración Final Cruzada (Dependencias)
    # -----------------------------------------------------
    echo "--- Ejecutando Configuraciones Finales cruzadas ---"
    # Volvemos a W2 para configurar logs y timers ahora que TODO está listo
    cd "$BASE_DIR/W2"
    echo "Configurando Logrotate (depende de Nginx y backups avanzados)..."
    bash logrotate_config.sh
    echo "Activando Temporizador de Backup avanzado (depende de W5)..."
    bash backup_timer.sh

    echo "--- ¡INFRAESTRUCTURA DESPLEGADA COMPLETAMENTE! ---"
    # Como este proceso corre en segundo plano por systemd, dejamos un aviso visible
    wall "¡El setup automatizado GSX ha terminado con éxito! W1, W2, W4 y W5 desplegadas."
fi
