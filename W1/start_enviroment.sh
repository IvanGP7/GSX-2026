#!/bin/bash

# Aturar si hi ha errors
set -euo pipefail

# 0. Comprobar si se ejecuta como root
if [ "$EUID" -ne 0 ]; then 
  echo "Por favor, ejecuta el script con 'su -' o como root"
  exit
fi

echo "--- Iniciando configuración de Debian 13 ---"

# 1 Pedir Usuario al cual darle sudo
read -p "Introduce el nombre de tu usuario para darle permisos sudo: " USUARIO


# 2. Instalación de paquetes esenciales
echo "[1/5] Instalando sudo y herramientas de consola..."
PAQUETES=(sudo kbd net-tools git openssh-server gnupg2 rsync)
apt update && apt install -y "${PAQUETES[@]}"

# 3. Configurar el teclado al español (permanente)
echo "[2/5] Configurando teclado en español..."
cat <<EOF > /etc/default/keyboard
XKBMODEL="pc105"
XKBLAYOUT="es"
XKBVARIANT=""
XKBOPTIONS=""
BACKSPACE="guess"
EOF

# 4. Desactivar el entorno gráfico (Modo Terminal)
echo "[3/5] Desactivando entorno gráfico (boot to CLI)..."
systemctl set-default multi-user.target

# 5. Configurar permisos de sudo para el usuario
# Nota: Detecta el usuario real que lanzó el script si usaste 'su'
/usr/sbin/usermod -aG sudo $USUARIO
echo "Usuario $USUARIO añadido al grupo sudo."

# 6. Limpieza y finalización
echo "[4/5] Aplicando cambios de teclado inmediatos..."
setupcon || loadkeys es

echo "--- [5/5] CONFIGURACIÓN COMPLETADA ---"
echo "El sistema se reiniciará en 5 segundos para aplicar todo."
sleep 5
/usr/sbin/reboot
