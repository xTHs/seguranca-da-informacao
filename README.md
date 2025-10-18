# Segurança da Informação
Esse repositório tem a finalidade de treinar minhas habilidades em segurança.

## Projetos

### Projeto Análise de Incidente SSH - Laboratório Automatizado

#### Escopo e Regras de Engajamento (ROE)

**Alvos Autorizados**
- **VMs do laboratório apenas**: rede isolada 192.168.56.0/24
- **Máquina VÍTIMA**: 192.168.56.10 (Ubuntu Server)
- **Máquina ATACANTE**: 192.168.56.20 (Kali Linux)

**Objetivos**
1. Reproduzir incidente SSH com senha fraca
2. Coletar evidências forenses
3. Implementar correções (hardening)
4. Documentar trilha de auditoria completa

#### Início Rápido

**Pré-requisitos**
- VirtualBox instalado
- Vagrant instalado
- 8GB RAM disponível

**Como Executar**
```bash
# 1. Entrar no diretório do projeto
cd projeto-incidente-ssh

# 2. Subir o laboratório
vagrant up

# 3. Acessar VMs
vagrant ssh vitima    # 192.168.56.10
vagrant ssh atacante  # 192.168.56.20
```

**Estrutura do Projeto**
```
├── Vagrantfile              # Automação das VMs
├── provision/               # Scripts de configuração
├── ansible/                 # Hardening automatizado
├── docs/                    # Documentação e políticas
├── scripts/                 # Automação de coleta
└── evidence/               # Evidências coletadas
```
