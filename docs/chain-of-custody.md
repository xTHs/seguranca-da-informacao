# Cadeia de Custódia - Evidências Digitais

## Informações do Caso
- **ID do Caso**: INC-SSH-001
- **Data de Início**: [Data atual]
- **Investigador Principal**: [Seu nome]
- **Tipo de Incidente**: Acesso não autorizado via SSH

## Template de Registro de Evidências

```
Evidência: auth.log (ou imagem de disco vitima_sda.img)
ID: EV-2025-10-18-001
Coletor: <nome>
Data/Hora (UTC-3): <AAAA-MM-DD HH:MM:SS>
Método: scp/journalctl/dc3dd
Local de armazenamento: /evidence/...
Hash SHA256: <...>
Transferências subsequentes (quem/quando/para onde): ...
Assinaturas: ...
Observações: ...
```

## Evidências Coletadas

*[Evidências serão registradas aqui durante a investigação]*

## Verificação de Integridade
- Todas as evidências devem ter hash SHA256 calculado
- Comando padrão: `sha256sum arquivo > arquivo.sha256`
- Verificação: `sha256sum -c arquivo.sha256`