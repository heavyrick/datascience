# Calculadora
import tkinter as tk
from tkinter import messagebox

root = tk.Tk()

def soma():
    # Soma
    if( str(ed1.get()).isnumeric() and str(ed2.get()).isnumeric()):
        val1 = int(ed1.get())
        val2 = int(ed2.get())
        lb["text"] = val1 + val2
    else:
        messagebox.showerror("Erro", "Operação Inválida")
    
def subtracao():
    # Subtração
    if( str(ed1.get()).isnumeric() and str(ed2.get()).isnumeric()):
        val1 = int(ed1.get())
        val2 = int(ed2.get())
        lb["text"] = val1 - val2
    else:
        messagebox.showerror("Erro", "Operação Inválida")

def multiplicacao():
    # Multiplicação
    if( str(ed1.get()).isnumeric() and str(ed2.get()).isnumeric()):
        val1 = int(ed1.get())
        val2 = int(ed2.get())
        lb["text"] = val1 * val2
    else:
        messagebox.showerror("Erro", "Operação Inválida")

def divisao():
    # Divisão
    if( str(ed1.get()).isnumeric() and str(ed2.get()).isnumeric()):
        val1 = int(ed1.get())
        val2 = int(ed2.get())
        if(val1 == 0):
            messagebox.showerror("Erro", "Divisão por zero")
        else:
            lb["text"] = val1 / val2
    else:
        messagebox.showerror("Erro", "Operação Inválida")

# Edits
ed1 = tk.Entry(root, width=35)
ed1.grid(padx=15, pady=30, row=1, column=1, columnspan=4)

ed2 = tk.Entry(root, width=35)
ed2.grid(padx=15, pady=1, row=2, column=1, columnspan=4)

# Botões
bt_soma = tk.Button(root, text=" + ", bg="blue", fg="white", width=4, command=soma)
bt_soma.grid(padx=0, pady=10, row=3, column=1)

bt_sub = tk.Button(root, text=" - ", bg="blue", fg="white", width=4, command=subtracao)
bt_sub.grid(padx=0, pady=10, row=3, column=2)

bt_mult = tk.Button(root, text=" x ", bg="blue", fg="white", width=4, command=multiplicacao)
bt_mult.grid(padx=0, pady=20, row=3, column=3)

bt_div = tk.Button(root, text=" / ", bg="blue", fg="white", width=4, command=divisao)
bt_div.grid(padx=0, pady=20, row=3, column=4)

# Label
lb = tk.Label(root, text="...")
lb.grid(padx=0, pady=20, row=6, column=1, columnspan=4)

# 
root.geometry("250x400+100+150")
root.title("Calculadora")
root.mainloop()