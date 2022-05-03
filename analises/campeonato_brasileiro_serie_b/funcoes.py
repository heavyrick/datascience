###################

def grafico_pontos(df, rotulo_x, rotulo_y, title):
    """
    Mostra o gráfico com o valor do coeficiente r, além da reta de regressão
    """
    coef = np.corrcoef(df[rotulo_x], df[rotulo_y])
    
    # Reta de regressão
    _x = df.loc[:, rotulo_x].values.reshape(-1, 1)
    _y = df.loc[:, rotulo_y].values.reshape(-1, 1)
    lr = LinearRegression()
    lr.fit(_x, _y)
    y_pred = lr.predict(_x)
    #reta = 'y^ = ' + str(lr.intercept_[0]) + str(lr.coef_[0]) + 'x'
    
    # Obter coeficiente de determinação r²
    r2 = lr.score(_x, _y)
    
    # Gráficos
    fig, ax = plt.subplots(figsize=(8, 5))
    ax.scatter(x=df[rotulo_x], y= df[rotulo_y] ,color='blue')
    ax.plot(df[rotulo_x], y_pred, color = '#F2929F')
    plt.suptitle(title, y=1.05, fontsize=18)
    plt.title("Correlação: " + 
              "{:.3f}".format(coef[0,1]) + " | Determinação: {:.2f}".format(r2) +
              "\n Reta: y^ = {:.3f} + {:.3f} x".format(lr.intercept_[0], lr.coef_[0][0])
             )
    ax.set(xlabel=rotulo_x, ylabel=rotulo_y)
    plt.show()

###################

def testar_coeficiente_r(df, x, y, alpha):
    """
    Testa o coeficiente de r
    """
    r = abs(np.corrcoef(df[x], df[y])[0][1])
    d_freedom = len(df) - 2
    critical_t = stats.t.ppf(alpha / 2, d_freedom)
    critical_r = np.sqrt( (critical_t ** 2) / ((critical_t ** 2) + d_freedom))
    if(r > critical_r):
        return {'r': round(r, 4), 'r_critico': round(critical_r, 4), 'alpha': alpha, 'significativo': True}
    else:
        return {'r': round(r, 4), 'r_critico': round(critical_r, 4), 'alpha': alpha, 'significativo': False}

###################

def teste_t(df, x, y, alpha):
    """
    Calcule a estatística de teste padronizada (Teste t)
    """
    r = np.corrcoef(df[x], df[y])[0][1]
    n = len(df)

    t_critico = stats.t.ppf((alpha / 2), n - 2)
    vec = [round(t_critico, 4), round(t_critico, 4) * -1]
    t = r / (np.sqrt((1 - (r ** 2)) / (n - 2)))
    
    if t > (t_critico * -1) or t < t_critico:
        return {'t': round(t, 4), 't_critico': vec, 'alpha': alpha, 'significativo': True}
    else:
        return {'t': round(t, 4), 't_critico': vec, 'alpha': alpha, 'significativo': False}