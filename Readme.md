---

## Guia Preparación

Instalación de la Imagen ISO
Descarga la versión "iso netinst para PC de 64 bits" desde la web oficial de Debian.

Creación de la Máquina Virtual en VirtualBox

Crea una nueva máquina virtual y selecciona la ISO descargada.

Configura el hardware (RAM y CPU) según la disponibilidad de tu equipo.

Inicia la instalación y completa el proceso hasta que el sistema cargue por primera vez.

Configuración de Red y Acceso SSH
Para habilitar la comunicación desde la máquina host:

Ve a la configuración de la máquina -> Red.

Asegúrate de que el adaptador esté en modo NAT.

En Avanzadas, entra en Reenvío de puertos y añade la siguiente regla:

Protocolo: TCP

Puerto anfitrión: 2222

Puerto invitado: 22

Preparación del Sistema e Instalación
Accede a la terminal de la máquina virtual como root y ejecuta:

su -
apt update && apt install ssh git -y


Almacenamiento Adicional

Apaga la máquina virtual.

En la configuración de VirtualBox, añade un disco duro extra en el controlador de almacenamiento.

Inicia la máquina de nuevo.

Conexión y Clonación del Proyecto
Desde la terminal de tu máquina host (fuera de la VM), ejecuta:

### Conexión vía SSH al puerto configurado
ssh gsx@127.0.0.1 -p 2222

### Clonación del repositorio
git clone [https://github.com/IvanGP7/GSX-2026.git](https://github.com/IvanGP7/GSX-2026.git)
cd GSX-2026


## Guía de Ejecución

Siga el orden de las semanas (W) para configurar el entorno correctamente:

### W1: Entorno y Administración
* [cite_start]`su ./start_enviroment.sh` [cite: 2]
* [cite_start]`./setup_admin.sh` [cite: 2]
* [cite_start]`./verify_setup.sh` [cite: 2]

### W2: Servicios y Logs
* [cite_start]`./nginx` [cite: 2]
* [cite_start]`./backup_timer.sh` [cite: 2]
* [cite_start]`./logrotate_config.sh` [cite: 2]

### W4: Usuarios y Permisos
* [cite_start]`./setup_env.sh` [cite: 2]
* [cite_start]`./setup_users.sh` [cite: 2]
* [cite_start]`./setup_group.sh` [cite: 2]
* [cite_start]`./limit_group.sh` [cite: 2]

### W5: Almacenamiento y Backup
* [cite_start]`./setup_storage.sh` [cite: 2]
* [cite_start]`./setup_backup_service.sh` [cite: 2]
* [cite_start]`./verify_backup.sh` [cite: 2]

---

## Funcionalidades Extra y Diagnóstico

El repositorio incluye herramientas adicionales para monitorización y pruebas:

| Archivo | Descripción |
| :--- | :--- |
| **W2/check_service.sh** | [cite_start]Permite inspeccionar el estado, actividad, logs y errores de un servicio específico[cite: 2, 3]. |
| **W3/performance_nginx.txt** | [cite_start]Guía para la modificación de `cgroups` aplicados a Nginx[cite: 4]. |
| **W3/process_control.sh** | [cite_start]Script de prueba para verificar la captura de señales (SIGNALS)[cite: 4]. |
| **W3/process_diag.sh** | [cite_start]Muestra procesos de alto consumo, árbol de dependencias y métricas detalladas[cite: 4]. |
| **W4/test_limits.sh** | [cite_start]Verificación de límites dentro de un entorno de desarrollo (dev)[cite: 4]. |
| **W4/test_security.sh** | [cite_start]Script para validar las limitaciones de acceso y seguridad[cite: 4]. |






