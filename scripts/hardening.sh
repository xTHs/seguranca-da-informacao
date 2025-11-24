#!/bin/bash
# Script de hardening via Ansible

cd "$(dirname "$0")/../ansible"

if ! command -v ansible-playbook &> /dev/null; then
    echo "Instalando Ansible..."
    sudo apt update
    sudo apt install -y ansible
fi

echo "Executando hardening..."
ansible-playbook -i inventory.ini hardening.yml -e "ansible_become_pass=Prof123"

echo ""
echo "Validando..."
ssh-audit 192.168.56.10 2>&1 | grep -E "PasswordAuthentication|PermitRootLogin|fail2ban"
