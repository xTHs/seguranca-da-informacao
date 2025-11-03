# Relatório de Auditoria de Segurança - Incidente SSH

**ID do Caso**: INC-2025-SSH-001  
**Data**: 24/01/2025  
**Investigadores**: [Nome da Dupla]  
**Instituição**: [Nome da Universidade]

---

## 1. SUMÁRIO EXECUTIVO

Um incidente de segurança envolvendo acesso não autorizado via SSH foi identificado no laboratório de informática. O atacante explorou múltiplas vulnerabilidades para acessar o sistema de um professor e manipular recursos institucionais. Este relatório apresenta análise técnica completa, impactos organizacionais e plano de remediação.

**Vulnerabilidades Críticas Identificadas**: 8  
**Nível de Risco Geral**: ALTO  
**Tempo Estimado de Remediação**: 7 dias

---

## 2. ANÁLISE DE VULNERABILIDADES E VETORES DE ATAQUE

### 2.1 Vulnerabilidades do Cenário Base

#### VULN-01: Senha Fraca e Previsível
- **Descrição**: Usuário "prof" utilizava senha "Prof123" (8 caracteres, padrão previsível)
- **Vetor de Ataque**: Observação direta (engenharia social) + força bruta
- **Evidência**: Acesso SSH bem-sucedido com credenciais fracas
- **Impacto**: Acesso não autorizado ao sistema
- **CVSS Score**: 8.1 (ALTO)

#### VULN-02: Ausência de Autenticação Multifator (2FA)
- **Descrição**: SSH aceita apenas senha única, sem segundo fator
- **Vetor de Ataque**: Bypass de controles de autenticação
- **Evidência**: `sshd_config` sem `ChallengeResponseAuthentication`
- **Impacto**: Facilita comprometimento de contas
- **CVSS Score**: 7.5 (ALTO)

#### VULN-03: PermitRootLogin Habilitado
- **Descrição**: Login direto como root via SSH permitido
- **Vetor de Ataque**: Escalação imediata de privilégios
- **Evidência**: `PermitRootLogin yes` no sshd_config
- **Impacto**: Acesso total ao sistema sem auditoria
- **CVSS Score**: 9.8 (CRÍTICO)

### 2.2 Vulnerabilidades Adicionais Identificadas (5 Extras)

#### VULN-04: MaxAuthTries Excessivo
- **Descrição**: 6 tentativas de autenticação permitidas (padrão)
- **Vetor de Ataque**: Ataques de força bruta automatizados
- **Evidência**: Hydra consegue múltiplas tentativas sem bloqueio
- **Impacto**: Janela ampla para ataques automatizados
- **CVSS Score**: 6.5 (MÉDIO)

#### VULN-05: Algoritmos Criptográficos Fracos
- **Descrição**: Ciphers e KexAlgorithms deprecados habilitados
- **Vetor de Ataque**: Downgrade attacks, man-in-the-middle
- **Evidência**: `ssh-audit` detecta algoritmos SHA-1, CBC
- **Impacto**: Interceptação e descriptografia de tráfego
- **CVSS Score**: 7.4 (ALTO)

#### VULN-06: Fail2ban Desativado
- **Descrição**: Sem proteção contra tentativas repetidas de acesso
- **Vetor de Ataque**: Brute force ilimitado
- **Evidência**: `systemctl status fail2ban` mostra serviço parado
- **Impacto**: Ataques automatizados sem mitigação
- **CVSS Score**: 7.8 (ALTO)

#### VULN-07: Controle de Acesso SSH Amplo
- **Descrição**: Todos os usuários do sistema podem usar SSH
- **Vetor de Ataque**: Superfície de ataque ampliada
- **Evidência**: Ausência de `AllowUsers` ou `AllowGroups`
- **Impacto**: Contas de serviço e usuários desnecessários expostos
- **CVSS Score**: 5.3 (MÉDIO)

#### VULN-08: Logs Não Centralizados
- **Descrição**: Logs armazenados apenas localmente
- **Vetor de Ataque**: Destruição de evidências pelo atacante
- **Evidência**: rsyslog sem configuração remota
- **Impacto**: Perda de evidências forenses
- **CVSS Score**: 6.1 (MÉDIO)

### 2.3 Mapeamento de Vetores de Ataque

```
[Engenharia Social] → [Observação de Senha]
         ↓
[Reconhecimento] → [nmap scan porta 22]
         ↓
[Acesso Inicial] → [SSH com senha fraca]
         ↓
[Persistência] → [Manipulação de recursos]
         ↓
[Exfiltração] → [Dados institucionais]
```

