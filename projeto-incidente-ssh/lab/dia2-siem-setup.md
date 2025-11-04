# Dia 2 - Instrumentar LOG e SIEM Leve

## Sincronismo de Tempo
```bash
# Em ambas as VMs
sudo apt install -y chrony
sudo systemctl enable --now chronyd
```

## Centralização de Logs

### VM ATACANTE (Coletor)
```bash
# Editar /etc/rsyslog.conf - descomentar/adicionar:
sudo nano /etc/rsyslog.conf

# Adicionar estas linhas:
module(load="imudp")
input(type="imudp" port="514")
module(load="imtcp")
input(type="imtcp" port="514")

# Reiniciar
sudo systemctl restart rsyslog
sudo systemctl enable rsyslog
```

### VM VÍTIMA (Cliente)
```bash
# Garantir rsyslog ativo
sudo systemctl enable --now rsyslog

# Configurar envio remoto
sudo tee /etc/rsyslog.d/60-remote.conf << EOF
*.* @192.168.56.20:514
EOF

sudo systemctl restart rsyslog
```

## Fail2ban (Preparação)
```bash
# Na VÍTIMA - instalar mas não endurecer ainda
sudo apt install -y fail2ban
sudo systemctl enable fail2ban
```

## Verificação
```bash
# Testar logs centralizados
logger "Teste de log centralizado - $(date)"

# Na ATACANTE, verificar recebimento:
sudo tail -f /var/log/syslog | grep "Teste de log"
```