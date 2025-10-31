# Segurança da Informação
Esse repositório tem a finalidade de treinar minhas habilidades em segurança.

## Projeto Laboratório SSH - Comparação A/B

### 📋 O que é este projeto?
Este laboratório demonstra a diferença entre um sistema **inseguro** e um sistema **endurecido** através de 3 máquinas virtuais que simulam um ambiente real de teste de segurança.

### 🏗️ Topologia de Rede

```
┌─────────────────────────────────────────────────────────┐
│          Rede Isolada: 192.168.56.0/24                  │
│              (Host-Only Network)                         │
└─────────────────────────────────────────────────────────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼
┌───────────────┐  ┌───────────────┐  ┌───────────────┐
│  def-weak     │  │  def-hard     │  │  atacante     │
│  .10          │  │  .11          │  │  .20          │
├───────────────┤  ├───────────────┤  ├───────────────┤
│ ❌ INSEGURO   │  │ ✅ SEGURO     │  │ 🔧 TESTES     │
│               │  │               │  │               │
│ • Senha fraca │  │ • Chaves SSH  │  │ • nmap        │
│ • Fail2ban    │  │ • Fail2ban ON │  │ • hydra       │
│   OFF         │  │ • UFW deny    │  │ • ssh-audit   │
│ • UFW allow   │  │ • Algoritmos  │  │ • tcpdump     │
│ • Root login  │  │   seguros     │  │               │
└───────────────┘  └───────────────┘  └───────────────┘
```

**Configuração:**
- **def-weak**: 192.168.56.10 (def-weak.lab.local) - Defensor INSEGURO
- **def-hard**: 192.168.56.11 (def-hard.lab.local) - Defensor ENDURECIDO  
- **atacante**: 192.168.56.20 (atacante.lab.local) - Máquina de testes

---

## 🚀 Guia Passo a Passo para Leigos

### Passo 1: Instalar Pré-requisitos

#### 🪟 Windows:
1. **Baixar VirtualBox**: https://www.virtualbox.org/wiki/Downloads
   - Clicar em "Windows hosts"
   - Instalar com configurações padrão
2. **Baixar Vagrant**: https://www.vagrantup.com/downloads
   - Escolher versão Windows
   - Instalar com configurações padrão
3. **Reiniciar o computador** após as instalações

#### 🐧 Linux (Ubuntu/Debian):
```bash
sudo apt update
sudo apt install virtualbox vagrant git
sudo usermod -aG vboxusers $USER
sudo reboot  # Reiniciar é obrigatório!
```

#### 🍎 macOS (com Homebrew):
```bash
brew install virtualbox vagrant git
```

### Passo 2: Baixar o Projeto
```bash
# Clonar o repositório
git clone https://github.com/xTHs/seguranca-da-informacao.git

# Entrar no diretório do projeto
cd seguranca-da-informacao/projeto-incidente-ssh
```

### Passo 3: Subir o Laboratório
```bash
# Este comando criará e configurará as 3 VMs automaticamente
# ⏱️ Pode demorar 10-15 minutos na primeira execução
vagrant up

# Verificar se todas as VMs estão rodando
vagrant status
```

**✅ Resultado esperado:**
```
Current machine states:
def-weak    running (virtualbox)
def-hard    running (virtualbox)
atacante    running (virtualbox)
```

### Passo 4: Acessar as Máquinas
```bash
# Acessar máquina atacante (onde faremos os testes)
vagrant ssh atacante

# Em outras abas/terminais, você pode acessar:
vagrant ssh def-weak   # Máquina vulnerável
vagrant ssh def-hard   # Máquina protegida
```

---

## 🧪 Experimentos Práticos (Comparação A/B)

### Experimento 1: Descoberta de Serviços 🔍
**Execute na máquina atacante:**
```bash
# Descobrir quais máquinas têm SSH aberto
nmap -sS -sV -p 22 192.168.56.10,11
```

**📊 Resultado esperado:**
```
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.9p1 Ubuntu (protocol 2.0)
```
✅ Ambas as máquinas têm SSH na porta 22

---

### Experimento 2: Auditoria de Segurança SSH 🔐
```bash
# Auditar máquina INSEGURA
ssh-audit 192.168.56.10

# Auditar máquina SEGURA
ssh-audit 192.168.56.11
```

