#!/bin/bash
set -euo pipefail

# 1. Crear la estructura base
sudo mkdir -p /home/greendevcorp/bin
sudo mkdir -p /home/greendevcorp/shared

# 2. Configurar /home/greendevcorp/bin
# Permisos: 750 rwxrwx---
sudo chown root:greendevcorp /home/greendevcorp/bin
sudo chmod 750 /home/greendevcorp/bin

# 3. Configurar /home/greendevcorp/shared (Colaboración con Setgid y Sticky Bit)
# Permisos: 3770 (rwxrws--T)
sudo chown root:greendevcorp /home/greendevcorp/shared
sudo chmod 3770 /home/greendevcorp/shared

# 4. Configurar /home/greendevcorp/done.log (Registro de tareas)
# Permisos: 644 (rw-r--r--)
if [ ! -f /home/greendevcorp/done.log ]; then
    sudo touch /home/greendevcorp/done.log
fi
sudo chown dev1:greendevcorp /home/greendevcorp/done.log
sudo chmod 644 /home/greendevcorp/done.log

echo "--- Estructura de directorios y permisos aplicada ---"
