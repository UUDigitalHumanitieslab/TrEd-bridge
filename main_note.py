
from tkinter import Frame, Label, Tk, ttk
from tkinter.ttk import Button, Notebook

from alpino_page import AlpinoInputPage
from functions import process_input
from styles import apply_styles
from TK_extensions.entry_dialog import EntryDialog
from utterance_page import UtterancePage


class TredBridgeMain(Tk):
    def __init__(self, input_path, *args, **kwargs):
        Tk.__init__(self, *args, **kwargs)
        self.input_path = input_path
        self.origutt, self.new_metadata = process_input(self.input_path)

        # phase the editor is currently in. 0=utterance, 1=alpino.
        self.phase = 0

        self.phase0 = self.origutt  # sentence at start
        self.phase1 = ''  # sentence after utterance phase
        self.phase2 = ''  # sentence after alpino editing

        # setup notebook
        self.notebook = Notebook(self)
        frame1 = ttk.Frame(self.notebook)
        frame2 = ttk.Frame(self.notebook)

        # add empty frames to notebook tabs
        self.notebook.add(frame1, text="Utterance Editor")
        self.notebook.add(frame2, text="Alpino Editor")
        self.notebook.grid()

        # fill the tab frames
        app1 = UtterancePage(parent=frame1, origutt=self.origutt)
        app1.grid()
        app2 = AlpinoInputPage(parent=frame2, origutt=self.origutt)
        app2.grid()

        # toggles
        self.alpino_toggle = False

        # setup
        self.notebook.tab(1, state='disabled')


if __name__ == '__main__':
    app = TredBridgeMain(input_path='vk_example.xml')
    s = ttk.Style()
    s.theme_use('clam')
    apply_styles()
    app.mainloop()
