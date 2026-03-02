#!/bin/bash
# Backup de datos sensibles con mantenimiento de atributos

ORIGEN="/admin/scripts"
DESTINO="/admin/backups"
FECHA=$(date +%Y%m%d_%H%M)
NOMBRE="admin_tools_$FECHA.tar.gz"

# Aturar script si hi ha errors
set -euo pipefail

# Asegurar que el destino existe
mkdir -p $DESTINO

echo "Iniciando empaquetado de seguridad..."

# 'p' preserva atributos, 'z' comprime con gzip
sudo tar -cpzf "$DESTINO/$NOMBRE" "$ORIGEN"

# Encriptación con GPG
# Se añade .gpg al final y se elimina el archivo original por seguridad
if sudo gpg --batch --yes --passphrase "gsx2026%" -c "$DESTINO/$NOMBRE"; then
    sudo rm "$DESTINO/$NOMBRE"
    echo "Backup completado y cifrado: $DESTINO/$NOMBRE.gpg"
else
    echo "Error en el cifrado."
    exit 1
fi
