from tkinter import *
from tkinter.ttk import *
import config
from functions import ask_input


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
            # w2 = tae_var.get()
            w2 = ask_input(self, label_text="<word2>:")
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

        def save():
            """Write and save file"""
            pass

        def configure_grid(frame):
            num_rows = 8
            num_cols = 12
            for i in range(0, num_rows):
                self.grid_rowconfigure(i, {'minsize': 85})
            for i in range(0, num_cols):
                self.grid_columnconfigure(i, {'minsize': 85})
            self.grid_rowconfigure(4, {'minsize': 0})

        configure_grid(self)
        # static display of the original utterance
        origuttVar = StringVar(
            value="Original utterance:\n" + origutt)
        origuttLabel = Label(
            self, text="Original utterance:\n" + origutt, anchor="center")
        origuttLabel.grid(row=1, column=2, columnspan=8, sticky='NWSE')

        self.alpino_input = Text(self)
        self.alpino_input.insert(END, origutt)
        self.alpino_input.grid(row=2, column=2, rowspan=2,
                               columnspan=8, sticky='NWSE')

        const_combobox = Combobox(
            self, value=config.CAT_VALS, state="readonly")
        const_combobox.current(0)
        const_button = Button(
            self, text="[ @cat <selection> ]", command=const)
        const_combobox.grid(row=4, column=1, columnspan=2, sticky='NWSE')
        const_button.grid(row=5, column=1, columnspan=2, sticky='NWSE')

        pos_button = Button(self, text="POS of <word>",
                            command=pos)
        pos_combobox = Combobox(
            self, value=list(config.POS_DICT.values()), state="readonly")
        pos_combobox.current(0)
        pos_combobox.grid(row=4, column=3, columnspan=2, sticky='NWSE')
        pos_button.grid(row=5, column=3, columnspan=2, sticky='NWSE')

        tae_button = Button(
            self, text="Treat <word> as: <word2>", command=tae)
        tae_var = StringVar()
        tae_var.set("<word2>")
        tae_entrybox = Entry(
            self, textvariable=tae_var, exportselection=0)
        tae_entrybox.grid(row=4, column=5, columnspan=2, sticky='NWSE')
        tae_button.grid(row=5, column=5, columnspan=2, sticky='NWSE')

        phantom_button = Button(
            self, text="[ @phantom <word> ]", command=phantom)
        phantom_var = StringVar()
        phantom_var.set("<word>")
        phantom_entrybox = Entry(
            self, textvariable=phantom_var, exportselection=0)
        phantom_entrybox.grid(row=4, column=7, columnspan=2, sticky='NWSE')
        phantom_button.grid(row=5, column=7, columnspan=2, sticky='NWSE')

        skip_button = Button(
            self, text="[ @skip <selection> ]", command=skip)
        skip_button.grid(row=5, column=9, columnspan=2, sticky='NWSE')

        parse_button = Button(self, text="parse", command=parse)
        parse_button.grid(row=6, column=1, columnspan=5, sticky='NWSE')

        save_button = Button(self, text="save", command=save)
        save_button.grid(row=6, column=6, columnspan=5, sticky='NWSE')
