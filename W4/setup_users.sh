#!/bin/bash
set -euo pipefail

# 1. Crear el grupo del equipo de desarrollo 'greendevcorp'
if ! getent group greendevcorp > /dev/null; then
    echo "[+] Creando grupo 'greendevcorp'..."
    sudo groupadd greendevcorp
else
    echo "[i] El grupo 'greendevcorp' ya existe."
fi

# 2. Crear los usuarios dev1 al dev4
for i in {1..4}; do
    username="dev$i"

    if ! id "$username" &>/dev/null; then
        echo "[+] Creando usuario '$username'..."
        # -m: crea home directory
        # -g: asignamos grupo principal
        # -s: asignamos la shell bash
        sudo useradd -m -g greendevcorp -s /bin/bash "$username"
	echo "$username:1234" | sudo chpasswd
    else
        echo "[i] El usuario '$username' ya existe."
    fi
done

echo "--- Estructura de usuarios completada ---"
