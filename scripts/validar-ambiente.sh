#!/bin/bash
# Script de validação completa do laboratório

set -e

TARGET="192.168.56.10"
PASS=0
FAIL=0

echo "=== Validação do Laboratório SSH ==="
echo ""

# Teste 1: Conectividade
echo -n "[1/8] Testando conectividade... "
if ping -c 2 -W 2 $TARGET > /dev/null 2>&1; then
    echo "✓ OK"
    ((PASS++))
else
    echo "✗ FALHA"
    ((FAIL++))
fi

# Teste 2: Porta SSH aberta
echo -n "[2/8] Verificando porta SSH... "
if nc -zv $TARGET 22 2>&1 | grep -q "succeeded"; then
    echo "✓ OK"
    ((PASS++))
else
    echo "✗ FALHA"
    ((FAIL++))
fi

# Teste 3: nmap instalado
echo -n "[3/8] Verificando nmap... "
if command -v nmap &> /dev/null; then
    echo "✓ OK"
    ((PASS++))
else
    echo "✗ FALHA"
    ((FAIL++))
fi

# Teste 4: ssh-audit instalado
echo -n "[4/8] Verificando ssh-audit... "
if command -v ssh-audit &> /dev/null; then
    echo "✓ OK"
    ((PASS++))
else
    echo "✗ FALHA"
    ((FAIL++))
fi

# Teste 5: hydra instalado
echo -n "[5/8] Verificando hydra... "
if command -v hydra &> /dev/null; then
    echo "✓ OK"
    ((PASS++))
else
    echo "✗ FALHA"
    ((FAIL++))
fi

# Teste 6: Ansible instalado
echo -n "[6/8] Verificando ansible... "
if command -v ansible &> /dev/null; then
    echo "✓ OK"
    ((PASS++))
else
    echo "✗ FALHA"
    ((FAIL++))
fi

# Teste 7: Pasta compartilhada
echo -n "[7/8] Verificando /vagrant... "
if [ -d "/vagrant" ]; then
    echo "✓ OK"
    ((PASS++))
else
    echo "✗ FALHA"
    ((FAIL++))
fi

# Teste 8: Scripts acessíveis
echo -n "[8/8] Verificando scripts... "
if [ -f "/vagrant/scripts/teste-lab.sh" ]; then
    echo "✓ OK"
    ((PASS++))
else
    echo "✗ FALHA"
    ((FAIL++))
fi

echo ""
echo "=== Resultado ==="
echo "Passou: $PASS/8"
echo "Falhou: $FAIL/8"

if [ $FAIL -eq 0 ]; then
    echo "✓ Ambiente configurado corretamente!"
    exit 0
else
    echo "✗ Ambiente com problemas. Verifique os itens com falha."
    exit 1
fi
