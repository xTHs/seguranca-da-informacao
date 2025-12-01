# Relatório de Auditoria e Análise Forense

## 1. Análise de Vulnerabilidades e Vetores de Ataque

### 1.1 Vulnerabilidade Principal: Acesso SSH Não Autorizado
- **Descrição**: Senha fraca descoberta por ataque de força bruta
- **Vetor de Ataque**: SSH com autenticação por senha + força bruta (Hydra)
- **Impacto**: Acesso total ao sistema
- **Evidências**: Logs de autenticação SSH com múltiplas tentativas falhas

### 1.2 Vulnerabilidade 2: MaxAuthTries Excessivo
- **Descrição**: MaxAuthTries configurado em 6 (padrão)
- **Vetor de Ataque**: Permite múltiplas tentativas de força bruta por conexão
- **Impacto**: Alto
- **Evidência**: Configuração confirmada - MaxAuthTries 6
- **Mitigação**: MaxAuthTries 3

### 1.3 Vulnerabilidade 3: Ausência de Autenticação Multifator (MFA)
- **Descrição**: Sistema permite acesso apenas com senha
- **Vetor de Ataque**: Força bruta ou senha comprometida
- **Impacto**: Alto
- **Mitigação**: Implementar 2FA

### 1.4 Vulnerabilidade 4: Root Login Habilitado
- **Descrição**: PermitRootLogin yes no sshd_config
- **Vetor de Ataque**: Acesso direto como root
- **Impacto**: Crítico
- **Evidência**: Configuração confirmada via grep /etc/ssh/sshd_config
- **Mitigação**: PermitRootLogin no

### 1.5 Vulnerabilidade 5: Firewall Permissivo
- **Descrição**: UFW com política default allow (incoming)
- **Vetor de Ataque**: Exposição de serviços desnecessários
- **Impacto**: Alto
- **Evidência**: sudo ufw status verbose - "Default: allow (incoming)"
- **Mitigação**: UFW default deny + whitelist

### 1.6 Vulnerabilidade 6: Ausência de IDS/IPS
- **Descrição**: Sem fail2ban ou sistema de detecção
- **Vetor de Ataque**: Ataques de força bruta sem bloqueio
- **Impacto**: Médio
- **Evidência**: Hydra completou 11 tentativas em 7 segundos sem bloqueio
- **Mitigação**: Implementar fail2ban com maxretry=3

### 1.7 Vulnerabilidade 7: Algoritmos Criptográficos Fracos
- **Descrição**: SSH aceita algoritmos ECDH-NISTP e HMAC-SHA1
- **Vetor de Ataque**: Possível backdoor da NSA em curvas elípticas NIST
- **Impacto**: Médio
- **Evidência**: ssh-audit detectou 3 algoritmos KEX fracos e 2 MACs fracos
- **Mitigação**: Desabilitar ecdh-sha2-nistp*, hmac-sha1*

### 1.8 Vulnerabilidade 8: Logs Não Centralizados
- **Descrição**: Logs apenas locais, sem SIEM
- **Vetor de Ataque**: Manipulação/exclusão de evidências
- **Impacto**: Médio
- **Mitigação**: Rsyslog centralizado

## 2. Análise Forense Digital

### 2.0 Dados do Ataque Capturado

**Sistema Alvo:**
- Hostname: def-weak (ubuntu-jammy)
- IP: 192.168.56.10
- OS: Ubuntu 22.04.5 LTS (GNU/Linux 5.15.0-160-generic x86_64)
- SSH: OpenSSH_8.9p1 Ubuntu-3ubuntu0.13, OpenSSL 3.0.2

**Sistema Atacante:**
- Hostname: atacante
- IP: 192.168.56.20
- Ferramenta: Hydra v9.2

**Resultado do Ataque:**
- Início: 2025-12-01 20:56:54 UTC
- Fim: 2025-12-01 20:57:01 UTC
- Duração: 7 segundos
- Tentativas falhas: 11
- Senha descoberta: Prof123 (12ª tentativa)
- Wordlist: 26 senhas (senhas-comuns.txt)
- Threads: 4 conexões paralelas

### 2.1 Cadeia de Custódia
```bash
# 1. Coleta de evidências (imagem de disco)
sudo dd if=/dev/vda of=/vagrant/evidence/disk.img bs=4M status=progress
sha256sum /vagrant/evidence/disk.img > /vagrant/evidence/disk.img.sha256

# 2. Coleta de logs críticos
sudo cp /var/log/auth.log /vagrant/evidence/auth.log
sudo journalctl -u ssh.service > /vagrant/evidence/ssh.log

# 3. Documentação da cadeia de custódia
echo "Coletado por: [Nome do Investigador]" >> /vagrant/evidence/chain-of-custody.txt
echo "Data/Hora: $(date -Iseconds)" >> /vagrant/evidence/chain-of-custody.txt
echo "Sistema: def-weak (192.168.56.10)" >> /vagrant/evidence/chain-of-custody.txt
echo "Hash: $(cat /vagrant/evidence/disk.img.sha256)" >> /vagrant/evidence/chain-of-custody.txt
```

