# Configuração do Laboratório - Dia 1

## Rede Isolada
- **Tipo**: Host-Only/Internal Network
- **Range**: 192.168.56.0/24
- **Gateway**: 192.168.56.1 (host)

## VM VÍTIMA (Ubuntu Server)
- **IP**: 192.168.56.10/24
- **Hostname**: lab-victim
- **OS**: Ubuntu Server 22.04 LTS
- **RAM**: 2GB
- **Disk**: 20GB

### Configuração Inicial
```bash
# Configurar IP estático
sudo nano /etc/netplan/00-installer-config.yaml

# Conteúdo:
network:
  version: 2
  ethernets:
    enp0s3:
      dhcp4: false
      addresses: [192.168.56.10/24]
      gateway4: 192.168.56.1
      nameservers:
        addresses: [8.8.8.8]

# Aplicar configuração
sudo netplan apply

# Instalar SSH
sudo apt update && sudo apt install -y openssh-server

# Criar usuário vulnerável
sudo useradd -m -s /bin/bash prof
echo 'prof:Prof123' | sudo chpasswd

# Verificar SSH
ss -tulpn | grep sshd
```

## VM ATACANTE (Kali Linux)
- **IP**: 192.168.56.20/24
- **Hostname**: lab-attacker
- **OS**: Kali Linux 2024.1
- **RAM**: 4GB
- **Disk**: 40GB

### Ferramentas Necessárias
```bash
# Já incluídas no Kali:
# - nmap, hydra, metasploit
# - wireshark, tcpdump
# - john, hashcat

# Configurar IP estático (se necessário)
sudo ip addr add 192.168.56.20/24 dev eth0
```

## Snapshots Obrigatórios
1. **baseline-limpa**: Estado inicial das VMs
2. **pos-configuracao**: Após configuração de rede e SSH
3. **pre-ataque**: Antes de iniciar testes