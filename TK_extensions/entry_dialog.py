import tkinter as tk
import tkinter.ttk as ttk
import time
import math


class EntryDialog:
    def __init__(self, parent, labeltext="Input variable below"):
        top = self.top = tk.Toplevel(parent)
        self.myLabel = tk.Label(top, text=labeltext)
        self.myLabel.pack()
        self.myEntryBox = tk.Entry(top)
        self.myEntryBox.pack()
        self.myEntryBox.bind("<Return>", self.key)
        self.myEntryBox.focus()
        self.mySubmitButton = ttk.Button(top, text='Submit', command=self.send)
        self.mySubmitButton.pack()

    def key(self, event):
        self.send()

    def send(self):
        if self.myEntryBox.get() != '':
            self.results = self.myEntryBox.get()
            self.top.destroy()


class ComboBoxDialog:
    def __init__(self, parent, labeltext, options):
        top = self.top = tk.Toplevel(parent)
        self.options = options
        if isinstance(options, list):
            self.value = options
        else:
            self.value = ['{} - {}'.format(value, key)
                          for key, value in options.items()]
        # self.value = list(options.keys()) if isinstance(
        #     options, dict) else options
        self.width = math.floor(
            max([len(key)+len(value) for key, value in list(options.items())])*1.2)
        self.myLabel = tk.Label(top, text=labeltext)
        self.myLabel.pack()
        self.myComboBox = ttk.Combobox(
            top, value=self.value, state='readonly', width=self.width)
        self.myComboBox.pack()
        self.myComboBox.current(0)
        self.myComboBox.focus()
        self.mySubmitButton = ttk.Button(top, text='Submit', command=self.send)
        self.mySubmitButton.pack(fill=tk.X, expand=1)
        self.myComboBox.bind("<Return>", self.key)

    def key(self, event):
        self.send()

    def send(self):
        if isinstance(self.options, list):
            self.results = self.myComboBox.get()
        else:
            self.results = list(self.options.values())[
                self.myComboBox.current()]
        # self.results = self.options[self.myComboBox.get()] if isinstance(
        #     self.options, dict) else self.myComboBox.get()
        self.top.destroy()