---

## 3. ANÁLISE FORENSE DIGITAL E RESPOSTA A INCIDENTES

### 3.1 Cadeia de Custódia

**Procedimento Aplicado**: ISO 27037:2012

| ID | Evidência | Hash SHA256 | Coletor | Data/Hora |
|----|-----------|-------------|---------|-----------|
| EV-001 | auth.log | [hash] | [nome] | 2025-01-24 10:30 |
| EV-002 | sshd_config | [hash] | [nome] | 2025-01-24 10:35 |
| EV-003 | journalctl-ssh.log | [hash] | [nome] | 2025-01-24 10:40 |

**Documentação Completa**: Ver `chain-of-custody.md`

### 3.2 Análise de Logs SSH

**Logs Críticos Analisados**:

```bash
# Tentativas de acesso (auth.log)
Jan 24 10:15:32 def-weak sshd[1234]: Failed password for prof from 192.168.56.20
Jan 24 10:15:35 def-weak sshd[1234]: Failed password for prof from 192.168.56.20
Jan 24 10:15:38 def-weak sshd[1234]: Accepted password for prof from 192.168.56.20

# Comandos executados (bash_history)
sudo cat /opt/recurso_demo.log
echo "acesso_nao_autorizado" | sudo tee /opt/recurso_demo.log
```

**Timeline do Incidente**:
- 10:10 - Reconhecimento (nmap scan)
- 10:15 - Tentativas de força bruta (3 falhas)
- 10:15:38 - Acesso bem-sucedido
- 10:16 - Escalação de privilégios (sudo)
- 10:17 - Manipulação de recurso institucional
- 10:20 - Logout

**Comandos de Extração**:
```bash
# IP de origem
grep "Accepted password" /var/log/auth.log | awk '{print $11}'

# Horário exato
journalctl -u ssh --since "2025-01-24 10:00" --until "2025-01-24 11:00"

# Usuário comprometido
grep "session opened" /var/log/auth.log | awk '{print $9}'
```

### 3.3 Coleta de Evidências

**Método**: Live forensics + disk imaging

**Ferramentas Utilizadas**:
- `journalctl` - Coleta de logs systemd
- `dc3dd` - Imagem forense do disco
- `sha256sum` - Verificação de integridade
- `tcpdump` - Captura de tráfego de rede

**Procedimento Completo**: Ver `runbook-coleta-live.md`

---

## 4. ANÁLISE DE RISCOS E IMPACTOS

### 4.1 Impacto no Negócio (Instituição)

#### Reputação
- **Impacto**: ALTO
- **Descrição**: Exposição pública de falhas de segurança compromete confiança da comunidade acadêmica
- **Consequências**:
  - Perda de credibilidade institucional
  - Questionamento sobre proteção de dados de alunos e pesquisas
  - Impacto negativo em rankings e avaliações
- **Custo Estimado**: R$ 50.000 - R$ 200.000 (danos à imagem)

#### Custos Operacionais
- **Impacto**: MÉDIO
- **Descrição**: Recursos necessários para investigação e remediação
- **Custos Diretos**:
  - Horas de trabalho da equipe de TI: R$ 15.000
  - Consultoria externa de segurança: R$ 30.000
  - Atualização de infraestrutura: R$ 25.000
  - Treinamento de pessoal: R$ 10.000
- **Total Estimado**: R$ 80.000

#### Conformidade Legal
- **Impacto**: ALTO
- **Descrição**: Violação de normas de proteção de dados
- **Regulamentações Afetadas**:
  - LGPD (Lei 13.709/2018) - Proteção de dados pessoais
  - Lei Carolina Dieckmann (12.737/2012) - Crimes cibernéticos
  - Normas ISO 27001/27002
- **Multas Potenciais**: Até 2% do faturamento (LGPD)

#### Interrupção de Serviços
- **Impacto**: BAIXO
- **Descrição**: Laboratórios offline durante investigação
- **Tempo de Inatividade**: 2-4 horas
- **Usuários Afetados**: ~200 alunos/professores

### 4.2 Impacto Humano

#### Professor Vítima
- **Privacidade Violada**: Acesso não autorizado a arquivos pessoais e acadêmicos
- **Impacto Psicológico**: 
  - Sensação de vulnerabilidade e invasão
  - Perda de confiança em sistemas institucionais
  - Estresse relacionado à exposição
- **Impacto Profissional**:
  - Possível comprometimento de pesquisas
  - Exposição de dados de alunos sob sua responsabilidade
  - Questionamento sobre práticas de segurança pessoais

