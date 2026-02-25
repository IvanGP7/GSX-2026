#!/bin/bash

set -euo pipefile

# 1. Comprobar si Nginx ya está instalado
if ! command -v nginx &> /dev/null; then
    echo -e "\nNginx no encontrado. Instalando..."
    sudo apt update
    sudo apt install -y nginx
else
    echo -e "\nNginx ya está instalado."
fi

# 2. Configurar el reinicio automático tras errores (Restart on Failure)
# Creamos un 'override' para systemd para que Nginx se reinicie si crashea
OVERRIDE_DIR="/etc/systemd/system/nginx.service.d"
OVERRIDE_FILE="$OVERRIDE_DIR/restart.conf"

if [ ! -f "$OVERRIDE_FILE" ]; then
    echo -e "\nConfigurando el reinicio automático del servicio..."
    sudo mkdir -p "$OVERRIDE_DIR"
    echo -e "[Service]\nRestart=on-failure\nRestartSec=5s" | sudo tee "$OVERRIDE_FILE" > /dev/null
    # Aplicar los cambios en el demonio de systemd
    sudo systemctl daemon-reload
else
    echo -e "\nEl reinicio automático ya está configurado."
fi

# 3. Asegurar que el servicio esté Habilitado (boot)
echo -e "\nVerificando el estado del servicio..."
sudo systemctl enable nginx     # Que arranque al encender el PC
sudo systemctl start nginx      # Que esté corriendo justo ahora

# 4. Verificación final
STATUS=$(systemctl is-active nginx)
echo -e "\n----------------------------------------"
echo "Estado final de Nginx: $STATUS"
echo "----------------------------------------"
