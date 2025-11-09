# Troubleshooting - Windows

## Problemas Comuns

### 1. VM não sobe - "Already exists"
```powershell
# Parar VMs em execução
vboxmanage list runningvms | ForEach-Object { $_ -match '\{(.+)\}'; vboxmanage controlvm $matches[1] poweroff }

# Limpar estado
vagrant global-status --prune
vagrant destroy -f

# Remover pastas conflitantes
Remove-Item -Recurse -Force "D:\VMBOX\SSH-Lab-*" -ErrorAction SilentlyContinue

# Recriar
vagrant up
```

### 2. Pasta /vagrant vazia dentro da VM
```powershell
# Verificar se synced_folder está habilitado no Vagrantfile
# Deve estar: config.vm.synced_folder ".", "/vagrant"

# Reinstalar Guest Additions
vagrant plugin install vagrant-vbguest
vagrant reload
```

### 3. Scripts não executam
```bash
# Dentro da VM
sudo chmod +x /vagrant/scripts/*.sh
```

### 4. Firewall do Windows bloqueia VMs
```powershell
# Executar como Administrador
New-NetFirewallRule -DisplayName "VirtualBox Host-Only" -Direction Inbound -Action Allow -Protocol Any -LocalAddress 192.168.56.0/24
```

### 5. Virtualização não habilitada
- Reiniciar PC
- Entrar na BIOS/UEFI (F2, DEL, F10)
- Habilitar: Intel VT-x ou AMD-V
- Desabilitar Hyper-V no Windows:
```powershell
# Como Administrador
bcdedit /set hypervisorlaunchtype off
# Reiniciar
```

### 6. Erro "VERR_ALREADY_EXISTS"
```powershell
# Limpar cache do VirtualBox
Remove-Item -Recurse -Force "$env:USERPROFILE\.VirtualBox\*" -Include "*.log"
vboxmanage list vms | ForEach-Object { $_ -match '"(.+)"'; vboxmanage unregistervm $matches[1] --delete }
vagrant up
```

### 7. SSH não conecta de fora da VM
```powershell
# Testar conectividade
ping 192.168.56.10
ping 192.168.56.20

# Se falhar, recriar rede host-only no VirtualBox:
# File → Host Network Manager → Create
# Configurar: 192.168.56.1/24
```

### 8. Comandos devem ser executados DENTRO da VM
```powershell
# ✗ ERRADO (no PowerShell do Windows)
ssh-audit 192.168.56.10

# ✓ CORRETO (dentro da VM atacante)
vagrant ssh atacante
ssh-audit 192.168.56.10
```

## Validação do Ambiente

```powershell
# 1. Verificar status
vagrant status

# 2. Entrar na VM atacante
vagrant ssh atacante

# 3. Executar validação
bash /vagrant/scripts/validar-ambiente.sh
```

## Reinstalação Limpa

```powershell
# 1. Destruir tudo
vagrant destroy -f

# 2. Limpar VirtualBox
vboxmanage list vms | ForEach-Object { 
    if ($_ -match '"(SSH-Lab-.+)"') { 
        vboxmanage unregistervm $matches[1] --delete 
    }
}

# 3. Limpar cache Vagrant
vagrant box prune
vagrant global-status --prune

# 4. Recriar
vagrant up

# 5. Validar
vagrant ssh atacante -c "bash /vagrant/scripts/validar-ambiente.sh"
```

## Requisitos Mínimos

- Windows 10/11 64-bit
- 4GB RAM (2GB para VMs + 2GB para host)
- 10GB espaço em disco
- Virtualização habilitada na BIOS
- VirtualBox 7.0+
- Vagrant 2.3+

## Logs Úteis

```powershell
# Logs do Vagrant
$env:VAGRANT_LOG="debug"
vagrant up

# Logs do VirtualBox
vboxmanage showvminfo "SSH-Lab-Defensor" --log 0
```
