#================================================================#

# Bibliotecas

library(ggplot2)
library(dplyr)
library(maps)
library(ggmap)
library(mongolite)
library(lubridate)
library(gridExtra)
library(leaflet)
library(leaflet.extras) 
require (sqldf)
library(RColorBrewer)
library(htmltools)
library(shiny)

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

# Converter as colunas de latitude e longitude de valores `character` para `numeric`
df_locais_votacao$NR_LATITUDE <- as.numeric(df_locais_votacao$NR_LATITUDE)
df_locais_votacao$NR_LONGITUDE <- as.numeric(df_locais_votacao$NR_LONGITUDE)

# sapply(df_locais_votacao, class)

#================================================================#

# Votos por seção (eleições municipais Americana 2016)

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

# Votos por seção (eleições gerais 2018)

"
DT_GERACAO 
HH_GERACAO 
AA_GERACAO
CD_TIPO_ELEICAO
NM_TIPO_ELEICAO
NR_TURNO
CD_ELEICAO
DS_ELEICAO
DT_ELEICAO
TP_ABRANGENCIA
SG_UF
SG_UE 
NM_UE 
CD_MUNICIPIO 
NM_MUNICIPIO
NR_ZONA *
NR_SECAO *
CD_CARGO *
DS_CARGO *
NR_VOTAVEL * 
NR_PARTIDO *
NM_VOTAVEL *
QT_VOTOS *
"

"
Excluindo-se logo de cara os dados do segundo turno, 
e considerando os votos apenas para deputados estaduais e federais, 
e tirando os votos brancos e nulos (95,96)
"

col_secao_votacao_gerais <- mongo("secao_votacao_gerais", url = "mongodb://localhost:27017/eleicoes")
df_secao_votacao_gerais = col_secao_votacao_gerais$find(
  query =  '{"NR_TURNO": "1", "CD_CARGO": { "$in": ["6", "7"]}, "NR_VOTAVEL": {"$nin": ["95", "96"]} }',
  fields = '{"NR_ZONA": "1", "NR_SECAO": "1", "CD_CARGO": "1", "DS_CARGO": "1", "NR_VOTAVEL": "1", "NR_PARTIDO": "1", "NM_VOTAVEL": "1", "QT_VOTOS": "1"}',
  sort = '{}'
)

# Validar json 
#js <- '[{"NR_TURNO": "1", "CD_CARGO": { "$in": ["6", "7"]} }, ]'
#jsonlite::fromJSON(js)

#================================================================#

