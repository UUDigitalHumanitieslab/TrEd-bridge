from chamd.cleanCHILDESMD import cleantext
# import tkinter as tk
# import tkinter.ttk as ttk
from tkinter import *
from tkinter.ttk import *

LARGE_FONT = ("Verdana", 12)

from functions import process_input

CAT_VALS = [
    "no cat",
    "advp", "ahi", "ap",
    "conj", "cp",
    "detp", "du",
    "inf",
    "mwu",
    "np",
    "oti",
    "pp", "ppart", "ppres",
    "rel",
    "smain", "ssub", "sv1", "svan",
    "ti", "top",
    "whq", "whrel", "whsub"]

POS_DICT = {
    'adj': 'Adjective',
    'adv': 'Adverb',
    'comp': 'Complementizer',
    'comparative': 'Comparative',
    'det': 'Determiner',
    'etc': '',
    'fixed': 'Fixed part of a fixed expression',
    'max': '',
    'name': 'Name',
    'noun': 'Noun',
    'num': 'Number',
    'part': 'Particle',
    'pp': 'Pronominal adverb',
    'pron': 'Pronoun',
    'prep': 'Preposition',
    'punct': 'Punctuation',
    'tag': '',
    'verb': 'Verb',
    'vg': 'Conjunction'
}


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


class UtterancePage(Frame):
    def __init__(self, origutt, parent, controller):
        Frame.__init__(self, parent)

        def parenthesize_selection():
            if self.utterance.tag_ranges(SEL):
                self.utterance.insert(SEL_FIRST, '(')
                self.utterance.insert(SEL_LAST, ')')
            else:
                print('No selected text.')

        def prefix_ampersande():
            ws = self.utterance.index(INSERT) + " wordstart"
            self.utterance.insert(ws, "&")

        def correct():
            pass

        def clean():
            text = self.utterance.get("1.0", END)
            cleaned_text = cleantext(text)
            self.utterance.delete("1.0", END)
            self.utterance.insert(END, cleaned_text)

        # static display of the original utterance
        origuttVar = StringVar(
            value="Original utterance:\n" + origutt)
        origuttLabel = Label(
            self, textvariable=origuttVar)
        origuttLabel.pack(pady=10, padx=10)

        self.utterance = Text(self, height=5)
        self.utterance.insert(END, origutt)
        self.utterance.pack(padx=10, pady=10)

        parenthesize_button = Button(
            self, text="parenthesize selection", command=parenthesize_selection)
        ampersande_button = Button(
            self, text="prefix &", command=prefix_ampersande)
        correct_button = Button(self, text="correct", command=correct)
        clean_button = Button(self, text="clean (CHAMD)", command=clean)

        parenthesize_button.pack(side=LEFT, padx=10, pady=10)
        ampersande_button.pack(side=LEFT, padx=10, pady=10)
        correct_button.pack(side=LEFT, padx=10, pady=10)
        correct_button["state"] = DISABLED
        clean_button.pack(side=LEFT, padx=10, pady=10)


class AlpinoInputPage(Frame):
    def __init__(self, origutt, parent, controller):
        Frame.__init__(self, parent)

        def bracket_selection(value):
            self.alpino_input.insert(SEL_FIRST, '[ %s ' % value)
            self.alpino_input.insert(SEL_LAST, ' ] ')

        def bracket_word(value):
            ws = self.alpino_input.index(INSERT) + " wordstart"
            we = self.alpino_input.index(INSERT) + " wordend"
            word = self.alpino_input.get(ws, we)
            self.alpino_input.delete(ws, we)
            self.alpino_input.insert(
                ws+"-1c", " [ {} {} ] ".format(value, word))

            # self.alpino_input.insert(ws, ' [ %s' % value)
            # self.alpino_input.insert(we, ' %s ] ' % word)

        def const():
            """Specify constituent of <selection>"""
            if self.alpino_input.tag_ranges(SEL):
                cat = const_combobox.get()
                value = "" if cat == "no cat" else "@"+cat
                bracket_selection(value)

        def pos():
            """Specify Part-Of-Speech of <word>"""
            value = pos_combobox.get()
            key = next((k for k, v in POS_DICT.items() if v == value), None)
            bracket_word("@"+key)

        def tae():
            """Treat < word > as"""
            w2 = tae_var.get()
            value = "@add_lex %s" % w2
            bracket_word(value)

        def skip():
            """Skip < selection >"""
            if self.alpino_input.tag_ranges(SEL):
                value = "@skip"
                bracket_selection(value)

        # static display of the original utterance
        origuttVar = StringVar(
            value="Original utterance:\n" + origutt)
        origuttLabel = Label(
            self, textvariable=origuttVar)
        origuttLabel.pack(pady=10, padx=10)

        self.alpino_input = Text(self, height=5)
        self.alpino_input.insert(END, origutt)
        self.alpino_input.pack(padx=10, pady=10)

        const_button = Button(
            self, text="[ @cat <selection> ]", command=const)
        const_combobox = Combobox(self, value=CAT_VALS, state="readonly")
        const_combobox.current(0)
        const_button.pack(padx=10, pady=10)
        const_combobox.pack(padx=10, pady=10)

        pos_button = Button(text="POS of <word>", command=pos)
        pos_combobox = Combobox(
            self, value=list(POS_DICT.values()), state="readonly")
        pos_combobox.current(0)
        pos_button.pack(padx=10, pady=10)
        pos_combobox.pack(padx=10, pady=10)

        tae_button = Button(text="Treat <word> as: <word2>", command=tae)
        tae_var = StringVar()
        tae_var.set("<word2>")
        tae_entrybox = Entry(self, textvariable=tae_var, exportselection=0)
        tae_button.pack(padx=10, pady=10)
        tae_entrybox.pack(padx=10, pady=10)

        skip_button = Button(text="[ @skip <selection> ]", command=skip)
        skip_button.pack(padx=10, pady=10)


if __name__ == '__main__':
    app = TredBridgeMain(input_path='vk_example.xml')
    app.geometry('500x500')
    app.focus()
    app.mainloop()
