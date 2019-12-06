db_access <<- 'remote'
setwd('/Users/ricardoalmeida/ds/datascience/r_analises/eleicoes_2018')
source(file = "load_data.R")

# DS_CARGO | DS_CARGO | 3: Governador / 5: Senado / 6: Dep Federal / 7: Dep Estadual

#########################################
# GERAL

#########################################
# Votos para deputado(a) estadual

votos_partido_dep_estadual_df = sqldf("
      SELECT p.Sigla, SUM(v.QT_VOTOS) as Votos 
      FROM df_partidos p
      LEFT JOIN df_votos_validos v ON p.Legenda = v.NR_PARTIDO
      WHERE v.CD_CARGO = 7 and p.Legenda = 50
      GROUP BY p.Sigla
      ")

# PSOL = 3222

###################################
# Votos para deputado(a) federal

votos_partido_dep_federal_df = sqldf("
      SELECT p.Sigla, SUM(v.QT_VOTOS) as Votos 
      FROM df_partidos p
      LEFT JOIN df_votos_validos v ON p.Legenda = v.NR_PARTIDO
      WHERE v.CD_CARGO = 6 and p.Legenda = 50
      GROUP BY p.Sigla
      ")

# PSOL = 2911

###################################
# Votos para senador(a)

votos_partido_senado_df = sqldf("
      SELECT p.Sigla, SUM(v.QT_VOTOS) as Votos 
      FROM df_partidos p
      LEFT JOIN df_votos_validos v ON p.Legenda = v.NR_PARTIDO
      WHERE v.CD_CARGO = 5 and p.Legenda = 50
      GROUP BY p.Sigla
      -- HAVING SUM(v.QT_VOTOS) > 0
      -- ORDER BY Votos DESC
      ")

# PSOL = 6277

#########################################
# CANDIDATOS

#########################################
# Votos para deputado(a) estadual

votos_candidato_dep_estadual_df = sqldf("
      SELECT 
        v.NR_VOTAVEL as Número, 
        v.NM_VOTAVEL as Candidato, 
        SUM(v.QT_VOTOS) as Votos,
        ROUND(
          CAST(SUM(v.QT_VOTOS) as real) / (
            SELECT SUM(v1.QT_VOTOS) 
            FROM df_partidos p1
            LEFT JOIN df_votos_validos v1 ON p1.Legenda = v1.NR_PARTIDO
            WHERE v1.CD_CARGO = 7 and p1.Legenda = 50
          ), 4 
        ) * 100  as VotosPorcento
      FROM df_partidos p
      LEFT JOIN df_votos_validos v ON p.Legenda = v.NR_PARTIDO
      WHERE v.CD_CARGO = 7 and p.Legenda = 50
      GROUP BY v.NR_VOTAVEL
      HAVING SUM(v.QT_VOTOS) > 0
      ORDER BY Votos DESC
      -- LIMIT 0,10
      ")

write.csv(votos_candidato_dep_estadual_df, 'export/votos_candidato_dep_estadual.csv')

#########################################
# Votos para deputado(a) federal

votos_candidato_dep_federal_df = sqldf("
      SELECT 
        v.NR_VOTAVEL as Número, 
        v.NM_VOTAVEL as Candidato, 
        SUM(v.QT_VOTOS) as Votos,
        ROUND(
          CAST(SUM(v.QT_VOTOS) as real) / (
            SELECT SUM(v1.QT_VOTOS) 
            FROM df_partidos p1
            LEFT JOIN df_votos_validos v1 ON p1.Legenda = v1.NR_PARTIDO
            WHERE v1.CD_CARGO = 6 and p1.Legenda = 50
          ), 4 
        ) * 100 as VotosPorcento
      FROM df_partidos p
      LEFT JOIN df_votos_validos v ON p.Legenda = v.NR_PARTIDO
      WHERE v.CD_CARGO = 6 and p.Legenda = 50
      GROUP BY v.NR_VOTAVEL
      HAVING SUM(v.QT_VOTOS) > 0
      ORDER BY Votos DESC
      -- LIMIT 0,10
      ")

write.csv(votos_candidato_dep_federal_df, 'export/votos_candidato_dep_federal.csv')

#########################################
# Votos para senador(a)

votos_candidato_senado_df = sqldf("
      SELECT 
        v.NR_VOTAVEL as Número, 
        v.NM_VOTAVEL as Candidato, 
        SUM(v.QT_VOTOS) as Votos,
        ROUND(
          CAST(SUM(v.QT_VOTOS) as real) / (
            SELECT SUM(v1.QT_VOTOS) 
            FROM df_partidos p1
            LEFT JOIN df_votos_validos v1 ON p1.Legenda = v1.NR_PARTIDO
            WHERE v1.CD_CARGO = 5 and p1.Legenda = 50
          ), 4 
        ) * 100  as VotosPorcento
      FROM df_partidos p
      LEFT JOIN df_votos_validos v ON p.Legenda = v.NR_PARTIDO
      WHERE v.CD_CARGO = 5 and p.Legenda = 50
      GROUP BY v.NR_VOTAVEL
      HAVING SUM(v.QT_VOTOS) > 0
      ORDER BY Votos DESC
      -- LIMIT 0,10
      ")

write.csv(votos_candidato_senado_df, 'export/votos_candidato_senado.csv')

#########################################
# BAIRROS

#########################################
# Votos para deputado(a) estadual

votos_bairro_dep_estadual_df = sqldf("
      SELECT 
        l.NM_BAIRRO as Bairro, 
        SUM(v.QT_VOTOS) as Votos,
        ROUND(
          CAST(SUM(v.QT_VOTOS) as real) / (
            SELECT SUM(v1.QT_VOTOS) 
            FROM df_partidos p1
            LEFT JOIN df_votos_validos v1 ON p1.Legenda = v1.NR_PARTIDO
            WHERE v1.CD_CARGO = 7 and p1.Legenda = 50
          ), 4 
        ) * 100  as VotosPorcento
      FROM  df_votos_validos v
      LEFT JOIN df_locais_votacao l ON l.NR_ZONA = v.NR_ZONA AND l.NR_SECAO = v.NR_SECAO
      LEFT JOIN df_partidos p ON p.Legenda = v.NR_PARTIDO
      WHERE v.CD_CARGO = 7 and p.Legenda = 50
      GROUP BY l.CD_BAIRRO
      ORDER BY Votos DESC
      ")

write.csv(votos_bairro_dep_estadual_df, 'export/votos_bairro_dep_estadual.csv')

###################################
# Votos para deputado(a) federal

votos_bairro_dep_federal_df = sqldf("
      SELECT 
        l.NM_BAIRRO as Bairro, 
        SUM(v.QT_VOTOS) as Votos,
        ROUND(
          CAST(SUM(v.QT_VOTOS) as real) / (
            SELECT SUM(v1.QT_VOTOS) 
            FROM df_partidos p1
            LEFT JOIN df_votos_validos v1 ON p1.Legenda = v1.NR_PARTIDO
            WHERE v1.CD_CARGO = 7 and p1.Legenda = 50
          ), 4 
        ) * 100  as VotosPorcento
      FROM  df_votos_validos v
      LEFT JOIN df_locais_votacao l ON l.NR_ZONA = v.NR_ZONA AND l.NR_SECAO = v.NR_SECAO
      LEFT JOIN df_partidos p ON p.Legenda = v.NR_PARTIDO
      WHERE v.CD_CARGO = 6 and p.Legenda = 50
      GROUP BY l.CD_BAIRRO
      ORDER BY Votos DESC
      ")

write.csv(votos_bairro_dep_federal_df, 'export/votos_bairro_dep_federal.csv')

#########################################
# Votos para senador(a)

votos_bairro_senado_df = sqldf("
      SELECT 
        l.NM_BAIRRO as Bairro, 
        SUM(v.QT_VOTOS) as Votos,
        ROUND(
          CAST(SUM(v.QT_VOTOS) as real) / (
            SELECT SUM(v1.QT_VOTOS) 
            FROM df_partidos p1
            LEFT JOIN df_votos_validos v1 ON p1.Legenda = v1.NR_PARTIDO
            WHERE v1.CD_CARGO = 7 and p1.Legenda = 50
          ), 4 
        ) * 100  as VotosPorcento
      FROM  df_votos_validos v
      LEFT JOIN df_locais_votacao l ON l.NR_ZONA = v.NR_ZONA AND l.NR_SECAO = v.NR_SECAO
      LEFT JOIN df_partidos p ON p.Legenda = v.NR_PARTIDO
      WHERE v.CD_CARGO = 5 and p.Legenda = 50
      GROUP BY l.CD_BAIRRO
      ORDER BY Votos DESC
      ")

write.csv(votos_bairro_senado_df, 'export/votos_bairro_senado.csv')

#########################################
# ESPECTRO POLÍTICO

#########################################
# Partidos da esquerda

partidos_esquerda_df = sqldf("SELECT * FROM df_partidos WHERE Espectro IN ('EE', 'E', 'CE')")

write.csv(partidos_esquerda_df, 'export/partidos_esquerda.csv')

#########################################
# Votos para deputado(a) estadual

votos_espectro_dep_estadual_df = sqldf("
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
        SUM(v.QT_VOTOS) as Votos,
        ROUND(
          CAST(SUM(v.QT_VOTOS) as real) / (
            SELECT SUM(v1.QT_VOTOS) 
            FROM df_partidos p1
            LEFT JOIN df_votos_validos v1 ON p1.Legenda = v1.NR_PARTIDO
            WHERE v1.CD_CARGO = 7 and p1.Espectro IN ('EE', 'E', 'CE')
          ), 4 
        ) * 100  as VotosPorcento
      FROM df_partidos p
      LEFT JOIN df_votos_validos v ON p.Legenda = v.NR_PARTIDO
      WHERE v.CD_CARGO = 7 AND p.Espectro IN ('EE', 'E', 'CE')
      GROUP BY p.Espectro
      HAVING SUM(v.QT_VOTOS) > 0
      ORDER BY ColorIdx ASC
      ")

write.csv(votos_espectro_dep_estadual_df, 'export/votos_espectro_dep_estadual.csv')

#########################################
# Votos para deputado(a) federal

votos_espectro_dep_federal_df = sqldf("
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
        SUM(v.QT_VOTOS) as Votos,
        ROUND(
          CAST(SUM(v.QT_VOTOS) as real) / (
            SELECT SUM(v1.QT_VOTOS) 
            FROM df_partidos p1
            LEFT JOIN df_votos_validos v1 ON p1.Legenda = v1.NR_PARTIDO
            WHERE v1.CD_CARGO = 6 and p1.Espectro IN ('EE', 'E', 'CE')
          ), 4 
        ) * 100  as VotosPorcento
      FROM df_partidos p
      LEFT JOIN df_votos_validos v ON p.Legenda = v.NR_PARTIDO
      WHERE v.CD_CARGO = 6 AND p.Espectro IN ('EE', 'E', 'CE')
      GROUP BY p.Espectro
      HAVING SUM(v.QT_VOTOS) > 0
      ORDER BY ColorIdx ASC
      ")

write.csv(votos_espectro_dep_federal_df, 'export/votos_espectro_dep_federal.csv')

#########################################
# Votos para senador(a)

votos_espectro_senado_df = sqldf("
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
        SUM(v.QT_VOTOS) as Votos,
        ROUND(
          CAST(SUM(v.QT_VOTOS) as real) / (
            SELECT SUM(v1.QT_VOTOS) 
            FROM df_partidos p1
            LEFT JOIN df_votos_validos v1 ON p1.Legenda = v1.NR_PARTIDO
            WHERE v1.CD_CARGO = 5 and p1.Espectro IN ('EE', 'E', 'CE')
          ), 4 
        ) * 100  as VotosPorcento
      FROM df_partidos p
      LEFT JOIN df_votos_validos v ON p.Legenda = v.NR_PARTIDO
      WHERE v.CD_CARGO = 5 AND p.Espectro IN ('EE', 'E', 'CE')
      GROUP BY p.Espectro
      HAVING SUM(v.QT_VOTOS) > 0
      ORDER BY ColorIdx ASC
      ")

write.csv(votos_espectro_senado_df, 'export/votos_espectro_senado.csv')

#########################################
# MAPAS

#########################################
# Votos para deputado(a) estadual

votos_partidos_dep_estadual_mapa = sqldf("
      SELECT 
        SUM(v.QT_VOTOS) AS Votos, 
        l.DS_LOCAL, 
        l.NR_LATITUDE as lat, 
        l.NR_LONGITUDE as lng, 
        l.NM_BAIRRO, 
        l.NM_CIDADE
      FROM df_votos_validos v 
      LEFT JOIN df_locais_votacao l ON l.NR_ZONA = v.NR_ZONA AND l.NR_SECAO = v.NR_SECAO
      LEFT JOIN df_partidos p ON p.Legenda = v.NR_PARTIDO
      WHERE v.CD_CARGO = 7 and p.Legenda = 50
      GROUP BY l.CD_LOCAL, l.NR_LATITUDE, l.NR_LONGITUDE, l.NM_BAIRRO, l.NM_CIDADE 
      ORDER BY Votos DESC
      ")

leaflet(data = votos_partidos_dep_estadual_mapa) %>% addTiles() %>%
  addMarkers(~lng, ~lat, 
             popup = paste(
               "<p><b>", as.character(votos_partidos_dep_estadual_mapa$DS_LOCAL), "</b> <br />",
               as.character(votos_partidos_dep_estadual_mapa$NM_BAIRRO), " <br /> ", 
               as.character(votos_partidos_dep_estadual_mapa$NM_CIDADE)  ,"/SP <br /> </p>",
               "<p><b>", as.character(votos_partidos_dep_estadual_mapa$Votos), " Votos</b> <br /> </p>"
             ), 
             label = as.character(votos_partidos_dep_estadual_mapa$Votos),
             labelOptions = labelOptions(noHide = T, direction = "bottom",
                                         style = list(
                                           "color" = "red",
                                           "font-family" = "serif",
                                           "font-style" = "bold",
                                           "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                           "font-size" = "12px",
                                           "border-color" = "rgba(0,0,0,0.5)"
                                         )))

#########################################
# Votos para deputado(a) federal

votos_partidos_dep_federal_mapa = sqldf("
      SELECT 
        SUM(v.QT_VOTOS) AS Votos, 
        l.DS_LOCAL, 
        l.NR_LATITUDE as lat, 
        l.NR_LONGITUDE as lng, 
        l.NM_BAIRRO, 
        l.NM_CIDADE
      FROM df_votos_validos v 
      LEFT JOIN df_locais_votacao l ON l.NR_ZONA = v.NR_ZONA AND l.NR_SECAO = v.NR_SECAO
      LEFT JOIN df_partidos p ON p.Legenda = v.NR_PARTIDO
      WHERE v.CD_CARGO = 6 and p.Legenda = 50
      GROUP BY l.CD_LOCAL, l.NR_LATITUDE, l.NR_LONGITUDE, l.NM_BAIRRO, l.NM_CIDADE 
      ORDER BY Votos DESC
      ")

leaflet(data = votos_partidos_dep_federal_mapa) %>% addTiles() %>%
  addMarkers(~lng, ~lat, 
             popup = paste(
               "<p><b>", as.character(votos_partidos_dep_federal_mapa$DS_LOCAL), "</b> <br />",
               as.character(votos_partidos_dep_federal_mapa$NM_BAIRRO), " <br /> ", 
               as.character(votos_partidos_dep_federal_mapa$NM_CIDADE)  ,"/SP <br /> </p>",
               "<p><b>", as.character(votos_partidos_dep_federal_mapa$Votos), " Votos</b> <br /> </p>"
             ), 
             label = as.character(votos_partidos_dep_federal_mapa$Votos),
             labelOptions = labelOptions(noHide = T, direction = "bottom",
                                         style = list(
                                           "color" = "red",
                                           "font-family" = "serif",
                                           "font-style" = "bold",
                                           "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                           "font-size" = "12px",
                                           "border-color" = "rgba(0,0,0,0.5)"
                                         )))

#########################################
# Votos para deputado(a) estadual

votos_partidos_dep_federal_mapa = sqldf("
      SELECT 
        SUM(v.QT_VOTOS) AS Votos, 
        l.DS_LOCAL, 
        l.NR_LATITUDE as lat, 
        l.NR_LONGITUDE as lng, 
        l.NM_BAIRRO, 
        l.NM_CIDADE
      FROM df_votos_validos v 
      LEFT JOIN df_locais_votacao l ON l.NR_ZONA = v.NR_ZONA AND l.NR_SECAO = v.NR_SECAO
      LEFT JOIN df_partidos p ON p.Legenda = v.NR_PARTIDO
      WHERE v.CD_CARGO = 6 and p.Legenda = 50
      GROUP BY l.CD_LOCAL, l.NR_LATITUDE, l.NR_LONGITUDE, l.NM_BAIRRO, l.NM_CIDADE 
      ORDER BY Votos DESC
      ")

leaflet(data = votos_partidos_dep_federal_mapa) %>% addTiles() %>%
  addMarkers(~lng, ~lat, 
             popup = paste(
               "<p><b>", as.character(votos_partidos_dep_federal_mapa$DS_LOCAL), "</b> <br />",
               as.character(votos_partidos_dep_federal_mapa$NM_BAIRRO), " <br /> ", 
               as.character(votos_partidos_dep_federal_mapa$NM_CIDADE)  ,"/SP <br /> </p>",
               "<p><b>", as.character(votos_partidos_dep_federal_mapa$Votos), " Votos</b> <br /> </p>"
             ), 
             label = as.character(votos_partidos_dep_federal_mapa$Votos),
             labelOptions = labelOptions(noHide = T, direction = "bottom",
                                         style = list(
                                           "color" = "red",
                                           "font-family" = "serif",
                                           "font-style" = "bold",
                                           "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                           "font-size" = "12px",
                                           "border-color" = "rgba(0,0,0,0.5)"
                                         )))

#########################################
# Votos para senador(a)

votos_partidos_senado_mapa = sqldf("
      SELECT 
        SUM(v.QT_VOTOS) AS Votos, 
        l.DS_LOCAL, 
        l.NR_LATITUDE as lat, 
        l.NR_LONGITUDE as lng, 
        l.NM_BAIRRO, 
        l.NM_CIDADE
      FROM df_votos_validos v 
      LEFT JOIN df_locais_votacao l ON l.NR_ZONA = v.NR_ZONA AND l.NR_SECAO = v.NR_SECAO
      LEFT JOIN df_partidos p ON p.Legenda = v.NR_PARTIDO
      WHERE v.CD_CARGO = 5 and p.Legenda = 50
      GROUP BY l.CD_LOCAL, l.NR_LATITUDE, l.NR_LONGITUDE, l.NM_BAIRRO, l.NM_CIDADE 
      ORDER BY Votos DESC
      ")

leaflet(data = votos_partidos_senado_mapa) %>% addTiles() %>%
  addMarkers(~lng, ~lat, 
             popup = paste(
               "<p><b>", as.character(votos_partidos_senado_mapa$DS_LOCAL), "</b> <br />",
               as.character(votos_partidos_senado_mapa$NM_BAIRRO), " <br /> ", 
               as.character(votos_partidos_senado_mapa$NM_CIDADE)  ,"/SP <br /> </p>",
               "<p><b>", as.character(votos_partidos_senado_mapa$Votos), " Votos</b> <br /> </p>"
             ), 
             label = as.character(votos_partidos_senado_mapa$Votos),
             labelOptions = labelOptions(noHide = T, direction = "bottom",
                                         style = list(
                                           "color" = "red",
                                           "font-family" = "serif",
                                           "font-style" = "bold",
                                           "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                           "font-size" = "12px",
                                           "border-color" = "rgba(0,0,0,0.5)"
                                         )))

#########################################
# Teste Calor

lf <- leaflet(data = votos_partidos_senado_mapa) %>%
  addProviderTiles(providers$CartoDB.Positron)


leaflet(data = votos_partidos_senado_mapa) %>%
  addTiles() %>%
  addMarkers(clusterOptions = markerClusterOptions()) 

purrr::walk(
  names(votos_partidos_senado_mapa),
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



