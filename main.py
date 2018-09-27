from tkinter import Tk, Label, Button, Text, StringVar, END, INSERT
from tkinter.ttk import Label, Button, Entry


class MyFirstGUI:
    def __init__(self, master):
        self.master = master
        master.title("A simple GUI")

        self.label = Label(master, text="This is our first GUI!")
        self.label.pack()

        self.labelText = StringVar()
        self.utterance = Entry(
            master, textvariable=self.labelText)
        self.utterance.pack()
        self.utterance.insert(END, "Dit is de originele uiting.")

        self.print_button = Button(master, text="print", command=self.printT)
        self.print_button.pack()

        self.insert_button = Button(
            master, text="insert", command=lambda: self.insert_into_entry("---"))
        self.insert_button.pack()

        self.greet_button = Button(master, text="Greet", command=self.greet)
        self.greet_button.pack()

        self.close_button = Button(master, text="Close", command=master.quit)
        self.close_button.pack()

    def greet(self):
        print("Greetings!")

    def printT(self):
        print(self.utterance.get())
        print(self.utterance.index(INSERT))

    def insert_into_entry(self, addition):
        cursor_position = self.utterance.index(INSERT)
        prefix = self.utterance.get()[0:cursor_position]
        suffix = self.utterance.get()[cursor_position:-1]
        self.labelText.set(prefix + addition + suffix)


root = Tk()
my_gui = MyFirstGUI(root)
root.mainloop()
