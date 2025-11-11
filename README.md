# Segurança da Informação - Lab SSH

Laboratório prático de segurança SSH com 2 VMs isoladas para testes éticos.

## 🏗️ Arquitetura

```
┌─────────────────────────────────────┐
│    Rede: 192.168.56.0/24            │
│    (Host-Only Network)              │
└─────────────────────────────────────┘
              │
      ┌───────┴───────┐
      ▼               ▼
┌──────────┐    ┌──────────┐
│def-weak  │    │atacante  │
│.10       │    │.20       │
├──────────┤    ├──────────┤
│❌ ALVO   │    │🔧 TESTES │
│Senha     │    │nmap      │
│fraca     │    │hydra     │
│Root      │    │ssh-audit │
│login     │    │tcpdump   │
└──────────┘    └──────────┘
```

## 🚀 Setup Rápido

### Ubuntu
```bash
# Instalar dependências
sudo apt update
sudo apt install -y virtualbox vagrant

# Clonar e executar
git clone https://github.com/xTHs/seguranca-da-informacao.git
cd seguranca-da-informacao
vagrant up
```

### Windows
- VirtualBox: https://www.virtualbox.org/wiki/Downloads
- Vagrant: https://www.vagrantup.com/downloads
- Executar: `vagrant up`

**Requisitos:** 2GB RAM, virtualização habilitada na BIOS

### Acesso

```bash
vagrant ssh atacante    # Máquina de testes
vagrant ssh def-weak    # Máquina vulnerável
```

## 🧪 Experimentos

### 1. Descoberta
```bash
# Na VM atacante
nmap -sS -sV -p 22 192.168.56.10
```

### 2. Auditoria
```bash
ssh-audit 192.168.56.10
```

### 3. Teste de Acesso
```bash
ssh prof@192.168.56.10
# Senha: Prof123
```

### 4. Força Bruta
```bash
hydra -l prof -p Prof123 -t 2 192.168.56.10 ssh
```

### 5. Análise de Logs
```bash
# Na VM def-weak
sudo journalctl -u ssh --since "-15 min"
sudo tail -f /var/log/auth.log
```

### 6. Hardening (Opcional)
```bash
# Na VM atacante
cd /vagrant/scripts
./hardening.sh
```

## 🎓 Vulnerabilidades Demonstradas

| Vulnerabilidade | Impacto | Mitigação |
|----------------|---------|-----------|
| Senha fraca | Alto | Chaves SSH + senha forte |
| Root login | Crítico | PermitRootLogin no |
| 6 tentativas | Médio | MaxAuthTries 3 + fail2ban |
| Firewall aberto | Alto | UFW default deny |
| Algoritmos fracos | Médio | Desabilitar ciphers antigos |

## 🛠️ Comandos Úteis

```bash
vagrant status          # Ver status
vagrant up              # Subir VMs
vagrant halt            # Desligar VMs
vagrant destroy -f      # Destruir VMs
vagrant reload          # Reiniciar VMs
```

## 📁 Estrutura

```
seguranca-da-informacao/
├── Vagrantfile                    # Configuração das VMs
├── provision/
│   ├── def_weak_provision.sh      # Setup vulnerável
│   └── atacante_provision.sh      # Ferramentas de teste
├── ansible/
│   ├── inventory.ini              # Hosts Ansible
│   └── hardening.yml              # Playbook de hardening
├── scripts/
│   ├── hash-evidence.sh           # Calcular hashes
│   ├── teste-lab.sh               # Teste automatizado
│   └── hardening.sh               # Aplicar hardening
├── RELATORIO-AUDITORIA.md         # Análise forense completa
├── POLITICA-USO-ACEITAVEL.md      # Política institucional
├── PLANO-TREINAMENTO.md           # Capacitação de usuários
├── DIAGRAMA-ARQUITETURA.md        # Diagramas técnicos
└── README.md                      # Este arquivo
```

## 💻 Requisitos

| Recurso | Mínimo | Recomendado |
|---------|--------|-------------|
| RAM | 2GB | 4GB |
| CPU | 2 cores | 4 cores |
| Disco | 3GB | 5GB |

## ⚠️ Avisos Legais

> **ATENÇÃO:** Uso exclusivo para fins educacionais em ambiente isolado. Ataques não autorizados são crime (Lei 12.737/2012).

### ✅ Permitido
- Ambiente isolado (host-only)
- VMs próprias
- Fins acadêmicos

### ❌ Proibido
- Atacar sistemas de terceiros
- Redes produtivas
- Sem autorização expressa

## 🔑 Credenciais (DEMO)
- **User**: prof
- **Pass**: Prof123
- **IP Defensor**: 192.168.56.10
- **IP Atacante**: 192.168.56.20

## 🆘 Problemas Comuns

### Validar Ambiente
```bash
vagrant ssh atacante -c "bash /vagrant/scripts/validar-ambiente.sh"
```

### VMs não sobem
```bash
vboxmanage --version
vagrant --version
```

### Pouca memória
Edite `Vagrantfile` e reduza para `vb.memory = "384"`

### SSH não conecta
```bash
vagrant ssh def-weak
sudo systemctl status ssh
```

### Recriar ambiente
```bash
vagrant destroy -f && vagrant up
```

### Problemas no Windows
Veja **[TROUBLESHOOTING-WINDOWS.md](TROUBLESHOOTING-WINDOWS.md)** para soluções específicas

## 📊 Checklist

- [ ] VirtualBox instalado
- [ ] Vagrant instalado
- [ ] 2 VMs rodando
- [ ] nmap detecta SSH
- [ ] ssh-audit mostra vulnerabilidades
- [ ] Login com Prof123 funciona
- [ ] Hydra tem sucesso
- [ ] Logs visíveis

## 🏆 Objetivos de Aprendizado

- ✅ Identificar vulnerabilidades SSH
- ✅ Explorar sistemas inseguros eticamente
- ✅ Analisar logs e evidências
- ✅ Aplicar hardening
- ✅ Validar melhorias de segurança

## 📚 Documentação Completa

### Documentos Principais
- **[RELATORIO-AUDITORIA.md](RELATORIO-AUDITORIA.md)** - Análise de 6 vulnerabilidades, forense digital, cadeia de custódia
- **[POLITICA-USO-ACEITAVEL.md](POLITICA-USO-ACEITAVEL.md)** - Regras de uso dos laboratórios
- **[PLANO-TREINAMENTO.md](PLANO-TREINAMENTO.md)** - Capacitação para professores e alunos
- **[DIAGRAMA-ARQUITETURA.md](DIAGRAMA-ARQUITETURA.md)** - Topologia, fluxos e matrizes de risco

### Guias de Uso
- **[SETUP-UBUNTU.md](SETUP-UBUNTU.md)** - Instalação detalhada no Ubuntu
- **[ROTEIRO-APRESENTACAO.md](ROTEIRO-APRESENTACAO.md)** - Roteiro completo para apresentação em sala

## 📞 Suporte

- **Issues**: https://github.com/xTHs/seguranca-da-informacao/issues
- **Docs Vagrant**: https://www.vagrantup.com/docs
- **Docs VirtualBox**: https://www.virtualbox.org/manual/

---

**📝 Atualizado**: 2025-01-24  
**📜 Licença**: MIT
**Link documentação**: https://docs.google.com/document/d/1GOJ9r4SNWSERWHX2_SKMJfhBJpQuzHD33Wq4xwfmC34/edit?usp=sharing
