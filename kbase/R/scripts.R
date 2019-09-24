#setwd('C:\Users\ricardo\Desktop\ds\datascience\kbase\R') # windows
setwd('/home/usuario/www/repositorios/datascience/kbase/R') # linux

"
Eleições Municipais 2016: Americana/SP - Vereadores

Análise de dados das eleições de Americana/SP do ano 2016.

> Objetivos:
* Entender a distribuição de votos por partido nas seções;
* Listar os partidos por votação;
* Analisar o desempenho da esquerda na votação na cidade;
"

# Carregar dados
source(file = "ler_dados.R", encoding = "UTF-8")

##
sqldf("SELECT * FROM df_partidos ORDER BY Legenda ASC")

#================================================================#

# Partidos e espectros políticos

# 1) Qual a quantidade de votos por partido ?

" 
Os votos ficam na base `df_secao_votacao_num` e devem ser juntados  com a base `df_partidos`. Temos que retornar a quantidade de votos por 
sigla partidária, não mostrando os que não tiveram votos.
"

df1 = sqldf("
      SELECT p.Sigla, SUM(v.QT_VOTOS) as votos 
      FROM df_partidos p
      LEFT JOIN df_secao_votacao_mun v ON p.Legenda = v.NR_PARTIDO
      GROUP BY p.Sigla
      HAVING SUM(v.QT_VOTOS) > 0
      ORDER BY votos DESC
      ")


# http://material.curso-r.com/ggplot/
#ggplot(data = df1)





