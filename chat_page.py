from tkinter import *
from tkinter import messagebox
from tkinter import Label as TKLabel
from tkinter.ttk import *

from chamd.cleanCHILDESMD import cleantext

from functions import (ask_input, clean_string,
                       correct_parenthesize, hard_reset_metadata)
import config
from TK_extensions.text import TextWithCallback


class CHATPage(ttk.Frame):
    def parenthesize_selection(self):
        if self.chat_edit.tag_ranges(SEL):
            self.chat_edit.insert(SEL_FIRST, '(')
            self.chat_edit.insert(SEL_LAST, ')')
        else:
            messagebox.showerror("Error", "No text selected.")
        self.chat_edit.focus()

    def prefix_ampersand(self):
        ws = self.chat_edit.index(INSERT) + " wordstart"
        self.chat_edit.insert(ws, "&")
        self.chat_edit.focus()

    def correct(self):
        # ws = self.alpino_edit.index(INSERT) + " wordstart"
        # we = self.alpino_edit.index(INSERT) + " wordend"
        # word = self.alpino_edit.get(ws, we)
        # self.alpino_edit.mark_set("start_pos", ws)
        # start_pos = self.alpino_edit.index("start_pos")
        # self.alpino_edit.delete(ws, we)
        # self.alpino_edit.insert(
        #     start_pos+"-1c", " [ {} {} ] ".format(value, word))

        ws = self.chat_edit.index(INSERT) + " wordstart"
        we = self.chat_edit.index(INSERT) + " wordend"
        word = self.chat_edit.get(ws, we)

        self.chat_edit.mark_set("start_pos", ws)
        start_pos = self.chat_edit.index("start_pos")

        correction = ask_input(
            self, label_text="word: {}\ncorrection:".format(word))

        corrected_string = correct_parenthesize(word, correction)

        self.chat_edit.delete(ws, we)
        self.chat_edit.insert(start_pos, "{} ".format(corrected_string))

        self.chat_edit.focus()

    def clean(self):
        text = self.chat_edit.get("1.0", END)
        cleaned_text = clean_string(
            cleantext(text, repkeep=False), punctuation=False)
        messagebox.showinfo("Cleaned utterance", cleaned_text)
        self.chat_edit.focus()

    def configure_grid(self):
        num_rows = 5
        num_cols = 12

        for i in range(0, num_rows):
            self.grid_rowconfigure(i, {'minsize': 85})
        for i in range(0, num_cols):
            self.grid_columnconfigure(i, {'minsize': 85})

        if config.DEBUG:
            self.grid_rowconfigure(num_rows-1, {'minsize': 20})
        for i in [0, num_cols-1]:
            self.grid_columnconfigure(i, {'minsize': 20})

    def reset_chat_edit(self):
        app = self.master.master.master
        self.chat_edit.delete("1.0", END)
        self.chat_edit.insert(END, app.revised_utt)
        self.chat_edit.focus()

    def clean_continue_to_alpino(self):
        '''
        Clean input, set tab to alpino editor, advance app phase
        '''
        # clean
        text = self.chat_edit.get("1.0", END)
        cleaned_text = cleantext(text, repkeep=False)
        double_cleaned_text = cleaned_text

        self.chat_edit.delete("1.0", END)
        self.chat_edit.insert(END, cleaned_text)

        # set utterances & sentences
        app = self.master.master.master  # TODO can this be somewhat more elegant?
        app.revised_utt = clean_string(text, punctuation=False)
        app.sentence = cleaned_text
        app.alpino_input = cleaned_text

        # switch to alpino editor
        app.alp_app.set_alpino_input(cleaned_text)
        app.transist_phase(0, 1)

    def key_callback(self, event):
        if event.state == 4:
            key = event.keysym if event.keysym != '??' else None
            if key is not None:
                try:
                    bind = config.CHAT_KEYBINDS[key]
                    exec('self.{}()'.format(bind))
                except:
                    pass

    def text_changed_callback(self, event):
        text = self.chat_edit.get("1.0", END)
        cleaned_text = clean_string(
            cleantext(text, repkeep=False), punctuation=False)
        self.clean_preview_text.set('cleaned utterance:\n'+cleaned_text)

    def hard_reset(self):
        result = messagebox.askokcancel(
            "Hard Reset", "This will reset this document to its original state.\nThis operation is irreversible.\nReset?")
        if result:
            app = self.winfo_toplevel()
            hard_reset_metadata(app)

    def __init__(self, utterance, parent=None):
        ttk.Frame.__init__(self, parent)

        self.configure_grid()

        # elements
        chat_editLabel = Label(
            self, text="Original utterance:\n" + utterance, anchor='center', font=('Roboto, 20'))

        self.chat_edit = TextWithCallback(self, height=4, font=('Roboto, 20'))
        self.chat_edit.insert(END, utterance)
        self.chat_edit.bind("<<TextChanged>>", self.text_changed_callback)

        chat_edit_reset_button = Button(
            self, text="reset", underline=0, command=self.reset_chat_edit)
        hard_reset_button = Button(
            self, text="hard\nreset", style="Red.TButton", command=self.hard_reset)
        parenthesize_button = Button(
            self, text="parenthesize\n( <selection> ) ", underline=0, command=self.parenthesize_selection)
        ampersand_button = Button(
            self, text="ignore\n&<word>", underline=1, command=self.prefix_ampersand)
        correct_button = Button(self, text="correct",
                                underline=6, command=self.correct)
        # clean_button = Button(
        #     self, text="preview cleaning (CHAMD)", underline=2, command=self.clean)
        self.clean_preview_text = StringVar()
        clean_preview = TKLabel(
            self, textvariable=self.clean_preview_text)
        continue_button = Button(
            self, text="  clean\n     &\ncontinue", underline=3, command=self.clean_continue_to_alpino)

        # grid
        chat_editLabel.grid(row=0, column=1, columnspan=8, sticky='NWSE')
        self.chat_edit.grid(row=1, column=1, columnspan=8, sticky='NWSE')
        chat_edit_reset_button.grid(row=1, column=10, sticky='NWSE')
        hard_reset_button.grid(row=1, column=9, sticky='NWSE')
        parenthesize_button.grid(row=2, column=1, columnspan=4, sticky='NWSE')
        ampersand_button.grid(row=2, column=5, columnspan=3, sticky='NWSE')
        correct_button.grid(row=2, column=8, columnspan=3, sticky='NWSE')
        # clean_button.grid(row=3, column=1, columnspan=5, sticky='NWSE')
        clean_preview.grid(row=3, column=1, columnspan=5, sticky='NWSE')
        continue_button.grid(row=3, column=6, columnspan=5, sticky='NWSE')

        # keybinds
        self.bind("<Control-Key>", self.key_callback)
        self.chat_edit.bind("<Control-Key>", self.key_callback)
