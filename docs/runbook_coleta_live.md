# Runbook - Coleta Live de Evidências

## Checklist de Comandos Essenciais

### 1. Informações do Sistema
```bash
# Registrar hora do sistema
date -Iseconds
timedatectl status

# Informações básicas
hostname
uname -a
uptime
```

### 2. Usuários e Sessões
```bash
# Usuários ativos
who -a
w
last -F

# Histórico de logins
lastlog
```

### 3. Configuração de Rede
```bash
# Interfaces e IPs
ip a
ip r

# Conexões ativas
ss -tunap
netstat -tulpn
```

### 4. Processos e Arquivos
```bash
# Processos em execução
ps auxf
ps -eo pid,ppid,cmd,etime

# Arquivos abertos
lsof -nP | head -50
```

### 5. Logs SSH Críticos
```bash
# Logs SSH recentes
journalctl -u ssh --since "-2 hours"

# Tentativas de autenticação
grep "Failed password" /var/log/auth.log 2>/dev/null || journalctl | grep "Failed password"
grep "Accepted password" /var/log/auth.log 2>/dev/null || journalctl | grep "Accepted password"
```

### 6. Configurações de Segurança
```bash
# Configuração SSH
cat /etc/ssh/sshd_config

# Status de serviços de segurança
systemctl status fail2ban
systemctl status ufw
sudo fail2ban-client status
sudo ufw status
```

### 7. Cópias e Hashes
```bash
# Calcular hashes de evidências
sha256sum [arquivo] >> evidence/hashes.txt

# Verificar integridade
sha256sum -c evidence/hashes.txt
```

### 8. Finalização
```bash
# Encerrar coleta
echo "Coleta finalizada em: $(date -Iseconds)" >> coleta.log

# Registrar no chain-of-custody
# [Atualizar docs/chain-of-custody.md com detalhes]
```

## Ordem de Execução Recomendada
1. Registrar hora do sistema
2. Capturar usuários e sessões ativas
3. Documentar configuração de rede
4. Listar processos e arquivos críticos
5. Coletar logs SSH específicos
6. Verificar configurações de segurança
7. Calcular hashes de todas as evidências
8. Registrar na cadeia de custódia

## Observações
- Execute comandos como usuário privilegiado quando necessário
- Documente qualquer erro ou anomalia encontrada
- Mantenha logs de todas as ações realizadas
- Preserve a integridade das evidências originais