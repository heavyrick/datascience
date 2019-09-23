from tkinter import *

# Função do login :
def login():
    # Login
    if (usuario.get()=="john" and senha.get()=="snow"):
        lb["text"] = "Login efetuado com sucesso!"
    else:
        lb["text"] = "Login inválido!"

# Interface Grafica :
janela = Tk()

base_xaxis = 30
base_yaxis = 20

usuario = Entry(janela)
usuario.place(x=base_xaxis + 70,y= base_yaxis)
label_usuario = Label(janela,text="Usuário: ")
label_usuario.place(x=base_xaxis,y= base_yaxis)

senha = Entry(janela)
senha.place(x=base_xaxis + 70,y=base_yaxis + 40)
label_usuario = Label(janela,text="Senha: ")
label_usuario.place(x=base_xaxis,y= base_yaxis + 40)

bt= Button(janela,text="Fazer Login",command=login)
bt.place(x=base_xaxis,y= base_yaxis + 90)

lb = Label (janela,text="Aguardando dados...")
lb.place(x=base_xaxis,y= base_yaxis + 150)

janela.geometry("300x300+200+200")
janela.title("Login")
janela.mainloop()