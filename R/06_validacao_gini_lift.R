# Validação — RMSE, MAE, Gini e Lift
library(readxl)
library(dplyr)

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

pred_freq <- predict(glm_freq, newdata = base_saude, type = "response")
pred_sev <- predict(glm_gamma, newdata = base_saude, type = "response")

pred <- pred_freq * pred_sev

rmse_freq <- sqrt(mean((base_saude$eventos - pred_freq)^2))
mae_freq <- mean(abs(base_saude$eventos - pred_freq))

cat("RMSE frequência:", rmse_freq, "\n")
cat("MAE frequência:", mae_freq, "\n")

base_saude$pred <- pred
base_saude$decil <- ntile(base_saude$pred, 10)

lift <- base_saude %>%
  group_by(decil) %>%
  summarise(
    observado = sum(custo_operadora),
    esperado = sum(pred),
    .groups = "drop"
  ) %>%
  mutate(lift = observado / esperado)

print(lift)
