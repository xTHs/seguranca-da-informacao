# Relatório de Auditoria e Análise Forense

## 1. Análise de Vulnerabilidades e Vetores de Ataque

### 1.1 Vulnerabilidade Principal: Acesso SSH Não Autorizado
- **Descrição**: Senha fraca observada por engenharia social
- **Vetor de Ataque**: SSH com autenticação por senha
- **Impacto**: Acesso total ao sistema
- **Evidências**: Logs de autenticação SSH

### 1.2 Vulnerabilidade 2: Ausência de Autenticação Multifator (MFA)
- **Descrição**: Sistema permite acesso apenas com senha
- **Vetor de Ataque**: Força bruta ou senha comprometida
- **Impacto**: Alto
- **Mitigação**: Implementar 2FA

### 1.3 Vulnerabilidade 3: Root Login Habilitado
- **Descrição**: PermitRootLogin yes no sshd_config
- **Vetor de Ataque**: Acesso direto como root
- **Impacto**: Crítico
- **Mitigação**: PermitRootLogin no

### 1.4 Vulnerabilidade 4: Firewall Permissivo
- **Descrição**: UFW com política default allow
- **Vetor de Ataque**: Exposição de serviços desnecessários
- **Impacto**: Alto
- **Mitigação**: UFW default deny + whitelist

### 1.5 Vulnerabilidade 5: Ausência de IDS/IPS
- **Descrição**: Sem fail2ban ou sistema de detecção
- **Vetor de Ataque**: Ataques de força bruta sem bloqueio
- **Impacto**: Médio
- **Mitigação**: Implementar fail2ban

### 1.6 Vulnerabilidade 6: Logs Não Centralizados
- **Descrição**: Logs apenas locais, sem SIEM
- **Vetor de Ataque**: Manipulação/exclusão de evidências
- **Impacto**: Médio
- **Mitigação**: Rsyslog centralizado

## 2. Análise Forense Digital

### 2.1 Cadeia de Custódia
```bash
# 1. Coleta de evidências
sudo dd if=/dev/sda of=/mnt/evidence/disk.img bs=4M status=progress
sha256sum /mnt/evidence/disk.img > disk.img.sha256

# 2. Documentação
echo "Coletado por: [Nome]" >> chain-of-custody.txt
echo "Data/Hora: $(date -Iseconds)" >> chain-of-custody.txt
echo "Hash: $(cat disk.img.sha256)" >> chain-of-custody.txt
```

### 2.2 Análise de Logs
```bash
# Logs SSH
sudo journalctl -u ssh --since "2025-01-24 00:00:00" > ssh.log

# Últimos acessos
last -F > last.log

# Tentativas de autenticação
sudo grep "Failed password" /var/log/auth.log > failed_auth.log
sudo grep "Accepted password" /var/log/auth.log > successful_auth.log

# Comandos executados (se auditd instalado)
sudo ausearch -ts today > audit.log
```

### 2.3 Timeline de Eventos
| Timestamp | Evento | IP Origem | Usuário | Ação |
|-----------|--------|-----------|---------|------|
| 2025-01-24 14:30:15 | Login SSH | 192.168.56.20 | prof | Sucesso |
| 2025-01-24 14:31:02 | Acesso arquivo | 192.168.56.20 | prof | /opt/recurso_demo.log |
| 2025-01-24 14:32:45 | Logout | 192.168.56.20 | prof | - |

## 3. Análise de Riscos e Impactos

### 3.1 Impacto no Negócio (Instituição)
- **Reputacional**: Perda de confiança na segurança institucional
- **Financeiro**: Custos de investigação, hardening e treinamento
- **Legal**: Possível violação da LGPD (Lei 13.709/2018)
- **Operacional**: Necessidade de revisão de políticas e processos

### 3.2 Impacto Humano
- **Professor**: Quebra de privacidade, exposição de dados pessoais
- **Aluno**: Consequências disciplinares e legais (Lei 12.737/2012)
- **Comunidade**: Clima de insegurança no ambiente acadêmico

### 3.3 Matriz de Riscos
| Vulnerabilidade | Probabilidade | Impacto | Risco | Prioridade |
|----------------|---------------|---------|-------|------------|
| Senha fraca | Alta | Alto | Crítico | 1 |
| Root login | Média | Crítico | Alto | 2 |
| Sem MFA | Alta | Alto | Alto | 3 |
| Firewall permissivo | Média | Médio | Médio | 4 |
| Sem IDS | Média | Médio | Médio | 5 |
| Logs locais | Baixa | Médio | Baixo | 6 |

## 4. Recomendações

### 4.1 Imediatas (0-7 dias)
- Desabilitar root login via SSH
- Implementar fail2ban
- Alterar todas as senhas fracas
- Configurar firewall restritivo

### 4.2 Curto Prazo (1-3 meses)
- Implementar autenticação por chaves SSH
- Adicionar MFA (Google Authenticator)
- Centralizar logs (rsyslog/SIEM)
- Criar política de uso aceitável

### 4.3 Longo Prazo (3-6 meses)
- Implementar IDS/IPS (Snort/Suricata)
- Treinamento de segurança para toda comunidade
- Auditorias periódicas
- Programa de conscientização contínua
