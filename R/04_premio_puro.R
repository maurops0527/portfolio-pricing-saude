# Prêmio puro
library(readxl)

base_saude <- read_excel("data/base_saude.xlsx")

glm_freq <- glm(
  eventos ~ idade + sexo + regiao + plano +
    offset(log(exposicao)),
  family = poisson(link = "log"),
  data = base_saude
)

base_sev <- subset(base_saude, eventos > 0)

glm_gamma <- glm(
  custo_operadora ~ idade + sexo + regiao + plano,
  family = Gamma(link = "log"),
  data = base_sev
)

freq_pred <- predict(glm_freq, newdata = base_saude, type = "response")
sev_pred <- predict(glm_gamma, newdata = base_saude, type = "response")

pp <- freq_pred * sev_pred

mean(pp)