**📊 Compare os resultados:**

| Aspecto | def-weak (.10) | def-hard (.11) |
|---------|----------------|----------------|
| PasswordAuthentication | ❌ yes | ✅ no |
| PermitRootLogin | ❌ yes | ✅ no |
| MaxAuthTries | ❌ 6 | ✅ 3 |
| Algoritmos fracos | ❌ Habilitados | ✅ Desabilitados |
| Fail2ban | ❌ OFF | ✅ ON |

---

### Experimento 3: Teste de Acesso com Senha 🔑
```bash
# Tentar acessar máquina INSEGURA (deve funcionar)
ssh prof@192.168.56.10
# Quando pedir senha, digite: Prof123
# ✅ Acesso concedido!

# Sair da sessão
exit

# Tentar acessar máquina SEGURA (deve falhar)
ssh prof@192.168.56.11
# Digite qualquer senha
# ❌ Permission denied (senha desabilitada)
```

**📊 Resultado:**
- **def-weak**: Acesso com senha fraca funciona ❌
- **def-hard**: Senha rejeitada, apenas chaves SSH ✅

---

### Experimento 4: Simulação de Ataque de Força Bruta ⚔️
```bash
# Ataque à máquina INSEGURA (sucesso)
hydra -l prof -p Prof123 -t 2 -f 192.168.56.10 ssh
```

**📊 Resultado esperado:**
```
[22][ssh] host: 192.168.56.10   login: prof   password: Prof123
1 of 1 target successfully completed
```
❌ **def-weak**: Ataque bem-sucedido!

```bash
# Ataque à máquina SEGURA (bloqueado)
hydra -l prof -p Prof123 -t 2 -f 192.168.56.11 ssh
```

**📊 Resultado esperado:**
```
[ERROR] target ssh://192.168.56.11:22/ does not support password authentication
```
✅ **def-hard**: Ataque bloqueado (senha desabilitada + fail2ban)

---

### Experimento 5: Análise de Logs e Evidências 📝

**Conectar na máquina def-hard:**
```bash
vagrant ssh def-hard
```

**Analisar tentativas de acesso:**
```bash
# Ver tentativas de acesso SSH nos últimos 15 minutos
sudo journalctl -u ssh --since "-15 min"

# Ver status do fail2ban
sudo fail2ban-client status sshd

# Ver IPs banidos
sudo fail2ban-client get sshd banip
```

**📊 Resultado esperado:**
```
Status for the jail: sshd
|- Filter
|  |- Currently failed: 0
|  |- Total failed:     3
|  `- File list:        /var/log/auth.log
`- Actions
   |- Currently banned: 1
   |- Total banned:     1
   `- Banned IP list:   192.168.56.20
```
✅ IP do atacante foi banido automaticamente!

---

## 🎓 O que Você Aprenderá

### 🔴 Vulnerabilidades Demonstradas:

1. **Senhas Fracas** 
   - def-weak: Prof123 (8 caracteres, previsível)
   - def-hard: Senha desabilitada, apenas chaves SSH

2. **Configurações SSH Permissivas**
   - def-weak: Root login permitido, 6 tentativas
   - def-hard: Root bloqueado, apenas 3 tentativas

3. **Ausência de Proteção contra Brute Force**
   - def-weak: Sem fail2ban, ataques ilimitados
   - def-hard: Fail2ban bane após 3 tentativas

4. **Firewall Permissivo**
   - def-weak: UFW default allow (tudo permitido)
   - def-hard: UFW default deny (apenas SSH permitido)

5. **Algoritmos Criptográficos Fracos**
   - def-weak: Algoritmos antigos habilitados
   - def-hard: Apenas algoritmos modernos e seguros

### ✅ Técnicas de Defesa Aplicadas:

- ✅ Desabilitação de autenticação por senha
- ✅ Configuração de fail2ban com banimento automático
- ✅ Hardening de SSH (PermitRootLogin no, MaxAuthTries 3)
- ✅ Configuração restritiva de firewall (UFW)
- ✅ Uso exclusivo de algoritmos criptográficos seguros
- ✅ Monitoramento e análise de logs
- ✅ Princípio do menor privilégio (AllowUsers)

---

## 🛠️ Comandos Úteis

### Gerenciar VMs:
```bash
vagrant up              # Subir todas as VMs
vagrant halt            # Desligar todas as VMs
vagrant destroy         # Destruir todas as VMs (apaga tudo)
vagrant reload          # Reiniciar VMs
vagrant status          # Ver status das VMs
vagrant suspend         # Suspender VMs (salva estado)
vagrant resume          # Retomar VMs suspensas
```

### Acessar VMs específicas:
```bash
vagrant ssh def-weak     # Máquina vulnerável
vagrant ssh def-hard     # Máquina protegida
vagrant ssh atacante     # Máquina atacante
```

### Gerenciar VMs individualmente:
```bash
vagrant up def-weak      # Subir apenas def-weak
vagrant halt atacante    # Desligar apenas atacante
vagrant reload def-hard  # Reiniciar apenas def-hard
```

### Solução de Problemas:
```bash
# Se algo der errado, destruir e recriar:
vagrant destroy -f
vagrant up

