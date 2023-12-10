#!/bin/bash

# Definisci le costanti
SSH_KEY="" # "/Users/yourName/.ssh/id_rsa"
BUILD_PATH="" # "/Users/yourName/path/to/your/project"
DEST_USER="" # your name on remote server
DEST_HOST="" # 12.34.56.67
DEST_PATH="" # /var/www/html/yourProject 

# Controlla se 'npm run watch' o 'npm run dev' sono in esecuzione
if ps aux | grep -E '[n]pm run watch|[n]pm run dev' > /dev/null; then
    echo "Uno dei processi 'npm run watch' o 'npm run dev' è già in esecuzione."
    echo "Interrompere questi processi prima di eseguire npm run build."
    exit 1
fi

# Esegui npm run build
cd "$BUILD_PATH" && npm run build

# Controlla se npm run build ha avuto successo
if [ $? -ne 0 ]; then
    echo "npm run build ha fallito. Arresto dello script."
    exit 1
fi

scp -i "$SSH_KEY" -r ${BUILD_PATH}/public/build ${DEST_USER}@${DEST_HOST}:${DEST_PATH}/public
ssh -i "$SSH_KEY" ${DEST_USER}@${DEST_HOST} "cd ${DEST_PATH} && git pull"