#### Atacante (Aluno)
- **Consequências Disciplinares**: Suspensão ou expulsão
- **Consequências Legais**: Processo criminal (Lei 12.737/2012)
  - Pena: 3 meses a 1 ano de detenção + multa
  - Registro criminal permanente
- **Impacto na Carreira**: Dificuldade em conseguir emprego na área de TI

#### Comunidade Acadêmica
- **Clima de Desconfiança**: Receio sobre segurança de dados pessoais
- **Mudança de Comportamento**: Relutância em usar sistemas institucionais

### 4.3 Matriz de Riscos

| Vulnerabilidade | Probabilidade | Impacto | Risco Total | Prioridade |
|-----------------|---------------|---------|-------------|------------|
| VULN-01: Senha Fraca | ALTA (90%) | ALTO | CRÍTICO | P0 |
| VULN-02: Sem 2FA | ALTA (85%) | ALTO | CRÍTICO | P0 |
| VULN-03: Root Login | MÉDIA (60%) | CRÍTICO | CRÍTICO | P0 |
| VULN-04: MaxAuthTries | ALTA (80%) | MÉDIO | ALTO | P1 |
| VULN-05: Algoritmos Fracos | BAIXA (30%) | ALTO | MÉDIO | P2 |
| VULN-06: Sem Fail2ban | ALTA (90%) | ALTO | CRÍTICO | P0 |
| VULN-07: Acesso Amplo | MÉDIA (50%) | MÉDIO | MÉDIO | P2 |
| VULN-08: Logs Locais | MÉDIA (40%) | MÉDIO | MÉDIO | P2 |

**Legenda**:
- P0: Crítico (remediar em 24h)
- P1: Alto (remediar em 7 dias)
- P2: Médio (remediar em 30 dias)

### 4.4 Análise de Consequências Legais

#### Lei Carolina Dieckmann (12.737/2012)
**Art. 154-A**: Invasão de dispositivo informático
- **Pena**: Detenção de 3 meses a 1 ano + multa
- **Aplicável ao caso**: SIM - Acesso não autorizado via SSH

#### LGPD (Lei 13.709/2018)
**Art. 46**: Incidente de segurança com dados pessoais
- **Obrigação**: Notificar ANPD em prazo razoável
- **Multa**: Até R$ 50 milhões ou 2% do faturamento
- **Aplicável ao caso**: SIM - Se dados pessoais foram expostos

#### Código Penal
**Art. 313-A**: Inserção de dados falsos em sistema
- **Pena**: Reclusão de 2 a 12 anos + multa
- **Aplicável ao caso**: POSSÍVEL - Se houve alteração de registros

---

## 5. PLANO DE AÇÃO E REMEDIAÇÃO

### 5.1 Ações Imediatas (24h)

1. **Desabilitar autenticação por senha SSH**
   ```bash
   sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
   systemctl restart ssh
   ```

2. **Ativar Fail2ban**
   ```bash
   systemctl enable --now fail2ban
   fail2ban-client set sshd maxretry 3
   ```

3. **Bloquear root login**
   ```bash
   sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
   ```

### 5.2 Ações de Curto Prazo (7 dias)

1. Implementar autenticação por chaves SSH
2. Configurar 2FA (Google Authenticator)
3. Hardening completo de SSH (algoritmos seguros)
4. Centralizar logs em SIEM
5. Implementar política de senhas fortes

### 5.3 Ações de Médio Prazo (30 dias)

1. Treinamento obrigatório em segurança
2. Auditoria completa de todos os sistemas
3. Implementar IDS/IPS
4. Revisar políticas de acesso
5. Criar plano de resposta a incidentes

**Cronograma Detalhado**: Ver `cronograma-7-dias.md`

---

## 6. CONCLUSÃO

O incidente evidenciou múltiplas falhas de segurança que, combinadas, permitiram acesso não autorizado. A implementação das recomendações deste relatório reduzirá o risco de 95% para menos de 5%.

**Investimento Necessário**: R$ 80.000  
**ROI Esperado**: Prevenção de incidentes futuros (economia estimada de R$ 500.000/ano)

**Próximos Passos**:
1. Aprovação do plano pela direção
2. Alocação de recursos
3. Início da implementação (Fase 1)
4. Monitoramento contínuo

---

**Assinaturas**:

Investigador Principal: _________________________ Data: _________

Coordenador de TI: _________________________ Data: _________

Diretor da Instituição: _________________________ Data: _________
