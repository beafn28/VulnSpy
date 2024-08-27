# VulnSpy
🔍 Herramienta de Ciberseguridad

📜 Descripción
Este script en Bash, creado por Beatriz Fresno Naumova, es una herramienta de ciberseguridad que realiza las siguientes funciones:

Escaneo de Puertos: Utiliza nmap para escanear todos los puertos de un objetivo específico (IP o dominio).
Verificación de Servicios: Identifica los servicios que se están ejecutando en los puertos abiertos.
Búsqueda de Vulnerabilidades: Utiliza searchsploit para buscar vulnerabilidades conocidas asociadas con los servicios detectados.
El script está diseñado para ser fácil de usar y presenta la información de manera clara y organizada.

🚀 Ejecución del Script
1. Requisitos Previos
Sistemas Operativos Compatibles: Linux / MacOS.

Dependencias:

nmap: Herramienta de red utilizada para descubrir hosts y servicios en una red.
searchsploit: Interfaz para Exploit Database que permite buscar vulnerabilidades.
Para instalar estas dependencias, puedes usar:

bash
Copiar código
sudo apt-get install nmap exploitdb
O en distribuciones basadas en yum:

bash
Copiar código
sudo yum install nmap exploitdb
2. Cómo Ejecutar
Para ejecutar este script, sigue los pasos a continuación:

Clonar el Repositorio:

bash
Copiar código
git clone https://github.com/beafn28/tu-repositorio.git
cd tu-repositorio
Dar Permisos de Ejecución:

Asegúrate de que el script tiene permisos de ejecución:

bash
Copiar código
chmod +x script.sh
Ejecutar el Script:

Para ejecutar el script, es necesario tener privilegios de superusuario:

bash
Copiar código
sudo ./script.sh <IP o dominio>
Ejemplo:

bash
Copiar código
sudo ./script.sh 192.168.1.1
3. Salida Esperada
El script mostrará información sobre:

Puertos abiertos en el objetivo.
Servicios en ejecución.
Vulnerabilidades conocidas relacionadas con esos servicios.
4. Ejemplo de Uso
A continuación se muestra un ejemplo de cómo se ve la salida del script:

plaintext
Copiar código
🔍 Escaneo de Puertos en 192.168.1.1:
80/tcp    open  http
22/tcp    open  ssh

🔎 Servicios en 192.168.1.1:
80/tcp    open  http      Apache httpd 2.4.41
22/tcp    open  ssh       OpenSSH 7.9p1

🛡 Vulnerabilidades para http:
----------------------------------------------------
Apache HTTPD 2.4.41 - 'mod_proxy_ftp' Module Buffer Overflow
----------------------------------------------------
Apache HTTPD 2.4.41 - URL Path Redirect (CVE-2020-1938)
----------------------------------------------------

✅ Evaluación completada para 192.168.1.1.
📚 Referencias
GitBook: Beatriz Fresno Naumova
GitHub: GitHub Profile
📝 Licencia
Este proyecto está bajo la licencia MIT.
