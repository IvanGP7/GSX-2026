#!/bin/bash

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "TEST DE SEGURIDAD DE USUARIOS\n"

# --- 1. VERIFICACIÓN DE ACCESO A DIRECTORIOS ---
echo "[1] Probando Control de Acceso a Directorios..."

# dev1 NO debería entrar en el home de gsx
if sudo -u dev1 ls /home/gsx &>/dev/null; then
    echo -e "${RED}[FALLO] dev1 pudo acceder al home de gsx${NC}"
else
    echo -e "${GREEN}[OK] Privacidad de Home: dev1 no tiene acceso a /home/gsx${NC}"
fi

# El equipo DEBE poder entrar en /home/greendevcorp/bin
if sudo -u dev2 ls /home/greendevcorp/bin &>/dev/null; then
    echo -e "${GREEN}[OK] Acceso compartido: dev2 puede ver /home/greendevcorp/bin${NC}"
else
    echo -e "${RED}[FALLO] dev2 no puede acceder a la carpeta bin del equipo${NC}"
fi

# --- 2. VERIFICACIÓN DE LÍMITES DE RECURSOS ---
echo -e "\n[2] Verificando Límites de Recursos (PAM)..."

# Verificar NPROC
NPROC_LIMIT=$(sudo -u dev1 bash -c "ulimit -u")
if [ "$NPROC_LIMIT" -eq 50 ]; then
    echo -e "${GREEN}[OK] Límite de procesos (nproc) configurado en 50${NC}"
else
    echo -e "${RED}[FALLO] Límite nproc incorrecto: $NPROC_LIMIT${NC}"
fi

# Verificar MEMORIA (Address Space)
MEM_LIMIT=$(sudo -u dev1 bash -c "ulimit -v")
if [ "$MEM_LIMIT" -eq 524288 ]; then
    echo -e "${GREEN}[OK] Límite de memoria (as) configurado en 512MB${NC}"
else
    echo -e "${RED}[FALLO] Límite de memoria incorrecto: $MEM_LIMIT${NC}"
fi

# --- 3. VERIFICACIÓN DE ESCRITURA EN LOG ---
echo -e "\n[3] Probando permisos en done.log..."

# dev1 debe poder escribir
if sudo -u dev1 bash -c "echo 'Test Auditoria' >> /home/greendevcorp/done.log" &>/dev/null; then
    echo -e "${GREEN}[OK] dev1 (autorizado) puede escribir en el log${NC}"
else
    echo -e "${RED}[FALLO] dev1 no pudo escribir en el log${NC}"
fi

# dev2 NO debe poder escribir
if sudo -u dev2 bash -c "echo 'Intento dev2' >> /home/greendevcorp/done.log" &>/dev/null; then
    echo -e "${RED}[FALLO] dev2 pudo escribir en el log (VIOLACIÓN DE SEGURIDAD)${NC}"
else
    echo -e "${GREEN}[OK] dev2 tiene restringida la escritura en el log${NC}"
fi

echo -e "\nFIN TEST"
