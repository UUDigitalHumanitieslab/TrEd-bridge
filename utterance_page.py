from tkinter import *
from tkinter import messagebox
from tkinter.ttk import *

from chamd.cleanCHILDESMD import cleantext
from functions import ask_input, correct_parenthesize


class UtterancePage(ttk.Frame):
    def __init__(self, origutt, parent=None):
        ttk.Frame.__init__(self, parent)

        def parenthesize_selection():
            if self.utterance.tag_ranges(SEL):
                self.utterance.insert(SEL_FIRST, '(')
                self.utterance.insert(SEL_LAST, ')')
            else:
                messagebox.showerror("Error", "No text selected.")

        def prefix_ampersand():
            ws = self.utterance.index(INSERT) + " wordstart"
            self.utterance.insert(ws, "&")

        def correct():
            ws = self.utterance.index(INSERT) + " wordstart"
            we = self.utterance.index(INSERT) + " wordend"
            word = self.utterance.get(ws, we)

            correction = ask_input(
                self, label_text="word: {}\ncorrection:".format(word))

            corrected_string = correct_parenthesize(word, correction)

            self.utterance.delete(ws, we)
            self.utterance.insert(ws, "{} ".format(corrected_string))

        def clean():
            text = self.utterance.get("1.0", END)
            cleaned_text = cleantext(text)
            self.utterance.delete("1.0", END)
            self.utterance.insert(END, cleaned_text)
            parent.master.tab(1, state='normal')

        def configure_grid(frame):
            num_rows = 7
            num_cols = 12
            for i in range(0, num_rows):
                self.grid_rowconfigure(i, {'minsize': 85})
            for i in range(0, num_cols):
                self.grid_columnconfigure(i, {'minsize': 85})

        def reset_utterance():
            self.utterance.delete("1.0", END)
            self.utterance.insert(END, origutt)

        configure_grid(self)

        # static display of the original utterance
        origuttVar = StringVar(
            value="Original utterance:\n" + origutt)
        origuttLabel = Label(
            self, text="Original utterance:\n" + origutt, anchor='center', font=('Roboto, 16'))
        origuttLabel.grid(row=0, column=2, columnspan=7,
                          sticky='NWSE')

        self.utterance = Text(self, height=5, font=('Roboto, 16'))
        self.utterance.insert(END, origutt)
        self.utterance.grid(row=1, column=2,
                            columnspan=8, sticky='NWSE')

        utterance_reset_button = Button(
            self, text="Reset", command=reset_utterance)
        utterance_reset_button.grid(row=1, column=9, sticky='NWSE')

        parenthesize_button = Button(
            self, text=" ( <selection> ) ", command=parenthesize_selection)
        ampersand_button = Button(
            self, text="&<word>", command=prefix_ampersand)
        correct_button = Button(self, text="correct", command=correct)
        clean_button = Button(self, text="clean (CHAMD)", command=clean)

        parenthesize_button.grid(
            row=2, column=2, columnspan=2, sticky='NWSE')
        ampersand_button.grid(row=2, column=4,
                              columnspan=2, sticky='NWSE')
        correct_button.grid(row=2, column=6,
                            columnspan=2, sticky='NWSE')
        clean_button.grid(row=2, column=8, columnspan=2, sticky='NWSE')
