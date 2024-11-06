#!/bin/bash

# Defina as variáveis de configuração
ALIAS="s3"                   # Nome do alias
URL="http://192.168.2.10:9000"         # URL do servidor MinIO
ACCESS_KEY="oln89bIGHVXGNBKQ2VVU"         # Chave de acesso
SECRET_KEY="lSE4zAUVzhkp8tSs94FSgTFpbrKTFwg5PwFEr0pp"         # Chave secreta

# Configura o alias no MinIO Client (mc)
mc alias set "$ALIAS" "$URL" "$ACCESS_KEY" "$SECRET_KEY"

#mc mirror --overwrite --remove s3 /mnt/lv_bkp
