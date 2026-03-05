#!/bin/bash
set -euo pipefail

ENV_FILE="/etc/profile.d/greendevcorp.sh"

echo "[+] Configurando entorno compartido en $ENV_FILE..."

sudo bash -c "cat > $ENV_FILE" <<'EOF'
# Configuración compartida para el equipo GreenDevCorp

# 1. Añadir el directorio bin del equipo al PATH
if [ -d "/home/greendevcorp/bin" ]; then
    export PATH="$PATH:/home/greendevcorp/bin"
fi

# 2. Alias comunes para productividad
alias ll='ls -la'
alias logs='cat /home/greendevcorp/done.log'
alias gs='git status'

# 3. Mensaje de bienvenida (opcional pero profesional)
if [ "$PS1" ]; then
    echo -e "\nBienvenido al entorno de GreenDevCorp, $USER."
    echo "Revisar tareas con: logs"
    echo "Revisar ficheros con: ll"
    echo -e "Revisar git status con: gs\n"
fi
EOF

# Dar permisos de lectura a todos
sudo chmod 644 $ENV_FILE

echo "[v] Entorno configurado correctamente."
