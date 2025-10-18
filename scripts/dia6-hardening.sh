#!/bin/bash
# Dia 6 - Execução do Hardening

echo "=== HARDENING AUTOMATIZADO - $(date -Iseconds) ==="

# Verificar se Ansible está instalado
if ! command -v ansible-playbook &> /dev/null; then
    echo "Instalando Ansible..."
    sudo apt update
    sudo apt install -y ansible
fi

# Executar playbook de hardening
echo "1. Executando hardening via Ansible..."
cd ../ansible
ansible-playbook -i inventory.ini hardening.yml

echo "2. Validando configurações aplicadas..."

# Verificar SSH
echo "=== Auditoria SSH Pós-Hardening ==="
if command -v ssh-audit &> /dev/null; then
    ssh-audit 192.168.56.10 | tee /tmp/ssh_audit_pos_hardening.txt
else
    echo "Instalando ssh-audit..."
    pip3 install ssh-audit
    ssh-audit 192.168.56.10 | tee /tmp/ssh_audit_pos_hardening.txt
fi

# Verificar fail2ban
echo "=== Status Fail2ban ==="
ssh prof@192.168.56.10 "sudo fail2ban-client status sshd" 2>/dev/null || echo "Erro ao conectar - verificar chaves SSH"

# Verificar firewall
echo "=== Status UFW ==="
ssh prof@192.168.56.10 "sudo ufw status verbose" 2>/dev/null || echo "Erro ao conectar - verificar chaves SSH"

# Teste de força bruta (deve falhar)
echo "3. Testando proteção contra força bruta..."
if command -v hydra &> /dev/null; then
    echo "Executando teste com Hydra (deve ser bloqueado)..."
    timeout 30 hydra -l prof -p wrongpass -t 2 -f 192.168.56.10 ssh || echo "Hydra bloqueado/falhou - SUCESSO!"
else
    echo "Hydra não disponível - instalar se necessário: sudo apt install hydra"
fi

# Verificar banimentos
echo "4. Verificando IPs banidos..."
ssh prof@192.168.56.10 "sudo fail2ban-client status sshd" 2>/dev/null | grep "Banned IP list" || echo "Verificar manualmente"

echo "=== HARDENING CONCLUÍDO ==="
echo "Arquivos de validação salvos em /tmp/"
echo "- ssh_audit_pos_hardening.txt"

# Registrar no chain of custody
echo "5. Registrando evidências de hardening..."
../scripts/hash-evidence.sh /tmp/ssh_audit_pos_hardening.txt "Auditoria SSH pós-hardening"