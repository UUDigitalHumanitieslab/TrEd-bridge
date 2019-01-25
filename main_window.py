
from tkinter import Frame, Tk, ttk, Label, Button

from alpino_page import AlpinoInputPage
from utterance_page import UtterancePage
from functions import process_input
from styles import apply_styles

from TK_extensions.entry_dialog import EntryDialog


class TredBridgeMain(Tk):
    def __init__(self, input_path, *args, **kwargs):
        Tk.__init__(self, *args, **kwargs)
        self.input_path = input_path
        self.origutt, self.new_metadata = process_input(self.input_path)

        menu_bar = Label(self, text="TrEd utterance editor for Alpino", bg='#A8CD28',
                         font=("Roboto", 32), height=3)
        menu_bar.pack(side="top", fill="both", expand=True)
        container = Frame(self)
        container.pack(side="top", fill="both", expand=True)

        self.frames = {}
        alpino_page_frame = AlpinoInputPage(self.origutt, container, self)
        utterance_page_frame = UtterancePage(self.origutt, container, self)
        self.frames[AlpinoInputPage] = alpino_page_frame
        self.frames[UtterancePage] = utterance_page_frame

        utterance_page_frame.grid(row=0, column=0, sticky="nsew")
        alpino_page_frame.grid(row=0, column=0, sticky="nsew")
        self.show_frame(AlpinoInputPage)

    def show_frame(self, cont):
        frame = self.frames[cont]
        frame.tkraise()


if __name__ == '__main__':
    app = TredBridgeMain(input_path='vk_example.xml')
    s = ttk.Style()
    s.theme_use('aqua')
    apply_styles()
    # app.geometry('1048x768')
    # app.focus()
    app.mainloop()
