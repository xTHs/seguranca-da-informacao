# 🪟 Guia Rápido - Windows

## Pré-requisitos

1. **VirtualBox** instalado: https://www.virtualbox.org/wiki/Downloads
2. **Vagrant** instalado: https://www.vagrantup.com/downloads
3. **PowerShell** ou **CMD**

## Passo a Passo

### 1. Abrir PowerShell/CMD no diretório do projeto
```powershell
cd d:\redes\seguranca-da-informacao\projeto-incidente-ssh
```

### 2. Validar Vagrantfile
```powershell
vagrant validate
```

### 3. Subir as VMs (primeira vez demora ~15 min)
```powershell
vagrant up
```

### 4. Verificar status
```powershell
vagrant status
```

**Resultado esperado:**
```
def-weak    running (virtualbox)
def-hard    running (virtualbox)
atacante    running (virtualbox)
```

### 5. Acessar VM atacante
```powershell
vagrant ssh atacante
```

### 6. Testar conectividade (dentro da VM atacante)
```bash
ping -c 2 192.168.56.10
ping -c 2 192.168.56.11
nmap -p 22 192.168.56.10,11
```

## Comandos Úteis

```powershell
# Desligar VMs
vagrant halt

# Reiniciar VMs
vagrant reload

# Destruir VMs (apaga tudo)
vagrant destroy -f

# Acessar VMs específicas
vagrant ssh def-weak
vagrant ssh def-hard
vagrant ssh atacante
```

## Problemas Comuns

### ❌ "VT-x is disabled"
- Habilitar virtualização na BIOS (Intel VT-x ou AMD-V)

### ❌ "Network not found"
```powershell
# Criar rede manualmente
VBoxManage hostonlyif create
VBoxManage hostonlyif ipconfig "VirtualBox Host-Only Ethernet Adapter" --ip 192.168.56.1 --netmask 255.255.255.0
```

### ❌ "Port collision"
- Outra VM usando a mesma porta
- Fechar VirtualBox e tentar novamente
