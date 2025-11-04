# Runbook - Coleta de Evidências Live

## Procedimento de Resposta a Incidentes

### 1. Preparação Inicial
```bash
# Registrar hora do sistema (UTC)
date -Iseconds
timedatectl status

# Criar diretório de evidências
mkdir -p /tmp/incident-$(date +%Y%m%d-%H%M%S)
cd /tmp/incident-$(date +%Y%m%d-%H%M%S)
```

### 2. Informações do Sistema
```bash
# Sistema e kernel
uname -a > system_info.txt
uptime > uptime.txt
hostname > hostname.txt

# Usuários e sessões ativas
who -a > who_active.txt
w > w_sessions.txt
last -F > last_logins.txt
lastlog > lastlog.txt
```

### 3. Informações de Rede
```bash
# Configuração de rede
ip a > ip_addresses.txt
ip r > ip_routes.txt
cat /etc/resolv.conf > dns_config.txt

# Conexões ativas
ss -tunap > connections_all.txt
netstat -tulpn > netstat.txt
```

### 4. Processos e Arquivos
```bash
# Processos em execução
ps auxf > processes_tree.txt
ps -eo pid,ppid,cmd,etime > processes_time.txt

# Arquivos abertos
lsof -nP > open_files.txt
lsof -i > network_files.txt
```

### 5. Logs Críticos SSH
```bash
# Logs de autenticação SSH (últimas 2 horas)
journalctl -u ssh --since "2 hours ago" > ssh_journal.txt

# Auth.log se disponível
if [ -f /var/log/auth.log ]; then
    tail -n 1000 /var/log/auth.log > auth_log.txt
fi

# Tentativas de login
grep "Failed password" /var/log/auth.log 2>/dev/null > failed_logins.txt || \
journalctl | grep "Failed password" > failed_logins.txt

# Logins bem-sucedidos
grep "Accepted password" /var/log/auth.log 2>/dev/null > successful_logins.txt || \
journalctl | grep "Accepted password" > successful_logins.txt
```

### 6. Configurações de Segurança
```bash
# Configuração SSH
cp /etc/ssh/sshd_config sshd_config_backup.txt

# Usuários e grupos
getent passwd > passwd_snapshot.txt
getent group > group_snapshot.txt

# Sudo e permissões
sudo -l > sudo_permissions.txt 2>/dev/null || echo "Sem permissões sudo" > sudo_permissions.txt
```

### 7. Integridade e Hashes
```bash
# Calcular hashes de todos os arquivos coletados
sha256sum *.txt > evidence_hashes.sha256

# Verificar integridade
sha256sum -c evidence_hashes.sha256
```

### 8. Empacotamento e Transferência
```bash
# Criar arquivo compactado com timestamp
EVIDENCE_FILE="evidence_$(hostname)_$(date +%Y%m%d_%H%M%S).tar.gz"
tar -czf "$EVIDENCE_FILE" *.txt *.sha256

# Hash do arquivo final
sha256sum "$EVIDENCE_FILE" > "${EVIDENCE_FILE}.sha256"

echo "Evidências coletadas em: $PWD/$EVIDENCE_FILE"
echo "Hash SHA256: $(cat ${EVIDENCE_FILE}.sha256)"
```

### 9. Registro na Cadeia de Custódia
```bash
# Template para chain-of-custody.md
cat << EOF
### Evidência: $EVIDENCE_FILE
- **Data/Hora**: $(date -Iseconds)
- **Coletado por**: $(whoami)
- **Sistema**: $(hostname) - $(uname -a)
- **Tipo**: Coleta live de evidências
- **Hash SHA256**: $(cut -d' ' -f1 ${EVIDENCE_FILE}.sha256)
- **Localização**: $PWD/$EVIDENCE_FILE
- **Método**: Runbook de coleta live
- **Status**: coletado
- **Observações**: Coleta realizada durante resposta a incidente SSH

EOF
```

### 10. Limpeza e Finalização
```bash
# Mover evidências para local seguro
# sudo mv "$EVIDENCE_FILE"* /evidence/

# Registrar conclusão
echo "Coleta finalizada em: $(date -Iseconds)" >> collection_log.txt

# Limpar dados temporários sensíveis (se necessário)
# shred -vfz -n 3 /tmp/sensitive_data 2>/dev/null || rm -f /tmp/sensitive_data
```

## Checklist de Verificação
- [ ] Hora do sistema registrada
- [ ] Usuários e sessões documentados
- [ ] Configuração de rede capturada
- [ ] Processos e arquivos abertos listados
- [ ] Logs SSH coletados
- [ ] Configurações de segurança salvas
- [ ] Hashes calculados e verificados
- [ ] Evidências empacotadas
- [ ] Cadeia de custódia atualizada
- [ ] Arquivos movidos para local seguro