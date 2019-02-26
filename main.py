#!/Users/3248526/git/tred-bridge/.env/bin/python
import sys
from optparse import OptionParser
from tkinter import Frame, Label, Tk, messagebox, ttk
from tkinter.ttk import Button, Notebook

from alpino_page import AlpinoInputPage
from chat_page import CHATPage
from functions import build_new_metadata, process_input
from styles import apply_styles
from TK_extensions.entry_dialog import EntryDialog


class TredBridgeMain(Tk):
    def print_state(self):
        print('Origutt:\t{}'.format(self.origutt))
        print('Revisedutt:\t{}'.format(self.revised_utt))
        print('Alpino input:\t{}'.format(self.alpino_input))
        print('Sentence:\t{}'.format(self.sentence))
        print('Origsent:\t{}\n'.format(self.origsent))

    def on_click_tab(self, event):
        clicked_tab = self.notebook.tk.call(
            self.notebook._w, "identify", "tab", event.x, event.y)
        if clicked_tab != '':
            self.switch_to_tab(clicked_tab)

    def switch_to_tab(self, target_tab):
        if self.phase == 0 and target_tab == 1:
            result = messagebox.askquestion(
                "Continue to Alpino editor", "Are you done editing the CHAT-utterance?")
            if result == 'yes':
                self.chat_app.clean_continue_to_alpino()
                self.transist_phase(0, 1)

        elif self.phase == 1 and target_tab == 0:
            result = messagebox.askquestion(
                "Return to CHAT editor",
                "Do you wish to return to the CHAT-editor?" +
                "\nWarning: all changes in the alpino editor are undone.",
                icon='warning')
            if result == 'yes':
                self.alp_app.reset()
                self.transist_phase(1, 0)

    def transist_phase(self, old_phase, new_phase):
        self.phase = new_phase
        self.notebook.tab(old_phase, state='disabled')
        self.notebook.tab(new_phase, state='normal')
        self.notebook.select(new_phase)

        if new_phase == 0:
            self.chat_app.chat_edit.focus()
        elif new_phase == 1:
            self.alp_app.alpino_edit.focus()

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
        self.notebook.tab(1, state='disabled')
        # focus on first screen
        self.chat_app.chat_edit.focus()
        # mouse binding
        self.notebook.bind('<Button-1>', self.on_click_tab)


def main(args=None):
    if args is None:
        args = sys.argv[1:]

    parser = OptionParser()
    parser.add_option("-f", "--file", dest="filename",
                      default=None, help="edit the given file (default: None)")
    (options, args) = parser.parse_args(args)

    app = None
    if options.filename is not None:
        app = TredBridgeMain(input_path=options.filename)
    else:
        app = TredBridgeMain(input_path='test_example.xml')

    apply_styles(app)
    app.mainloop()


if __name__ == '__main__':
    main()
