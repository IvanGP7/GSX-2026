#!/bin/bash
set -euo pipefail

ENV_FILE="/etc/profile.d/greendevcorp.sh"

echo "[+] Configurando entorno compartido en $ENV_FILE..."

sudo bash -c "cat > $ENV_FILE" <<'EOF'
# Solo aplicar si el usuario pertenece al grupo 'greendevcorp'
if id -nG "$USER" | grep -qw "greendevcorp"; then

    # 1. Añadir el directorio bin
    if [ -d "/home/greendevcorp/bin" ]; then
        export PATH="$PATH:/home/greendevcorp/bin"
    fi

    # 2. Alias comunes
    alias ll='ls -la'
    alias logs='cat /home/greendevcorp/done.log'
    alias gs='git status'

    # 3. Mensaje de bienvenida
    if [ "$PS1" ]; then
        echo -e "\nBienvenido al entorno de GreenDevCorp, $USER."
    fi
fi
EOF

# Dar permisos de lectura a todos
sudo chmod 644 $ENV_FILE

echo "[v] Entorno configurado correctamente."
