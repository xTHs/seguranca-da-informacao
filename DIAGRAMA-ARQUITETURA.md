# Diagramas de Arquitetura

## 1. Topologia de Rede

```
┌─────────────────────────────────────────────────────────────┐
│                    HOST FÍSICO (LINUX)                       │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │         VirtualBox Host-Only Network                   │ │
│  │              192.168.56.0/24                           │ │
│  │                                                        │ │
│  │   ┌──────────────────────┐   ┌──────────────────────┐ │ │
│  │   │   def-weak (Alvo)    │   │  atacante (Testes)   │ │ │
│  │   │  192.168.56.10       │   │  192.168.56.20       │ │ │
│  │   │                      │   │                      │ │ │
│  │   │  Ubuntu 22.04        │   │  Ubuntu 22.04        │ │ │
│  │   │  512MB RAM           │   │  512MB RAM           │ │ │
│  │   │  1 CPU               │   │  1 CPU               │ │ │
│  │   │                      │   │                      │ │ │
│  │   │  Serviços:           │   │  Ferramentas:        │ │ │
│  │   │  - SSH (22/tcp)      │   │  - nmap              │ │ │
│  │   │  - rsyslog           │   │  - hydra             │ │ │
│  │   │  - UFW (permissivo)  │   │  - ssh-audit         │ │ │
│  │   │                      │   │  - tcpdump           │ │ │
│  │   │  Vulnerável:         │   │  - python3           │ │ │
│  │   │  ✗ Senha fraca       │   │                      │ │ │
│  │   │  ✗ Root login        │   │                      │ │ │
│  │   │  ✗ Sem MFA           │   │                      │ │ │
│  │   │  ✗ Sem fail2ban      │   │                      │ │ │
│  │   └──────────────────────┘   └──────────────────────┘ │ │
│  │              │                         │               │ │
│  │              └─────────────────────────┘               │ │
│  │                    Rede Isolada                        │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## 2. Fluxo de Ataque

```
┌─────────────┐
│  Atacante   │
│ 192.168.56  │
│     .20     │
└──────┬──────┘
       │
       │ 1. Reconhecimento
       │ nmap -sS -sV -p 22 192.168.56.10
       │
       ▼
┌─────────────────────────────────────┐
│  Descoberta de Serviços             │
│  - SSH aberto na porta 22           │
│  - OpenSSH 8.9p1                    │
│  - PasswordAuthentication: yes      │
└──────┬──────────────────────────────┘
       │
       │ 2. Auditoria
       │ ssh-audit 192.168.56.10
       │
       ▼
┌─────────────────────────────────────┐
│  Identificação de Vulnerabilidades  │
│  - Root login habilitado            │
│  - MaxAuthTries: 6                  │
│  - Algoritmos fracos                │
└──────┬──────────────────────────────┘
       │
       │ 3. Exploração
       │ ssh prof@192.168.56.10
       │ Senha: Prof123
       │
       ▼
┌─────────────────────────────────────┐
│  Acesso Bem-Sucedido                │
│  - Login como usuário 'prof'        │
│  - Privilégios sudo                 │
└──────┬──────────────────────────────┘
       │
       │ 4. Pós-Exploração
       │ Manipulação de arquivos
       │
       ▼
