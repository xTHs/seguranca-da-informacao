#!/bin/bash
# ==============================================================================
# Script: atacante_provision.sh
# Descrição: Provisionamento da VM atacante com ferramentas de teste de segurança
# Autor: Projeto Segurança da Informação
# Data: 2025-09-24
# Uso: Executado automaticamente pelo Vagrant durante 'vagrant up'
# ATENÇÃO: Uso exclusivo para fins educacionais em ambiente isolado!
# ==============================================================================

set -e  # Parar execução em caso de erro

echo "=== Configurando VM Atacante ==="

# Configurar instalação não-interativa
export DEBIAN_FRONTEND=noninteractive

# Atualizar repositórios
apt-get update -qq

# Instalar ferramentas de teste de segurança
# nmap: Scanner de rede e portas
# hydra: Ferramenta de força bruta
# tcpdump: Captura de pacotes de rede
# python3-pip: Gerenciador de pacotes Python
apt-get install -y nmap hydra tcpdump python3-pip

# Instalar ssh-audit via pip
# ssh-audit: Ferramenta de auditoria de configurações SSH
pip3 install --quiet ssh-audit

# Instalar Ansible para hardening
apt-get install -y ansible sshpass

# Configurar resolução de nomes local
grep -q "192.168.56.10 def-weak" /etc/hosts || echo "192.168.56.10 def-weak" >> /etc/hosts
grep -q "192.168.56.20 atacante" /etc/hosts || echo "192.168.56.20 atacante" >> /etc/hosts

echo "=== Atacante Configurado ==="
echo "IP: 192.168.56.20 | Ferramentas: nmap, hydra, ssh-audit, tcpdump"
