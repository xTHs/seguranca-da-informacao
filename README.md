# Projeto Análise de Incidente SSH - Laboratório Automatizado

## Escopo e Regras de Engajamento (ROE)

### Alvos Autorizados
- **VMs do laboratório apenas**: rede isolada 192.168.56.0/24
- **Máquina VÍTIMA**: 192.168.56.10 (Ubuntu Server)
- **Máquina ATACANTE**: 192.168.56.20 (Kali Linux)

### Objetivos
1. Reproduzir incidente SSH com senha fraca
2. Coletar evidências forenses
3. Implementar correções (hardening)
4. Documentar trilha de auditoria completa

### Limites e Restrições
- ❌ Sem dados pessoais reais
- ❌ Sem pivotar para redes externas
- ❌ Sem ataques fora do escopo definido
- ✅ Apenas ambiente controlado e isolado

### Autorização
**Projeto autorizado para fins acadêmicos**
- Responsável: [Nome do Professor/Coordenador]
- Data: [Data atual]
- Assinatura: [Assinatura digital/física]

## Início Rápido

### Pré-requisitos
- VirtualBox instalado
- Vagrant instalado
- 8GB RAM disponível

### Como Executar
```bash
# 1. Subir o laboratório
vagrant up

# 2. Verificar status
vagrant status

# 3. Acessar VMs
vagrant ssh vitima    # 192.168.56.10
vagrant ssh atacante  # 192.168.56.20
```

### Validação Inicial (no atacante)
```bash
# Reconhecimento
nmap -sS -sV -p 22 192.168.56.10
ssh-audit 192.168.56.10

# Teste de acesso (LAB APENAS)
ssh prof@192.168.56.10  # senha: Prof123
```

## Estrutura do Projeto
```
├── Vagrantfile              # Automação das VMs
├── provision/               # Scripts de configuração
├── ansible/                 # Hardening automatizado
├── docs/                    # Documentação e políticas
├── scripts/                 # Automação de coleta
└── evidence/               # Evidências coletadas
```

## Status do Projeto
- [x] Dia 0: Estrutura e ROE definidas
- [x] Laboratório automatizado (Vagrant)
- [x] Scripts de provisionamento
- [x] Documentação completa