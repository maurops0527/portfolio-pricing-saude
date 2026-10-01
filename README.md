# Projeto — Pricing de Saúde Suplementar

**Modelagem atuarial de frequência e severidade + Machine Learning + validação + estratégia de Pricing**

> Projeto independente desenvolvido para aprofundamento técnico em Atuária, Pricing e Data Analytics.  
> **Dados sintéticos**, sem utilização de informações confidenciais ou proprietárias de empresas.

---

## 1. Resumo

Este projeto apresenta um estudo completo de precificação de uma carteira sintética de Saúde Suplementar.

O trabalho parte da análise exploratória da carteira e evolui para:

1. modelagem de frequência;
2. modelagem de severidade;
3. estimativa de prêmio puro;
4. comparação com abordagens de Machine Learning;
5. avaliação de poder discriminatório;
6. análise por decis;
7. simulação de carregamento;
8. interpretação dos resultados sob a ótica de Pricing.

O objetivo não é apenas construir um modelo preditivo, mas demonstrar o processo completo de transformar dados em **informação atuarial e suporte à decisão de preço**.

---

## 2. Problema de negócio

A pergunta central do estudo é:

> **Como estimar o custo esperado de uma carteira de Saúde e transformar essa estimativa em uma referência quantitativa para Pricing?**

O projeto busca responder:

- Quais características estão associadas à frequência de utilização?
- Quais características estão associadas à severidade?
- O GLM Poisson apresenta evidência de overdispersion?
- Qual abordagem de severidade apresenta comportamento mais adequado à base?
- Qual o prêmio puro esperado?
- Os modelos de Machine Learning agregam capacidade preditiva suficiente para justificar maior complexidade?
- O modelo consegue ordenar a carteira por risco?
- Como um carregamento altera a relação entre prêmio e custo esperado?

---

## 3. Base de dados

A base possui **10.000 observações e 12 variáveis**:

| Variável | Descrição |
|---|---|
| `idade` | Idade do beneficiário |
| `sexo` | Sexo |
| `regiao` | Região |
| `plano` | Categoria do plano |
| `empresa` | Identificação da empresa |
| `exposicao` | Exposição utilizada no modelo de frequência |
| `risco` | Variável de risco disponível na base |
| `eventos` | Quantidade de eventos |
| `tipo_evento` | Tipo do evento |
| `custo_unitario` | Custo unitário |
| `custo_total_bruto` | Custo total bruto |
| `custo_operadora` | Custo para a operadora |

A base possui **3.243 observações com pelo menos um evento**.

### Nota de modelagem

Para modelos preditivos de portfólio, variáveis que são consequência do próprio evento/custo não devem ser utilizadas como explicadoras quando o objetivo é prever risco **antes da ocorrência**. Por isso, a versão refinada separa:

- variáveis disponíveis ex ante;
- variáveis de resultado utilizadas como alvo;
- variáveis derivadas do evento/custo, utilizadas apenas em avaliação.

Essa separação evita **target leakage** e aproxima o exercício de um processo real de desenvolvimento de modelo.

---

## 4. Arquitetura do projeto

```text
Dados
  ↓
Análise exploratória
  ↓
Modelagem de frequência
  ↓
Modelagem de severidade
  ↓
Frequência × Severidade
  ↓
Prêmio puro
  ↓
Validação / discriminação
  ↓
Machine Learning
  ↓
Comparação de abordagens
  ↓
Estratégia de Pricing
```

---

# 5. Modelagem de frequência

Foi utilizado um **GLM Poisson com função de ligação log** e exposição como offset:

```r
eventos ~ idade + sexo + regiao + plano +
  offset(log(exposicao))
```

A dispersão calculada no estudo original foi:

**1,0125**

Como o valor ficou muito próximo de 1, o racional documentado considerou que não havia evidência relevante de overdispersion e, portanto, não identificou necessidade de substituição do Poisson por Binomial Negativa.

### Principais coeficientes documentados

| Variável | Coeficiente |
|---|---:|
| Idade | 0,03939 |
| Sexo masculino | -0,00582 |
| MG | -0,00771 |
| PR | -0,03257 |
| RJ | -0,01463 |
| SP | -0,04475 |
| Plano Intermediário | 0,38308 |
| Plano Premium | 0,49935 |

No modelo log-link, a interpretação deve ser feita pela transformação `exp(coeficiente)`.

Por exemplo, o coeficiente de idade de aproximadamente 0,0394 corresponde a um fator multiplicativo de aproximadamente **1,040** por unidade de idade, mantendo as demais variáveis constantes.

---

# 6. Modelagem de severidade

A severidade foi estudada sobre as observações com eventos positivos.

Foram comparadas:

### GLM Gamma

```r
custo_operadora ~ idade + sexo + regiao + plano
```

com link log.

### Lognormal

Modelagem de:

```r
log(custo_operadora)
```

por regressão linear.

### Resultado do estudo

O racional original selecionou a **Gamma** para composição do prêmio puro, considerando o comportamento da distribuição observada e a presença de cauda nos custos.

Importante: essa escolha é específica ao conjunto de dados e ao desenho do exercício. Não significa que Gamma seja universalmente superior a Lognormal em carteiras de Saúde.

---

# 7. Prêmio puro

A estrutura utilizada foi:

```text
Prêmio Puro
=
Frequência Esperada
×
Severidade Esperada
```

O valor médio documentado no estudo original foi:

**R$ 837,49**

Esse valor representa uma referência de custo esperado do risco antes da aplicação dos carregamentos considerados no exercício.

---

