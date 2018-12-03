from tkinter import (DISABLED, END, INSERT, LEFT, BOTTOM, X, Y, SEL, SEL_FIRST, SEL_LAST,
                     Frame, StringVar, Text, Label)
from tkinter.ttk import Button, Combobox, Entry

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

        def phantom():
            """phantom <cursor position>"""
            if not self.alpino_input.tag_ranges(SEL):
                w = phantom_var.get()
                pos = self.alpino_input.index(INSERT)
                value = " [ @phantom %s ] " % w
                self.alpino_input.insert(pos, value)

        def parse():
            """Parse with alpino"""
            pass

        # static display of the original utterance
        origuttVar = StringVar(
            value="Original utterance:\n" + origutt)
        origuttLabel = Label(
            self, textvariable=origuttVar)
        origuttLabel.pack(pady=10, padx=10)

        self.alpino_input = Text(self, height=5, bg='lightgrey', bd=5)
        self.alpino_input.insert(END, origutt)
        self.alpino_input.pack(padx=10, pady=10)

        control_frame = Frame(self)
        control_frame.pack()

        const_frame = Frame(control_frame)
        const_button = Button(
            const_frame, text="[ @cat <selection> ]", command=const)
        const_combobox = Combobox(
            const_frame, value=config.CAT_VALS, state="readonly")
        const_combobox.current(0)
        const_button.pack(expand=True, fill=X)
        const_combobox.pack(expand=True, fill=X)
        const_frame.pack(side=LEFT)

        pos_frame = Frame(control_frame)
        pos_button = Button(pos_frame, text="POS of <word>",
                            command=pos)
        pos_combobox = Combobox(
            pos_frame, value=list(config.POS_DICT.values()), state="readonly")
        pos_combobox.current(0)
        pos_button.pack(expand=True, fill=X)
        pos_combobox.pack(expand=True, fill=X)
        pos_frame.pack(side=LEFT)

        tae_frame = Frame(control_frame)
        tae_button = Button(
            tae_frame, text="Treat <word> as: <word2>", command=tae)
        tae_var = StringVar()
        tae_var.set("<word2>")
        tae_entrybox = Entry(
            tae_frame, textvariable=tae_var, exportselection=0)
        tae_button.pack(expand=True, fill=X)
        tae_entrybox.pack(expand=True, fill=X)
        tae_frame.pack(side=LEFT)

        phantom_frame = Frame(control_frame)
        phantom_button = Button(
            phantom_frame, text="[ @phantom <word> ]", command=phantom)
        phantom_var = StringVar()
        phantom_var.set("<word>")
        phantom_entrybox = Entry(
            phantom_frame, textvariable=phantom_var, exportselection=0)
        phantom_entrybox.pack(expand=True, fill=X)
        phantom_button.pack(expand=True, fill=X)
        phantom_frame.pack(side=LEFT)

        skip_frame = Frame(control_frame)
        skip_button = Button(
            skip_frame, text="[ @skip <selection> ]", command=skip)
        skip_button.pack(expand=True, fill=X)
        skip_frame.pack(side=LEFT)

        parse_frame = Frame(control_frame)
        parse_button = Button(parse_frame, text="parse",
                              command=parse)
        parse_button.pack(expand=True, fill=X)
        parse_frame.pack(side=LEFT)
