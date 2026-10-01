# Machine Learning — versão refinada
# Importante: features devem estar disponíveis antes do resultado que se deseja prever.

library(readxl)
library(randomForest)
library(xgboost)

base_saude <- read_excel("data/base_saude.xlsx")

# Variáveis ex ante disponíveis na base
features_freq <- base_saude[, c(
  "idade", "sexo", "regiao", "plano",
  "empresa", "exposicao", "risco"
)]

# Target
y_freq <- base_saude$eventos

X_freq <- model.matrix(~ . - 1, data = features_freq)

set.seed(123)
idx <- sample(seq_len(nrow(base_saude)), size = floor(0.80*nrow(base_saude)))

x_train <- X_freq[idx, ]
x_test  <- X_freq[-idx, ]
y_train <- y_freq[idx]
y_test  <- y_freq[-idx]

xgb_freq <- xgboost(
  x = x_train,
  y = y_train,
  objective = "count:poisson",
  nrounds = 100,
  verbose = 0
)

pred_freq <- predict(xgb_freq, x_test)

rmse_freq <- sqrt(mean((y_test - pred_freq)^2))
mae_freq <- mean(abs(y_test - pred_freq))

cat("RMSE:", rmse_freq, "\n")
cat("MAE:", mae_freq, "\n")


# Severidade
base_sev <- subset(base_saude, eventos > 0)

features_sev <- base_sev[, c(
  "idade", "sexo", "regiao", "plano",
  "empresa", "exposicao", "risco", "tipo_evento"
)]

y_sev <- base_sev$custo_operadora

X_sev <- model.matrix(~ . - 1, data = features_sev)

set.seed(123)
idx_s <- sample(seq_len(nrow(base_sev)), size = floor(0.80*nrow(base_sev)))

x_train_s <- X_sev[idx_s, ]
x_test_s  <- X_sev[-idx_s, ]
y_train_s <- y_sev[idx_s]
y_test_s  <- y_sev[-idx_s]

xgb_sev <- xgboost(
  x = x_train_s,
  y = y_train_s,
  objective = "reg:gamma",
  nrounds = 100,
  verbose = 0
)

pred_sev <- predict(xgb_sev, x_test_s)

rmse_sev <- sqrt(mean((y_test_s - pred_sev)^2))
mae_sev <- mean(abs(y_test_s - pred_sev))

cat("RMSE severidade:", rmse_sev, "\n")
cat("MAE severidade:", mae_sev, "\n")
