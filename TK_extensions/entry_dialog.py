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
        self.value = list(options.keys()) if isinstance(
            options, dict) else options
        self.width = math.floor(
            max([len(item) for item in list(options.keys())])*1.2)
        self.myLabel = tk.Label(top, text=labeltext)
        self.myLabel.pack()
        self.myComboBox = ttk.Combobox(
            top, value=self.value, state='readonly', width=self.width)
        self.myComboBox.pack()
        self.myComboBox.current(0)
        self.myComboBox.focus()
        self.mySubmitButton = ttk.Button(top, text='Submit', command=self.send)
        self.mySubmitButton.pack()

    def send(self):
        self.results = self.options[self.myComboBox.get()] if isinstance(
            self.options, dict) else self.myComboBox.get()
        self.top.destroy()
