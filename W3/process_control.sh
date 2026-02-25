#!/bin/bash

set -euo pipefail

# Función de Control de Señales
handle_sigint() {
    echo -e "\n[!] Recibida SIGINT (Ctrl+C). Limpiando carga de trabajo antes de salir..."
    stop_workload
    exit 0
}

handle_sigusr1() {
    echo "[?] Recibida SIGUSR1: ¡Hola! Soy el script informando de su estado."
}

handle_sigusr2() {
    echo "[!] Recibida SIGUSR2: Reiniciando contadores de simulación..."
}

# Registrar los "traps" para capturar señales
trap handle_sigint SIGINT
trap handle_sigint SIGTERM
trap handle_sigint SIGQUIT
trap handle_sigusr1 SIGUSR1
trap handle_sigusr2 SIGUSR2

# --- Gestión de Carga (Workload) ---
start_workload() {
    echo "[+] Iniciando carga de trabajo (procesos 'yes' en background)..."
    # Lanzamos 3 procesos 'yes' redirigidos a /dev/null para no llenar la pantalla
    yes "Carga_GSX" > /dev/null &
    PID1=$!
    yes "Carga_GSX_2" > /dev/null &
    PID2=$!
    echo "[i] Procesos lanzados con PIDs: $PID1, $PID2"
}

stop_workload() {
    echo "[-] Deteniendo procesos en segundo plano..."
    # Buscamos procesos que tengan la marca "Carga_GSX" y los matamos
    pkill -f "Carga_GSX"
    echo "[v] Procesos detenidos."
}

# --- Ejecución ---
echo "--- DEMOSTRACIÓN DE CONTROL DE PROCESOS GSX ---"
echo "PID de este script: $$"
echo "Prueba a enviarme señales desde otra terminal con:"
echo "  kill -SIGUSR1 $$"
echo "  kill -SIGUSR2 $$"
echo "-----------------------------------------------"

start_workload

# Mantener el script vivo para recibir señales
while true; do
    sleep 1
done
