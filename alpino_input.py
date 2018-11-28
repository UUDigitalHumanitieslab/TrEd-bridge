from tkinter import (DISABLED, END, INSERT, LEFT, SEL, SEL_FIRST, SEL_LAST,
                     Frame, StringVar, Text)
from tkinter.ttk import Button, Combobox, Entry, Label

import config


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
            key = next(
                (k for k, v in config.POS_DICT.items() if v == value), None)
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
        const_combobox = Combobox(
            self, value=config.CAT_VALS, state="readonly")
        const_combobox.current(0)
        const_button.pack(padx=10, pady=10)
        const_combobox.pack(padx=10, pady=10)

        pos_button = Button(text="POS of <word>", command=pos)
        pos_combobox = Combobox(
            self, value=list(config.POS_DICT.values()), state="readonly")
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
