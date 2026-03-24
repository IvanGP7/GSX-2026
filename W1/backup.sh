#!/bin/bash
# Backup de datos sensibles con mantenimiento de atributos y cifrado GPG (Interactivo)

ORIGEN="/admin/scripts"
DESTINO="/admin/backups"
FECHA=$(date +%Y%m%d_%H%M)
NOMBRE="admin_tools_$FECHA.tar.gz"

# Aturar script si hi ha errors
set -euo pipefail

# Asegurar que el destino existe
sudo mkdir -p "$DESTINO"

echo "Iniciando empaquetado de seguridad..."

# 'p' preserva atributos, 'z' comprime con gzip
sudo tar -cpzf "$DESTINO/$NOMBRE" "$ORIGEN"

# Pedir la contraseña directamente al usuario
echo -n "Introduce la contraseña para cifrar el backup con GPG: "
read -s PASSPHRASE
echo ""

# Encriptación con GPG usando la variable que acabas de teclear
if sudo gpg --batch --yes --passphrase "$PASSPHRASE" -c "$DESTINO/$NOMBRE"; then
    sudo rm "$DESTINO/$NOMBRE"
    echo "Backup completado y cifrado: $DESTINO/$NOMBRE.gpg"
else
    echo "Error en el cifrado."
    exit 1
fi
