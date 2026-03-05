#!/bin/bash
set -e

LIMITS_FILE="/etc/security/limits.conf"
CONFIG_MARKER="# GSX-LIMITS-GREENDEVCORP"

echo "[+] Configurando límites para @greendevcorp..."

# Verificamos si ya existe nuestra marca en el archivo para ser idempotentes
if ! grep -q "$CONFIG_MARKER" "$LIMITS_FILE"; then
    sudo bash -c "cat >> $LIMITS_FILE" <<EOF

$CONFIG_MARKER
@greendevcorp    hard    nproc           50
@greendevcorp    hard    nofile          1024
@greendevcorp    hard    as              524288
@greendevcorp    soft    cpu             1
EOF
    echo "[v] Límites añadidos correctamente."
else
    echo "[i] Los límites ya están configurados en $LIMITS_FILE."
fi

# Asegurar que PAM cargue los límites (idempotencia en common-session)
if ! grep -q "pam_limits.so" /etc/pam.d/common-session; then
    echo "session required pam_limits.so" | sudo tee -a /etc/pam.d/common-session
fi

echo "--- Verificación de límites para dev1 ---"

# Ejecutamos ulimit dentro de una sesión de dev1
sudo su - dev1 -c "ulimit -a" | grep -E "processes|open files|virtual memory"

echo -e "\n[i] Si los valores coinciden (1024, 50, 524288), la configuración es válida."
