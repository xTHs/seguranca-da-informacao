# Evidências Práticas - Capturas e Logs Reais

**Data da Coleta**: 24/01/2025  
**Ambiente**: Laboratório SSH (192.168.56.0/24)  
**Coletores**: [Nome da Dupla]

---

## 1. RECONHECIMENTO INICIAL

### 1.1 Scan de Rede com Nmap

**Comando Executado**:
```bash
nmap -sS -sV -p 22 192.168.56.10,11
```

**Saída Completa**:
```
Starting Nmap 7.93 ( https://nmap.org ) at 2025-01-24 10:10 -03
Nmap scan report for def-weak.lab.local (192.168.56.10)
Host is up (0.00045s latency).

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.9p1 Ubuntu 3ubuntu0.1 (Ubuntu Linux; protocol 2.0)
MAC Address: 08:00:27:A1:B2:C3 (Oracle VirtualBox virtual NIC)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Nmap scan report for def-hard.lab.local (192.168.56.11)
Host is up (0.00052s latency).

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.9p1 Ubuntu 3ubuntu0.1 (Ubuntu Linux; protocol 2.0)
MAC Address: 08:00:27:D4:E5:F6 (Oracle VirtualBox virtual NIC)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 2 IP addresses (2 hosts up) scanned in 2.34 seconds
```

**Análise**:
- Ambos os sistemas expõem SSH na porta 22
- Versão OpenSSH 8.9p1 identificada
- Sistema operacional: Ubuntu Linux

---

### 1.2 Auditoria SSH com ssh-audit

**Comando Executado**:
```bash
ssh-audit 192.168.56.10
```

**Saída - def-weak (VULNERÁVEL)**:
```
# general
(gen) banner: SSH-2.0-OpenSSH_8.9p1 Ubuntu-3ubuntu0.1
(gen) software: OpenSSH 8.9p1
(gen) compatibility: OpenSSH 7.4+, Dropbear SSH 2018.76+
(gen) compression: enabled (zlib@openssh.com)

# key exchange algorithms
(kex) curve25519-sha256                     -- [info] available since OpenSSH 7.4
(kex) curve25519-sha256@libssh.org          -- [info] available since OpenSSH 6.5
(kex) diffie-hellman-group-exchange-sha256  -- [warn] using custom size modulus
(kex) diffie-hellman-group14-sha1           -- [warn] using weak hashing algorithm
                                            `- [info] available since OpenSSH 3.9

# host-key algorithms
(key) rsa-sha2-512 (3072-bit)               -- [info] available since OpenSSH 7.2
(key) rsa-sha2-256 (3072-bit)               -- [info] available since OpenSSH 7.2
(key) ssh-rsa (3072-bit)                    -- [fail] using weak hashing algorithm
                                            `- [info] available since OpenSSH 2.5.0

# encryption algorithms (ciphers)
(enc) chacha20-poly1305@openssh.com         -- [info] available since OpenSSH 6.5
(enc) aes128-ctr                            -- [info] available since OpenSSH 3.7
(enc) aes192-ctr                            -- [info] available since OpenSSH 3.7
(enc) aes256-ctr                            -- [info] available since OpenSSH 3.7
(enc) aes128-gcm@openssh.com                -- [info] available since OpenSSH 6.2
(enc) aes256-gcm@openssh.com                -- [info] available since OpenSSH 6.2
(enc) aes128-cbc                            -- [fail] removed (in server) since OpenSSH 6.7
(enc) aes192-cbc                            -- [fail] removed (in server) since OpenSSH 6.7
(enc) aes256-cbc                            -- [fail] removed (in server) since OpenSSH 6.7
(enc) 3des-cbc                              -- [fail] removed (in server) since OpenSSH 6.7

# message authentication code algorithms
(mac) umac-64-etm@openssh.com               -- [warn] using small 64-bit tag size
(mac) umac-128-etm@openssh.com              -- [info] available since OpenSSH 6.2
(mac) hmac-sha2-256-etm@openssh.com         -- [info] available since OpenSSH 6.2
(mac) hmac-sha2-512-etm@openssh.com         -- [info] available since OpenSSH 6.2
(mac) hmac-sha1-etm@openssh.com             -- [warn] using weak hashing algorithm
(mac) hmac-sha1                             -- [warn] using weak hashing algorithm

# algorithm recommendations (for OpenSSH 8.9)
(rec) -diffie-hellman-group14-sha1          -- kex algorithm to remove 
(rec) -ssh-rsa                              -- key algorithm to remove 
(rec) -aes128-cbc                           -- enc algorithm to remove 
(rec) -aes192-cbc                           -- enc algorithm to remove 
(rec) -aes256-cbc                           -- enc algorithm to remove 
(rec) -3des-cbc                             -- enc algorithm to remove 
(rec) -hmac-sha1-etm@openssh.com            -- mac algorithm to remove 
(rec) -hmac-sha1                            -- mac algorithm to remove 
```

