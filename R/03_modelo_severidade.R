# Modelos de severidade — Gamma x Lognormal
library(readxl)

base_saude <- read_excel("data/base_saude.xlsx")
base_sev <- subset(base_saude, eventos > 0)

glm_gamma <- glm(
  custo_operadora ~ idade + sexo + regiao + plano,
  family = Gamma(link = "log"),
  data = base_sev
)

glm_lognormal <- lm(
  log(custo_operadora) ~ idade + sexo + regiao + plano,
  data = base_sev
)

summary(glm_gamma)
summary(glm_lognormal)

pred_gamma <- predict(glm_gamma, type = "response")
pred_lognormal <- exp(predict(glm_lognormal))

mean(pred_gamma)
mean(pred_lognormal)
