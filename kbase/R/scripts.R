setwd('C:/Users/heavyrick/Desktop/datascience/kbase/R') # windows- pc
#setwd('C:/Users/ricardo/Desktop/ds/datascience/kbase/R') # windows
#setwd('/home/usuario/www/repositorios/datascience/kbase/R') # linux

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

title_text = 'Eleições municipais 2016 | Americana: '

" 
Os votos ficam na base `df_secao_votacao_num` e devem ser juntados com a base `df_partidos`. Temos que retornar a quantidade de votos por 
sigla partidária, não mostrando os que não tiveram votos.
"

# Select dos dados

df1 = sqldf("
      SELECT p.Sigla, SUM(v.QT_VOTOS) as Votos 
      FROM df_partidos p
      LEFT JOIN df_secao_votacao_mun v ON p.Legenda = v.NR_PARTIDO
      GROUP BY p.Sigla
      HAVING SUM(v.QT_VOTOS) > 0
      ORDER BY Votos DESC
      ")

# O gráfico primeiro é preparado ordendando as colunas por quantidade de votos
# a propriedade fill dá um degradê interessante para a contagem

chart_df1 <- ggplot(df1, aes(x = reorder(Sigla, -Votos), y = Votos, fill=as.factor(Votos)))

# Gráfico de barras horizontais para mostrar as votações
# Fosse vertical os nomes iam ficar difíceis de ler, iam ficar encavalados
chart_df1 + 
  geom_bar(stat = "identity") + 
  scale_fill_grey(start = 0.65, end = 0.20) +
  coord_flip() + 
  ggtitle(paste(title_text, 'Votos por partido')) + 
  xlab('Partidos') + 
  ylab('Qtde Votos') +
  theme(legend.position="none",
        plot.title = element_text(size = 11, face='bold'), 
        axis.title = element_text(size=12, color='black'))

"
Fica claro pelo gráfico que os partidos MDB, PSDB, PV, PDT e PCdoB são os que possuem a maior quantidade de votos
para vereadores. O MDB, mesmo partido do prefeito, fica bem isolado a frente, seguido pelo PSDB,
partido do último prefeito eleito.
"

# 2) Qual a quantidade de vereadores que receberam votos por partido?

# Select dos dados

df2 = sqldf("
      SELECT p.Sigla, COUNT(DISTINCT v.NR_VOTAVEL) as Candidatos 
      FROM df_partidos p
      INNER JOIN df_secao_votacao_mun v ON p.Legenda = v.NR_PARTIDO
      GROUP BY p.Sigla
      ORDER BY Candidatos DESC
      ")

chart_df2 <- ggplot(df2, aes(x = reorder(Sigla, -Candidatos), y = Candidatos, fill=as.factor(Candidatos)))
chart_df2 + 
  geom_bar(stat = "identity") + 
  scale_fill_grey(start = 0.85, end = 0.20) +
  coord_flip() + 
  ggtitle(paste(title_text, 'Quantidade de candidatos que receberam votos por partido')) + 
  xlab('Partidos') + 
  ylab('Qtde Candidatos') +
  theme(legend.position="none",
        plot.title = element_text(size = 11, face='bold'), 
        axis.title = element_text(size=12, color='black'))

"
Vemos que o padrão se segue, os partidos com mais votos são aqueles que tiveram mais candidatos
com votos,
"

# 3) Qual a distribuição dos votos por espectro político?

# Select dos dados

df3 = sqldf("
      SELECT 
        p.Espectro,
        (CASE 
          WHEN p.Espectro = 'EE' THEN 1
          WHEN p.Espectro = 'E' THEN 2
          WHEN p.Espectro = 'CE' THEN 3
          WHEN p.Espectro = 'C' THEN 4
          WHEN p.Espectro = 'CD' THEN 5
          WHEN p.Espectro = 'D' THEN 6
          WHEN p.Espectro = 'ED' THEN 7
        END) AS ColorIdx,
        SUM(v.QT_VOTOS) as Votos 
      FROM df_partidos p
      LEFT JOIN df_secao_votacao_mun v ON p.Legenda = v.NR_PARTIDO
      GROUP BY p.Espectro
      HAVING SUM(v.QT_VOTOS) > 0
      ORDER BY Votos DESC
      ")

# Feito a escala de cores manualmente pelo https://www.colorhexa.com

chart_df3 <- ggplot(df3, aes(x = reorder(Espectro, ColorIdx), y = Votos, fill=as.factor(ColorIdx)))
chart_df3 + 
  geom_bar(width=0.7, stat = "identity") + 
  #scale_fill_gradient(low = "red", high = "blue") +
  scale_fill_manual(values = c("#990000", "#80001a", "#660033", "#4d004d", "#330066", "#1a0080", "#000099") ) +
  ggtitle(paste(title_text,'Quantidade de votos por espectro político')) + 
  xlab('Espectro') + 
  ylab('Votos') +
  theme(legend.position="none",
        plot.title = element_text(size = 11, face='bold'), 
        axis.title = element_text(size=12, color='black'))


