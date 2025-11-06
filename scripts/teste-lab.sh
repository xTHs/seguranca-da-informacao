#!/bin/bash
# Script de teste rápido do laboratório

TARGET="192.168.56.10"

echo "=== Teste do Laboratório SSH ==="
echo ""

echo "[1] Testando conectividade..."
ping -c 2 $TARGET > /dev/null 2>&1 && echo "✓ OK" || echo "✗ FALHA"

echo ""
echo "[2] Escaneando SSH..."
nmap -p 22 $TARGET | grep "22/tcp"

echo ""
echo "[3] Auditando SSH..."
ssh-audit $TARGET 2>&1 | grep -E "PasswordAuthentication|PermitRootLogin|MaxAuthTries" | head -3

echo ""
echo "[4] Testando acesso..."
echo "Execute: ssh prof@$TARGET (senha: Prof123)"
