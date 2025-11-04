# Diagramas de Arquitetura e Fluxos

**Projeto**: Incidente SSH - Análise de Segurança  
**Data**: 24/01/2025

---

## 1. TOPOLOGIA DE REDE

```
┌─────────────────────────────────────────────────────────────────┐
│                  REDE ISOLADA (HOST-ONLY)                       │
│                    192.168.56.0/24                              │
│                                                                 │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │   def-weak       │  │   def-hard       │  │  atacante    │ │
│  │   .10            │  │   .11            │  │  .20         │ │
│  ├──────────────────┤  ├──────────────────┤  ├──────────────┤ │
│  │ Ubuntu 22.04     │  │ Ubuntu 22.04     │  │ Ubuntu 22.04 │ │
│  │ 2GB RAM / 2 CPU  │  │ 2GB RAM / 2 CPU  │  │ 2GB RAM      │ │
│  │                  │  │                  │  │              │ │
│  │ SSH: 22 ❌       │  │ SSH: 22 ✅       │  │ nmap         │ │
│  │ Senha: yes       │  │ Senha: no        │  │ hydra        │ │
│  │ Fail2ban: OFF    │  │ Fail2ban: ON     │  │ ssh-audit    │ │
│  │ UFW: allow       │  │ UFW: deny        │  │ tcpdump      │ │
│  │ Root: yes        │  │ Root: no         │  │              │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
│         ▲                      ▲                     │         │
│         │                      │                     │         │
│         └──────────────────────┴─────────────────────┘         │
│                    Comunicação SSH (porta 22)                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌─────────────────┐
                    │  VirtualBox     │
                    │  Host Machine   │
                    └─────────────────┘
```

---

## 2. FLUXO DE ATAQUE (def-weak - VULNERÁVEL)

```
┌─────────────┐
│  ATACANTE   │
│ 192.168.56  │
│    .20      │
└──────┬──────┘
       │
       │ 1. RECONHECIMENTO
       │ nmap -sS -sV -p 22 192.168.56.10
       ▼
┌─────────────────────────────────────┐
│  Porta 22 aberta                    │
│  OpenSSH 8.9p1                      │
│  PasswordAuthentication: yes ❌     │
└──────┬──────────────────────────────┘
       │
       │ 2. ENUMERAÇÃO
       │ ssh-audit 192.168.56.10
       ▼
┌─────────────────────────────────────┐
│  Algoritmos fracos detectados       │
│  Sem fail2ban                       │
│  MaxAuthTries: 6                    │
└──────┬──────────────────────────────┘
       │
       │ 3. BRUTE FORCE
       │ hydra -l prof -p Prof123 ssh
       ▼
┌─────────────────────────────────────┐
│  ✅ ACESSO CONCEDIDO                │
│  Tempo: 8 segundos                  │
│  Usuário: prof                      │
└──────┬──────────────────────────────┘
       │
       │ 4. ESCALAÇÃO DE PRIVILÉGIOS
       │ sudo su -
       ▼
┌─────────────────────────────────────┐
│  ✅ ROOT OBTIDO                     │
│  Controle total do sistema          │
└──────┬──────────────────────────────┘
       │
       │ 5. MANIPULAÇÃO
       │ echo "hack" | sudo tee /opt/recurso.log
       ▼
┌─────────────────────────────────────┐
│  ✅ RECURSO COMPROMETIDO            │
│  Missão cumprida                    │
└─────────────────────────────────────┘

TEMPO TOTAL: ~3 minutos
RESULTADO: SISTEMA COMPROMETIDO ❌
```

---

## 3. FLUXO DE DEFESA (def-hard - SEGURO)

```
┌─────────────┐
│  ATACANTE   │
│ 192.168.56  │
│    .20      │
└──────┬──────┘
       │
       │ 1. RECONHECIMENTO
       │ nmap -sS -sV -p 22 192.168.56.11
       ▼
┌─────────────────────────────────────┐
│  Porta 22 aberta                    │
│  OpenSSH 8.9p1                      │
│  PasswordAuthentication: no ✅      │
└──────┬──────────────────────────────┘
       │
       │ 2. ENUMERAÇÃO
       │ ssh-audit 192.168.56.11
       ▼
┌─────────────────────────────────────┐
│  Apenas algoritmos seguros          │
│  Fail2ban ativo                     │
│  MaxAuthTries: 3                    │
└──────┬──────────────────────────────┘
       │
       │ 3. TENTATIVA DE BRUTE FORCE
       │ hydra -l prof -p Prof123 ssh
       ▼
┌─────────────────────────────────────┐
│  ❌ SENHA DESABILITADA              │
│  Apenas chaves SSH aceitas          │
└──────┬──────────────────────────────┘
       │
       │ 4. TENTATIVAS REPETIDAS
       │ ssh prof@192.168.56.11 (3x)
       ▼
┌─────────────────────────────────────┐
│  ❌ FAIL2BAN ATIVADO                │
│  IP 192.168.56.20 BANIDO            │
│  Tempo de ban: 1 hora               │
└──────┬──────────────────────────────┘
       │
       │ 5. NOVAS TENTATIVAS
       │ ssh prof@192.168.56.11
       ▼
┌─────────────────────────────────────┐
│  ❌ CONNECTION REFUSED               │
│  Firewall bloqueou IP               │
└─────────────────────────────────────┘

TEMPO TOTAL: ~15 segundos
RESULTADO: ATAQUE BLOQUEADO ✅
```

