# Checklist - Coleta Rápida de Evidências

## Procedimento Essencial (7 passos)

### 1) Registrar hora do sistema
```bash
date -Iseconds
```

### 2) Usuários e sessões
```bash
who -a ; w ; last -F
```

### 3) Rede
```bash
ip a ; ip r ; ss -tunap
```

### 4) Processos e arquivos
```bash
ps auxf ; lsof -nP | head
```

### 5) Logs-chave
```bash
journalctl -u ssh --since "2 hours ago"
```

### 6) Cópias e hashes
```bash
sha256sum <arquivo> >> evidence/hashes.txt
```

### 7) Encerrar coleta, registrar no chain-of-custody

## Checklist de Verificação
- [ ] Hora registrada
- [ ] Sessões documentadas  
- [ ] Rede mapeada
- [ ] Processos capturados
- [ ] Logs SSH coletados
- [ ] Hashes calculados
- [ ] Chain-of-custody atualizada