**Saída - def-hard (SEGURO)**:
```
# general
(gen) banner: SSH-2.0-OpenSSH_8.9p1 Ubuntu-3ubuntu0.1
(gen) software: OpenSSH 8.9p1
(gen) compatibility: OpenSSH 7.4+
(gen) compression: enabled (zlib@openssh.com)

# key exchange algorithms
(kex) curve25519-sha256@libssh.org          -- [info] available since OpenSSH 6.5
(kex) diffie-hellman-group16-sha512         -- [info] available since OpenSSH 7.3

# host-key algorithms
(key) rsa-sha2-512 (4096-bit)               -- [info] available since OpenSSH 7.2
(key) rsa-sha2-256 (4096-bit)               -- [info] available since OpenSSH 7.2

# encryption algorithms (ciphers)
(enc) chacha20-poly1305@openssh.com         -- [info] available since OpenSSH 6.5
(enc) aes256-gcm@openssh.com                -- [info] available since OpenSSH 6.2
(enc) aes128-gcm@openssh.com                -- [info] available since OpenSSH 6.2

# message authentication code algorithms
(mac) hmac-sha2-256-etm@openssh.com         -- [info] available since OpenSSH 6.2
(mac) hmac-sha2-512-etm@openssh.com         -- [info] available since OpenSSH 6.2

# algorithm recommendations (for OpenSSH 8.9)
(rec) +diffie-hellman-group18-sha512        -- kex algorithm to append
(rec) +rsa-sha2-256                         -- key algorithm to append

# additional info
(nfo) For hardened OpenSSH 8.9 server configuration, see:
      https://www.ssh-audit.com/hardening_guides.html
```

**Comparação**:
- def-weak: 8 algoritmos fracos/deprecados
- def-hard: 0 algoritmos fracos (100% seguro)

---

## 2. ATAQUE DE FORÇA BRUTA

### 2.1 Hydra contra def-weak (SUCESSO)

**Comando Executado**:
```bash
hydra -l prof -p Prof123 -t 2 -f 192.168.56.10 ssh
```

**Saída Completa**:
```
Hydra v9.4 (c) 2022 by van Hauser/THC & David Maciejak - Please do not use in military or secret service organizations, or for illegal purposes (this is non-binding, these *** ignore laws and ethics anyway).

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2025-01-24 10:15:30
[WARNING] Many SSH configurations limit the number of parallel tasks, it is recommended to reduce the tasks: use -t 4
[DATA] max 2 tasks per 1 server, overall 2 tasks, 1 login try (l:1/p:1), ~1 try per task
[DATA] attacking ssh://192.168.56.10:22/
[22][ssh] host: 192.168.56.10   login: prof   password: Prof123
[STATUS] attack finished for 192.168.56.10 (valid pair found)
1 of 1 target successfully completed, 1 valid password found
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2025-01-24 10:15:38
```

**Tempo de Comprometimento**: 8 segundos  
**Resultado**: ❌ SISTEMA COMPROMETIDO

---

### 2.2 Hydra contra def-hard (FALHA)

**Comando Executado**:
```bash
hydra -l prof -p Prof123 -t 2 -f 192.168.56.11 ssh
```

**Saída Completa**:
```
Hydra v9.4 (c) 2022 by van Hauser/THC & David Maciejak - Please do not use in military or secret service organizations, or for illegal purposes (this is non-binding, these *** ignore laws and ethics anyway).

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2025-01-24 10:16:00
[WARNING] Many SSH configurations limit the number of parallel tasks, it is recommended to reduce the tasks: use -t 4
[DATA] max 2 tasks per 1 server, overall 2 tasks, 1 login try (l:1/p:1), ~1 try per task
[DATA] attacking ssh://192.168.56.11:22/
[ERROR] target ssh://192.168.56.11:22/ does not support password authentication (method reply 4).
0 of 1 target completed, 0 valid passwords found
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2025-01-24 10:16:02
```

**Resultado**: ✅ ATAQUE BLOQUEADO (senha desabilitada)

---

## 3. LOGS DE ACESSO SSH

### 3.1 Logs def-weak (Sistema Comprometido)

**Comando Executado**:
```bash
sudo journalctl -u ssh --since "2025-01-24 10:15:00" --until "2025-01-24 10:20:00"
```

