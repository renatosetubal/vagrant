#!/bin/bash
ARQUIVO=/tmp/halog.txt
if [ ! -f "$ARQUIVO" ]; then
    echo "O arquivo $ARQUIVO não existe."
    systemctl restart haproxy
    echo "Arquivo $ARQUIVO criado."
fi
