# Relatório de Análise de Incidente SSH
**Caso**: INC-SSH-001  
**Data**: [Data do relatório]  
**Investigador**: [Nome]  
**Status**: CONCLUÍDO

## 1. Sumário Executivo

### Resumo do Incidente
Em [data], foi identificado um acesso não autorizado via SSH ao sistema do laboratório de informática, resultando na manipulação de recursos institucionais. A investigação revelou múltiplas vulnerabilidades de segurança que permitiram o comprometimento.

### Principais Achados
- **8 vulnerabilidades críticas** identificadas
- **Acesso obtido** através de credenciais fracas
- **Evidências coletadas** com cadeia de custódia preservada
- **Correções implementadas** via hardening automatizado

### Impacto
- **Técnico**: Comprometimento de sistema crítico
- **Reputacional**: Exposição de falhas de segurança
- **Operacional**: Necessidade de revisão de políticas

## 2. Contexto e Regras de Engajamento

### Escopo Autorizado
- Laboratório isolado (192.168.56.0/24)
- VMs: Vítima (192.168.56.10) e Atacante (192.168.56.20)
- Período: [datas do teste]

### Limitações
- Ambiente controlado apenas
- Sem dados pessoais reais
- Sem impacto em sistemas produtivos

## 3. Análise Técnica

### 3.1 Vulnerabilidades Identificadas

| ID | Vulnerabilidade | Severidade | Status |
|----|-----------------|------------|--------|
| V01 | Senha fraca/previsível | ALTO | Corrigido |
| V02 | Ausência de 2FA | ALTO | Corrigido |
| V03 | PermitRootLogin habilitado | CRÍTICO | Corrigido |
| V04 | MaxAuthTries alto | MÉDIO | Corrigido |
| V05 | Algoritmos SSH fracos | MÉDIO | Corrigido |
| V06 | Fail2ban desativado | ALTO | Corrigido |
| V07 | Controle de acesso amplo | MÉDIO | Corrigido |
| V08 | Logs não centralizados | MÉDIO | Corrigido |

### 3.2 Vetor de Ataque
1. **Reconhecimento**: Scan de portas (nmap)
2. **Enumeração**: Identificação de serviços SSH
3. **Exploração**: Força bruta com credenciais fracas
4. **Acesso**: Login SSH bem-sucedido
5. **Persistência**: Manipulação de arquivos do sistema

### 3.3 Timeline do Incidente
```
[HH:MM:SS] - Início do reconhecimento
[HH:MM:SS] - Scan de portas SSH
[HH:MM:SS] - Tentativa de autenticação
[HH:MM:SS] - Acesso bem-sucedido
[HH:MM:SS] - Manipulação de recursos
[HH:MM:SS] - Detecção e resposta
```

## 4. Análise Forense

### 4.1 Metodologia
- **Coleta live**: Preservação de evidências voláteis
- **Imaging**: Cópia bit-a-bit do disco (dc3dd)
- **Timeline**: Análise temporal com plaso
- **Cadeia de custódia**: Documentação completa

### 4.2 Evidências Coletadas
- Logs de autenticação SSH
- Configurações do sistema
- Imagem forense do disco
- Timeline de eventos
- Hashes SHA256 de verificação

### 4.3 Principais Achados Forenses
- **Horário de acesso**: [timestamp]
- **IP de origem**: 192.168.56.20
- **Usuário comprometido**: prof
- **Arquivos modificados**: /opt/recurso_demo.log

## 5. Análise de Riscos e Impactos

### 5.1 Impacto Institucional
- **Reputacional**: Exposição de vulnerabilidades
- **Financeiro**: Custos de correção e auditoria
- **Operacional**: Interrupção de serviços
- **Legal**: Possível não conformidade com regulamentações

### 5.2 Impacto Humano
- **Professor**: Exposição e constrangimento
- **Alunos**: Perda de confiança no sistema
- **TI**: Sobrecarga de trabalho para correções

## 6. Plano de Ação Implementado

### 6.1 Correções Técnicas (Concluídas)
- ✅ Hardening SSH (algoritmos seguros, 2FA)
- ✅ Implementação de fail2ban
- ✅ Configuração de firewall (UFW)
- ✅ Política de senhas robustas
- ✅ Centralização de logs

### 6.2 Melhorias de Processo
- ✅ Política de Uso Aceitável atualizada
- ✅ Runbook de resposta a incidentes
- ✅ Cadeia de custódia padronizada

### 6.3 Backlog (Fase 2)
- [ ] Implementação de SIEM completo
- [ ] Monitoramento 24/7
- [ ] Treinamento de usuários
- [ ] Auditoria trimestral automatizada

## 7. Recomendações

### 7.1 Imediatas (0-30 dias)
1. Aplicar hardening em todos os sistemas similares
2. Implementar monitoramento de tentativas de acesso
3. Revisar todas as contas de usuário

### 7.2 Médio Prazo (30-90 dias)
1. Implementar SIEM centralizado
2. Treinamento obrigatório para todos os usuários
3. Auditoria de segurança completa

### 7.3 Longo Prazo (90+ dias)
1. Certificação em segurança da informação
2. Programa de conscientização contínua
3. Testes de penetração regulares

## 8. Conclusão

O incidente demonstrou vulnerabilidades críticas que foram prontamente corrigidas. A implementação de controles de segurança adequados e o treinamento de usuários são essenciais para prevenir futuros incidentes.

---

## Apêndices

### A. Comandos Utilizados
```bash
# Reconhecimento
nmap -sS -sV -p 22 192.168.56.10

# Coleta de evidências
journalctl -u ssh -S -2h > ssh.log
sha256sum *.log > evidence.sha256

# Hardening
ansible-playbook -i inventory.ini hardening.yml
```

### B. Hashes de Verificação
```
[Hash SHA256 das evidências principais]
```

### C. Configurações Aplicadas
```
# /etc/ssh/sshd_config (principais alterações)
PermitRootLogin no
MaxAuthTries 3
PasswordAuthentication no
PubkeyAuthentication yes
```

**Assinatura Digital**: [Hash do documento]  
**Investigador**: [Nome e assinatura]  
**Data**: [Data de conclusão]