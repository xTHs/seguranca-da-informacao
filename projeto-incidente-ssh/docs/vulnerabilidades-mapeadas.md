# Dia 5 - Mapeamento de Vulnerabilidades

## Vulnerabilidades Identificadas

### 1. Senha Fraca/Previsível
- **Descrição**: Usuário "prof" com senha "Prof123"
- **Evidência**: Acesso SSH bem-sucedido com credenciais fracas
- **Risco**: ALTO - Permite acesso não autorizado
- **Recomendação**: Política de senhas complexas + gerenciador de senhas
- **Medida**: Implementar libpam-pwquality

### 2. Ausência de Autenticação Multifator (2FA)
- **Descrição**: SSH aceita apenas senha, sem 2FA
- **Evidência**: sshd_config sem ChallengeResponseAuthentication
- **Risco**: ALTO - Facilita ataques de força bruta
- **Recomendação**: Implementar Google Authenticator ou similar
- **Medida**: Configurar pam_google_authenticator

### 3. PermitRootLogin Habilitado
- **Descrição**: Login root via SSH permitido
- **Evidência**: PermitRootLogin yes no sshd_config
- **Risco**: CRÍTICO - Acesso direto com privilégios máximos
- **Recomendação**: PermitRootLogin no
- **Medida**: Usar sudo para escalação de privilégios

### 4. MaxAuthTries Alto
- **Descrição**: Muitas tentativas de autenticação permitidas
- **Evidência**: MaxAuthTries padrão (6) ou não configurado
- **Risco**: MÉDIO - Facilita ataques de força bruta
- **Recomendação**: MaxAuthTries 3
- **Medida**: Limitar tentativas + fail2ban

### 5. Algoritmos SSH Fracos
- **Descrição**: Ciphers e Key Exchange antigos habilitados
- **Evidência**: ssh-audit mostra algoritmos deprecados
- **Risco**: MÉDIO - Vulnerável a ataques criptográficos
- **Recomendação**: Desabilitar algoritmos fracos
- **Medida**: Configurar Ciphers e KexAlgorithms seguros

### 6. Fail2ban Desativado
- **Descrição**: Sem proteção contra força bruta
- **Evidência**: fail2ban-client status vazio
- **Risco**: ALTO - Permite ataques automatizados
- **Recomendação**: Ativar jail sshd
- **Medida**: Configurar banimento após 3 tentativas

### 7. Controle de Acesso Amplo
- **Descrição**: Todos os usuários podem usar SSH
- **Evidência**: Ausência de AllowUsers/AllowGroups
- **Risco**: MÉDIO - Superfície de ataque ampla
- **Recomendação**: AllowUsers específicos
- **Medida**: Restringir acesso SSH por usuário/grupo

### 8. Logs Não Centralizados
- **Descrição**: Logs apenas locais, sem backup
- **Evidência**: rsyslog sem configuração remota
- **Risco**: MÉDIO - Perda de evidências
- **Recomendação**: Centralizar logs em SIEM
- **Medida**: Configurar rsyslog remoto + retenção

## Comandos de Auditoria

```bash
# Host auditing
sudo apt install -y lynis
sudo lynis audit system --quick > /tmp/lynis_report.txt

# SSH audit
pip3 install ssh-audit
ssh-audit 192.168.56.10 > /tmp/ssh_audit.txt

# Verificar configurações
sudo sshd -T | grep -E "(permitroot|maxauth|password|pubkey)"
sudo fail2ban-client status
sudo ufw status
```