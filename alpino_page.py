import os
import tkinter
import urllib.parse
import urllib.request
import webbrowser
from tkinter import *
from tkinter import filedialog
from tkinter.ttk import *

import config
from functions import (ask_input, build_new_metadata, clean_string,
                       hard_reset_metadata)


class AlpinoInputPage(ttk.Frame):
    def bracket_selection(self, value):
        self.alpino_edit.insert(SEL_FIRST, '[ {} '.format(value))
        self.alpino_edit.insert(SEL_LAST, ' ] ')
        self.alpino_edit.focus()

    def bracket_word(self, value, word=''):
        ws = self.alpino_edit.index(INSERT) + " wordstart"
        we = self.alpino_edit.index(INSERT) + " wordend"
        word = self.alpino_edit.get(ws, we)
        self.alpino_edit.mark_set("start_pos", ws)
        start_pos = self.alpino_edit.index("start_pos")
        self.alpino_edit.delete(ws, we)
        self.alpino_edit.insert(
            start_pos+"-1c", " [ {} {} ] ".format(value, word))

    def const(self):
        """Specify constituent of < selection >"""
        if self.alpino_edit.tag_ranges(SEL):
            cat = ask_input(self, label_text="Constituent:",
                            options=config.CAT_DICT)
            value = "" if cat == " " else "@"+cat
            self.bracket_selection(value)
            self.alpino_edit.focus()

    def pos(self):
        """Specify Part-Of-Speech of < word > or < selection >"""
        if self.alpino_edit.tag_ranges(SEL):
            print('selection')
            value = ask_input(self, label_text="POS-tag:",
                              options=config.POS_DICT)
            self.bracket_selection("@posflt {}".format(value))
        else:
            value = ask_input(self, label_text="POS-tag:",
                              options=config.POS_DICT)
            self.bracket_word("@posflt {}".format(value))

        self.alpino_edit.focus()

    def tae(self):
        """Treat < word > as"""
        w2 = ask_input(self, label_text="<word2>:")
        value = "@add_lex {}".format(w2)
        self.bracket_word(value)
        self.alpino_edit.focus()

    def skip(self):
        """Skip < selection >"""
        if self.alpino_edit.tag_ranges(SEL):
            value = "@skip"
            self.bracket_selection(value)
            self.alpino_edit.focus()

    def phantom(self):
        """phantom <cursor position>"""
        if not self.alpino_edit.tag_ranges(SEL):
            w = ask_input(self, label_text="<word>:")
            pos = self.alpino_edit.index(INSERT)
            value = " [ @phantom {} ] ".format(w)
            self.alpino_edit.insert(pos, value)
            self.alpino_edit.focus()

    def parse(self):
        """Parse with alpino"""
        sent = self.alpino_edit.get(1.0, "end-1c")
        sent = clean_string(sent)
        self.alpino_edit.delete("1.0", END)
        self.alpino_edit.insert(END, sent)

        app = self.master.master.master
        app.alpino_input = sent

        parse_url = os.path.join(
            config.GRETEL_URL, 'gretel4/api/src/router.php/parse_sentence/')
        # parse_url = 'http://localhost:4200/gretel/api/src/router.php/parse_sentence/'
        encoded_query = urllib.parse.quote(sent)  # %-formatted symbols
        url = parse_url + encoded_query

        try:
            contents = urllib.request.urlopen(url).read()
            self.alp_out_txt.set(contents)
            new_soup = build_new_metadata(app, contents)
            app.new_xml = new_soup
            self.save_button.state(["!disabled"])
            self.treepreview_button.state(["!disabled"])
        except urllib.error.HTTPError as e:
            print(url)
            self.alp_out_txt.set('{}\n{}'.format(url, e))

        self.alpino_edit.focus()

    def save(self):
        """Write and save file"""
        app = self.winfo_toplevel()
        if self.save_button.state()[0] == 'active':
            fileloc = filedialog.asksaveasfilename(title="Save as")
            with open(fileloc, "w+") as f:
                f.write(app.new_xml)

    def tree_preview(self):
        visualizer_url = os.path.join(config.GRETEL_URL, 'tree')
        app = self.winfo_toplevel()
        sent = self.alpino_edit.get(1.0, "end-1c")
        xml = app.new_xml
        parameter = urllib.parse.urlencode({
            'sent': sent,
            'xml': xml
        })
        url = "{}?{}".format(visualizer_url, parameter)
        webbrowser.get().open(url, new=2)

    def reset(self):
        """reset to enter state"""
        app = self.master.master.master
        self.alpino_edit.delete("1.0", END)
        self.alpino_edit.insert(END, app.alpino_input)
        self.alpino_edit.focus()

    def configure_grid(self):
        num_rows = 5
        num_cols = 12
        for i in range(0, num_rows):
            self.grid_rowconfigure(i, {'minsize': 85})
        for i in range(0, num_cols):
            self.grid_columnconfigure(i, {'minsize': 85})

    def set_alpino_input(self, alpino_input):
        self.alpino_edit.delete("1.0", END)
        self.alpino_edit.insert(END, alpino_input)

    def key_callback(self, event):
        if event.state == 4:
            key = event.keysym if event.keysym != '??' else None
            if key is not None:
                try:
                    bind = config.ALPINO_KEYBINDS[key]
                    exec('self.{}()'.format(bind))
                except:
                    pass

    def back_to_chat(self):
        app = self.winfo_toplevel()
        app.switch_to_tab(0)

    def hard_reset(self):
        result = messagebox.askokcancel(
            "Hard Reset", "This will reset this document to its original state.\nThis operation is irreversible.\nReset?")
        if result:
            app = self.winfo_toplevel()
            hard_reset_metadata(app)

    def __init__(self, sentence, parent=None):
        ttk.Frame.__init__(self, parent)

        self.configure_grid()
        sentenceVar = StringVar(
            value="Original sentence:\n" + sentence)
        sentenceLabel = Label(
            self, text="Original sentence:\n" + sentence, anchor="center", font=('Roboto, 20'))

        self.alpino_edit = Text(
            self, height=4, font=('Roboto, 20'), wrap='word', width=60)
        self.alpino_edit.insert(END, sentence)
        reset_button = Button(self, text="reset",
                              underline=0, command=self.reset)
        self.hard_reset_button = Button(
            self, text="hard reset", style="Red.TButton", command=self.hard_reset)
        back_to_chat_button = Button(self, text="back to\nCHAT editor",
                                     underline=0, command=self.back_to_chat)
        const_button = Button(
            self, text="constituent\n[ @cat <selection> ]", underline=2, command=self.const)
        pos_button = Button(
            self, text="part-of-speech\n[ @pos <word>/<selection> ]", underline=0, command=self.pos)
        tae_button = Button(
            self, text="treat as ...\n[ @add_lex <word> <word2> ]", underline=0, command=self.tae)
        phantom_button = Button(
            self, text="phantom word\n[ @phantom <word> ]", underline=1, command=self.phantom)
        skip_button = Button(
            self, text="skip\n[ @skip <selection> ]", underline=0, command=self.skip)
        parse_button = Button(self, text="parse",
                              underline=1, command=self.parse)
        self.save_button = Button(
            self, text="save", underline=0, command=self.save)
        self.save_button.state(["disabled"])
        self.treepreview_button = Button(
            self, text="preview tree", underline=0, command=self.tree_preview)
        self.treepreview_button.state(["disabled"])

        self.alp_out_txt = StringVar(value="Alpino output")
        alpino_out = tkinter.Label(self, textvariable=self.alp_out_txt)

        sentenceLabel.grid(row=0, column=2, columnspan=8, sticky='NWSE')
        self.alpino_edit.grid(row=1, column=2, columnspan=7, sticky='NWSE')
        reset_button.grid(row=1, column=10, sticky='NWSE')
        self.hard_reset_button.grid(row=1, column=9, sticky='NWSE')
        back_to_chat_button.grid(row=1, column=1, sticky="NWSE")
        const_button.grid(row=2, column=1, columnspan=2, sticky='NWSE')
        pos_button.grid(row=2, column=3, columnspan=2, sticky='NWSE')
        tae_button.grid(row=2, column=5, columnspan=2, sticky='NWSE')
        phantom_button.grid(row=2, column=7, columnspan=2, sticky='NWSE')
        skip_button.grid(row=2, column=9, columnspan=2, sticky='NWSE')
        parse_button.grid(row=3, column=1, columnspan=4, sticky='NWSE')
        self.save_button.grid(row=3, column=7, columnspan=4, sticky='NWSE')
        self.treepreview_button.grid(
            row=3, column=5, columnspan=2, sticky='NWSE')
        if config.DEBUG:
            alpino_out.grid(row=4, rowspan=4, column=1,
                            columnspan=10, sticky='NWSE')

        self.bind("<Control-Key>", self.key_callback)
        self.alpino_edit.bind("<Control-Key>", self.key_callback)
