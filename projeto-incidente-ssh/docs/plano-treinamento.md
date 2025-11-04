# Plano de Treinamento em Segurança da Informação

**Instituição**: [Nome da Universidade]  
**Vigência**: 2025  
**Carga Horária Total**: 16 horas  
**Modalidade**: Híbrido (presencial + EAD)

---

## 1. OBJETIVOS

- Conscientizar sobre riscos de segurança da informação
- Capacitar para identificação e prevenção de ameaças
- Reduzir incidentes de segurança em 80%
- Garantir conformidade com LGPD e normas ISO 27001

---

## 2. PÚBLICO-ALVO

- **Professores e Servidores**: 200 pessoas
- **Alunos**: 1.500 pessoas
- **Técnicos de TI**: 15 pessoas

---

## 3. MÓDULO 1: PROFESSORES E SERVIDORES

### 3.1 Proteção de Dados Pessoais e Acadêmicos (4h)

**Conteúdo**:
- LGPD aplicada ao ambiente acadêmico
- Classificação de dados (públicos, internos, confidenciais)
- Armazenamento seguro de notas e pesquisas
- Compartilhamento seguro de arquivos

**Atividades Práticas**:
- Configurar criptografia de disco (BitLocker/LUKS)
- Usar gerenciador de senhas institucional
- Identificar dados sensíveis em cenários reais

**Avaliação**: Quiz de 10 questões (nota mínima 7.0)

### 3.2 Senhas Seguras e Autenticação (2h)

**Conteúdo**:
- Anatomia de uma senha forte (12+ caracteres, complexidade)
- Gerenciadores de senhas (LastPass, Bitwarden)
- Autenticação multifator (2FA/MFA)
- Chaves SSH para acesso remoto

**Atividades Práticas**:
- Criar senha forte com gerenciador
- Configurar 2FA no email institucional
- Gerar e usar chaves SSH

**Avaliação**: Demonstração prática de configuração 2FA

### 3.3 Identificação de Ameaças (3h)

**Conteúdo**:
- Phishing e engenharia social
- Malware e ransomware
- Ataques de força bruta
- Insider threats

**Casos Reais**:
- Análise do incidente SSH do laboratório
- Casos de ransomware em universidades brasileiras
- Vazamentos de dados acadêmicos

**Atividades Práticas**:
- Identificar emails de phishing (simulação)
- Reportar incidentes via sistema institucional
- Análise de logs suspeitos

**Avaliação**: Simulação de phishing (taxa de cliques < 10%)

### 3.4 Boas Práticas em Laboratórios (3h)

**Conteúdo**:
- Política de uso aceitável
- Bloqueio de tela obrigatório (5 min)
- Não compartilhar credenciais
- Logout ao final da sessão
- Uso de VPN para acesso remoto

**Atividades Práticas**:
- Configurar bloqueio automático de tela
- Instalar e usar VPN institucional
- Revisar permissões de arquivos compartilhados

**Avaliação**: Checklist de conformidade (100% obrigatório)

---

## 4. MÓDULO 2: ALUNOS

### 4.1 Ética Digital e Responsabilidade (2h)

**Conteúdo**:
- Código de ética em TI
- Consequências de ciberataques (Lei 12.737/2012)
- Privacidade e consentimento
- Propriedade intelectual

**Casos Reais**:
- Aluno expulso por invasão de sistema
- Processos criminais por vazamento de provas
- Plágio acadêmico e suas consequências

**Atividades Práticas**:
- Debate sobre dilemas éticos
- Análise de casos jurídicos
- Assinatura de termo de compromisso

**Avaliação**: Redação sobre ética digital (1 página)

### 4.2 Consequências de Ciberataques (2h)

**Conteúdo**:
- Lei Carolina Dieckmann (12.737/2012)
- LGPD e proteção de dados
- Penas: detenção, multas, registro criminal
- Impacto na carreira profissional

**Exemplos Práticos**:
- Caso real: Aluno condenado a 1 ano de detenção
- Empresas que não contratam profissionais com antecedentes
- Danos morais e indenizações

**Atividades Práticas**:
- Simulação de julgamento
- Cálculo de multas LGPD
- Pesquisa de jurisprudência

**Avaliação**: Apresentação de caso jurídico (grupos de 4)

### 4.3 Boas Práticas de Segurança (2h)

**Conteúdo**:
- Senhas fortes e únicas por serviço
- Não usar WiFi público sem VPN
- Atualizar sistemas operacionais
- Backup de dados importantes
- Cuidado com downloads e links

**Atividades Práticas**:
- Instalar antivírus institucional
- Configurar backup automático (Google Drive/OneDrive)
- Verificar segurança de sites (HTTPS, certificados)

**Avaliação**: Quiz de 15 questões (nota mínima 7.0)

### 4.4 Uso Responsável de Laboratórios (2h)

**Conteúdo**:
- Política de uso aceitável
- Proibições: hacking, downloads ilegais, jogos
- Monitoramento e auditoria de atividades
- Como reportar problemas de segurança