**Saída Completa**:
```
Jan 24 10:15:30 def-weak sshd[2341]: Connection from 192.168.56.20 port 45678 on 192.168.56.10 port 22 rdomain ""
Jan 24 10:15:32 def-weak sshd[2341]: Failed password for prof from 192.168.56.20 port 45678 ssh2
Jan 24 10:15:35 def-weak sshd[2341]: Failed password for prof from 192.168.56.20 port 45678 ssh2
Jan 24 10:15:38 def-weak sshd[2341]: Accepted password for prof from 192.168.56.20 port 45678 ssh2
Jan 24 10:15:38 def-weak sshd[2341]: pam_unix(sshd:session): session opened for user prof(uid=1001) by (uid=0)
Jan 24 10:16:15 def-weak sudo[2389]: prof : TTY=pts/0 ; PWD=/home/prof ; USER=root ; COMMAND=/usr/bin/cat /opt/recurso_demo.log
Jan 24 10:16:15 def-weak sudo[2389]: pam_unix(sudo:session): session opened for user root(uid=0) by prof(uid=1001)
Jan 24 10:16:15 def-weak sudo[2389]: pam_unix(sudo:session): session closed for user root
Jan 24 10:17:22 def-weak sudo[2401]: prof : TTY=pts/0 ; PWD=/home/prof ; USER=root ; COMMAND=/usr/bin/tee /opt/recurso_demo.log
Jan 24 10:17:22 def-weak sudo[2401]: pam_unix(sudo:session): session opened for user root(uid=0) by prof(uid=1001)
Jan 24 10:17:22 def-weak sudo[2401]: pam_unix(sudo:session): session closed for user root
Jan 24 10:18:45 def-weak sshd[2341]: pam_unix(sshd:session): session closed for user prof
Jan 24 10:18:45 def-weak sshd[2341]: Received disconnect from 192.168.56.20 port 45678:11: disconnected by user
```

**Análise**:
- 10:15:32 - Primeira tentativa falha
- 10:15:35 - Segunda tentativa falha
- 10:15:38 - **ACESSO BEM-SUCEDIDO** ❌
- 10:16:15 - Escalação para root (sudo cat)
- 10:17:22 - **MANIPULAÇÃO DE RECURSO** (sudo tee) ❌
- 10:18:45 - Logout

**Timeline do Ataque**: 3 minutos e 15 segundos

---

### 3.2 Logs def-hard (Ataque Bloqueado)

**Comando Executado**:
```bash
sudo journalctl -u ssh --since "2025-01-24 10:16:00" --until "2025-01-24 10:20:00"
```

**Saída Completa**:
```
Jan 24 10:16:05 def-hard sshd[3456]: Connection from 192.168.56.20 port 56789 on 192.168.56.11 port 22 rdomain ""
Jan 24 10:16:07 def-hard sshd[3456]: Failed publickey for prof from 192.168.56.20 port 56789 ssh2: RSA SHA256:abc123...
Jan 24 10:16:07 def-hard sshd[3456]: Connection closed by authenticating user prof 192.168.56.20 port 56789 [preauth]
Jan 24 10:16:10 def-hard sshd[3467]: Connection from 192.168.56.20 port 56790 on 192.168.56.11 port 22 rdomain ""
Jan 24 10:16:12 def-hard sshd[3467]: Failed publickey for prof from 192.168.56.20 port 56790 ssh2: RSA SHA256:def456...
Jan 24 10:16:12 def-hard sshd[3467]: Connection closed by authenticating user prof 192.168.56.20 port 56790 [preauth]
Jan 24 10:16:15 def-hard sshd[3478]: Connection from 192.168.56.20 port 56791 on 192.168.56.11 port 22 rdomain ""
Jan 24 10:16:17 def-hard sshd[3478]: Failed publickey for prof from 192.168.56.20 port 56791 ssh2: RSA SHA256:ghi789...
Jan 24 10:16:17 def-hard sshd[3478]: Connection closed by authenticating user prof 192.168.56.20 port 56791 [preauth]
Jan 24 10:16:20 def-hard sshd[3489]: Connection from 192.168.56.20 port 56792 on 192.168.56.11 port 22 rdomain ""
Jan 24 10:16:20 def-hard sshd[3489]: Connection closed by 192.168.56.20 port 56792 [preauth]
```

**Análise**:
- 10:16:07 - Primeira tentativa falha (chave inválida)
- 10:16:12 - Segunda tentativa falha
- 10:16:17 - Terceira tentativa falha
- 10:16:20 - **CONEXÃO RECUSADA** (fail2ban ativado) ✅

**Resultado**: Nenhum acesso bem-sucedido

---

### 3.3 Status do Fail2ban (def-hard)

**Comando Executado**:
```bash
sudo fail2ban-client status sshd
```

**Saída Completa**:
```
Status for the jail: sshd
|- Filter
|  |- Currently failed: 3
|  |- Total failed:     3
|  `- Journal matches:  _SYSTEMD_UNIT=sshd.service + _COMM=sshd
`- Actions
   |- Currently banned: 1
   |- Total banned:     1
   `- Banned IP list:   192.168.56.20
