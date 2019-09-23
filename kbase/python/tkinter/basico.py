# -*- coding: utf-8 -*-
"""
Created on Fri Dec 14 09:27:19 2018

@author: ricardo.filho
"""

import tkinter as tk
from PIL import ImageTk, Image

root = tk.Tk()

# width x height + left + top
root.geometry('500x300+100+50')
root.title("Trevilub - DS")
root.iconbitmap(r'./images/play_button_Sgq_icon.ico')

text = tk.Label(root, text='Texto na tela', bg='red', fg='white')
text.pack(padx=10, pady=10)

#photo = ImageTk.PhotoImage(Image.open('./images/goku.jpg'))
#labelphoto = tk.Label(root, image = photo)
#labelphoto.pack(side="bottom", fill="both", expand="yes")

root.mainloop()

"""
import matplotlib, numpy, sys
matplotlib.use('TkAgg')
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
from matplotlib.figure import Figure
if sys.version_info[0] < 3:
    import Tkinter as Tk
else:
    import tkinter as Tk

root = Tk.Tk()

f = Figure(figsize=(5,4), dpi=100)
ax = f.add_subplot(111)

data = (20, 35, 30, 35, 27)

ind = numpy.arange(5)  # the x locations for the groups
width = .5

rects1 = ax.bar(ind, data, width)

canvas = FigureCanvasTkAgg(f, master=root)
canvas.show()
canvas.get_tk_widget().pack(side=Tk.TOP, fill=Tk.BOTH, expand=1)

Tk.mainloop()
"""