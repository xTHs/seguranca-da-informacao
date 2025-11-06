#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Uso: $0 <arquivo>"
    exit 1
fi

FILE="$1"

if [ ! -f "$FILE" ]; then
    echo "Erro: Arquivo não encontrado"
    exit 1
fi

HASH=$(sha256sum "$FILE" | cut -d' ' -f1)
echo "SHA256: $HASH"
echo "Arquivo: $(basename "$FILE")"
echo "Data: $(date '+%Y-%m-%d %H:%M:%S')"