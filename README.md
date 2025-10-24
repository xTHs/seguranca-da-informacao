# Segurança da Informação
Esse repositório tem a finalidade de treinar minhas habilidades em segurança.

## Projeto Laboratório SSH - Comparação A/B

### 📋 O que é este projeto?
Este laboratório demonstra a diferença entre um sistema **inseguro** e um sistema **endurecido** através de 3 máquinas virtuais que simulam um ambiente real de teste de segurança.

### 🏗️ Topologia (3 VMs)
- **def-weak**: 192.168.56.10 - Defensor INSEGURO (propositalmente vulnerável)
- **def-hard**: 192.168.56.11 - Defensor ENDURECIDO (configuração segura)  
- **atacante**: 192.168.56.20 - Máquina de testes (ferramentas de pentest)

**Rede**: Isolada 192.168.56.0/24 (sem acesso à Internet)

---

## 🚀 Guia Passo a Passo para Leigos

### Passo 1: Instalar Pré-requisitos

#### Windows:
1. **Baixar VirtualBox**: https://www.virtualbox.org/wiki/Downloads
   - Instalar com configurações padrão
2. **Baixar Vagrant**: https://www.vagrantup.com/downloads
   - Instalar com configurações padrão
3. **Reiniciar o computador** após as instalações

#### Linux/Mac:
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install virtualbox vagrant

# macOS (com Homebrew)
brew install virtualbox vagrant
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
# Pode demorar 10-15 minutos na primeira execução
vagrant up

# Verificar se todas as VMs estão rodando
vagrant status
```

**Resultado esperado:**
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

## 🧪 Experimentos Práticos

### Experimento 1: Descoberta de Serviços
**Execute na máquina atacante:**
```bash
# Descobrir quais máquinas têm SSH aberto
nmap -sS -sV -p 22 192.168.56.10,11
```

**O que você verá:**
- Ambas as máquinas têm SSH na porta 22
- Versões do OpenSSH serão mostradas

### Experimento 2: Auditoria de Segurança SSH
```bash
# Auditar máquina INSEGURA
ssh-audit 192.168.56.10

# Auditar máquina SEGURA
ssh-audit 192.168.56.11
```

**Compare os resultados:**
- def-weak: Muitos algoritmos fracos, configurações inseguras
- def-hard: Apenas algoritmos seguros, configurações restritivas

### Experimento 3: Teste de Acesso com Senha
```bash
# Tentar acessar máquina INSEGURA (deve funcionar)
ssh prof@192.168.56.10
# Quando pedir senha, digite: Prof123

# Tentar acessar máquina SEGURA (deve falhar)
ssh prof@192.168.56.11
# Qualquer senha falhará - apenas chaves SSH são aceitas
```

### Experimento 4: Simulação de Ataque de Força Bruta
```bash
# Ataque à máquina INSEGURA (sucesso)
hydra -l prof -p Prof123 -t 2 -f 192.168.56.10 ssh

# Ataque à máquina SEGURA (bloqueado)
hydra -l prof -p Prof123 -t 2 -f 192.168.56.11 ssh
```

**O que acontece:**
- def-weak: Ataque bem-sucedido
- def-hard: IP atacante é banido pelo fail2ban

### Experimento 5: Análise de Logs
**Na máquina def-hard:**
```bash
# Ver tentativas de acesso SSH
sudo journalctl -u ssh --since "-15 min"

# Ver status do fail2ban
sudo fail2ban-client status sshd

# Ver IPs banidos
sudo fail2ban-client get sshd banip
```

---

## 🔍 O que Você Aprenderá

### Vulnerabilidades Demonstradas:
1. **Senhas fracas** vs **Autenticação por chaves**
2. **Configurações SSH permissivas** vs **Configurações restritivas**
3. **Ausência de proteção** vs **Fail2ban ativo**
4. **Firewall permissivo** vs **Firewall restritivo**
5. **Algoritmos criptográficos fracos** vs **Algoritmos seguros**

### Técnicas de Defesa:
- Desabilitação de autenticação por senha
- Configuração de fail2ban
- Hardening de SSH
- Configuração de firewall
- Monitoramento de logs

---

## 🛠️ Comandos Úteis

### Gerenciar VMs:
```bash
vagrant up              # Subir todas as VMs
vagrant halt             # Desligar todas as VMs
vagrant destroy          # Destruir todas as VMs
vagrant reload           # Reiniciar VMs
vagrant status           # Ver status das VMs
```

### Acessar VMs específicas:
```bash
vagrant ssh def-weak     # Máquina vulnerável
vagrant ssh def-hard     # Máquina protegida
vagrant ssh atacante     # Máquina atacante
```

### Solução de Problemas:
```bash
# Se algo der errado, destruir e recriar:
vagrant destroy -f
vagrant up

# Ver logs detalhados:
vagrant up --debug
```

---

## ⚠️ Avisos Importantes

### 🔒 Segurança e Ética:
- **USO EXCLUSIVO EM AMBIENTE ISOLADO**
- **FINS EDUCACIONAIS APENAS**
- **NÃO USAR EM SISTEMAS PRODUTIVOS**
- **NÃO ATACAR SISTEMAS SEM AUTORIZAÇÃO**

### 🎯 Senha de Demonstração:
- **Usuário**: prof
- **Senha**: Prof123
- **⚠️ APENAS PARA LABORATÓRIO - NUNCA USE EM PRODUÇÃO**

### 💻 Requisitos do Sistema:
- **RAM**: Mínimo 6GB disponível
- **CPU**: 2+ cores recomendado
- **Disco**: 10GB livres
- **SO**: Windows 10+, Linux, macOS

---

## 📚 Estrutura do Projeto
```
projeto-incidente-ssh/
├── Vagrantfile                 # Configuração das 3 VMs
├── provision/                  # Scripts de configuração automática
│   ├── def_weak_provision.sh   # Configuração insegura
│   ├── def_hard_provision.sh   # Configuração segura
│   └── atacante_provision.sh   # Ferramentas de teste
├── docs/                       # Documentação forense
│   ├── chain-of-custody.md     # Cadeia de custódia
│   └── runbook_coleta_live.md  # Procedimentos de coleta
└── README.md                   # Este guia
```

---

## 🆘 Precisa de Ajuda?

### Problemas Comuns:
1. **"VMs não sobem"**: Verificar se VirtualBox está instalado e funcionando
2. **"Sem memória"**: Fechar outros programas, liberar RAM
3. **"Vagrant não encontrado"**: Reiniciar terminal após instalação
4. **"Rede não funciona"**: Verificar se VirtualBox Host-Only está ativo

### Contato:
- Abrir issue no GitHub
- Verificar logs com `vagrant up --debug`

**🎓 Bom aprendizado e use com responsabilidade!**