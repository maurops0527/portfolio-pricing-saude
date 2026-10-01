# GLM de frequência — Poisson
library(readxl)

base_saude <- read_excel("data/base_saude.xlsx")

glm_freq <- glm(
  eventos ~ idade + sexo + regiao + plano +
    offset(log(exposicao)),
  family = poisson(link = "log"),
  data = base_saude
)

summary(glm_freq)

dispersion <- sum(
  residuals(glm_freq, type = "pearson")^2
) / glm_freq$df.residual

print(dispersion)

# Interpretação de efeitos relativos
exp(coef(glm_freq))
