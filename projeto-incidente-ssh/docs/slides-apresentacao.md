# Slides - Apresentação Incidente SSH

## Slide 1: Título
**Análise de Incidente SSH**  
*Laboratório de Segurança da Informação*

**Equipe**: [Nomes]  
**Data**: [Data da apresentação]

---

## Slide 2: Agenda
1. **Contexto** do incidente
2. **Metodologia** de investigação  
3. **Vulnerabilidades** identificadas
4. **Demonstração** prática
5. **Correções** implementadas
6. **Recomendações** finais

---

## Slide 3: Contexto do Incidente
- **Local**: Laboratório de informática
- **Vetor**: Acesso SSH não autorizado
- **Impacto**: Manipulação de recurso institucional
- **Descoberta**: Monitoramento de logs

---

## Slide 4: Escopo da Investigação
- **Ambiente**: Rede isolada (192.168.56.0/24)
- **Período**: 7 dias de análise
- **Metodologia**: Forense digital + hardening
- **Ferramentas**: nmap, ssh-audit, fail2ban, Ansible

---

## Slide 5: Vulnerabilidades Críticas
1. **Senha fraca** (Prof123)
2. **Sem 2FA** 
3. **PermitRootLogin** habilitado
4. **Fail2ban** desativado
5. **Algoritmos SSH** fracos

---

## Slide 6: Timeline do Ataque
```
[HH:MM] Reconhecimento (nmap)
[HH:MM] Enumeração SSH  
[HH:MM] Força bruta
[HH:MM] Acesso obtido
[HH:MM] Manipulação de arquivos
```

---

## Slide 7: Evidências Coletadas
- **Logs SSH** (journalctl)
- **Imagem forense** (dc3dd)
- **Timeline** (plaso)
- **Configurações** (sshd_config)
- **Hashes SHA256** (integridade)

---

## Slide 8: Demonstração - ANTES
**SSH Audit Results:**
- ❌ Algoritmos fracos habilitados
- ❌ PermitRootLogin yes
- ❌ MaxAuthTries 6
- ❌ Sem fail2ban ativo

---

## Slide 9: Hardening Aplicado
```bash
ansible-playbook hardening.yml
```
- ✅ PasswordAuthentication no
- ✅ PermitRootLogin no  
- ✅ MaxAuthTries 3
- ✅ Fail2ban configurado
- ✅ UFW ativo

---

## Slide 10: Demonstração - DEPOIS
**Teste de Força Bruta:**
```bash
hydra -l prof -p wrongpass 192.168.56.10 ssh
# Resultado: BLOQUEADO pelo fail2ban
```

---

## Slide 11: Impactos e Riscos
**Técnico**: Sistema comprometido  
**Reputacional**: Exposição de vulnerabilidades  
**Operacional**: Interrupção de serviços  
**Humano**: Constrangimento do professor

---

## Slide 12: Recomendações
**Imediatas**:
- Aplicar hardening em todos os sistemas
- Implementar 2FA obrigatório

**Médio prazo**:
- SIEM centralizado
- Treinamento de usuários

**Longo prazo**:
- Testes de penetração regulares
- Programa de conscientização

---

## Roteiro de Apresentação (20 min)

**Introdução** (3 min): Slides 1-4  
**Análise Técnica** (8 min): Slides 5-7  
**Demonstração** (7 min): Slides 8-10  
**Conclusões** (2 min): Slides 11-12