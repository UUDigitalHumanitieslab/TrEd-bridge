from tkinter import *
from tkinter.ttk import *
import config
from functions import ask_input


class AlpinoInputPage(Frame):
    def __init__(self, origutt, parent, controller):
        Frame.__init__(self, parent)

        def bracket_selection(value):
            self.alpino_input.insert(SEL_FIRST, '[ {} '.format(value))
            self.alpino_input.insert(SEL_LAST, ' ] ')

        def bracket_word(value, word=''):
            ws = self.alpino_input.index(INSERT) + " wordstart"
            we = self.alpino_input.index(INSERT) + " wordend"
            word = self.alpino_input.get(ws, we)
            self.alpino_input.delete(ws, we)
            self.alpino_input.insert(
                ws+"-1c", " [ {} {} ] ".format(value, word))

        def const():
            """Specify constituent of <selection>"""
            if self.alpino_input.tag_ranges(SEL):
                cat = ask_input(self, label_text="Constituent:",
                                options=config.CAT_DICT)
                value = "" if cat == "no cat" else "@"+cat
                bracket_selection(value)

        def pos():
            """Specify Part-Of-Speech of <word>"""
            value = ask_input(self, label_text="POS-tag:",
                              options=config.POS_DICT)
            bracket_word("@"+value)

        def tae():
            """Treat < word > as"""
            w2 = ask_input(self, label_text="<word2>:")
            value = "@add_lex {}".format(w2)
            bracket_word(value)

        def skip():
            """Skip < selection >"""
            if self.alpino_input.tag_ranges(SEL):
                value = "@skip"
                bracket_selection(value)

        def phantom():
            """phantom <cursor position>"""
            if not self.alpino_input.tag_ranges(SEL):
                w = ask_input(self, label_text="<word>:")
                pos = self.alpino_input.index(INSERT)
                value = " [ @phantom {} ] ".format(w)
                self.alpino_input.insert(pos, value)

        def parse():
            """Parse with alpino"""
            pass

        def save():
            """Write and save file"""
            pass

        def reset():
            """reset to enter state"""
            self.alpino_input.delete("1.0", END)
            self.alpino_input.insert(END, origutt)

        def configure_grid(frame):
            num_rows = 4
            num_cols = 12
            for i in range(0, num_rows):
                self.grid_rowconfigure(i, {'minsize': 85})
            for i in range(0, num_cols):
                self.grid_columnconfigure(i, {'minsize': 85})

        configure_grid(self)

        origuttVar = StringVar(
            value="Original utterance:\n" + origutt)
        origuttLabel = Label(
            self, text="Original utterance:\n" + origutt, anchor="center", font=('Robot, 16'))
        origuttLabel.grid(row=0, column=2, columnspan=8, sticky='NWSE')

        self.alpino_input = Text(self, height=5, font=('Robot, 16'))
        self.alpino_input.insert(END, origutt)
        self.alpino_input.grid(row=1, column=2,
                               columnspan=8, sticky='NWSE')

        reset_button = Button(self, text="Reset", command=reset)
        reset_button.grid(row=1, column=10, sticky='NWSE')

        const_button = Button(self, text="[ @cat <selection> ]", command=const)
        const_button.grid(row=2, column=1, columnspan=2, sticky='NWSE')

        pos_button = Button(self, text="POS of <word>", command=pos)
        pos_button.grid(row=2, column=3, columnspan=2, sticky='NWSE')

        tae_button = Button(
            self, text="Treat <word> as: <word2>", command=tae)
        tae_button.grid(row=2, column=5, columnspan=2, sticky='NWSE')

        phantom_button = Button(
            self, text="[ @phantom <word> ]", command=phantom)
        phantom_button.grid(row=2, column=7, columnspan=2, sticky='NWSE')

        skip_button = Button(
            self, text="[ @skip <selection> ]", command=skip)
        skip_button.grid(row=2, column=9, columnspan=2, sticky='NWSE')

        parse_button = Button(self, text="parse", command=parse)
        parse_button.grid(row=3, column=1, columnspan=5, sticky='NWSE')

        save_button = Button(self, text="save", command=save)
        save_button.grid(row=3, column=6, columnspan=5, sticky='NWSE')
