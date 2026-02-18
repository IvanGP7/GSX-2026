#!/bin/bash
set -euo pipefail

# 1. Definir el servicio a por parametro
if [ $# -eq 0 ]; then
    echo "--- SERVICIOS DISPONIBLES EN EL SISTEMA (Cargados) ---"
    # Listamos todos los servicios (activos e inactivos)
    systemctl list-units --type=service --all --no-pager --no-legend | awk '{print $1}'
    echo "----------------------------------------------------"

    read -p "No has especificado ningún servicio. Introduce el nombre ahora: " SERVICE
else
    # Si hay al menos un parámetro, lo asignamos
    SERVICE=$1
fi

# 3. Verificar si el servicio existe
if ! systemctl list-unit-files | grep -q "^$SERVICE"; then
    # Verificación de la extensión .service
    if ! systemctl list-unit-files | grep -q "^$SERVICE.service"; then
        echo "Error: El servicio '$SERVICE' no existe en el sistema."
        exit 1
    else
        SERVICE="$SERVICE.service"
    fi
fi

echo "--- ANALIZANDO: $SERVICE ---"

# 4. Mostrar estado general (si está apagado, encendido o fallido)
echo "[ESTADO ACTUAL]"
echo "Estado: $(systemctl is-active $SERVICE || echo "Estado: Inactivo/Apagado")"
systemctl is-enabled $SERVICE > /dev/null && echo "Arranque: Habilitado (Auto-start)" || echo "Arranque: Deshabilitado"

# 5. Última ejecución
echo -e "\n[ÚLTIMA ACTIVIDAD]"
sudo journalctl -u "$SERVICE" --no-pager | grep "Started" | tail -n 1 || echo "No hay registros de inicio recientes."

# 6. Desplegar Logs (últimas 15 líneas)
echo -e "\n[ÚLTIMOS LOGS]"
sudo journalctl -u "$SERVICE" -n 15 --no-pager

# 7. Desplegar Errores específicos
echo -e "\n[ERRORES DETECTADOS]"
sudo journalctl -u "$SERVICE" -p err --no-pager
