# 🔍 Herramienta de Ciberseguridad

![Security Banner](https://img.shields.io/badge/security-tool-green.svg) ![Bash](https://img.shields.io/badge/bash-v5.0-blue.svg)

## 📜 Descripción

Este script en Bash, creado por **Beatriz Fresno Naumova**, es una herramienta de ciberseguridad que realiza las siguientes funciones:

1. **Escaneo de Puertos:** Utiliza `nmap` para escanear todos los puertos de un objetivo específico (IP o dominio).
2. **Verificación de Servicios:** Identifica los servicios que se están ejecutando en los puertos abiertos.
3. **Búsqueda de Vulnerabilidades:** Utiliza `searchsploit` para buscar vulnerabilidades conocidas asociadas con los servicios detectados.

El script está diseñado para ser fácil de usar y presenta la información de manera clara y organizada.

## 🚀 Ejecución del Script

### 1. **Requisitos Previos**

- **Sistemas Operativos Compatibles:** Linux / MacOS.
- **Dependencias:**

  | Distribución               | Comando de Instalación                  |
  |----------------------------|-----------------------------------------|
  | Basadas en `apt` (Debian, Ubuntu) | `sudo apt-get install nmap exploitdb`  |
  | Basadas en `yum` (CentOS, RHEL)   | `sudo yum install nmap exploitdb`      |

### 2. **Cómo Ejecutar**

Para ejecutar este script, sigue los pasos a continuación:

1. **Clonar el Repositorio:**
   ```bash
   git clone (https://github.com/beafn28/VulnSpy)
   cd VulnSpy
2. **Dar Permisos de Ejecución:**
    ```bash
    chmod +x script.sh
3. **Ejecutar el Script:**
    ```bash
    sudo ./script.sh <IP o dominio>
### 3. **Ejemplo:**

    sudo ./script.sh 192.168.1.1
1. **Salida Esperada**

  El script mostrará información sobre:
- Puertos abiertos en el objetivo.
- Servicios en ejecución.
- Vulnerabilidades conocidas relacionadas con esos servicios.
2. **Ejemplo de Uso**

A continuación se muestra un ejemplo de cómo se ve la salida del script:

```sql
🔍 Escaneo de Puertos en 192.168.1.1:
80/tcp    open  http
22/tcp    open  ssh

🔎 Servicios en 192.168.1.1:
80/tcp    open  http      Apache httpd 2.4.41
22/tcp    open  ssh       OpenSSH 7.9p1

🛡 Vulnerabilidades para http:
Apache HTTPD 2.4.41 - 'mod_proxy_ftp' Module Buffer Overflow
Apache HTTPD 2.4.41 - URL Path Redirect (CVE-2020-1938)

🛡 Vulnerabilidades para ssh:
OpenSSH 7.9p1 - User Enumeration
OpenSSH 7.9p1 - Memory Corruption (CVE-2018-15473)
OpenSSH 7.9p1 - Public Key Authentication Bypass (CVE-2018-15473)

✅ Evaluación completada para 192.168.1.1.
