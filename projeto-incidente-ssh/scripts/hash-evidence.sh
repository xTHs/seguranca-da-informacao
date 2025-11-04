#!/bin/bash
# Script para calcular hashes de evidências

EVIDENCE_DIR="../evidence"
CHAIN_OF_CUSTODY="../docs/chain-of-custody.md"

if [ $# -eq 0 ]; then
    echo "Uso: $0 <arquivo_evidencia> [descrição]"
    echo "Exemplo: $0 auth.log 'Log de autenticação SSH'"
    exit 1
fi

EVIDENCE_FILE="$1"
DESCRIPTION="${2:-Evidência coletada}"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
INVESTIGATOR=$(whoami)

if [ ! -f "$EVIDENCE_FILE" ]; then
    echo "Erro: Arquivo $EVIDENCE_FILE não encontrado"
    exit 1
fi

# Calcular hash
HASH=$(sha256sum "$EVIDENCE_FILE" | cut -d' ' -f1)

# Mover para diretório de evidências
BASENAME=$(basename "$EVIDENCE_FILE")
cp "$EVIDENCE_FILE" "$EVIDENCE_DIR/$BASENAME"

# Criar arquivo de hash
echo "$HASH  $BASENAME" > "$EVIDENCE_DIR/$BASENAME.sha256"

# Adicionar à cadeia de custódia
cat >> "$CHAIN_OF_CUSTODY" << EOF

### Evidência: $BASENAME
- **Data/Hora**: $TIMESTAMP
- **Coletado por**: $INVESTIGATOR
- **Tipo**: arquivo
- **Origem**: $EVIDENCE_FILE
- **Hash SHA256**: $HASH
- **Descrição**: $DESCRIPTION
- **Status**: coletado

EOF

echo "✓ Evidência $BASENAME registrada com hash $HASH"