# Ver logs detalhados:
vagrant up --debug

# Reprovisionar (reexecutar scripts):
vagrant provision

# Verificar versões:
vagrant --version
vboxmanage --version
```

---

## 🔄 Próximos Passos

### Após Completar os Experimentos:

#### 🎯 Nível Iniciante:
1. **Repetir os testes** várias vezes para fixar conceitos
2. **Documentar** os resultados em um relatório
3. **Comparar** capturas de tela antes/depois
4. **Apresentar** para colegas/professor

#### 🎯 Nível Intermediário:
1. **Adicionar 2FA** no def-hard (Google Authenticator)
2. **Configurar SIEM** centralizado para logs
3. **Criar mais cenários** de ataque (port scanning, etc)
4. **Automatizar** coleta de evidências com scripts

#### 🎯 Nível Avançado:
1. **Implementar IDS/IPS** (Snort, Suricata)
2. **Adicionar honeypot** para detectar atacantes
3. **Configurar VPN** entre as máquinas
4. **Criar dashboard** de monitoramento (Grafana)
5. **Simular APT** (Advanced Persistent Threat)

### 📚 Recursos para Aprofundamento:
- **SSH Hardening**: https://www.ssh.com/academy/ssh/security
- **Fail2ban**: https://www.fail2ban.org/wiki/index.php/Main_Page
- **NIST Cybersecurity**: https://www.nist.gov/cyberframework
- **OWASP Top 10**: https://owasp.org/www-project-top-ten/

---

## ⚠️ Avisos Importantes

### 🔒 Segurança e Ética:

> **⚠️ ATENÇÃO LEGAL:**
> - Este laboratório é para **FINS EDUCACIONAIS APENAS**
> - **USO EXCLUSIVO EM AMBIENTE ISOLADO**
> - **NUNCA atacar sistemas sem autorização expressa**
> - Ataques não autorizados são **CRIME** (Lei 12.737/2012 - Brasil)
> - Violações podem resultar em **prisão e multas**

### 🎯 Uso Correto:
- ✅ Ambiente isolado (rede host-only)
- ✅ Máquinas virtuais próprias
- ✅ Fins acadêmicos e treinamento
- ✅ Documentação de aprendizado

### ❌ Uso Proibido:
- ❌ Atacar sistemas de terceiros
- ❌ Usar em redes produtivas
- ❌ Compartilhar credenciais reais
- ❌ Aplicar técnicas sem autorização

### 🔑 Credenciais de Demonstração:
- **Usuário**: prof
- **Senha**: Prof123
- **⚠️ APENAS PARA LABORATÓRIO - NUNCA USE EM PRODUÇÃO**

### 💻 Requisitos do Sistema:
- **RAM**: Mínimo 6GB disponível (8GB recomendado)
- **CPU**: 2+ cores (4+ recomendado)
- **Disco**: 15GB livres
- **SO**: Windows 10+, Linux (Ubuntu 22.04+), macOS 11+
- **Virtualização**: VT-x/AMD-V habilitado na BIOS

---

## 📚 Estrutura do Projeto
```
projeto-incidente-ssh/
├── Vagrantfile                 # Configuração das 3 VMs
├── provision/                  # Scripts de configuração automática
│   ├── def_weak_provision.sh   # Configuração insegura (intencional)
│   ├── def_hard_provision.sh   # Configuração segura (hardening)
│   └── atacante_provision.sh   # Ferramentas de teste (nmap, hydra)
├── docs/                       # Documentação forense
│   ├── chain-of-custody.md     # Template de cadeia de custódia
│   ├── runbook_coleta_live.md  # Procedimentos de coleta de evidências
│   ├── vulnerabilidades-mapeadas.md  # Detalhamento técnico
│   └── politica-uso-aceitavel.md     # Política de segurança
├── scripts/                    # Scripts de automação
│   ├── hash-evidence.sh        # Cálculo de hashes SHA256
│   └── dia3-incidente.sh       # Simulação de incidente
├── evidence/                   # Diretório para evidências coletadas
├── .gitignore                  # Arquivos ignorados pelo Git
└── README.md                   # Este guia
```

---

## 🆘 Precisa de Ajuda?

### Problemas Comuns e Soluções:

#### ❌ "VMs não sobem"
```bash
# Verificar se VirtualBox está instalado
vboxmanage --version