---

## 4. ARQUITETURA DE SEGURANÇA (ANTES vs DEPOIS)

### 4.1 ANTES (Sistema Vulnerável)

```
┌─────────────────────────────────────────────┐
│           SISTEMA VULNERÁVEL                │
├─────────────────────────────────────────────┤
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │  Camada de Aplicação                │   │
│  │  - SSH Server (porta 22)            │   │
│  │  - Senha fraca: Prof123 ❌          │   │
│  └─────────────────────────────────────┘   │
│                    │                        │
│  ┌─────────────────────────────────────┐   │
│  │  Camada de Autenticação             │   │
│  │  - PasswordAuthentication: yes ❌   │   │
│  │  - PermitRootLogin: yes ❌          │   │
│  │  - MaxAuthTries: 6 ❌               │   │
│  │  - Sem 2FA ❌                       │   │
│  └─────────────────────────────────────┘   │
│                    │                        │
│  ┌─────────────────────────────────────┐   │
│  │  Camada de Proteção                 │   │
│  │  - Fail2ban: OFF ❌                 │   │
│  │  - IDS/IPS: Nenhum ❌               │   │
│  └─────────────────────────────────────┘   │
│                    │                        │
│  ┌─────────────────────────────────────┐   │
│  │  Camada de Rede                     │   │
│  │  - UFW: default allow ❌            │   │
│  │  - Algoritmos fracos ❌             │   │
│  └─────────────────────────────────────┘   │
│                    │                        │
│  ┌─────────────────────────────────────┐   │
│  │  Camada de Auditoria                │   │
│  │  - Logs locais apenas ⚠️            │   │
│  │  - Sem SIEM ❌                      │   │
│  └─────────────────────────────────────┘   │
│                                             │
└─────────────────────────────────────────────┘

VULNERABILIDADES: 8 críticas
TEMPO PARA COMPROMETER: < 10 segundos
```

### 4.2 DEPOIS (Sistema Endurecido)

```
┌─────────────────────────────────────────────┐
│         SISTEMA ENDURECIDO                  │
├─────────────────────────────────────────────┤
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │  Camada de Aplicação                │   │
│  │  - SSH Server (porta 22)            │   │
│  │  - Chaves SSH 4096-bit ✅           │   │
│  └─────────────────────────────────────┘   │
│                    │                        │
│  ┌─────────────────────────────────────┐   │
│  │  Camada de Autenticação             │   │
│  │  - PasswordAuthentication: no ✅    │   │
│  │  - PermitRootLogin: no ✅           │   │
│  │  - MaxAuthTries: 3 ✅               │   │
│  │  - AllowUsers: prof ✅              │   │
│  │  - 2FA (opcional) ⚠️                │   │
│  └─────────────────────────────────────┘   │
│                    │                        │
│  ┌─────────────────────────────────────┐   │
│  │  Camada de Proteção                 │   │
│  │  - Fail2ban: ON (3 tries) ✅        │   │
│  │  - Ban time: 1 hora ✅              │   │
│  │  - IDS/IPS: Planejado ⚠️            │   │
│  └─────────────────────────────────────┘   │
│                    │                        │
│  ┌─────────────────────────────────────┐   │
│  │  Camada de Rede                     │   │
│  │  - UFW: default deny ✅             │   │
│  │  - Apenas algoritmos seguros ✅     │   │
│  │  - ChaCha20, AES-GCM ✅             │   │
│  └─────────────────────────────────────┘   │
│                    │                        │
│  ┌─────────────────────────────────────┐   │
│  │  Camada de Auditoria                │   │
│  │  - Logs detalhados ✅               │   │
│  │  - SIEM centralizado (planejado) ⚠️ │   │
│  │  - Alertas automáticos ✅           │   │
│  └─────────────────────────────────────┘   │
│                                             │
└─────────────────────────────────────────────┘

VULNERABILIDADES: 0 críticas
TEMPO PARA COMPROMETER: ∞ (não comprometido)
```