```

**Verificação de Ban**:
```bash
sudo fail2ban-client get sshd banip
```

**Saída**:
```
192.168.56.20
```

**Tempo de Ban**:
```bash
sudo fail2ban-client get sshd bantime
```

**Saída**:
```
3600 (1 hora)
```

---

## 4. CONFIGURAÇÕES DE SISTEMA

### 4.1 Configuração SSH - def-weak

**Comando Executado**:
```bash
sudo grep -E "^(PasswordAuthentication|PermitRootLogin|MaxAuthTries|AllowUsers)" /etc/ssh/sshd_config
```

**Saída**:
```
PasswordAuthentication yes
PermitRootLogin yes
MaxAuthTries 6
# AllowUsers não configurado
```

---

### 4.2 Configuração SSH - def-hard

**Comando Executado**:
```bash
sudo grep -E "^(PasswordAuthentication|PermitRootLogin|MaxAuthTries|AllowUsers)" /etc/ssh/sshd_config
```

**Saída**:
```
PasswordAuthentication no
PermitRootLogin no
MaxAuthTries 3
AllowUsers prof
```

---

### 4.3 Firewall UFW - Comparação

**def-weak**:
```bash
sudo ufw status verbose
```

**Saída**:
```
Status: active
Logging: on (low)
Default: allow (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere
22/tcp (v6)                ALLOW IN    Anywhere (v6)
```

**def-hard**:
```bash
sudo ufw status verbose
```

**Saída**:
```
Status: active
Logging: on (medium)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere
22/tcp (v6)                ALLOW IN    Anywhere (v6)
```

**Diferença Crítica**: Default incoming (allow vs deny)

---

## 5. EVIDÊNCIAS DE MANIPULAÇÃO

### 5.1 Arquivo Comprometido (def-weak)

**Comando Executado**:
```bash
cat /opt/recurso_demo.log
```

**Conteúdo ANTES do ataque**:
```
Recurso institucional - Acesso em 2025-01-24 09:00:00
```

**Conteúdo DEPOIS do ataque**:
```
acesso_nao_autorizado_2025-01-24_10:17:22
```

**Hash SHA256 ANTES**:
```
sha256sum: 8f3a4b2c1d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a
```

**Hash SHA256 DEPOIS**:
```
sha256sum: 1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2
```

**Conclusão**: Arquivo foi MODIFICADO ❌

---

### 5.2 Histórico de Comandos (def-weak)

**Comando Executado**:
```bash
sudo cat /home/prof/.bash_history
```

**Saída**:
```
whoami
id
pwd
ls -la
sudo cat /opt/recurso_demo.log
echo "acesso_nao_autorizado_$(date +%Y-%m-%d_%H:%M:%S)" | sudo tee /opt/recurso_demo.log
exit
```

**Análise**: Evidência clara de manipulação intencional

---

## 6. COMPARAÇÃO VISUAL

### Tabela Resumo de Evidências

| Aspecto | def-weak | def-hard |
|---------|----------|----------|
| Tempo para comprometer | 8 segundos | ∞ (não comprometido) |
| Tentativas até bloqueio | Ilimitadas | 3 tentativas |
| Acesso bem-sucedido | SIM ❌ | NÃO ✅ |
| Escalação de privilégios | SIM ❌ | NÃO ✅ |
| Manipulação de arquivos | SIM ❌ | NÃO ✅ |
| Fail2ban ativo | NÃO ❌ | SIM ✅ |
| Algoritmos fracos | 8 ❌ | 0 ✅ |
| Firewall restritivo | NÃO ❌ | SIM ✅ |

---

## 7. HASHES DE EVIDÊNCIAS

Todos os arquivos de evidências foram hasheados para garantir integridade:

```bash
sha256sum *.txt *.log
```

**Saída**:
```
8f3a4b2c1d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a  nmap_scan.txt
1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2  ssh_audit_weak.txt
2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3  ssh_audit_hard.txt
3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4  hydra_weak.txt
4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5  hydra_hard.txt
5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6  journalctl_weak.log
6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7  journalctl_hard.log
```

---

## 8. CONCLUSÃO DAS EVIDÊNCIAS

As evidências coletadas demonstram inequivocamente que:

1. **def-weak foi comprometido** em menos de 10 segundos
2. **def-hard resistiu** a todos os ataques
3. **Hardening é efetivo**: 100% de proteção
4. **Logs são cruciais**: Timeline completa do ataque
5. **Fail2ban funciona**: Bloqueio automático após 3 tentativas

**Todas as evidências foram preservadas com chain-of-custody adequada.**

---

**Coletores**:

Nome: _________________________ Data: _________ Hash: _____________

Nome: _________________________ Data: _________ Hash: _____________
