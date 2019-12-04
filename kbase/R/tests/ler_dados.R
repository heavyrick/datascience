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

#================================================================#

# Partidos

"
Sigla
Nome
Legenda
Espectro
"

col_partidos <- mongo("partidos", url = "mongodb://localhost:27017/eleicoes")
df_partidos = col_partidos$find ('{}')

#================================================================#

# Locais de votação

"
Zona
Seção
Local
Latitude
Longitude
Local Seção
Endereço
Bairro
IdBairro
Cidade
"

col_locais_votacao <- mongo("locais_votacao", url = "mongodb://localhost:27017/eleicoes")
df_locais_votacao = col_locais_votacao$find ('{}')

#================================================================#

# Votos por seção (eleições municipais)

"
DT_GERACAO
HH_GERACAO
AA_GERACAO
NR_TURNO
DS_ELEICAO
SG_UF
CD_MUNICIPIO
NM_MUNICIPIO
NR_ZONA
NR_SECAO
CD_CARGO
DS_CARGO
NR_VOTAVEL
NR_PARTIDO
QT_VOTOS
"

col_secao_votacao_mun <- mongo("secao_votacao_mun", url = "mongodb://localhost:27017/eleicoes")
df_secao_votacao_mun = col_secao_votacao_mun$find ('{}')

#================================================================#