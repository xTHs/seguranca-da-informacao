# Cadeia de Custódia - Template

## Informações do Caso
- **ID do Caso**: [ID-YYYY-MM-DD-XXX]
- **Data de Início**: [YYYY-MM-DD HH:MM:SS UTC-3]
- **Investigador Principal**: [Nome do investigador]
- **Tipo de Incidente**: [Descrição do incidente]

## Template de Registro de Evidências

```
Evidência: [nome do arquivo/imagem]
ID: EV-YYYY-MM-DD-XXX
Coletor: [nome do coletor]
Data/Hora (UTC-3): YYYY-MM-DD HH:MM:SS
Método: [scp/journalctl/dc3dd/manual]
Local de armazenamento: /evidence/[caminho]
Hash SHA256: [hash calculado]
Transferências subsequentes (quem/quando/para onde): [detalhes]
Assinaturas: [assinatura digital/física]
Observações: [observações relevantes]
```

## Evidências Coletadas

*[Evidências serão registradas aqui durante a investigação]*

## Verificação de Integridade
- Todas as evidências devem ter hash SHA256 calculado
- Comando padrão: `sha256sum arquivo > arquivo.sha256`
- Verificação: `sha256sum -c arquivo.sha256`

## Procedimentos de Coleta
1. Registrar data/hora de início
2. Identificar e isolar evidências
3. Calcular hash antes da coleta
4. Documentar método de coleta
5. Calcular hash após coleta
6. Registrar na cadeia de custódia
7. Armazenar em local seguro