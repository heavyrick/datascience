#================================================================#
# Definindo o ambiente

ambiente = 'windowsPc'

switch(ambiente, 
  windowsPc={
   setwd('C:/Users/heavyrick/Desktop/datascience/r_analises/eleicoes')
  },
  windowsNote={
   setwd('C:/Users/ricardo/Desktop/ds/datascience/kbase/R')
  },
  linuxPC={
    setwd('/home/usuario/www/repositorios/datascience/kbase/R')
  }
)

#================================================================#

# Carregar dados

source(file = "eleicoes_carrega_dados.R", encoding = "UTF-8")

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

"
Neste gráfico vemos que a maioria dos votos ficaram concentrados nos partidos de centro direita, e houve um equilibrio
entre os partidos de esquerda, centro esquerda e centro. Os partidos nos extremos quase não receberam votos.
"

#================================================================#

# Seções e Bairros

# 1) Qual a distribuição de voto por seções?

"As seções não nos dizem muito sobre a distribuição dos votos, a diferença de votos entre elas é muito pequena. 
Talvez esteja relacionado com a distribuição do eleitorado em seções pelo TSE. 
Mas o que pode nos ajudar mais adiante, é entender a distribuição de votos por partido nos bairros.

o dataframe abaixo mostrará a quantidade total de votos por bairro.
"

df4 = sqldf("
      SELECT SUM(v.QT_VOTOS) AS Votos, l.NM_BAIRRO  
      FROM df_secao_votacao_mun v 
      LEFT JOIN df_locais_votacao l ON l.NR_ZONA = v.NR_ZONA AND l.NR_SECAO = v.NR_SECAO
      GROUP BY l.CD_BAIRRO
      ORDER BY Votos DESC
      ")

"Agora vamos para um mapa, para mostrar a distribuição dos votos na cidade, baseando-se nas seções"


df5 = sqldf("
      SELECT 
        SUM(v.QT_VOTOS) AS Votos, l.DS_LOCAL, l.NR_LATITUDE as lat, l.NR_LONGITUDE as lng, l.NM_BAIRRO, l.NM_CIDADE
      FROM 
        df_secao_votacao_mun v 
      LEFT JOIN 
        df_locais_votacao l ON l.NR_ZONA = v.NR_ZONA AND l.NR_SECAO = v.NR_SECAO
      GROUP BY 
        l.CD_LOCAL, l.NR_LATITUDE, l.NR_LONGITUDE, l.NM_BAIRRO, l.NM_CIDADE 
      ORDER BY 
        Votos DESC
      ")

# Mapa com todos os locais de votação e quantidade de votos em cada

leaflet(data = df5) %>% addTiles() %>%
  addMarkers(~lng, ~lat, 
             popup = paste(
                "<p><b>", as.character(df5$DS_LOCAL), "</b> <br />",
                as.character(df5$NM_BAIRRO), " <br /> ", 
                as.character(df5$NM_CIDADE)  ,"/SP <br /> </p>",
                "<p><b>", as.character(df5$Votos), " Votos</b> <br /> </p>"
             ), 
             label = as.character(df5$Votos),
             labelOptions = labelOptions(noHide = T, direction = "bottom",
                                         style = list(
                                           "color" = "red",
                                           "font-family" = "serif",
                                           "font-style" = "bold",
                                           "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                           "font-size" = "12px",
                                           "border-color" = "rgba(0,0,0,0.5)"
                                         )))


# Mapa com a distribuição dos votos nos locais de votação

mapa_votos <- function() {
  leaflet(data = df5) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addHeatmap(lng = ~lng, lat = ~lat, intensity = ~Votos, blur = 20, max = 0.05, radius = 15)
}

mapa_votos()



df6 = sqldf("
      SELECT 
        SUM(v.QT_VOTOS) AS Votos, l.DS_LOCAL, l.NR_LATITUDE as lat, l.NR_LONGITUDE as lng, l.NM_BAIRRO, l.NM_CIDADE, v.NR_PARTIDO, 
          (CASE WHEN p.Sigla IS NULL THEN 'BRANCO/NULO' ELSE p.Sigla END) AS Sigla
      FROM 
        df_secao_votacao_mun v 
      LEFT JOIN 
        df_locais_votacao l ON l.NR_ZONA = v.NR_ZONA AND l.NR_SECAO = v.NR_SECAO
      LEFT JOIN 
        df_partidos p ON p.Legenda = v.NR_PARTIDO  
      GROUP BY 
        l.CD_LOCAL, l.NR_LATITUDE, l.NR_LONGITUDE, l.NM_BAIRRO, l.NM_CIDADE, v.NR_PARTIDO 
      ORDER BY 
        Votos DESC
      ")

mapa_votos_2 <- function() {
  
  lf <- leaflet(data = df6) %>%
    addProviderTiles(providers$CartoDB.Positron)
  
  purrr::walk(
    names(df6),
    function(Sigla) {
     # print(Sigla)
      lf <<- lf %>%
        #addHeatmap(lng = ~lng, lat = ~lat, group =df6$Sigla, intensity = ~Votos, blur = 20, max = 0.05, radius = 15)
        addHeatmap(
          #data = df6[[Sigla]],
          layerId = Sigla, group = Sigla,
          lng=~lng, lat=~lat, intensity = ~Votos,
          blur = 20, max = 0.05, radius = 15)
    })
  
  lf %>%
    addLayersControl(
      baseGroups = names(df6),
      options = layersControlOptions(collapsed = FALSE)
    )
}

mapa_votos_2()


purrr::walk(
  names(df6),
  function(df) {
    
    print(df[df])
  }
)