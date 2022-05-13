import requests
from bs4 import BeautifulSoup
import pandas as pd
from ExtrairJogos import ExtrairJogos

###################

def criar_dataframe(blocos):
    
    rodadas = ExtrairJogos.listar_rodadas(blocos)
    datas = ExtrairJogos.listar_datas(blocos)
    times_casa = ExtrairJogos.listar_time_casa(blocos)
    times_visitante = ExtrairJogos.listar_time_visitante(blocos)
    placar_times_casa = ExtrairJogos.listar_placares(blocos, 'casa')
    placar_times_visitante = ExtrairJogos.listar_placares(blocos, 'visitante')

    df = pd.DataFrame({
        'Rodada': rodadas, 
        'Data': datas,
        'Time casa': times_casa,
        'Gols time casa': placar_times_casa,
        'Time visitante': times_visitante,
        'Gols time visitante': placar_times_visitante
    }).reset_index(drop=True)
    
    return df