# Diagramas de Arquitetura

## 1. Topologia de Rede

```
┌──────────────────────────────────────────────────────────────┐
│                          HOST FÍSICO                         │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐  │
│  │         VirtualBox Host-Only Network                   │  │
│  │              192.168.56.0/24                           │  │
│  │                                                        │  │
│  │   ┌──────────────────────┐   ┌──────────────────────┐  │  │
│  │   │   def-weak (Alvo)    │   │  atacante (Testes)   │  │  │
│  │   │  192.168.56.10       │   │  192.168.56.20       │  │  │
│  │   │                      │   │                      │  │  │
│  │   │  Ubuntu 22.04        │   │  Ubuntu 22.04        │  │  │
│  │   │  512MB RAM           │   │  512MB RAM           │  │  │
│  │   │  1 CPU               │   │  1 CPU               │  │  │
│  │   │                      │   │                      │  │  │
│  │   │  Serviços:           │   │  Ferramentas:        │  │  │
│  │   │  - SSH (22/tcp)      │   │  - nmap              │  │  │
│  │   │  - rsyslog           │   │  - hydra             │  │  │
│  │   │  - UFW (permissivo)  │   │  - ssh-audit         │  │  │
│  │   │                      │   │  - tcpdump           │  │  │
│  │   │  Vulnerável:         │   │  - ansible           │  │  │
│  │   │  ✗ Senha fraca       │   │  - sshpass           │  │  │
│  │   │  ✗ Root login        │   │  - python3           │  │  │
│  │   │  ✗ Sem MFA           │   │                      │  │  │
│  │   │  ✗ Sem fail2ban      │   │                      │  │  │
│  │   └──────────────────────┘   └──────────────────────┘  │  │
│  │              │                         │               │  │
│  │              └─────────────────────────┘               │  │
│  │                    Rede Isolada                        │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

## 2. Fluxo de Ataque (Sequência dos Experimentos)

```
┌─────────────┐
│  Atacante   │
│ 192.168.56  │
│     .20     │
└──────┬──────┘
       │
       │ 1. Reconhecimento - Descoberta de Rede
       │ nmap -sn 192.168.56.0/24
       │ nmap -sS -sV -p 22 192.168.56.10
       │
       ▼
┌─────────────────────────────────────────────────┐
│  Descoberta de Serviços                         │
│  - Host ativo: 192.168.56.10                    │
│  - SSH aberto na porta 22                       │
│  - OpenSSH 8.9p1 Ubuntu                         │
│  - PasswordAuthentication: yes                  │
└──────┬──────────────────────────────────────────┘
       │
       │ 2. Invasão - Força Bruta SSH
       │ hydra -l prof -P senhas-comuns.txt
       │       -t 4 192.168.56.10 ssh
       │
       ▼
┌─────────────────────────────────────────────────┐
│  Credenciais Descobertas                        │
│  - Usuário: prof                                │
│  - Senha: Prof123                               │
│  - Tentativas: ~12 (de 27 senhas)               │
└──────┬──────────────────────────────────────────┘
       │
       │ 3. Invasão - Password Spraying (Alternativa)
       │ hydra -L usuarios-comuns.txt -p Prof123
       │       -t 4 192.168.56.10 ssh
       │
       ▼
┌─────────────────────────────────────────────────┐
│  4. Invasão - Acesso Direto                     │
│  ssh prof@192.168.56.10                         │
│  Senha: Prof123                                 │
└──────┬──────────────────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────────────────┐
│  Acesso Bem-Sucedido                            │
│  - Login como usuário 'prof'                    │
│  - Privilégios sudo                             │
│  - Acesso total ao sistema                      │
└──────┬──────────────────────────────────────────┘
       │
       │ 5. Invasão - Exploração de Root Login
       │ ssh root@192.168.56.10
       │ (se root login habilitado)
       │
       ▼
┌─────────────────────────────────────────────────┐
│  6. Pós-Exploração - Análise de Logs            │
│  journalctl -u ssh --since "-15 min"            │
│  tail -f /var/log/auth.log                      │
└──────┬──────────────────────────────────────────┘
       │
       │ 7. Auditoria - Identificar Vulnerabilidades
       │ ssh-audit 192.168.56.10
       │
       ▼
┌─────────────────────────────────────────────────┐
│  Vulnerabilidades Confirmadas                   │
│  - Root login habilitado                        │
│  - MaxAuthTries: 6                              │
│  - Algoritmos fracos                            │
│  - Sem fail2ban                                 │
└──────┬──────────────────────────────────────────┘
       │
       │ 8. Defesa - Hardening (Opcional)
       │ cd /vagrant/scripts
       │ ./hardening.sh
       │
       ▼
┌─────────────────────────────────────────────────┐
│  Sistema Protegido                              │
│  - PasswordAuthentication no                    │
│  - PermitRootLogin no                           │
│  - MaxAuthTries 3                               │
│  - fail2ban ativo                               │
│  - UFW default deny                             │
└─────────────────────────────────────────────────┘
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
│  C │  [Root Login]      [Senha Fraca]                        │
│  R │                                                         │
│  Í │                                                         │
│  T │                    [Sem MFA]                            │
│  I │                                                         │
│  C │                                                         │
│  O │  [Logs Locais]     [Sem IDS]    [Firewall Permissivo]   │
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
│                  Fluxo de Logs                          │
│                                                         │
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
│  ┌──────────────────────────────┐                       │
│  │  Servidor de Logs Central    │                       │
│  │  (Opcional - não no lab)     │                       │
│  │                              │                       │
│  │  - Agregação                 │                       │
│  │  - Indexação                 │                       │
│  │  - Alertas                   │                       │
│  │  - Retenção                  │                       │
│  └──────────────────────────────┘                       │
│                    │                                    │
│                    ▼                                    │
│  ┌──────────────────────────────┐                       │
│  │  SIEM / Dashboard            │                       │
│  │  (Grafana/ELK)               │                       │
│  └──────────────────────────────┘                       │
└─────────────────────────────────────────────────────────┘
```
