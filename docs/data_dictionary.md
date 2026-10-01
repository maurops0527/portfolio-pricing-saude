# Data Dictionary

| Campo | Tipo | Papel |
|---|---|---|
| idade | numérico | Feature ex ante |
| sexo | categórico | Feature ex ante |
| regiao | categórico | Feature ex ante |
| plano | categórico | Feature ex ante |
| empresa | categórico | Feature / identificação |
| exposicao | numérico | Exposição / offset |
| risco | numérico | Feature de risco |
| eventos | numérico | Target de frequência |
| tipo_evento | categórico | Informação associada ao evento |
| custo_unitario | numérico | Resultado de custo — evitar em previsão ex ante |
| custo_total_bruto | numérico | Resultado de custo — evitar em previsão ex ante |
| custo_operadora | numérico | Target de severidade / resultado |

**Nota:** o papel de cada variável depende do momento da previsão. Variáveis observadas somente após o evento não devem ser utilizadas para prever a ocorrência do próprio evento.
