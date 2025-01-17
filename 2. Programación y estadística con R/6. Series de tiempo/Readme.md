# Work

### Material complementario: Causalidad de Granger

Es un test consistente en comprobar si los resultados de una variable sirven para predecir a otra variable, si tiene carácter unidireccional o bidireccional. Para ello se tiene que comparar y deducir si el comportamiento actual y el pasado de una serie temporal A predice la conducta de una serie temporal B.

→ http://www.scielo.org.mx/scielo.php?script=sci_arttext&pid=S1870-66222016000100073


* [Ejemplos](#Ejemplos)
  * [Ejemplo 1 (Ejemplos de series de tiempo y técnicas descriptivas)](#Ejemplo-1)
  * [Ejemplo 2 (Modelos estocásticos básicos, modelos estacionarios y predicción)](#Ejemplo-2)
  * [Ejemplo 3 (Modelos no estacionarios y predicción)](#Ejemplo-3)

* [Retos](#Retos)
  * [ ] [Reto 1 (Proceso AR(1))](#Reto-1)
  * [ ] [Reto 2 (Proceso ARIMA(1, 1, 1))](#Reto-2)
  * [ ] [Reto 3 (Gráfica de series de tiempo)](#Reto-3)

# Ejemplos

## Ejemplo 1
```r
#### TÃ©cnicas descriptivas: grÃ¡ficas, tendencias y variaciÃ³n estacional

library(TSA)

setwd("C:/Users/LLerma/Google Drive/Analisis de Datos/M2 - Programacion y Estadistica con R/S6/Files")

data(oilfilters)
plot(oilfilters, type = "o", ylab = "Ventas", xlab = "Tiempo", main = "Ventas Mesuales ")
plot(oilfilters, type = "l", ylab = "Ventas", xlab = "Tiempo",
     main = "Ventas Mensuales de Filtro de Aceite",
     sub = "Símbolos Especiales")

#Agregar las iniciales del mes en cada uno de los puntos
points(y = oilfilters, x = time(oilfilters),
       pch = as.vector(season(oilfilters)))

data(AirPassengers)
AP <- AirPassengers
AP

# Clase de un objeto

class(AP)

start(AP); end(AP); frequency(AP)

summary(AP)

plot(AP, ylab = "Pasajeros (1000's)", xlab = "Tiempo", 
     main = "Reserva de pasajeros aéreos internacionales", 
     sub = "Estados Unidos en el periodo 1949-1960")

################################################

layout(1:2)
plot(aggregate(AP, nfrequency = 1), xlab = "Tiempo",
     main = "Reserva de pasajeros aÃ©reos internacionales", 
     sub = "Estados Unidos en el periodo 1949-1960")

boxplot(AP ~ cycle(AP),
        xlab = "Boxplot de valores estacionales",
        sub = "Estados Unidos en el periodo 1949-1960",
        main = "Reserva de pasajeros aÃ©reos internacionales")
dev.off()

################################################

# https://github.com/AtefOuni/ts/tree/master/Data

# Series de Tiempo MÃºltiple

# Serie de producciÃ³n de electricidad, cerveza y chocolate

CBE <- read.csv("cbe.csv", header = TRUE)
CBE[1:4,]
class(CBE)

plot(CBE)

Elec.ts <- ts(CBE[, 3], start = 1958, freq = 12)
Beer.ts <- ts(CBE[, 2], start = 1958, freq = 12)
Choc.ts <- ts(CBE[, 1], start = 1958, freq = 12)

plot(cbind(Elec.ts, Beer.ts, Choc.ts), 
     main = "ProducciÃ³n de Chocolate, Cerveza y Electricidad", 
     xlab = "Tiempo",
     sub = "Enero de 1958 - Diciembre de 1990")

################################################

# Serie de temperaturas globales, expresadas como anomalÃ­as de las medias mensuales

Global <- scan("global.txt")
Global.ts <- ts(Global, st = c(1856, 1), end = c(2005, 12), fr = 12)
Global.annual <- aggregate(Global.ts, FUN = mean)
plot(Global.ts, xlab = "Tiempo", ylab = "Temperatura en ÃÂ°C", main = "Serie de Temperatura Global",
     sub = "Serie mensual: Enero de 1856 a Diciembre de 2005")
plot(Global.annual, xlab = "Tiempo", ylab = "Temperatura en ÃÂ°C", main = "Serie de Temperatura Global",
     sub = "Serie anual de temperaturas medias: 1856 a 2005")

################################################

New.series <- window(Global.ts, start = c(1970, 1), end = c(2005, 12)) 
New.time <- time(New.series)
plot(New.series, xlab = "Tiempo", ylab = "Temperatura en ÃÂ°C", main = "Serie de Temperatura Global",
     sub = "Serie mensual: Enero de 1970 a Diciembre de 2005"); abline(reg = lm(New.series ~ New.time))


#### DescomposiciÃ³n de series

# Modelo Aditivo

# Se debe elegir entre el modelo aditivo o el modelo multiplicativo cuando sea razonable suponer la descomposiciÃ³n
Elec.decom.A <- decompose(Elec.ts)

plot(Elec.decom.A, xlab = "Tiempo", 
     sub = "DescomposiciÃ³n de los datos de producciÃ³n de electricidad")

# Componentes

Tendencia <- Elec.decom.A$trend
Estacionalidad <- Elec.decom.A$seasonal
Aleatorio <- Elec.decom.A$random

ts.plot(cbind(Tendencia, Tendencia + Estacionalidad+Aleatorio), 
        xlab = "Tiempo", main = "Datos de ProducciÃ³n de Electricidad", 
        ylab = "ProducciÃ³n de electricidad", lty = 1:2,
        sub = "Tendencia con efectos estacionales aditivos sobrepuestos")

Tendencia[20] + Estacionalidad[20] + Aleatorio[20]
Elec.ts[20]

###

# Modelo Multiplicativo

Elec.decom.M <- decompose(Elec.ts, type = "mult")

plot(Elec.decom.M, xlab = "Tiempo", 
     sub = "DescomposiciÃ³n de los datos de producciÃ³n de electricidad")

# Componentes

Trend <- Elec.decom.M$trend
Seasonal <- Elec.decom.M$seasonal
Random <- Elec.decom.M$random

ts.plot(cbind(Trend, Trend*Seasonal), xlab = "Tiempo", main = "Datos de ProducciÃ³n de Electricidad", 
        ylab = "ProducciÃ³n de electricidad", lty = 1:2,
        sub = "Tendencia con efectos estacionales multiplicativos sobrepuestos")

Trend[20]*Seasonal[20]*Random[20]
Elec.ts[20]

Trend[100]*Seasonal[100]*Random[100]
Elec.ts[100]


# J. Cryer & K. Chan. (2008). Time Series Analysis With Applications 
# in R. 233 Spring Street, New York, NY 10013, USA: Springer 
# Science+Business Media, LLC.

# P. Cowpertwait & A. Metcalfe. (2009). Introductory Time Series with R. 
# 233 Spring Street, New York, NY 10013, USA: Springer Science+Business 
# Media, LLC.
```

## Ejemplo 2
```r
# Ejemplo 2. Modelos estocÃ¡sticos bÃ¡sicos, modelos estacionarios y predicciÃ³n

# Ruido Blanco y simulaciÃ³n en R

set.seed(1)
w <- rnorm(100)
plot(w, type = "l", xlab = "")
title(main = "Ruido Blanco Gaussiano", xlab = "Tiempo")

###

# Para ilustrar mediante simulaciÃ³n como las muestras pueden diferir 
# de sus poblaciones subyacentes considere lo siguiente

x <- seq(-3, 3, length = 1000)
hist(rnorm(100), prob = T, ylab = "", xlab = "", main = "") 
points(x, dnorm(x), type = "l")
title(ylab = "Densidad", xlab = "Valores simulados de la distribuciÃ³n normal estandar",
      main = "ComparaciÃ³n de una muestra con su poblaciÃ³n subyacente")

###

set.seed(2)
acf(rnorm(100), main = "")
title(main = "FunciÃ³n de AutocorrelaciÃ³n Muestral", 
      sub = "Valores simulados de la distribuciÃ³n normal estandar")

###

# Caminata Aleatoria
# SimulaciÃ³n en R

x <- w <- rnorm(1000)
for(t in 2:1000) x[t] <- x[t-1] + w[t]
plot(x, type = "l", main = "Caminata Aleatoria Simulada", 
     xlab = "t", ylab = expression(x[t]), 
     sub = expression(x[t]==x[t-1]+w[t]))
acf(x, main = "")
title(main = "Correlograma para la caminata aleatoria simulada", 
      sub = expression(x[t]==x[t-1]+w[t]))

# Buscar otro modelo, hay una alta autocorrelacion

###

# Modelos Ajustados y grÃ¡ficas de diagnÃ³stico
# Series de caminatas aleatorias simuladas

# El correlograma de las series de diferencias puede usarse para evaluar si una serie dada
# puede modelarse como una caminata aleatoria

acf(diff(x), main = "")
title(main = "Correlograma de la serie de diferencias", 
      sub = expression(nabla*x[t]==x[t]-x[t-1]))

#### Modelos AR(p), MA(q) y ARMA(p, q)

# Modelos AR(p)

# Correlograma de un proceso AR(1)

rho <- function(k, alpha) alpha^k

plot(0:10, rho(0:10, 0.7), type = "h", ylab = "", xlab = "")
title(main = "Correlograma para un proceso AR(1)",
      ylab = expression(rho[k] == alpha^k),
      xlab = "lag k",
      sub = expression(x[t]==0.7*x[t-1]+w[t]))

plot(0:10, rho(0:10, -0.7), type = "h", ylab = "", xlab = "")
title(main = "Correlograma para un proceso AR(1)",
      ylab = expression(rho[k] == alpha^k),
      xlab = "lag k",
      sub = expression(x[t]==-0.7*x[t-1]+w[t]))
abline(h = 0)

###

# SimulaciÃ³n en R

# Un proceso AR(1) puede ser simulado en R como sigue:

set.seed(1)
x <- w <- rnorm(100)
for(t in 2:100) x[t] <- 0.7 * x[t-1] + w[t]
plot(x, type = "l", xlab = "", ylab = "")
title(main = "Proceso AR(1) simulado",
      xlab = "Tiempo",
      ylab = expression(x[t]),
      sub = expression(x[t]==0.7*x[t-1]+w[t]))

#

acf(x, main = "")
title(main = "Correlograma del proceso AR(1) simulado", 
      sub = expression(x[t]==0.7*x[t-1]+w[t]))

#

pacf(x, main = "")
title(main = "Correlograma Parcial del proceso AR(1) simulado", 
      sub = expression(x[t]==0.7*x[t-1]+w[t]))

###

# Modelos Ajustados

# Ajuste de modelos a series simuladas

x.ar <- ar(x, method = "mle")
x.ar$order
x.ar$ar
x.ar$ar + c(-2, 2)*sqrt(x.ar$asy.var)

# Serie de temperaturas globales, expresadas como anomalÃ­as de las medias mensuales: Ajuste de un modelo AR

Global <- scan("global.txt")
Global.ts <- ts(Global, st = c(1856, 1), end = c(2005, 12), fr = 12)
Global.annual <- aggregate(Global.ts, FUN = mean)
plot(Global.ts, xlab = "Tiempo", ylab = "Temperatura en ÃÂ°C", 
     main = "Serie de Temperatura Global",
     sub = "Serie mensual: Enero de 1856 a Diciembre de 2005")
plot(Global.annual, xlab = "Tiempo", ylab = "Temperatura en ÃÂ°C", 
     main = "Serie de Temperatura Global",
     sub = "Serie anual de temperaturas medias: 1856 a 2005")

#

mean(Global.annual)
Global.ar <- ar(Global.annual, method = "mle")
Global.ar$order
Global.ar$ar
acf(Global.ar$res[-(1:Global.ar$order)], lag = 50, main = "")
title(main = "Correlograma de la serie de residuales",
      sub = "Modelo AR(4) ajustado a la serie de temperaturas globales anuales")

####################################################################################################################################################

# Modelos MA(q)

# Ejemplos en R: Correlograma y SimulaciÃ³n

# FunciÃ³n en R para calcular la FunciÃ³n de AutocorrelaciÃ³n

rho <- function(k, beta){
  q <- length(beta) - 1
  if(k > q) ACF <- 0 else {
    s1 <- 0; s2 <- 0
    for(i in 1:(q-k+1)) s1 <- s1 + beta[i]*beta[i + k]
    for(i in 1:(q+1)) s2 <- s2 + beta[i]^2
    ACF <- s1/s2}
  ACF}

# Correlograma para un proceso MA(3)

beta <- c(1, 0.7, 0.5, 0.2)
rho.k <- rep(1, 10)
for(k in 1:10) rho.k[k] <- rho(k, beta)
plot(0:10, c(1, rho.k), ylab = expression(rho[k]), xlab = "lag k", type = "h",
     sub = expression(x[t] == w[t] + 0.7*w[t-1] + 0.5*w[t-2] + 0.2*w[t-3]),
     main = "FunciÃ³n de autocorrelaciÃ³n para un proceso MA(3)")
abline(0, 0)

# Correlograma para otro proceso MA(3)

beta <- c(1, -0.7, 0.5, -0.2)
rho.k <- rep(1, 10)
for(k in 1:10) rho.k[k] <- rho(k, beta)
plot(0:10, c(1, rho.k), ylab = expression(rho[k]), xlab = "lag k", type = "h",
     sub = expression(x[t] == w[t] - 0.7*w[t-1] + 0.5*w[t-2] - 0.2*w[t-3]),
     main = "FunciÃ³n de autocorrelaciÃ³n para un proceso MA(3)")
abline(0, 0)

####################################################################################################################################################

# SimulaciÃ³n de un proceso MA(3)

set.seed(1)
b <- c(0.8, 0.6, 0.4)
x <- w <- rnorm(1000)
for(t in 4:1000){
  for(j in 1:3) x[t] <- x[t] + b[j]*w[t-j]
}

plot(x, type = "l", ylab = expression(x[t]), xlab = "Tiempo t",
     sub = expression(x[t] == w[t] + 0.8*w[t-1] + 0.6*w[t-2] + 0.4*w[t-3]),
     main = "Serie de tiempo simulada de un proceso MA(3)")

###

acf(x, main = "")
title(main = "Correlograma para un proceso MA(3) simulado", 
      sub = expression(x[t] == w[t] + 0.8*w[t-1] + 0.6*w[t-2] + 0.4*w[t-3]))

####################################################################################################################################################

# Ajuste de modelos MA 

x.ma <- arima(x, order = c(0, 0, 3))
x.ma

####################################################################################################################################################

# Modelos ARMA(p, q)


# SimulaciÃ³n y Ajuste

set.seed(1)
x <- arima.sim(n = 10000, list(ar = -0.6, ma = 0.5))
plot(x[1:100], type = "l", xlab = "")
title(main = "Serie simulada", xlab = "Tiempo", 
      sub = expression(x[t] == -0.6*x[t-1] + w[t] + 0.5*w[t-1]))

#

coef(arima(x, order = c(1, 0, 1)))

#### PredicciÃ³n

# Serie de producciÃ³n de electricidad

CBE <- read.csv("cbe.csv", header = TRUE)
Elec.ts <- ts(CBE[, 3], start = 1958, freq = 12)
plot(Elec.ts, xlab = "", ylab = "")
title(main = "Serie de ProducciÃ³n de Electricidad",
      xlab = "Tiempo",
      ylab = "ProducciÃ³n de electricidad")

#

plot(log(Elec.ts), xlab = "", ylab = "")
title(main = "Serie-log de ProducciÃ³n de Electricidad",
      xlab = "Tiempo",
      ylab = "Log de ProducciÃ³n de electricidad")

# El siguiente modelo que se ajustarÃ¡ no serÃ¡ un buen modelo, porque en los residuales aÃºn quedarÃ¡n autocorrelaciones estadÃ­sticamente diferentes de cero

Time <- 1:length(Elec.ts)
Imth <- cycle(Elec.ts)
Elec.lm <- lm(log(Elec.ts) ~ Time + I(Time^2) + factor(Imth))

#

acf(resid(Elec.lm), main = "")
title(main = "Correlograma de la serie de residuales del modelo de regresiÃ³n",
      sub = "Serie de producciÃ³n de electricidad")

#

plot(resid(Elec.lm), type = "l", main = "", xlab = "", ylab = "")
title(main = "Serie de residuales del modelo de regresiÃ³n ajustado",
      sub = "Serie de producciÃ³n de electricidad",
      xlab = "Tiempo",
      ylab = "Residuales")

###

# CÃ³digo para encontrar el mejor modelo ARMA(p, q) considerando el AIC 
# (Akaike Information Criterion). El ajuste se lleva a cabo para los residuales del ajuste anterior.

best.order <- c(0, 0, 0)
best.aic <- Inf
for(i in 0:2)for(j in 0:2){
  model <- arima(resid(Elec.lm), order = c(i, 0, j))
  fit.aic <- AIC(model)
  if(fit.aic < best.aic){
    best.order <- c(i, 0, j)
    best.arma <- arima(resid(Elec.lm), order = best.order)
    best.aic <- fit.aic
  }
}

best.order

#

acf(resid(best.arma), main = "")
title(main = "Serie de residuales del modelo ARMA(2, 0) ajustado",
      sub = "Serie de residuales del modelo de regresiÃ³n ajustado a los datos de electricidad")

#### Las siguientes predicciones aÃºn pueden ser mejoradas con un modelo "mÃ¡s adecuado"

new.time <- seq(length(Elec.ts)+1, length = 36)
new.data <- data.frame(Time = new.time, Imth = rep(1:12, 3))
predict.lm <- predict(Elec.lm, new.data)
predict.arma <- predict(best.arma, n.ahead = 36)
elec.pred <- ts(exp(predict.lm + predict.arma$pred), start = 1991, freq = 12)

#

ts.plot(cbind(Elec.ts, elec.pred), lty = 1:2, 
        col = c("blue", "red"), xlab = "Tiempo", 
        ylab = "ProducciÃ³n de electricidad",
        main = "PredicciÃ³n de los datos de producciÃ³n de electricidad",
        sub = "PredicciÃ³n de 36 meses")


Â© 2021 GitHub, Inc.
Terms
Privacy
Security
Status
Docs
Contact GitHub
Pricing
API
Training
Blog
About

```

## Ejemplo 3
```r

```

## Ejemplo 4
```r

```


# Retos

## Reto 1
```r

```

## Reto 2
```r

```

## Reto 3
```r

```
