# Resumo Executivo — Pricing de Saúde Suplementar

## Contexto

Estudo independente de modelagem de risco para uma carteira sintética de Saúde Suplementar, estruturado para reproduzir uma etapa de análise quantitativa de Pricing.

## Objetivo

Estimar frequência e severidade, obter prêmio puro, avaliar capacidade discriminatória e comparar modelos estatísticos com Machine Learning.

## Racional

A frequência foi modelada por GLM Poisson com exposição como offset. A dispersão estimada foi 1,012, próxima de 1.

Para severidade, foram avaliados GLM Gamma e Lognormal. O estudo original selecionou Gamma para a composição do prêmio puro.

O prêmio puro foi estimado pela multiplicação da frequência esperada pela severidade esperada.

## Resultados

O prêmio puro médio documentado foi de R$ 837,49. Com carregamento de 25%, o prêmio médio passou para R$ 1.046,86 e a sinistralidade estimada no cenário foi de aproximadamente 51,5%.

O Gini documentado foi de 0,5968.

## Visão de Pricing

Os principais direcionadores documentados foram idade e plano Premium. O estudo recomenda aprofundar a segmentação etária e monitorar o comportamento do produto Premium.

## Limitações

Os dados são sintéticos. A versão pública do projeto reconstrói os scripts a partir dos outputs e memória de cálculo disponíveis; portanto, não deve ser apresentada como reprodução literal do código histórico.
