#!/bin/bash

# Defina as variáveis de configuração
ALIAS="s3"                   # Nome do alias
URL="https://s3dev.mpes.mp.br:9000"         # URL do servidor MinIO
ACCESS_KEY="admin"         # Chave de acesso
SECRET_KEY="admin12345678"         # Chave secreta

# Configura o alias no MinIO Client (mc)
mc alias set "$ALIAS" "$URL" "$ACCESS_KEY" "$SECRET_KEY"

#mc mirror --overwrite --remove s3 /mnt/lv_bkp
