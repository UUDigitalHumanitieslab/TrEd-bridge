
from tkinter import Frame, Tk

from alpino_input import AlpinoInputPage
from functions import process_input
from utterance import UtterancePage


class TredBridgeMain(Tk):
    def __init__(self, input_path, *args, **kwargs):
        Tk.__init__(self, *args, **kwargs)
        self.input_path = input_path
        self.origutt, self.new_metadata = process_input(self.input_path)

        container = Frame(self)
        container.pack(side="top", fill="both", expand=True)
        container.grid_rowconfigure(0, weight=1)
        container.grid_columnconfigure(0, weight=1)

        self.frames = {}
        frame = AlpinoInputPage(self.origutt, container, self)
        self.frames[AlpinoInputPage] = frame

        frame.grid(row=0, column=0, sticky="nsew")
        self.show_frame(AlpinoInputPage)

    def show_frame(self, cont):
        frame = self.frames[cont]
        frame.tkraise()


if __name__ == '__main__':
    app = TredBridgeMain(input_path='vk_example.xml')
    app.geometry('500x500')
    app.focus()
    app.mainloop()