### 2.2 Análise de Logs
```bash
# Logs SSH do systemd
sudo journalctl -u ssh.service --since "today" > /vagrant/evidence/ssh.log

# Últimos acessos ao sistema
last -F > /vagrant/evidence/last.log

# Tentativas de autenticação falhas
sudo grep "Failed password" /var/log/auth.log > /vagrant/evidence/failed_auth.log

# Autenticações bem-sucedidas
sudo grep "Accepted password" /var/log/auth.log > /vagrant/evidence/successful_auth.log

# Sessões SSH abertas
sudo grep "session opened" /var/log/auth.log > /vagrant/evidence/sessions.log

# Captura de tráfego de rede (executar no atacante ou def-weak)
# Descobrir interface: ip a | grep 192.168.56
sudo tcpdump -i enp0s8 -w /vagrant/evidence/network.pcap host 192.168.56.10

# Histórico de comandos do usuário comprometido
sudo cat /home/prof/.bash_history > /vagrant/evidence/bash_history.log
```

### 2.3 Timeline de Eventos (Dados Reais)
| Timestamp (UTC) | Evento | IP Origem | Usuário | Ação |
|-----------------|--------|-----------|---------|------|
| 20:55:00 | Scan de rede | 192.168.56.20 | - | nmap -sn 192.168.56.0/24 (12.21s) |
| 20:55:54 | Scan de porta SSH | 192.168.56.20 | - | nmap -sS -sV -p 22 192.168.56.10 |
| 20:56:54 | Força bruta iniciada | 192.168.56.20 | prof | Hydra v9.2 - 26 senhas |
| 20:56:55 | Tentativas falhas 1-4 | 192.168.56.20 | prof | 4 conexões simultâneas |
| 20:56:57 | Tentativas falhas 5-8 | 192.168.56.20 | prof | 4 conexões simultâneas |
| 20:57:00 | Tentativas falhas 9-11 | 192.168.56.20 | prof | 3 conexões simultâneas |
| 20:57:00 | Login SSH bem-sucedido | 192.168.56.20 | prof | Senha: Prof123 (12ª tentativa) |
| 20:57:00 | Sessão SSH aberta | 192.168.56.20 | prof | keyboard-interactive/pam |
| 20:57:00 | Sessão encerrada | 192.168.56.20 | prof | Hydra desconecta |
| 20:59:56 | Login manual | 192.168.56.20 | prof | Acesso interativo |
| 21:00:00 | Verificação de privilégios | 192.168.56.20 | prof | sudo -l (ALL:ALL) |
| 21:00:06 | Logout | 192.168.56.20 | prof | Sessão encerrada |

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
| Vulnerabilidade | Probabilidade | Impacto | Risco | Prioridade | Evidência |
|----------------|---------------|---------|-------|------------|------------|
| Senha fraca | Alta | Alto | Crítico | 1 | Quebrada em 7s (12 tentativas) |
| MaxAuthTries 6 | Alta | Alto | Crítico | 2 | Permite 6 tentativas/conexão |
| Root login | Média | Crítico | Alto | 3 | PermitRootLogin yes |
| Sem fail2ban | Alta | Alto | Alto | 4 | 11 tentativas sem bloqueio |
| Firewall permissivo | Média | Médio | Médio | 5 | Default: allow (incoming) |
| Algoritmos fracos | Média | Médio | Médio | 6 | ECDH-NISTP, HMAC-SHA1 |
| Sem MFA | Baixa | Alto | Médio | 7 | Apenas senha |
| Logs locais | Baixa | Médio | Baixo | 8 | Sem SIEM |

## 4. Recomendações

### 4.1 Imediatas (0-7 dias)
- Alterar senha do usuário prof (comprometida)
- Implementar fail2ban (maxretry=3, bantime=1h)
- Reduzir MaxAuthTries de 6 para 3
- Desabilitar root login via SSH (PermitRootLogin no)
- Configurar firewall restritivo (UFW default deny)

### 4.2 Curto Prazo (1-3 meses)
- Desabilitar algoritmos fracos (ecdh-sha2-nistp*, hmac-sha1*)
- Implementar autenticação por chaves SSH
- Adicionar MFA (Google Authenticator)
- Centralizar logs (rsyslog/SIEM)
- Criar política de uso aceitável
- Implementar política de senhas fortes (libpam-pwquality)

### 4.3 Longo Prazo (3-6 meses)
- Implementar IDS/IPS (Snort/Suricata)
- Treinamento de segurança para toda comunidade
- Auditorias periódicas
- Programa de conscientização contínua
