from tkinter import *
from tkinter import messagebox
from tkinter.ttk import *

from chamd.cleanCHILDESMD import cleantext

from functions import ask_input, clean_string, correct_parenthesize
import config


class CHATPage(ttk.Frame):
    def parenthesize_selection(self):
        if self.chat_edit.tag_ranges(SEL):
            self.chat_edit.insert(SEL_FIRST, '(')
            self.chat_edit.insert(SEL_LAST, ')')
        else:
            messagebox.showerror("Error", "No text selected.")

    def prefix_ampersand(self):
        ws = self.chat_edit.index(INSERT) + " wordstart"
        self.chat_edit.insert(ws, "&")

    def correct(self):
        ws = self.chat_edit.index(INSERT) + " wordstart"
        we = self.chat_edit.index(INSERT) + " wordend"
        word = self.chat_edit.get(ws, we)

        correction = ask_input(
            self, label_text="word: {}\ncorrection:".format(word))

        corrected_string = correct_parenthesize(word, correction)

        self.chat_edit.delete(ws, we)
        self.chat_edit.insert(ws, "{} ".format(corrected_string))

    def clean(self):
        text = self.chat_edit.get("1.0", END)
        cleaned_text = clean_string(cleantext(text), punctuation=False)
        # self.chat_edit.delete("1.0", END)
        # self.chat_edit.insert(END, cleaned_text)
        messagebox.showinfo("Cleaned utterance", cleaned_text)

    def configure_grid(self):
        num_rows = 7
        num_cols = 12
        for i in range(0, num_rows):
            self.grid_rowconfigure(i, {'minsize': 85})
        for i in range(0, num_cols):
            self.grid_columnconfigure(i, {'minsize': 85})

    def reset_chat_edit(self):
        app = self.master.master.master
        self.chat_edit.delete("1.0", END)
        self.chat_edit.insert(END, app.revised_utt)

    def clean_continue_to_alpino(self):
        '''
        Clean input, set tab to alpino editor, advance app phase
        '''
        # clean
        text = self.chat_edit.get("1.0", END)
        cleaned_text = cleantext(text)
        double_cleaned_text = cleaned_text

        self.chat_edit.delete("1.0", END)
        self.chat_edit.insert(END, cleaned_text)

        # set utterances & sentences
        app = self.master.master.master  # TODO can this be somewhat more elegant?
        app.revised_utt = clean_string(text, punctuation=False)
        app.sentence = cleaned_text
        app.alpino_input = cleaned_text

        # TODO: Remove print statements
        # print('after CHAT')
        # app.print_state()

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

    def __init__(self, utterance, parent=None):
        ttk.Frame.__init__(self, parent)

        self.configure_grid()

        chat_editLabel = Label(
            self, text="Original utterance:\n" + utterance, anchor='center', font=('Roboto, 16'))

        self.chat_edit = Text(self, height=5, font=('Roboto, 16'))
        self.chat_edit.insert(END, utterance)
        self.chat_edit.grid(row=1, column=1,
                            columnspan=8, sticky='NWSE')

        chat_edit_reset_button = Button(
            self, text="reset", underline=0, command=self.reset_chat_edit)
        parenthesize_button = Button(
            self, text="parenthesize\n( <selection> ) ", underline=0, command=self.parenthesize_selection)
        ampersand_button = Button(
            self, text="ignore\n&<word>", underline=1, command=self.prefix_ampersand)
        correct_button = Button(self, text="correct",
                                underline=1, command=self.correct)
        clean_button = Button(
            self, text="preview cleaning (CHAMD)", underline=1, command=self.clean)
        continue_button = Button(
            self, text="  clean\n     &\ncontinue", underline=3, command=self.clean_continue_to_alpino)

        chat_editLabel.grid(row=0, column=1, columnspan=7, sticky='NWSE')
        chat_edit_reset_button.grid(row=1, column=8, sticky='NWSE')
        parenthesize_button.grid(row=2, column=1, columnspan=2, sticky='NWSE')
        ampersand_button.grid(row=2, column=3, columnspan=2, sticky='NWSE')
        correct_button.grid(row=2, column=5, columnspan=2, sticky='NWSE')
        clean_button.grid(row=2, column=7, columnspan=2, sticky='NWSE')
        continue_button.grid(row=1, column=9, rowspan=2, sticky='NWSE')

        self.bind("<Control-Key>", self.key_callback)
        self.chat_edit.bind("<Control-Key>", self.key_callback)
