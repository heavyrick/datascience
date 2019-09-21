import tkinter as tk
from tkinter import messagebox

root = tk.Tk()

root.title("Botão")
root.configure(bg="grey80")
#root.state("zoomed") 
root.geometry("600x300")

menubar = tk.Menu(root)
#root.config(menubar)

def donothing():
   filewin = tk.Toplevel(root)
   button = tk.Button(filewin, text="Do nothing button")
   button.grid()

# Criar submenus
submenu  = tk.Menu(menubar, tearoff=0)
menubar.add_cascade(label="File", menu=submenu)
submenu.add_command(label='Novo', command=donothing)
submenu.add_command(label='Abrir', command=donothing)
submenu.add_separator()
submenu.add_command(label='Fechar', command=donothing)

app = tk.Frame(root, borderwidth=1, relief='sunken')
app.grid(padx=1, pady=1, row=1, column=1)

app2 = tk.Frame(root, borderwidth=1, relief='sunken')
app2.grid(padx=1, pady=1, row=1, column=2)

app3 = tk.Frame(root, borderwidth=1, relief='sunken')
app3.grid(row=2, column=1, columnspan=2)

def hello():
    messagebox.showinfo('Hello', 'world')
    
def close_window():
    root.destroy()

# Botão normal
b1 = tk.Button(app, text="Hello", width=5, command=hello, bd=2, bg='blue', fg='white')
b1.grid(padx=20, pady=10)

# Botão fechar
bt_exit = tk.Button(app, text='Sair', width=4, command=close_window)
bt_exit.grid(padx=20, pady=10)

# Input
input_1 = tk.Entry(app, width=15)
input_1.grid(padx=20, pady=10)

# Label
label1 = tk.Label(app3, text='Texto', bg='red', fg='white', width=60)
label1.grid(padx=5, pady=10)

# Checkbutton

CheckVar1 = tk.IntVar()
CheckVar2 = tk.IntVar()

ck1 = tk.Checkbutton(app2, text='Cheque 1', variable=CheckVar1, \
                     onvalue=1, offvalue=0, height=2, width=20)

ck2 = tk.Checkbutton(app2, text='Cheque 2', variable=CheckVar2, \
                     onvalue=1, offvalue=0, height=2, width=20)
ck1.grid(padx=20, pady=10)
ck2.grid(padx=20, pady=10)

#b.pack()
root.config(menu=menubar)
root.mainloop()    