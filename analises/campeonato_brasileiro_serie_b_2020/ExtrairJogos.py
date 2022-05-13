import requests
from bs4 import BeautifulSoup
import pandas as pd
import re

class ExtrairJogos:
    
    @staticmethod    
    def extrair_pagina(link_pagina):
        """
        Para realizar a solicitação à página temos que informar ao site que somos um navegador
        e é para isso que usamos a variável headers
        """
        headers = {'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36'}

        # endereco_da_pagina representa o link que direciona a página com os dados
        endereco_da_pagina = link_pagina

        # no objeto_response iremos realizar o download da página da web 
        objeto_response = requests.get(endereco_da_pagina, headers=headers)
        
        if objeto_response.status_code != 200:
            return False

        """
        Agora criaremos um objeto BeautifulSoup a partir do nosso objeto_response.
        O parâmetro 'html.parser' representa qual parser usaremos na criação do nosso objeto,
        um parser é um software responsável por realizar a conversão de uma entrada para uma estrutura de dados.
        """
        pagina = BeautifulSoup(objeto_response.content, 'html.parser')
        
        return pagina
    
    @staticmethod
    def extrair_area_dados(pagina):
        """
        Recebe a página extraída do site, e captura a área de interesse
        onde estão os dados da tabela de jogos (depois de feita a análise do html)
        
        Retorna uma lista com os blocos onde ficam os jogos
        """
        tabela = pagina.find('aside', {'class': 'aside-rodadas'})
        blocos = []
        for row in tabela.find('div').find_all('div', {'class': ['aside-content']}):
            blocos.append(row)
        
        return blocos
    
    
    @staticmethod
    def listar_rodadas(blocos):
        rodadas = []
        rodada = 1
        for bloco in blocos: # Rodada
            for celula in bloco.find_all('div', attrs={'class':['clearfix']}): # Jogos
                rodadas.append(rodada)
            rodada += 1
        return rodadas
    
    @staticmethod
    def listar_datas(blocos):
        datas = []
        for bloco in blocos: # Rodada
            for celula in bloco.find_all('span', attrs={'class':['partida-desc']}): # Jogos
                if(re.search(r'\d{2}/\d{2}/\d{4}', celula.get_text())):
                    mat = re.search(r'\d{2}/\d{2}/\d{4}', celula.get_text())
                    datas.append(mat.group())
        return datas
    
    @staticmethod
    def listar_time_casa(blocos):
        times = []
        for bloco in blocos: # Rodada
            for celula in bloco.find_all('div', attrs={'class':['clearfix']}): # Jogos
                div_casa = celula.find("div", {'class': ['pull-left']})
                div_casa = div_casa.find("img", {"class": "icon"}, {"title":True})
                times.append(div_casa['title'])
        return times
    
    @staticmethod
    def listar_time_visitante(blocos):
        times = []
        for bloco in blocos: # Rodada
            for celula in bloco.find_all('div', attrs={'class':['clearfix']}): # Jogos
                div_casa = celula.find("div", {'class': ['pull-right']})
                div_casa = div_casa.find("img", {"class": "icon"}, {"title":True})
                times.append(div_casa['title'])
        return times
    
    @staticmethod
    def listar_placares(blocos, time = 'casa'):
        """
        Retorna os gols feitos pela equipe, extraindo da string 'gol casa x gol visitante'
        A string 
        """
        placares = []
        for bloco in blocos: # Rodada
            for celula in bloco.find_all('div', attrs={'class':['clearfix']}): # Jogos
                placar = celula.find("strong", {'class': ['partida-horario']})
                txt = placar.get_text().strip()
                if time == 'casa':
                    placares.append(int(txt.split('x')[0]))
                else:
                    placares.append(int(txt.split('x')[1]))
        return placares
                    