# Verificar se Vagrant está instalado
vagrant --version

# Verificar se virtualização está habilitada
egrep -c '(vmx|svm)' /proc/cpuinfo  # Linux
# Se retornar 0, habilitar VT-x/AMD-V na BIOS
```

#### ❌ "Sem memória suficiente"
```bash
# Reduzir memória das VMs no Vagrantfile:
# Alterar de 2048 para 1536 MB
vb.memory = "1536"
```

#### ❌ "Vagrant não encontrado após instalação"
```bash
# Reiniciar terminal ou computador
# Verificar PATH:
echo $PATH  # Linux/Mac
echo %PATH%  # Windows
```

#### ❌ "Rede não funciona entre VMs"
```bash
# Verificar rede host-only no VirtualBox
VBoxManage list hostonlyifs

# Recriar rede se necessário
vagrant destroy -f
vagrant up
```

#### ❌ "SSH não conecta"
```bash
# Verificar status do SSH na VM
vagrant ssh def-weak
sudo systemctl status ssh

# Verificar firewall
sudo ufw status
```

### 📞 Suporte:
- **Issues GitHub**: https://github.com/xTHs/seguranca-da-informacao/issues
- **Logs detalhados**: `vagrant up --debug > vagrant.log 2>&1`
- **Documentação Vagrant**: https://www.vagrantup.com/docs
- **Documentação VirtualBox**: https://www.virtualbox.org/manual/

---

## 📊 Checklist de Validação

Antes de considerar o laboratório completo, verifique:

- [ ] VirtualBox instalado e funcionando
- [ ] Vagrant instalado e funcionando
- [ ] 3 VMs criadas com sucesso (`vagrant status`)
- [ ] Consegue acessar as 3 VMs via SSH
- [ ] nmap detecta SSH nas 3 máquinas
- [ ] ssh-audit mostra diferenças entre def-weak e def-hard
- [ ] Consegue logar no def-weak com Prof123
- [ ] Não consegue logar no def-hard com senha
- [ ] Hydra tem sucesso no def-weak
- [ ] Hydra falha no def-hard
- [ ] Fail2ban está ativo no def-hard
- [ ] Logs SSH são visíveis com journalctl
- [ ] Documentou os resultados dos experimentos

---

## 🏆 Conclusão

Este laboratório demonstra na prática a diferença entre um sistema vulnerável e um sistema endurecido. Através de experimentos hands-on, você aprendeu:

- ✅ Como identificar vulnerabilidades SSH
- ✅ Como explorar sistemas inseguros (eticamente)
- ✅ Como implementar defesas efetivas
- ✅ Como monitorar e analisar tentativas de ataque
- ✅ A importância do hardening de sistemas

**🎓 Continue aprendendo e use esse conhecimento de forma ética e responsável!**

---

**📝 Última atualização**: 2025-01-24  
**👤 Autor**: [Seu Nome]  
**📜 Licença**: MIT (ver arquivo LICENSE)  
**⭐ Se este projeto foi útil, deixe uma estrela no GitHub!**