---

## 5. DIAGRAMA DE BLOCOS - RESPOSTA A INCIDENTES

```
┌─────────────────────────────────────────────────────────────┐
│                  RESPOSTA A INCIDENTES                      │
└─────────────────────────────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
        ▼                   ▼                   ▼
┌───────────────┐   ┌───────────────┐   ┌───────────────┐
│ 1. PREPARAÇÃO │   │ 2. DETECÇÃO   │   │ 3. CONTENÇÃO  │
├───────────────┤   ├───────────────┤   ├───────────────┤
│ - Políticas   │   │ - Logs SSH    │   │ - Isolar VM   │
│ - Ferramentas │   │ - Fail2ban    │   │ - Bloquear IP │
│ - Treinamento │   │ - Alertas     │   │ - Desabilitar │
│ - Runbooks    │   │ - SIEM        │   │   usuário     │
└───────┬───────┘   └───────┬───────┘   └───────┬───────┘
        │                   │                   │
        └───────────────────┼───────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
        ▼                   ▼                   ▼
┌───────────────┐   ┌───────────────┐   ┌───────────────┐
│ 4. ANÁLISE    │   │ 5. ERRADICAÇÃO│   │ 6. RECUPERAÇÃO│
├───────────────┤   ├───────────────┤   ├───────────────┤
│ - Forense     │   │ - Hardening   │   │ - Restaurar   │
│ - Timeline    │   │ - Patches     │   │   serviços    │
│ - Evidências  │   │ - Trocar      │   │ - Monitorar   │
│ - Relatório   │   │   senhas      │   │ - Validar     │
└───────┬───────┘   └───────┬───────┘   └───────┬───────┘
        │                   │                   │
        └───────────────────┼───────────────────┘
                            │
                            ▼
                    ┌───────────────┐
                    │ 7. LIÇÕES     │
                    │    APRENDIDAS │
                    ├───────────────┤
                    │ - Documentar  │
                    │ - Melhorias   │
                    │ - Atualizar   │
                    │   políticas   │
                    └───────────────┘
```

---

## 6. FLUXO DE AUTENTICAÇÃO SSH

### 6.1 Sistema Vulnerável (def-weak)

```
┌─────────┐                                    ┌─────────┐
│ Cliente │                                    │ Servidor│
│  SSH    │                                    │  SSH    │
└────┬────┘                                    └────┬────┘
     │                                              │
     │  1. Conexão TCP (porta 22)                  │
     ├─────────────────────────────────────────────>│
     │                                              │
     │  2. Banner SSH-2.0-OpenSSH_8.9p1            │
     │<─────────────────────────────────────────────┤
     │                                              │
     │  3. Negociação de algoritmos                │
     ├─────────────────────────────────────────────>│
     │     (inclui algoritmos fracos ❌)            │
     │                                              │
     │  4. Solicita autenticação por senha         │
     ├─────────────────────────────────────────────>│
     │                                              │
     │  5. Aceita senha ❌                          │
     │<─────────────────────────────────────────────┤
     │                                              │
     │  6. Envia senha: "Prof123"                  │
     ├─────────────────────────────────────────────>│
     │                                              │
     │  7. Verifica senha (fraca ❌)                │
     │                                              │
     │  8. ✅ ACESSO CONCEDIDO                      │
     │<─────────────────────────────────────────────┤
     │                                              │
     │  9. Shell interativo                        │
     │<────────────────────────────────────────────>│
     │                                              │
     │  10. sudo su - (sem restrições ❌)           │
     ├─────────────────────────────────────────────>│
     │                                              │
     │  11. ✅ ROOT OBTIDO                          │
     │<─────────────────────────────────────────────┤
     │                                              │
```

### 6.2 Sistema Seguro (def-hard)