# 8. Machine Learning

Foram explorados:

- Random Forest;
- XGBoost para frequência;
- XGBoost para severidade.

### Refinamento metodológico

Na versão refinada do projeto, as variáveis que representam o próprio resultado do evento/custo são retiradas das features ex ante.

Por exemplo, para previsão de frequência não são utilizadas como explicadoras:

- `custo_operadora`;
- `custo_total_bruto`;
- `custo_unitario`.

Essas variáveis podem carregar informação diretamente derivada do evento que se pretende prever, produzindo leakage.

Esse cuidado é importante para aproximar o projeto de uma situação real de desenvolvimento de modelos de Pricing.

---

# 9. Validação

Foram consideradas:

- RMSE;
- MAE;
- Deviance;
- Gini;
- Lift;
- análise por decis;
- backtesting exploratório.

Resultados documentados no estudo original:

| Métrica | Resultado |
|---|---:|
| RMSE — frequência | 0,700 |
| MAE — frequência | 0,477 |
| RMSE — severidade | 5.541,85 |
| MAE — severidade | 2.193,53 |
| Deviance — frequência | 8.153,48 |
| Gini | 0,5968 |

### Interpretação

A diferença entre RMSE e MAE na severidade é compatível com a influência de observações extremas: o RMSE penaliza mais fortemente erros grandes.

O Gini documentado de aproximadamente **0,60** indica capacidade de ordenação/discriminação no exercício, mas deve ser interpretado dentro da base sintética e da metodologia utilizada.

---

# 10. Lift e ordenação de risco

A carteira foi dividida em decis de risco segundo a previsão do prêmio puro.

O objetivo foi verificar se os grupos classificados como de maior risco também apresentavam custos observados maiores.

A análise original mostrou crescimento relevante do custo observado nos decis superiores, embora a calibração entre observado e esperado não fosse perfeita.

Isso é importante porque um modelo de Pricing precisa ser avaliado não apenas pela métrica global, mas também pela sua capacidade de **ordenar adequadamente o risco**.

---

# 11. Estratégia de Pricing

Foi simulado um carregamento de:

**25%**

Sobre o prêmio puro:

```text
Prêmio = Prêmio Puro × (1 + Carregamento)
```

Resultado documentado:

- Prêmio puro médio: **R$ 837,49**
- Prêmio com carregamento: **R$ 1.046,86**
- Sinistralidade estimada no cenário: **51,52%**

### Observação

A relação entre carregamento, margem e sinistralidade não deve ser generalizada como uma meta universal de mercado. Neste projeto, o percentual de 25% é exclusivamente um **cenário de simulação**.

---

# 12. Principais insights de negócio

Os resultados documentados apontaram:

### Idade

A idade apresentou associação positiva com frequência e severidade.

Isso sugere que a segmentação etária pode ser uma alternativa mais adequada para aprofundar a diferenciação de risco do que utilizar apenas idade como variável contínua.

### Plano Premium

O Plano Premium apresentou coeficientes positivos nos modelos de frequência e severidade, indicando maior custo esperado em relação ao plano de referência.

No estudo original, esse comportamento foi associado à necessidade de atenção ao risco de seleção/adverse selection.

Essa interpretação deve ser tratada como **hipótese de negócio a investigar**, e não como causalidade comprovada pelo modelo.

### Sexo e região

Não foram identificadas evidências estatísticas relevantes para essas variáveis nos GLMs documentados.

Isso não significa que sejam universalmente irrelevantes: o resultado é específico da carteira e da especificação utilizada.

### Machine Learning

O estudo original não identificou ganho relevante de ML que justificasse, para aquele exercício, substituir os modelos estatísticos tradicionais.

Esse resultado também é um insight: **modelo mais complexo não é automaticamente modelo melhor para Pricing**.

---

# 13. Limitações e próximos passos

Este é um estudo independente e educacional. A base é sintética.

Principais oportunidades de evolução:

1. separar formalmente treino, validação e teste;
2. utilizar validação temporal quando houver dimensão temporal;
3. testar diferentes especificações de frequência;
4. aprofundar segmentação por faixa etária;
5. tratar explicitamente eventos extremos;
6. avaliar calibração, além de discriminação;
7. comparar GLM e Gradient Boosting sob o mesmo conjunto de features ex ante;
8. incorporar elasticidade e conversão em um projeto futuro;
9. desenvolver uma camada de simulação de preço, margem e volume.

---

# 14. O que este projeto demonstra

Este projeto demonstra experiência prática independente em:

**Atuária**
- frequência;
- severidade;
- prêmio puro;
- risco;
- segmentação.

**Estatística**
- GLM;
- Poisson;
- Gamma;
- Lognormal;
- dispersão;
- diagnóstico;
- interpretação de parâmetros.

**Machine Learning**
- Random Forest;
- XGBoost;
- feature engineering;
- importância de variáveis.

**Model Validation**
- RMSE;
- MAE;
- Deviance;
- Gini;
- Lift;
- Backtesting.

**Pricing**
- custo esperado;
- carregamento;
- sinistralidade;
- interpretação de risco;
- suporte quantitativo à decisão.

---

## Autor

**Mauro Pequeno da Silva**

Atuário | Precificação | Seguros | Data Analytics | Gestão de Riscos

Projeto independente desenvolvido para aprofundamento técnico e demonstração de aplicação quantitativa em Pricing.


---

## Disclaimer

Este projeto é exclusivamente educacional. Os dados são sintéticos e não representam qualquer carteira, cliente, contrato ou informação proprietária de empresa.