**Atividades Práticas**:
- Leitura e assinatura da política
- Simulação de reporte de incidente
- Tour virtual pelos sistemas de monitoramento

**Avaliação**: Assinatura de termo + quiz (10 questões)

---

## 5. MÓDULO 3: TÉCNICOS DE TI (Avançado)

### 5.1 Hardening de Sistemas (8h)

**Conteúdo**:
- SSH hardening (chaves, fail2ban, algoritmos seguros)
- Firewall (UFW, iptables)
- SELinux/AppArmor
- Atualizações automáticas
- Auditoria com Lynis

**Atividades Práticas**:
- Configurar servidor SSH seguro
- Implementar fail2ban com regras customizadas
- Criar políticas de firewall restritivas

**Avaliação**: Laboratório prático (servidor deve resistir a ataques)

### 5.2 Resposta a Incidentes (8h)

**Conteúdo**:
- Metodologia NIST 800-61
- Coleta de evidências forenses
- Cadeia de custódia
- Análise de logs (journalctl, syslog)
- Ferramentas: Wireshark, tcpdump, Volatility

**Atividades Práticas**:
- Simular resposta a incidente SSH
- Coletar evidências com chain-of-custody
- Analisar dump de memória

**Avaliação**: Relatório forense completo

---

## 6. CRONOGRAMA DE IMPLEMENTAÇÃO

### Fase 1: Preparação (Semanas 1-2)
- Desenvolver materiais didáticos
- Configurar plataforma EAD
- Contratar instrutores externos
- Criar laboratórios virtuais

### Fase 2: Treinamento Professores (Semanas 3-4)
- 4 turmas de 50 pessoas
- Horários: manhã (8h-12h) e tarde (14h-18h)
- Local: Auditório principal + labs

### Fase 3: Treinamento Alunos (Semanas 5-8)
- 15 turmas de 100 pessoas
- Modalidade: 50% EAD + 50% presencial
- Obrigatório para matrícula no próximo semestre

### Fase 4: Treinamento TI (Semanas 9-10)
- 1 turma de 15 pessoas
- Período integral (8h-17h)
- Certificação externa (CompTIA Security+)

### Fase 5: Avaliação e Certificação (Semana 11)
- Aplicação de provas finais
- Emissão de certificados
- Relatório de aproveitamento

---

## 7. RECURSOS NECESSÁRIOS

### Humanos
- 2 instrutores internos (TI)
- 1 consultor externo (segurança)
- 1 advogado (aspectos legais)
- 2 monitores (suporte técnico)

### Infraestrutura
- Plataforma EAD (Moodle)
- 3 laboratórios de informática (40 PCs cada)
- Ambiente virtualizado (VMs para práticas)
- Sistema de videoconferência

### Materiais
- Apostilas digitais (PDF)
- Vídeos educativos (10-15 min cada)
- Simuladores de phishing
- Laboratórios virtuais (Vagrant/Docker)

### Orçamento
- Instrutores: R$ 20.000
- Plataforma EAD: R$ 5.000
- Materiais: R$ 3.000
- Certificados: R$ 2.000
- **Total**: R$ 30.000

---

## 8. INDICADORES DE SUCESSO

| Métrica | Meta | Medição |
|---------|------|---------|
| Taxa de conclusão | > 95% | Plataforma EAD |
| Nota média | > 8.0 | Avaliações |
| Redução de incidentes | -80% | Logs de segurança |
| Satisfação | > 4.5/5 | Pesquisa pós-treinamento |
| Phishing simulado | < 10% cliques | Ferramenta de simulação |

---

## 9. CERTIFICAÇÃO

**Certificado Emitido**: "Segurança da Informação - Nível [Básico/Intermediário/Avançado]"

**Requisitos**:
- Frequência mínima: 75%
- Nota mínima: 7.0 em todas as avaliações
- Conclusão de atividades práticas
- Assinatura de termo de compromisso

**Validade**: 1 ano (reciclagem obrigatória)

---

## 10. MANUTENÇÃO E ATUALIZAÇÃO

- **Revisão anual** do conteúdo
- **Atualização trimestral** com novas ameaças
- **Treinamento de reciclagem** anual (4h)
- **Simulações de phishing** mensais
- **Newsletters** semanais sobre segurança

---

## 11. CONTATOS E SUPORTE

**Coordenação do Programa**:
- Email: seguranca@instituicao.edu.br
- Telefone: (11) 1234-5678
- Sala: TI-123

**Suporte Técnico**:
- Email: suporte@instituicao.edu.br
- Telefone: (11) 1234-5679
- Horário: 8h-18h (seg-sex)

**Reporte de Incidentes**:
- Email: incidentes@instituicao.edu.br
- Telefone: (11) 1234-5680 (24/7)
- Portal: https://seguranca.instituicao.edu.br

---

**Aprovação**:

Coordenador de TI: _________________________ Data: _________

Diretor Acadêmico: _________________________ Data: _________

Reitor: _________________________ Data: _________
