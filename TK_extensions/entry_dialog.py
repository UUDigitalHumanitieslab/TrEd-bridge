import tkinter as tk
import tkinter.ttk as ttk
import time


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
