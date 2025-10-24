#!/bin/bash
# Provisionamento VM DEFENSOR ENDURECIDO - Configuração SEGURA

echo "=== Configurando VM Defensor Endurecido (SEGURO) ==="

# Atualizar sistema
apt-get update

# Instalar pacotes de segurança
apt-get install -y openssh-server rsyslog chrony ufw fail2ban libpam-pwquality unattended-upgrades

# Criar usuário (sem senha inicial - será configurado com chaves SSH)
useradd -m -s /bin/bash prof
usermod -aG sudo prof
# Opcional: forçar troca de senha na primeira conexão
# passwd -e prof

# Configurar SSH SEGURO
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
cat >> /etc/ssh/sshd_config << EOF

# === CONFIGURAÇÕES SEGURAS ===
PasswordAuthentication no
PermitRootLogin no
MaxAuthTries 3
LoginGraceTime 20
PubkeyAuthentication yes
AllowUsers prof
UsePAM yes

# Algoritmos seguros
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com
MACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com
KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group16-sha512

# 2FA (comentado - ativar se necessário)
# ChallengeResponseAuthentication yes
# AuthenticationMethods publickey,keyboard-interactive
EOF

# Configurar qualidade de senhas
cat >> /etc/security/pwquality.conf << EOF
minlen = 12
minclass = 3
maxrepeat = 2
EOF

# Configurar UFW restritivo (SEGURO)
ufw --force reset
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
ufw --force enable

# Configurar Fail2ban
cat > /etc/fail2ban/jail.d/sshd.local << EOF
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 1h
findtime = 10m
EOF

# Habilitar atualizações automáticas
cat > /etc/apt/apt.conf.d/20auto-upgrades << EOF
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
EOF

# Configurar chrony para sincronismo
systemctl enable --now chronyd

# Habilitar serviços
systemctl enable --now ssh
systemctl enable --now rsyslog
systemctl enable --now fail2ban
systemctl restart ssh
systemctl restart rsyslog
systemctl restart fail2ban

# Gerar chave SSH para usuário prof (para acesso posterior)
sudo -u prof mkdir -p /home/prof/.ssh
sudo -u prof chmod 700 /home/prof/.ssh
sudo -u prof ssh-keygen -t rsa -b 4096 -f /home/prof/.ssh/id_rsa -N ""
sudo -u prof cp /home/prof/.ssh/id_rsa.pub /home/prof/.ssh/authorized_keys
sudo -u prof chmod 600 /home/prof/.ssh/authorized_keys

# Criar arquivo de recurso para demonstração
mkdir -p /opt
echo "Recurso institucional PROTEGIDO - Acesso em $(date)" > /opt/recurso_demo.log
chmod 644 /opt/recurso_demo.log

# Configurar hostname no /etc/hosts
echo "127.0.0.1 def-hard.lab.local def-hard" >> /etc/hosts
echo "192.168.56.10 def-weak.lab.local def-weak" >> /etc/hosts
echo "192.168.56.11 def-hard.lab.local def-hard" >> /etc/hosts
echo "192.168.56.20 atacante.lab.local atacante" >> /etc/hosts

# Verificar serviços
echo "=== Status dos Serviços ==="
systemctl status ssh --no-pager -l
systemctl status fail2ban --no-pager -l
ss -tulpn | grep :22

echo "=== VM Defensor Endurecido Configurada ==="
echo "IP: 192.168.56.11"
echo "Hostname: def-hard.lab.local"
echo "Usuário: prof (acesso via chave SSH apenas)"
echo "SSH: CONFIGURAÇÃO SEGURA"
echo "UFW: Restritivo (default deny)"
echo "Fail2ban: ATIVO com jail SSH"
echo "Chave SSH gerada em: /home/prof/.ssh/id_rsa"

# Instruções para 2FA (comentado)
echo "# Para ativar 2FA:"
echo "# apt-get install libpam-google-authenticator"
echo "# Descomentar linhas 2FA no sshd_config"
echo "# Configurar PAM em /etc/pam.d/sshd"