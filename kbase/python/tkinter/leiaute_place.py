from functools import partial
import tkinter as tk

def bt_click(botao):
    # Imprime o texto do botão
    print(botao["text"])
    #lb["text"] = "Funcionou"
    
def bt_onclick():
    # imprime o valor do edit
    valor = ed.get()
    print(valor)
    lb["text"] = valor    

janela = tk.Tk()

# Menubar
menubar = tk.Menu(janela)
filemenu = tk.Menu(menubar, tearoff=0)

# Submenu
menubar.add_cascade(label="File", menu=filemenu)
filemenu.add_command(label="Exit", command=janela.destroy)

# Botão 1
bt1 = tk.Button(janela, width=20, text="Botão 1")
bt1["command"] = partial(bt_click, bt1)
bt1.place(x=10, y=10)

# Botão 2
bt2 = tk.Button(janela, width=20, text="Botão 2")
bt2["command"] = partial(bt_click, bt2)
bt2.place(x=10, y=50)

# Botão 3
bt3 = tk.Button(janela, width=20, text="Botão 3", command=bt_onclick)
bt3.place(x=10, y=90)

# Edit
ed = tk.Entry(janela)
ed.place(x=10, y=130)

lb = tk.Label(janela, text="Teste")
lb.place(x=10, y=160)

janela.geometry("300x300+200+200")
janela.config(menu=menubar)
janela.mainloop()