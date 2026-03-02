#!/bin/bash
# Backup de datos sensibles con mantenimiento de atributos

ORIGEN="/admin/scripts"
DESTINO="/admin/backups"
FECHA=$(date +%Y%m%d_%H%M)
NOMBRE="admin_tools_$FECHA.tar.gz"
PASS_FILE="/admin/config/.gpg_pass"

# Aturar script si hi ha errors
set -euo pipefail

# Asegurar que el destino existe
mkdir -p $DESTINO

echo "Iniciando empaquetado de seguridad..."

# 'p' preserva atributos, 'z' comprime con gzip
sudo tar -cpzf "$DESTINO/$NOMBRE" "$ORIGEN"

# Leer la contraseña del archivo protegido
if [ ! -f "$PASS_FILE" ]; then
    echo "Error: No se encuentra el archivo de contraseña en $PASS_FILE"
    exit 1
fi

PASSPHRASE=$(sudo cat "$PASS_FILE")

# Encriptación con GPG leyendo la variable en modo desatendido
if sudo gpg --batch --yes --passphrase "$PASSPHRASE" -c "$DESTINO/$NOMBRE"; then
    sudo rm "$DESTINO/$NOMBRE"
    echo "Backup completado y cifrado: $DESTINO/$NOMBRE.gpg"
else
    echo "Error en el cifrado."
    exit 1
fi
