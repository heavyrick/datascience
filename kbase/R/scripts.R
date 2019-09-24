setwd('C:\Users\ricardo\Desktop\ds\datascience\kbase\R')

# Bibliotecas
library(ggplot2)
library(dplyr)
library(maps)
library(ggmap)
library(mongolite)
library(lubridate)
library(gridExtra)
require (sqldf)

# inserir collections nos dataframes
col_partidos <- mongo("partidos", url = "mongodb://localhost:27017/eleicoes")
df_partidos = col_partidos$find ('{}')


sqldf("SELECT * FROM df_partidos ORDER BY Legenda ASC")


