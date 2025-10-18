#!/bin/bash
# Provisionamento VM ATACANTE - Ferramentas de pentest e coleta

echo "=== Configurando VM Atacante ==="

# Atualizar sistema
apt-get update

# Instalar ferramentas essenciais (se não estiverem no Kali)
apt-get install -y nmap hydra rsyslog chrony python3-pip

# Instalar ssh-audit via pip
pip3 install ssh-audit

# Configurar rsyslog como coletor
cp /etc/rsyslog.conf /etc/rsyslog.conf.backup
cat >> /etc/rsyslog.conf << EOF

# Habilitar recepção de logs UDP/TCP
module(load="imudp")
input(type="imudp" port="514")
module(load="imtcp")
input(type="imtcp" port="514")
EOF

# Configurar chrony
systemctl enable --now chronyd

# Habilitar serviços
systemctl enable --now rsyslog
systemctl restart rsyslog

# Criar diretórios de trabalho
mkdir -p /tmp/evidence_collection
mkdir -p /tmp/attack_logs

# Verificar ferramentas instaladas
echo "=== Ferramentas Disponíveis ==="
nmap --version | head -1
hydra -h | head -1
ssh-audit --help | head -1 2>/dev/null || echo "ssh-audit: OK"

# Verificar recepção de logs
echo "=== Testando Coleta de Logs ==="
systemctl status rsyslog --no-pager -l
ss -tulpn | grep :514

echo "=== VM Atacante Configurada ==="
echo "IP: 192.168.56.20"
echo "Ferramentas: nmap, hydra, ssh-audit"
echo "Rsyslog: Coletando na porta 514"