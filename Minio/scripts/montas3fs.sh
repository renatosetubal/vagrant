#!/bin/bash

# Diretório base onde os buckets serão montados
BASE_DIR="/mnt/s3_buckets"
URL="https://s3dev.mpes.mp.br:9000"
# Criar o diretório base, se não existir
mkdir -p "$BASE_DIR"

ACCESS_KEY="admin"
SECRET_KEY="admin12345678"

echo "admin:admin12345678" > ~/.passwd-s3fs
chmod 600 ~/.passwd-s3fs

# Listar buckets usando o MinIO Client
mc alias set s3 $URL admin  admin12345678
buckets=$(mc ls s3 | awk '{print $NF}' | sed 's/\/$//')

# Montar cada bucket
for bucket in $buckets; do
    # Criar um diretório para o bucket
    mkdir -p "$BASE_DIR/$bucket"
    # Montar o bucket usando s3fs
    s3fs "$bucket" "$BASE_DIR/$bucket" -o passwd_file=~/.passwd-s3fs -o url=$URL -o use_path_request_style  -o parallel_count=15 -o multipart_size=128
    echo "Bucket $bucket montado em $BASE_DIR/$bucket"
done
