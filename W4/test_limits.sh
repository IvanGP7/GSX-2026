#!/bin/bash

# TEST DE LÍMITES - Ejecutar como dev1
# Ejecutar como dev1

echo -e "\n--- Iniciando Test de MEMORIA (Límite: 512MB) ---"
echo "[i] Intentando reservar 600MB de RAM con Python..."
python3 -c 'a = " " * (600 * 1024 * 1024)' 2>/dev/null || echo "[!] BLOQUEO ALCANZADO: Error de memoria (Address Space limit)."

echo ""
echo "--- Iniciando Test de NPROC (Límite: 50) ---"
echo "[i] Intentando lanzar 60 procesos 'sleep'..."
for i in {1..70}; do sleep 10 & done

# Limpieza de procesos huérfanos
killall sleep 2>/dev/null
