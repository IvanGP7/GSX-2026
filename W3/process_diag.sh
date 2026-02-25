#!/bin/bash

set -euo pipefail

# Función para verificar e instalar dependencias (Idempotencia)
check_dependencies() {
    for cmd in ps htop pstree; do
        if ! command -v $cmd &> /dev/null; then
            echo "[!] Instalando $cmd para asegurar el funcionamiento del script..."
            sudo apt update && sudo apt install -y $cmd
        fi
    done
}

# 1. Top Consumidores de Recursos (CPU y Memoria)
show_top_consumers() {
    echo -e "\n--- TOP 10 CONSUMIDORES DE CPU ---"
    ps aux --sort=-%cpu | head -n 11 | awk '{print $1, $2, $3, $11}' | column -t

    echo -e "\n--- TOP 10 CONSUMIDORES DE MEMORIA ---"
    ps aux --sort=-%mem | head -n 11 | awk '{print $1, $2, $4, $11}' | column -t
}

# 2. Árbol de Procesos y Relaciones
show_process_tree() {
    echo -e "\n--- ÁRBOL DE PROCESOS (Jerarquía) ---"
    # Usamos -p para mostrar PIDs y -u para ver el usuario
    pstree -pnhu | head -n 20
}

# 3. Métricas Específicas de un Proceso (por nombre o PID)
show_process_metrics() {
    local target=$1
    if [ -z "$target" ]; then
        echo "[!] Error: Debes especificar un nombre de proceso o PID (ej: ./script.sh -m nginx)"
        return
    fi

    echo -e "\n--- MÉTRICAS ESPECÍFICAS PARA: $target ---"
    # Buscamos el proceso y extraemos métricas detalladas
    ps -eo pid,ppid,user,%cpu,%mem,vsz,rss,stat,comm | grep -i "$target" | grep -v "grep" | column -t
}

# Lógica principal del script

# Si el número de argumentos es cero, mostrar explicación sencilla
if [ $# -eq 0 ]; then
    echo "Uso rápido: ./process_diag.sh [PARÁMETRO]"
    echo "  -t : Muestra los procesos que más CPU y RAM consumen actualmente."
    echo "  -p : Muestra el árbol genealógico de procesos (quién creó a quién)."
    echo "  -m [nombre] : Muestra estadísticas detalladas de un proceso específico."
    exit 0
fi

check_dependencies

case "$1" in
    -t|--top)
        show_top_consumers
        ;;
    -p|--tree)
        show_process_tree
        ;;
    -m|--metrics)
        show_process_metrics "$2"
        ;;
    *)
        echo "Uso: $0 {--top|--tree|--metrics [nombre/PID]}"
        echo "  -t, --top      : Lista los mayores consumidores de CPU/RAM"
        echo "  -p, --tree     : Muestra el árbol de procesos"
        echo "  -m, --metrics  : Extrae métricas de un proceso específico"
        ;;
esac
