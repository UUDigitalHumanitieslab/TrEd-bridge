
from tkinter import Frame, Label, Tk, ttk
from tkinter.ttk import Button, Notebook

from alpino_page import AlpinoInputPage
from functions import process_input
from styles import apply_styles
from TK_extensions.entry_dialog import EntryDialog
from utterance_page import UtterancePage

from pprint import pprint


class TredBridgeMain(Tk):
    def __init__(self, input_path, *args, **kwargs):
        Tk.__init__(self, *args, **kwargs)
        self.input_path = input_path
        # self.origutt, self.new_metadata = process_input(self.input_path)

        # input parse
        input_info = process_input(self.input_path)
        # all utterances and sentences
        self.origutt = input_info['origutt']
        self.revised_utt = input_info['revised_utt']
        self.alpino_input = input_info['alpino_input']
        self.sentence = input_info['sentence']
        self.origsent = input_info['origsent']
        # fields present at time of input parse
        self.revised_exists = input_info['revised_exists']
        self.origsent_exists = input_info['origsent_exists']
        self.alpino_input_exists = input_info['alpino_input_exists']

        # phase the editor is currently in. 0=utterance, 1=alpino.
        self.phase = 0

        # setup notebook
        self.notebook = Notebook(self)
        frame1 = ttk.Frame(self.notebook)
        frame2 = ttk.Frame(self.notebook)

        # add empty frames to notebook tabs
        self.notebook.add(frame1, text="Utterance Editor")
        self.notebook.add(frame2, text="Alpino Editor")
        self.notebook.grid()

        # fill the tab frames
        self.app1 = UtterancePage(parent=frame1, utterance=self.revised_utt)
        self.app1.grid()
        self.app2 = AlpinoInputPage(parent=frame2, sentence=self.sentence)
        self.app2.grid()

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
