#!/bin/bash
# Provisionamento VM DEFENSOR FRACO - Configuração INTENCIONALMENTE INSEGURA

echo "=== Configurando VM Defensor Fraco (INSEGURO) ==="

# Atualizar sistema
apt-get update

# Instalar pacotes essenciais
apt-get install -y openssh-server rsyslog chrony ufw fail2ban

# Criar usuário vulnerável (DEMO APENAS)
useradd -m -s /bin/bash prof
echo 'prof:Prof123' | chpasswd
usermod -aG sudo prof

# Configurar SSH INSEGURO (para demonstração)
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
cat >> /etc/ssh/sshd_config << EOF

# === CONFIGURAÇÕES INSEGURAS PARA LABORATÓRIO ===
# NÃO USAR EM PRODUÇÃO!
PasswordAuthentication yes
PermitRootLogin yes
MaxAuthTries 6
LoginGraceTime 120
# Sem AllowUsers (acesso amplo)
EOF

# Configurar UFW permissivo (INSEGURO)
ufw --force reset
ufw default allow
ufw allow 22/tcp
ufw --force enable

# Fail2ban instalado mas DESABILITADO (INSEGURO)
systemctl enable fail2ban
systemctl stop fail2ban

# Configurar chrony para sincronismo
systemctl enable --now chronyd

# Habilitar serviços
systemctl enable --now ssh
systemctl enable --now rsyslog
systemctl restart ssh
systemctl restart rsyslog

# Criar arquivo de recurso para demonstração
mkdir -p /opt
echo "Recurso institucional - Acesso em $(date)" > /opt/recurso_demo.log
chmod 644 /opt/recurso_demo.log

# Configurar hostname no /etc/hosts
echo "127.0.0.1 def-weak.lab.local def-weak" >> /etc/hosts
echo "192.168.56.10 def-weak.lab.local def-weak" >> /etc/hosts
echo "192.168.56.11 def-hard.lab.local def-hard" >> /etc/hosts
echo "192.168.56.20 atacante.lab.local atacante" >> /etc/hosts

# Verificar serviços
echo "=== Status dos Serviços ==="
systemctl status ssh --no-pager -l
ss -tulpn | grep :22

echo "=== VM Defensor Fraco Configurada ==="
echo "IP: 192.168.56.10"
echo "Hostname: def-weak.lab.local"
echo "Usuário: prof / Senha: Prof123 (DEMO APENAS)"
echo "SSH: CONFIGURAÇÃO INSEGURA INTENCIONAL"
echo "UFW: Permissivo (default allow)"
echo "Fail2ban: DESABILITADO"