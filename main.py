from tkinter import Frame, Label, Tk, ttk
from tkinter.ttk import Button, Notebook

from alpino_page import AlpinoInputPage
from chat_page import CHATPage
from functions import process_input, build_new_metadata
from styles import apply_styles
from TK_extensions.entry_dialog import EntryDialog


class TredBridgeMain(Tk):
    def print_state(self):
        print('Origutt:\t{}'.format(self.origutt))
        print('Revisedutt:\t{}'.format(self.revised_utt))
        print('Alpino input:\t{}'.format(self.alpino_input))
        print('Sentence:\t{}'.format(self.sentence))
        print('Origsent:\t{}\n'.format(self.origsent))

    def __init__(self, input_path, *args, **kwargs):
        Tk.__init__(self, *args, **kwargs)
        self.input_path = input_path

        # input parse
        input_info = process_input(self.input_path)
        # all utterances and sentences
        self.origutt = input_info['origutt']
        self.revised_utt = input_info['revised_utt']
        self.alpino_input = input_info['alpino_input']
        self.sentence = input_info['sentence']
        self.sentid = input_info['sent_id']
        self.origsent = input_info['origsent']
        # fields present at time of input parse
        self.revised_exists = input_info['revised_exists']
        self.origsent_exists = input_info['origsent_exists']
        self.alpino_input_exists = input_info['alpino_input_exists']

        # XML contents
        self.xml_content = input_info['xml_content']
        self.new_xml = ''

        # TODO remove prints
        # print('initial')
        # self.print_state()
        # build_new_metadata(self)

        # phase the editor is currently in. 0=utterance, 1=alpino.
        self.phase = 0

        # setup notebook
        self.notebook = Notebook(self)
        frame1 = ttk.Frame(self.notebook)
        frame2 = ttk.Frame(self.notebook)
        # add empty frames to notebook tabs
        self.notebook.add(frame1, text="CHAT Editor")
        self.notebook.add(frame2, text="Alpino Editor")
        self.notebook.grid()
        # fill the tab frames
        self.chat_app = CHATPage(parent=frame1, utterance=self.revised_utt)
        self.chat_app.grid()
        self.alp_app = AlpinoInputPage(parent=frame2, sentence=self.sentence)
        self.alp_app.grid()
        # setup tabs
        # self.notebook.tab(1, state='disabled')


if __name__ == '__main__':
    app = TredBridgeMain(input_path='jan_example.xml')
    s = ttk.Style()
    s.theme_use('clam')
    app.configure(background="lightgrey")
    apply_styles()
    app.mainloop()
