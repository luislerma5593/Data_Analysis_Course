# Reto 3.3

setwd("C:/Users/LLerma/Google Drive/Analisis de Datos/M2 - Programacion y Estadistica con R/S3/Files")

# 1 Importa los datos de producci�n de electricidad que se encuentra en el archivo cbe.csv a R

data <- read.csv("cbe.csv")


# 2 Crea la serie de tiempo mensual de producci�n de electricidad en R a partir del a�o 1958

(datats <- ts(data$elec, start=1958, frequency=12))

start(datats); end(datats); frequency(datats)

# Frequency
# 1 ??? Annual
# 4 ??? Quarterly
# 12 ??? Monthly
# 52 ??? Weekly

# 3 Realiza la descomposición multiplicativa de la serie de tiempo y grafica la serie original junto con sus componentes (tendencia, estacionalidad y componente aleatoria)

tsm <- decompose(datats, type = "multiplicative" )

plot(tsm)


# 4 Realiza la gráfica de tendencia y coloca la gráfica de tendencia x estacionalidad superpuesta a esta

plot(datats, main="Consumo de energ�a el�ctrica")
lines(tsm$seasonal*tsm$trend , col="red", lty=2, lwd=1)
lines(tsm$trend, col="blue", lty=1, lwd=2)

# Otra forma

ts.plot(cbind(tsm$trend,tsm$seasonal*tsm$trend), xlab = "Tiempo", main = "Datos de Producción de Electricidad", 
        ylab = "Producción de electricidad", lty = 1:2,
        sub = "Tendencia con efectos estacionales multiplicativos sobrepuestos")


plot(tsm$seasonal*tsm$trend , col="red", lty=2, lwd=1)
lines(tsm$trend, col="blue", lty=1, lwd=2)

