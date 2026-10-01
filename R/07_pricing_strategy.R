# Estratégia de Pricing
library(readxl)

base_saude <- read_excel("data/base_saude.xlsx")

# Para reproduzir exatamente o cenário histórico,
# utilize as previsões geradas pelos modelos do projeto.
# O estudo original aplicou carregamento de 25%.

loading <- 0.25

# Exemplo conceitual:
# premio <- pp * (1 + loading)
# loss_ratio <- mean(base_saude$custo_operadora) / mean(premio)

print(loading)
