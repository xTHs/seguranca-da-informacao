#!/bin/bash
# Provisionamento VM VÍTIMA - Configuração "insegura" inicial

echo "=== Configurando VM Vítima (Insegura) ==="

# Atualizar sistema
apt-get update

# Instalar pacotes essenciais
apt-get install -y openssh-server rsyslog chrony ufw fail2ban

# Criar usuário vulnerável
useradd -m -s /bin/bash prof
echo 'prof:Prof123' | chpasswd
usermod -aG sudo prof

# Configurar SSH "inseguro" (para demonstração)
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
cat >> /etc/ssh/sshd_config << EOF

# Configurações inseguras para laboratório
PermitRootLogin yes
PasswordAuthentication yes
MaxAuthTries 6
LoginGraceTime 120
EOF

# Configurar rsyslog para envio remoto
cat > /etc/rsyslog.d/60-remote.conf << EOF
*.* @192.168.56.20:514
EOF

# Configurar chrony
systemctl enable --now chronyd

# Habilitar serviços
systemctl enable --now ssh
systemctl enable --now rsyslog
systemctl restart ssh
systemctl restart rsyslog

# Fail2ban instalado mas não configurado (será feito no hardening)
systemctl enable fail2ban
systemctl stop fail2ban

# UFW instalado mas não configurado
ufw --force reset

# Criar arquivo de recurso para demonstração
mkdir -p /opt
echo "Recurso institucional - Acesso em $(date)" > /opt/recurso_demo.log
chmod 644 /opt/recurso_demo.log

# Verificar serviços
echo "=== Status dos Serviços ==="
systemctl status ssh --no-pager -l
ss -tulpn | grep :22

echo "=== VM Vítima Configurada ==="
echo "IP: 192.168.56.10"
echo "Usuário: prof / Senha: Prof123"
echo "SSH: Porta 22 (configuração insegura)"