```
┌─────────┐                                    ┌─────────┐
│ Cliente │                                    │ Servidor│
│  SSH    │                                    │  SSH    │
└────┬────┘                                    └────┬────┘
     │                                              │
     │  1. Conexão TCP (porta 22)                  │
     ├─────────────────────────────────────────────>│
     │                                              │
     │  2. Banner SSH-2.0-OpenSSH_8.9p1            │
     │<─────────────────────────────────────────────┤
     │                                              │
     │  3. Negociação de algoritmos                │
     ├─────────────────────────────────────────────>│
     │     (apenas seguros ✅)                      │
     │                                              │
     │  4. Solicita autenticação por senha         │
     ├─────────────────────────────────────────────>│
     │                                              │
     │  5. ❌ SENHA DESABILITADA                    │
     │<─────────────────────────────────────────────┤
     │     "Password authentication disabled"       │
     │                                              │
     │  6. Tenta chave SSH inválida                │
     ├─────────────────────────────────────────────>│
     │                                              │
     │  7. ❌ CHAVE REJEITADA (tentativa 1)         │
     │<─────────────────────────────────────────────┤
     │                                              │
     │  8. Tenta novamente (tentativa 2)           │
     ├─────────────────────────────────────────────>│
     │                                              │
     │  9. ❌ CHAVE REJEITADA (tentativa 2)         │
     │<─────────────────────────────────────────────┤
     │                                              │
     │  10. Tenta novamente (tentativa 3)          │
     ├─────────────────────────────────────────────>│
     │                                              │
     │  11. ❌ CHAVE REJEITADA (tentativa 3)        │
     │<─────────────────────────────────────────────┤
     │                                              │
     │  12. ❌ FAIL2BAN ATIVADO                     │
     │      IP 192.168.56.20 BANIDO (1h)           │
     │                                              │
     │  13. Novas tentativas                       │
     ├─────────────────────────────────────────────>│
     │                                              │
     │  14. ❌ CONNECTION REFUSED                   │
     │<─────────────────────────────────────────────┤
     │      (Firewall bloqueou)                    │
     │                                              │
```

---

## 7. MATRIZ DE DEFESA EM PROFUNDIDADE

```
┌─────────────────────────────────────────────────────────────┐
│                    DEFESA EM PROFUNDIDADE                   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Camada 7: POLÍTICAS E CONSCIENTIZAÇÃO                     │
│  ┌───────────────────────────────────────────────────┐     │
│  │ - Treinamento obrigatório                         │     │
│  │ - Política de uso aceitável                       │     │
│  │ - Conscientização sobre engenharia social         │     │
│  └───────────────────────────────────────────────────┘     │
│                          │                                  │
│  Camada 6: APLICAÇÃO                                       │
│  ┌───────────────────────────────────────────────────┐     │
│  │ - SSH hardening (chaves, algoritmos seguros)      │     │
│  │ - Desabilitar serviços desnecessários             │     │
│  │ - Atualizações automáticas                        │     │
│  └───────────────────────────────────────────────────┘     │
│                          │                                  │
│  Camada 5: AUTENTICAÇÃO                                    │
│  ┌───────────────────────────────────────────────────┐     │
│  │ - Chaves SSH 4096-bit                             │     │
│  │ - 2FA (Google Authenticator)                      │     │
│  │ - AllowUsers restritivo                           │     │
│  └───────────────────────────────────────────────────┘     │
│                          │                                  │
│  Camada 4: CONTROLE DE ACESSO                              │
│  ┌───────────────────────────────────────────────────┐     │
│  │ - PermitRootLogin no                              │     │
│  │ - Sudo com auditoria                              │     │
│  │ - Princípio do menor privilégio                   │     │
│  └───────────────────────────────────────────────────┘     │
│                          │                                  │
│  Camada 3: PROTEÇÃO ATIVA                                  │
│  ┌───────────────────────────────────────────────────┐     │
│  │ - Fail2ban (3 tentativas, ban 1h)                │     │
│  │ - IDS/IPS (Snort, Suricata)                       │     │
│  │ - Rate limiting                                   │     │
│  └───────────────────────────────────────────────────┘     │
│                          │                                  │
│  Camada 2: REDE                                            │
│  ┌───────────────────────────────────────────────────┐     │
│  │ - UFW default deny                                │     │
│  │ - Segmentação de rede                             │     │
│  │ - VPN para acesso remoto                          │     │
│  └───────────────────────────────────────────────────┘     │
│                          │                                  │
│  Camada 1: MONITORAMENTO E AUDITORIA                       │
│  ┌───────────────────────────────────────────────────┐     │
│  │ - Logs centralizados (SIEM)                       │     │
│  │ - Alertas em tempo real                           │     │
│  │ - Análise forense                                 │     │
│  └───────────────────────────────────────────────────┘     │
│                                                             │
└─────────────────────────────────────────────────────────────┘

RESULTADO: Múltiplas camadas de proteção
           Falha em uma camada não compromete o sistema
```

---

## 8. CONCLUSÃO

Os diagramas demonstram visualmente:

1. **Topologia isolada**: Ambiente seguro para testes
2. **Fluxo de ataque**: Como sistemas vulneráveis são comprometidos
3. **Fluxo de defesa**: Como hardening bloqueia ataques
4. **Arquitetura em camadas**: Defesa em profundidade
5. **Resposta a incidentes**: Processo estruturado

**Todos os diagramas podem ser convertidos para formato visual usando ferramentas como draw.io, Lucidchart ou PlantUML.**

---

**Elaborado por**: [Nome da Dupla]  
**Data**: 24/01/2025  
**Versão**: 1.0
