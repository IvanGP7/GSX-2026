#!/bin/bash
# Script de instalación de herramientas y creación de estructura administrativa

ADMIN_DIR="/admin"
PAQUETES=(sudo kbd net-tools git openssh-server tar gnupg2 rsync)

echo "--- Iniciando Configuración de Entorno ---"

# Aturar script si hi ha errors
set -euo pipefail

# 1. Instalación inteligente de paquetes (Punto 5.1)
pendientes=()
for pkg in "${PAQUETES[@]}"; do
    if ! dpkg -l | grep -q "^ii  $pkg "; then
        pendientes+=("$pkg")
    fi
done

if [ ${#pendientes[@]} -gt 0 ]; then
    echo "Instalando paquetes faltantes: ${pendientes[*]}..."
    sudo apt update && sudo apt install -y "${pendientes[@]}"
else
    echo "[OK] Todos los paquetes ya están instalados."
fi

# 2. Configuración de estructura compartida (Punto 4 y 5.2)
echo "Configurando directorio compartido en $ADMIN_DIR..."
# Creamos la estructura. -p garantiza idempotencia (no error si ya existe)
sudo mkdir -p $ADMIN_DIR/{scripts,backups,config,logs}

# Ajuste de permisos para que el grupo 'sudo' pueda administrarlo
sudo chown -R root:gsx $ADMIN_DIR
sudo chmod -R 755 $ADMIN_DIR
echo "[OK] Estructura administrativa lista."
