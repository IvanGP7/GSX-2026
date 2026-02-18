#!/bin/bash
# Script de verificación y re-aplicación (Idempotencia)

# Aturar si hi ha errors
set -euo pipefail

ADMIN_DIR="/admin"
ESTADO_OK=true
PAQUETES=(sudo kbd net-tools git openssh-server tar gnupg2)

echo "--- Verificando Integridad del Sistema ---"

# 1. Verificar paquetes
for pkg in "${PAQUETES[@]}"; do
    if ! dpkg -l | grep -q "^ii  $pkg "; then
        echo "[!] Error: Falta el paquete $pkg"
        ESTADO_OK=false
    fi
done

# 2. Verificar estructura de directorios
for dir in scripts backups config logs; do
    if [ ! -d "$ADMIN_DIR/$dir" ]; then
        echo "[!] Error: Falta el directorio $ADMIN_DIR/$dir"
        ESTADO_OK=false
    fi
done

# 3. Acción correctiva
if [ "$ESTADO_OK" = false ]; then
    echo "Detectados errores."
else
    echo "[SUCCESS] Todo el sistema está configurado correctamente."
fi
