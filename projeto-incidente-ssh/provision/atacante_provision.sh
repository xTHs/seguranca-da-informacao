#!/bin/bash
# Provisionamento VM ATACANTE - Ferramentas de pentest e coleta

echo "=== Configurando VM Atacante ==="

# Atualizar sistema
apt-get update

# Instalar ferramentas essenciais
apt-get install -y nmap hydra tcpdump rsyslog chrony python3-pip git

# Instalar ssh-audit via pip
pip3 install ssh-audit

# Configurar rsyslog como coletor (opcional para logs centralizados)
cp /etc/rsyslog.conf /etc/rsyslog.conf.backup
cat >> /etc/rsyslog.conf << EOF

# Habilitar recepção de logs UDP/TCP (opcional)
module(load="imudp")
input(type="imudp" port="514")
module(load="imtcp")
input(type="imtcp" port="514")
EOF

# Configurar chrony para sincronismo
systemctl enable --now chronyd

# Habilitar serviços
systemctl enable --now rsyslog
systemctl restart rsyslog

# Criar diretórios de trabalho
mkdir -p /tmp/evidence_collection
mkdir -p /tmp/attack_logs

# Configurar hostname no /etc/hosts
echo "127.0.0.1 atacante.lab.local atacante" >> /etc/hosts
echo "192.168.56.10 def-weak.lab.local def-weak" >> /etc/hosts
echo "192.168.56.11 def-hard.lab.local def-hard" >> /etc/hosts
echo "192.168.56.20 atacante.lab.local atacante" >> /etc/hosts

# Verificar ferramentas instaladas
echo "=== Ferramentas Disponíveis ==="
nmap --version | head -1
hydra -h | head -1 2>/dev/null || echo "Hydra: OK"
ssh-audit --help | head -1 2>/dev/null || echo "ssh-audit: OK"
tcpdump --version 2>&1 | head -1

# Verificar recepção de logs
echo "=== Testando Coleta de Logs ==="
systemctl status rsyslog --no-pager -l
ss -tulpn | grep :514

echo "=== VM Atacante Configurada ==="
echo "IP: 192.168.56.20"
echo "Hostname: atacante.lab.local"
echo "Ferramentas: nmap, hydra, ssh-audit, tcpdump"
echo "Rsyslog: Coletando na porta 514 (opcional)"
echo "AVISO: Uso apenas em ambiente isolado para fins acadêmicos!"