┌─────────────────────────────────────┐
│  Impacto                            │
│  - Acesso não autorizado            │
│  - Modificação de dados             │
│  - Logs de atividade                │
└─────────────────────────────────────┘
```

## 3. Arquitetura de Hardening

```
┌─────────────────────────────────────────────────────────┐
│                  Camadas de Segurança                    │
│                                                          │
│  ┌────────────────────────────────────────────────────┐ │
│  │  Camada 1: Autenticação                            │ │
│  │  ✓ Chaves SSH (sem senha)                          │ │
│  │  ✓ MFA (Google Authenticator)                      │ │
│  │  ✓ AllowUsers (whitelist)                          │ │
│  └────────────────────────────────────────────────────┘ │
│                         │                                │
│                         ▼                                │
│  ┌────────────────────────────────────────────────────┐ │
│  │  Camada 2: Controle de Acesso                      │ │
│  │  ✓ PermitRootLogin no                              │ │
│  │  ✓ MaxAuthTries 3                                  │ │
│  │  ✓ LoginGraceTime 20                               │ │
│  └────────────────────────────────────────────────────┘ │
│                         │                                │
│                         ▼                                │
│  ┌────────────────────────────────────────────────────┐ │
│  │  Camada 3: Firewall                                │ │
│  │  ✓ UFW default deny                                │ │
│  │  ✓ Apenas porta 22 aberta                          │ │
│  │  ✓ Rate limiting                                   │ │
│  └────────────────────────────────────────────────────┘ │
│                         │                                │
│                         ▼                                │
│  ┌────────────────────────────────────────────────────┐ │
│  │  Camada 4: Detecção de Intrusão                    │ │
│  │  ✓ fail2ban (bantime 1h)                           │ │
│  │  ✓ maxretry 3                                      │ │
│  │  ✓ Monitoramento de logs                           │ │
│  └────────────────────────────────────────────────────┘ │
│                         │                                │
│                         ▼                                │
│  ┌────────────────────────────────────────────────────┐ │
│  │  Camada 5: Auditoria                               │ │
│  │  ✓ Logs centralizados (rsyslog)                    │ │
│  │  ✓ Retenção de 12 meses                            │ │
│  │  ✓ Alertas automáticos                             │ │
│  └────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

## 4. Fluxo de Resposta a Incidentes

```
┌─────────────────┐
│  Detecção       │
│  - Alerta       │
│  - Log suspeito │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Contenção      │
│  - Isolar host  │
│  - Bloquear IP  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Análise        │
│  - Coletar logs │
│  - Timeline     │
│  - Evidências   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Erradicação    │
│  - Remover      │
│    acesso       │
│  - Corrigir     │
│    vulnerab.    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Recuperação    │
│  - Restaurar    │
│    sistema      │
│  - Validar      │
│    segurança    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Lições         │
│  Aprendidas     │
│  - Documentar   │
│  - Melhorar     │
└─────────────────┘
```

## 5. Matriz de Vulnerabilidades

```
┌──────────────────────────────────────────────────────────────┐
│                    Matriz de Riscos                          │
│                                                              │
│  IMPACTO                                                     │
│    ▲                                                         │
│    │                                                         │
│  C │  [Root Login]      [Senha Fraca]                       │
│  R │                                                         │
│  Í │                                                         │
│  T │                    [Sem MFA]                            │
│  I │                                                         │
│  C │                                                         │
│  O │  [Logs Locais]     [Sem IDS]    [Firewall Permissivo]  │
│    │                                                         │
│  B │                                                         │
│  A │                                                         │
│  I │                                                         │
│  X │                                                         │
│  O │                                                         │
│    └─────────────────────────────────────────────────────▶  │
│         BAIXA          MÉDIA          ALTA                   │
│                    PROBABILIDADE                             │
└──────────────────────────────────────────────────────────────┘
```

## 6. Arquitetura de Logs

```
┌─────────────────────────────────────────────────────────┐
│                  Fluxo de Logs                           │
│                                                          │
│  ┌──────────────┐                                       │
│  │  def-weak    │                                       │
│  │              │                                       │
│  │  /var/log/   │                                       │
│  │  - auth.log  │──┐                                    │
│  │  - syslog    │  │                                    │
│  │  - fail2ban  │  │                                    │
│  └──────────────┘  │                                    │
│                    │                                    │
│                    │ rsyslog                            │
│                    │ (514/tcp)                          │
│                    │                                    │
│                    ▼                                    │
│  ┌──────────────────────────────┐                      │
│  │  Servidor de Logs Central    │                      │
│  │  (Opcional - não no lab)     │                      │
│  │                              │                      │
│  │  - Agregação                 │                      │
│  │  - Indexação                 │                      │
│  │  - Alertas                   │                      │
│  │  - Retenção                  │                      │
│  └──────────────────────────────┘                      │
│                    │                                    │
│                    ▼                                    │
│  ┌──────────────────────────────┐                      │
│  │  SIEM / Dashboard            │                      │
│  │  (Grafana/ELK)               │                      │
│  └──────────────────────────────┘                      │
└─────────────────────────────────────────────────────────┘
```
