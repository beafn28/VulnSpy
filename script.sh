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
RESET='\033[0m'
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
# Información del autor
echo -e "${YELLOW}Autor: Beatriz Fresno Naumova${RESET}"
echo -e "${YELLOW}GitBook: https://beafn28.gitbook.io/beafn28/${RESET}"
echo -e "${YELLOW}GitHub: https://github.com/beafn28${RESET}"
echo

# Verificar permisos de root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}🔒 Por favor, ejecute este script como root.${RESET}"
  exit 1
fi

# Menú de personalización
echo -e "${CYAN}Seleccione el tipo de escaneo:${RESET}"
echo -e "1) Escaneo rápido (puertos abiertos)"
echo -e "2) Escaneo detallado (versión y servicios)"
echo -e "3) Escaneo agresivo (vulnerabilidades)"
echo -e "4) Personalizado (configuración avanzada)"
read -p "Seleccione una opción (1-4): " SCAN_TYPE

read -p "Ingrese la dirección IP o dominio objetivo: " TARGET

# Configuración personalizada
if [ "$SCAN_TYPE" -eq 4 ]; then
  echo -e "${YELLOW}Ingrese opciones avanzadas de Nmap:${RESET}"
  read -p "Opciones (ej: -sC -sV -p1-65535 -A): " CUSTOM_OPTIONS
  read -p "¿Guardar resultado en un archivo? (s/n): " SAVE_OPTION
  if [[ "$SAVE_OPTION" =~ ^[Ss]$ ]]; then
    read -p "Nombre del archivo de salida: " OUTPUT_FILE
    CUSTOM_OPTIONS="$CUSTOM_OPTIONS -oX $OUTPUT_FILE"
  fi
fi

scan_ports() {
  local target=$1
  PORTS=()
  echo -e "\n${BLUE}🔍 Escaneando Puertos en $target...${RESET}"
  case $SCAN_TYPE in
    1) nmap -p- --min-rate 5000 -n -Pn "$target" | tee scan_result.txt;;
    2) nmap -sV -T4 -oX nmapScan.xml "$target" | tee scan_result.txt;;
    3) nmap -A -T4 --script=vuln -oX nmapScan.xml "$target" | tee scan_result.txt;;
    4) nmap $CUSTOM_OPTIONS "$target" | tee scan_result.txt;;
    *) echo -e "${RED}❌ Opción no válida.${RESET}"; exit 1;;
  esac
}

search_vulnerabilities() {
  echo -e "\n${PURPLE}🛡 Buscando vulnerabilidades...${RESET}"
  if [ -f nmapScan.xml ]; then
    searchsploit --nmap nmapScan.xml | tee exploits_found.txt
    rm nmapScan.xml
  elif [ -n "$OUTPUT_FILE" ] && [ -f "$OUTPUT_FILE" ]; then
    searchsploit --nmap "$OUTPUT_FILE" | tee exploits_found.txt
  else
    echo -e "${RED}❌ Fallo en el escaneo.${RESET}"
    exit 1
  fi
}

# Ejecutar escaneo
scan_ports "$TARGET"
if [ ! -s scan_result.txt ]; then
  echo -e "\n${YELLOW}❌ No se encontraron puertos abiertos en ${TARGET}.${RESET}"
  exit 1
fi

# Buscar vulnerabilidades en escaneos agresivos o personalizados
if [ "$SCAN_TYPE" -eq 3 ] || [ "$SCAN_TYPE" -eq 4 ]; then
  search_vulnerabilities
fi

# Opcional: Descargar exploits
read -p "¿Descargar exploits? (s/n): " EXPLOIT_OPTION
if [[ "$EXPLOIT_OPTION" =~ ^[Ss]$ ]]; then
  echo -e "\n${PURPLE}⚔ Buscando exploits...${RESET}"
  searchsploit "$(grep -oP 'Service Info: \K.*' scan_result.txt)" | tee exploits_list.txt
  read -p "¿Descargar algún exploit? (s/n): " DOWNLOAD_EXPLOIT
  if [[ "$DOWNLOAD_EXPLOIT" =~ ^[Ss]$ ]]; then
    read -p "Ingrese el ID del exploit: " EXPLOIT_ID
    searchsploit -m "$EXPLOIT_ID"
    echo -e "${GREEN}✅ Exploit $EXPLOIT_ID descargado.${RESET}"
  fi
fi

echo -e "\n${GREEN}✅ Evaluación completada para $TARGET.${RESET}"
