## Guía de Preparación

**1. Instalación de la Imagen ISO**
Descarga la versión "iso netinst para PC de 64 bits" desde la web oficial de Debian.

**2. Creación de la Máquina Virtual en VirtualBox**
* Crea una nueva máquina virtual y selecciona la ISO descargada.
* Configura el hardware (RAM y CPU) según la disponibilidad de tu equipo.
* Inicia la instalación y completa el proceso hasta que el sistema cargue por primera vez.

**3. Configuración de Red y Acceso SSH**
Para habilitar la comunicación desde la máquina host:
* Ve a la configuración de la máquina -> Red.
* Asegúrate de que el adaptador esté en modo NAT.
* En Avanzadas, entra en Reenvío de puertos y añade la siguiente regla:
  * Protocolo: TCP
  * Puerto anfitrión: 2222
  * Puerto invitado: 22

**4. Preparación del Sistema e Instalación**
Accede a la terminal de la máquina virtual como root y ejecuta:

```bash
su -
apt update && apt install ssh git -y
```

**5. Almacenamiento Adicional**
* Apaga la máquina virtual.
* En la configuración de VirtualBox, añade un disco duro extra en el controlador de almacenamiento.
* Inicia la máquina de nuevo.

**6. Conexión y Clonación del Proyecto**
Desde la terminal de tu máquina host (fuera de la VM), ejecuta:

```bash
# Conexión vía SSH al puerto configurado
ssh gsx@127.0.0.1 -p 2222

# Clonación del repositorio
git clone https://github.com/IvanGP7/GSX-2026.git
cd GSX-2026
```
## Guía de Ejecución

Siga el orden de las semanas (W) para configurar el entorno correctamente:

### W1: Entorno y Administración
* `su ./start_enviroment.sh`
* `./setup_admin.sh`
* `./verify_setup.sh`

### W2: Servicios y Logs
* `./nginx`
* `./backup_timer.sh`
* `./logrotate_config.sh`

### W4: Usuarios y Permisos
* `./setup_env.sh`
* `./setup_users.sh`
* `./setup_group.sh`
* `./limit_group.sh`

### W5: Almacenamiento y Backup
* `./setup_storage.sh`
* `./setup_backup_service.sh`
* `./verify_backup.sh`

## Funcionalidades Extra y Diagnóstico

El repositorio incluye herramientas adicionales para monitorización y pruebas:

| Archivo | Descripción |
| :--- | :--- |
| **W2/check_service.sh** | Permite inspeccionar el estado, actividad, logs y errores de un servicio específico. |
| **W3/performance_nginx.txt** | Guía para la modificación de `cgroups` aplicados a Nginx. |
| **W3/process_control.sh** | Script de prueba para verificar la captura de señales (SIGNALS). |
| **W3/process_diag.sh** | Muestra procesos de alto consumo, árbol de dependencias y métricas detalladas. |
| **W4/test_limits.sh** | Verificación de límites dentro de un entorno de desarrollo (dev). |
| **W4/test_security.sh** | Script para validar las limitaciones de acceso y seguridad. |






