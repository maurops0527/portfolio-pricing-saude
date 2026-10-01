# Análise exploratória — Pricing Saúde
# Reconstruído a partir da memória de cálculo original.

library(readxl)
library(dplyr)
library(ggplot2)

base_saude <- read_excel("data/base_saude.xlsx")

summary(base_saude)
str(base_saude)

base_saude %>%
  summarise(
    n = n(),
    frequencia_media = mean(eventos),
    exposicao_media = mean(exposicao),
    custo_medio_operadora = mean(custo_operadora),
    eventos_positivos = sum(eventos > 0)
  )

base_saude %>%
  count(plano, sexo)

ggplot(base_saude, aes(x = idade, y = eventos)) +
  geom_jitter(alpha = 0.15) +
  labs(title = "Eventos por idade", x = "Idade", y = "Eventos")
