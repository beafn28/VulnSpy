#!/bin/bash

# Limpiar pantalla
clear

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
RESET='\033[0m' # Sin color

# Imprimir ASCII
echo -e "${CYAN}██████──██████─██████──██████─██████─────────██████──────────██████─██████████████─██████████████─████████──████████${RESET}"
echo -e "${CYAN}██░░██──██░░██─██░░██──██░░██─██░░██─────────██░░██████████──██░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░██──██░░░░██${RESET}"
echo -e "${CYAN}██░░██──██░░██─██░░██──██░░██─██░░██─────────██░░░░░░░░░░██──██░░██─██░░██████████─██░░██████░░██─████░░██──██░░████${RESET}"
echo -e "${CYAN}██░░██──██░░██─██░░██──██░░██─██░░██─────────██░░██████░░██──██░░██─██░░██─────────██░░██──██░░██───██░░░░██░░░░██───${RESET}"
echo -e "${CYAN}██░░██──██░░██─██░░██──██░░██─██░░██─────────██░░██──██░░██──██░░██─██░░██████████─██░░██████░░██───████░░░░░░████───${RESET}"
echo -e "${CYAN}██░░██──██░░██─██░░██──██░░██─██░░██─────────██░░██──██░░██──██░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─────████░░████─────${RESET}"
echo -e "${CYAN}██░░██──██░░██─██░░██──██░░██─██░░██─────────██░░██──██░░██──██░░██─██████████░░██─██░░██████████───────██░░██───────${RESET}"
echo -e "${CYAN}██░░░░██░░░░██─██░░██──██░░██─██░░██─────────██░░██──██░░██████░░██─────────██░░██─██░░██───────────────██░░██───────${RESET}"
echo -e "${CYAN}████░░░░░░████─██░░██████░░██─██░░██████████─██░░██──██░░░░░░░░░░██─██████████░░██─██░░██───────────────██░░██───────${RESET}"
echo -e "${CYAN}───████░░████───██░░░░░░░░░░██─██░░░░░░░░░░██─██░░██──██████████░░██─██░░░░░░░░░░██─██░░██───────────────██░░██───────${RESET}"
echo -e "${CYAN}─────██████─────██████████████─██████████████─██████──────────██████─██████████████─██████───────────────██████───────${RESET}"
echo
echo

# Información mía
echo -e "${YELLOW}Autor: Beatriz Fresno Naumova${RESET}"
echo -e "${YELLOW}GitBook: https://beafn28.gitbook.io/beafn28/${RESET}"
echo -e "${YELLOW}GitHub: https://github.com/beafn28${RESET}"
echo

# Comprobar si el script se está ejecutando como root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}🔒 Por favor, ejecute este script como root.${RESET}"
  exit 1
fi

# Función para escanear puertos
scan_ports() {
  local target=$1
  echo -e "\n${BLUE}🔍 Escaneo de Puertos en $target:${RESET}"
  nmap -p- "$target" | grep -E '^[0-9]+/[a-z]+'
}

# Función para verificar servicios en ejecución
check_services() {
  local target=$1
  echo -e "\n${BLUE}🔎 Servicios en $target:${RESET}"
  nmap -sV "$target" | grep -E '^[0-9]+/[a-z]+'
}

# Función para buscar vulnerabilidades
search_vulnerabilities() {
  local service=$1
  echo -e "\n${PURPLE}🛡 Vulnerabilidades para $service:${RESET}"
  searchsploit "$service" | head -n 10
}

# Verificar argumentos
if [ "$#" -ne 1 ]; then
  echo -e "\n${RED}🚨 Uso incorrecto. Ejemplo: $0 <IP o dominio>${RESET}"
  exit 1
fi

TARGET=$1

# Ejecutar las funciones
scan_ports "$TARGET"
check_services "$TARGET"

# Identificar los servicios y buscar vulnerabilidades
echo -e "\n${BLUE}🔍 Identificación de Servicios y Búsqueda de Vulnerabilidades:${RESET}"
SERVICES=$(nmap -sV "$TARGET" | grep 'open' | awk '{print $3}' | sort | uniq)

if [ -z "$SERVICES" ]; then
  echo -e "${YELLOW}⚠ No se encontraron servicios abiertos.${RESET}"
else
  for service in $SERVICES; do
    search_vulnerabilities "$service"
  done
fi

echo -e "\n${GREEN}✅ Evaluación completada para $TARGET.${RESET}"
