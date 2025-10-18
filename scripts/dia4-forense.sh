#!/bin/bash
# Dia 4 - Coleta Forense e Timeline

EVIDENCE_DIR="/tmp/evidence"
mkdir -p $EVIDENCE_DIR

echo "=== COLETA FORENSE - $(date -Iseconds) ==="

# Imagem do disco (executar na VÍTIMA)
echo "1. Criando imagem forense..."
cat << 'EOF'
# Executar na VÍTIMA:
sudo apt install -y dc3dd
sudo mkdir -p /mnt/evidence
sudo dc3dd if=/dev/sda of=/mnt/evidence/vitima_sda.img hash=sha256 log=/mnt/evidence/dc3dd.log
sudo sha256sum /mnt/evidence/vitima_sda.img > /mnt/evidence/vitima_sda.img.sha256
EOF

# Timeline com plaso
echo "2. Gerando timeline..."
cat << 'EOF'
# Instalar plaso (na ATACANTE)
sudo apt update
sudo apt install -y plaso-tools

# Gerar timeline
log2timeline.py /tmp/vitima.plaso /mnt/evidence/vitima_sda.img
psort.py -o L2tcsv /tmp/vitima.plaso > /tmp/timeline.csv
EOF

# Coleta de artefatos SSH
echo "3. Coletando artefatos SSH (executar na VÍTIMA)..."
cat << 'EOF'
# Configurações e logs SSH
sudo cp /etc/ssh/sshd_config /tmp/sshd_config_backup
sudo cp /var/log/auth.log /tmp/ 2>/dev/null || sudo journalctl -u ssh > /tmp/auth_journal.log
sudo getent passwd > /tmp/passwd_snapshot.txt
sudo getent shadow > /tmp/shadow_snapshot.txt

# Informações do sistema
uname -a > /tmp/system_info.txt
sudo netstat -tulpn > /tmp/netstat.txt
sudo iptables -L -n > /tmp/iptables.txt

# Hashes de todos os artefatos
sha256sum /tmp/sshd_config_backup /tmp/auth* /tmp/passwd_snapshot.txt /tmp/system_info.txt /tmp/netstat.txt /tmp/iptables.txt > /tmp/artifacts.sha256
EOF

echo "4. Registrar evidências no chain-of-custody..."
echo "Use o script ../scripts/hash-evidence.sh para cada arquivo coletado"

echo "=== COLETA FORENSE CONCLUÍDA ==="