from tkinter import ttk


def apply_styles(app):
    app.resizable(False, False)
    app.configure(background="lightgrey")
    gui_style = ttk.Style()
    gui_style.theme_use('clam')
    gui_style.configure('TButton', background='#A8CD28')
    gui_style.configure('TButton', foreground='white')
    gui_style.configure('Red.TButton', background='indian red')
    gui_style.configure('Red.TButton', foreground='white')
    gui_style.configure('.', font=('Roboto', 20))
