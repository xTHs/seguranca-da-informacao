# Cronograma Executivo - 7 Dias

## ✅ Dia 0 - Estrutura e ROE
- [x] Definir escopo e regras de engajamento
- [x] Criar estrutura de diretórios
- [x] Configurar cadeia de custódia
- [x] Preparar scripts de automação

## 📋 Dia 1 - Laboratório Isolado
- [ ] Criar VMs (Ubuntu Server + Kali Linux)
- [ ] Configurar rede isolada (192.168.56.0/24)
- [ ] Instalar SSH na vítima
- [ ] Criar usuário "prof" com senha fraca
- [ ] Tirar snapshots baseline

**Arquivos**: `lab/vm-setup.md`

## 📋 Dia 2 - SIEM e Logs
- [ ] Sincronizar tempo (chrony)
- [ ] Configurar rsyslog centralizado
- [ ] Instalar fail2ban (sem configurar)
- [ ] Testar coleta de logs

**Arquivos**: `lab/dia2-siem-setup.md`

## 📋 Dia 3 - Reprodução do Incidente
- [ ] Reconhecimento com nmap
- [ ] Acesso SSH com senha fraca
- [ ] Manipular recurso institucional
- [ ] Coletar evidências imediatas
- [ ] Registrar na cadeia de custódia

**Arquivos**: `scripts/dia3-incidente.sh`

## 📋 Dia 4 - Forense e Timeline
- [ ] Criar imagem do disco (dc3dd)
- [ ] Gerar timeline (plaso)
- [ ] Coletar artefatos SSH
- [ ] Calcular hashes de evidências
- [ ] Documentar achados

**Arquivos**: `scripts/dia4-forense.sh`

## 📋 Dia 5 - Mapeamento de Vulnerabilidades
- [ ] Auditoria com Lynis
- [ ] Análise SSH com ssh-audit
- [ ] Mapear 8 vulnerabilidades
- [ ] Documentar riscos e impactos
- [ ] Preparar recomendações

**Arquivos**: `docs/vulnerabilidades-mapeadas.md`

## 📋 Dia 6 - Hardening Automatizado
- [ ] Executar playbook Ansible
- [ ] Validar configurações aplicadas
- [ ] Testar proteções (fail2ban, UFW)
- [ ] Verificar ssh-audit pós-hardening
- [ ] Documentar melhorias

**Arquivos**: `ansible/hardening.yml`, `scripts/dia6-hardening.sh`

## 📋 Dia 7 - Relatório e Apresentação
- [ ] Compilar relatório final
- [ ] Preparar demonstração prática
- [ ] Criar slides de apresentação
- [ ] Revisar política de uso aceitável
- [ ] Finalizar documentação

**Arquivos**: `docs/relatorio-final-template.md`

---

## Checklist de Entregáveis

### Documentação
- [ ] Relatório de auditoria completo
- [ ] Cadeia de custódia com evidências
- [ ] Política de uso aceitável
- [ ] Runbook de resposta a incidentes

### Técnico
- [ ] VMs configuradas e funcionais
- [ ] Evidências coletadas com hashes
- [ ] Hardening aplicado e validado
- [ ] Scripts de automação testados

### Apresentação
- [ ] Demonstração antes/depois
- [ ] Timeline do incidente
- [ ] Validação das correções
- [ ] Plano de treinamento

## Recursos Necessários

### Software
- VirtualBox/VMware
- Ubuntu Server 22.04
- Kali Linux 2024.1
- Ansible, plaso, lynis
- ssh-audit, fail2ban

### Tempo Estimado
- **Setup inicial**: 2-3 horas
- **Execução diária**: 1-2 horas
- **Documentação**: 2-3 horas
- **Total**: ~15 horas

### Equipe Mínima
- 1 Analista de Segurança (você)
- 1 Supervisor/Professor
- Acesso a laboratório isolado