#!/bin/bash
# ==============================================================================
# Script: def_weak_provision.sh
# Descrição: Provisionamento da VM defensor com configurações INTENCIONALMENTE
#            INSEGURAS para fins educacionais
# Autor: Projeto Segurança da Informação
# Data: 2025-01-24
# Uso: Executado automaticamente pelo Vagrant durante 'vagrant up'
# ATENÇÃO: NÃO usar em ambiente de produção!
# ==============================================================================

set -e  # Parar execução em caso de erro

echo "=== Configurando VM Defensor Fraco ==="

# Configurar instalação não-interativa
export DEBIAN_FRONTEND=noninteractive

# Atualizar repositórios e instalar pacotes essenciais
apt-get update -qq
apt-get install -y openssh-server ufw

# Criar usuário vulnerável com senha fraca (DEMO)
# VULNERABILIDADE 1: Senha fraca e previsível
id -u prof &>/dev/null || useradd -m -s /bin/bash prof
echo 'prof:Prof123' | chpasswd
usermod -aG sudo prof  # Adicionar ao grupo sudo

# Configurar SSH com vulnerabilidades intencionais
# VULNERABILIDADE 2: Autenticação por senha habilitada
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# VULNERABILIDADE 3: Root login permitido
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# VULNERABILIDADE 4: Muitas tentativas de autenticação
sed -i 's/#MaxAuthTries 6/MaxAuthTries 6/' /etc/ssh/sshd_config

# Configurar firewall permissivo (INSEGURO)
# VULNERABILIDADE 5: Firewall com política default allow
ufw --force disable
ufw --force reset
ufw default allow incoming   # INSEGURO: Permite todo tráfego de entrada
ufw default allow outgoing
ufw --force enable

# Reiniciar serviço SSH para aplicar configurações
systemctl restart ssh

# Configurar resolução de nomes local
grep -q "192.168.56.10 def-weak" /etc/hosts || echo "192.168.56.10 def-weak" >> /etc/hosts
grep -q "192.168.56.20 atacante" /etc/hosts || echo "192.168.56.20 atacante" >> /etc/hosts

echo "=== Defensor Configurado ==="
echo "IP: 192.168.56.10 | User: prof | Pass: Prof123"
