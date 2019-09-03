import os
import sys
import tkinter
import sys
import urllib.parse
import urllib.request
import webbrowser
from tkinter import *
from tkinter import filedialog
from tkinter.ttk import *

import config
from functions import (ask_input, build_new_metadata, clean_string,
                       hard_reset_metadata, read_config_csv)


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
        options = read_config_csv(config.CAT_CONFIG)
        if self.alpino_edit.tag_ranges(SEL):
            cat = ask_input(self, label_text="Constituent:",
                            options=options)
            value = "" if cat == " " else "@"+cat
            self.bracket_selection(value)
            self.alpino_edit.focus()

    def pos(self):
        """Specify Part-Of-Speech of < word > or < selection >"""
        options = read_config_csv(config.POS_CONFIG)

        if self.alpino_edit.tag_ranges(SEL):
            value = ask_input(self, label_text="POS-tag:",
                              options=options)
            self.bracket_selection("@posflt {}".format(value))
        else:
            value = ask_input(self, label_text="POS-tag:",
                              options=options)
            self.bracket_word("@posflt {}".format(value))

        self.alpino_edit.focus()

    def pos_tag(self):
        """Specify complete Part-Of-Speech tag of < word > or < selection >"""
        options = read_config_csv(config.POSTAGS_CONFIG)

        if self.alpino_edit.tag_ranges(SEL):
            value = ask_input(self, label_text="POS-tag:", options=options)
            self.bracket_selection("@postag {}".format(value))
        else:
            value = ask_input(self, label_text="POS-tag:", options=options)
            self.bracket_word("@postag {}".format(value))

        self.alpino_edit.focus()

    def tae(self):
        """Treat < word > as"""
        w2 = ask_input(self, label_text="<word2>:")
        value = "@add_lex {}".format(w2)
        self.bracket_word(value)
        self.alpino_edit.focus()

    def skip(self):
        """Skip < selection > or < word >"""
        value = "@skip"
        if self.alpino_edit.tag_ranges(SEL):
            sel = self.alpino_edit.get(SEL_FIRST, SEL_LAST)
            sel = re.sub(r'\b(\w+)\b', r'[ @skip \1 ]', sel)
            self.alpino_edit.mark_set("start_pos", SEL_FIRST)
            start_pos = self.alpino_edit.index("start_pos")
            self.alpino_edit.delete(SEL_FIRST, SEL_LAST)
            self.alpino_edit.insert(start_pos, sel)
        else:
            self.bracket_word(value)

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

        app = self.winfo_toplevel()
        app.alpino_input = sent

        encoded_query = urllib.parse.quote(sent)  # %-formatted symbols
        url = config.PARSER_URL + encoded_query

        if config.DEBUG:
            self.alpino_out.grid_remove()
        else:
            self.alp_msg.grid_remove()

        try:
            contents = urllib.request.urlopen(url).read()
            new_soup = build_new_metadata(app, contents)
            app.new_xml = new_soup
            self.save_button.state(["!disabled"])
            self.treepreview_button.state(["!disabled"])
            if config.DEBUG:
                self.alp_out_txt.set(contents)
                self.alpino_out.grid(row=4, rowspan=4, column=1,
                                     columnspan=10, sticky='NWSE')
            else:
                self.alp_msg_txt.set('Parse succesful!')
                self.alp_msg.configure(background='#A8CD28')
                self.alp_msg.grid(
                    row=4, column=1, columnspan=4, sticky='NWSE')

        except urllib.error.HTTPError as e:
            if config.DEBUG:
                self.alp_out_txt.set('{}\n{}'.format(url, e))
            else:
                alp_message = tkinter.Label(self, text='joehoe')
                self.alp_msg_txt.set('Parse failed: {}'.format(e))
                self.alp_msg.configure(background="indian red")
                self.alp_msg.grid(
                    row=4, column=1, columnspan=4, sticky='NWSE')

        self.alpino_edit.focus()

    def save(self):
        """Write and save file"""
        app = self.winfo_toplevel()
        if self.save_button.state()[0] == 'active':
            if config.DEBUG:
                fileloc = filedialog.asksaveasfilename(title="Save as")
            else:
                fileloc = app.input_path
            with open(fileloc, encoding='utf-8', mode='w+') as f:
                f.write(app.new_xml)
            if not config.DEBUG:
                sys.exit()

    def tree_preview(self):
        visualizer_url = config.TREE_VIS_URL
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
        num_rows = 8 if config.DEBUG else 5
        num_cols = 12
        for i in range(0, num_rows):
            self.grid_rowconfigure(i, {'minsize': 85})
        for i in range(0, num_cols):
            self.grid_columnconfigure(i, {'minsize': 85})

        if config.DEBUG:
            self.grid_rowconfigure(num_rows-1, {'minsize': 20})
        for i in [0, num_cols-1]:
            self.grid_columnconfigure(i, {'minsize': 20})

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
        return 'break'

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
            self, text="POS-tag (partial)\n[ @pos <word>/<selection> ]", underline=0, command=self.pos)
        # pos_tag_button = Button(
        #     self, text="POS-tag (full)\n[ @pos <word>/<selection> ]", underline=0, command=self.pos_tag)
        tae_button = Button(
            self, text="treat as ...\n[ @add_lex <word2> <word> ]", underline=0, command=self.tae)
        phantom_button = Button(
            self, text="phantom word\n[ @phantom <word> ]", underline=1, command=self.phantom)
        skip_button = Button(
            self, text="skip\n[ @skip <word>/<selection> ]", underline=0, command=self.skip)
        parse_button = Button(self, text="parse",
                              underline=1, command=self.parse)
        self.save_button = Button(
            self, text="save" if config.DEBUG else "save & exit", underline=0, command=self.save)
        self.save_button.state(["disabled"])
        self.treepreview_button = Button(
            self, text="preview tree", underline=3, command=self.tree_preview)
        self.treepreview_button.state(["disabled"])

        sentenceLabel.grid(row=0, column=2, columnspan=8, sticky='NWSE')

        self.alpino_edit.grid(row=1, column=2, columnspan=7, sticky='NWSE')
        reset_button.grid(row=1, column=10, sticky='NWSE')
        self.hard_reset_button.grid(row=1, column=9, sticky='NWSE')
        back_to_chat_button.grid(row=1, column=1, sticky="NWSE")

        const_button.grid(row=2, column=1, columnspan=2, sticky='NWSE')
        pos_button.grid(row=2, column=3, columnspan=1, sticky='NWSE')
        # pos_tag_button.grid(row=2, column=4, columnspan=1, sticky='NWSE')
        tae_button.grid(row=2, column=5, columnspan=2, sticky='NWSE')
        phantom_button.grid(row=2, column=7, columnspan=2, sticky='NWSE')
        skip_button.grid(row=2, column=9, columnspan=2, sticky='NWSE')

        parse_button.grid(row=3, column=1, columnspan=4, sticky='NWSE')
        self.save_button.grid(row=3, column=7, columnspan=4, sticky='NWSE')
        self.treepreview_button.grid(
            row=3, column=5, columnspan=2, sticky='NWSE')

        # Output for Alpino. Full when in DEBUG, concise otherwise
        if config.DEBUG:
            self.alp_out_txt = StringVar(value="Alpino output")
            self.alpino_out = tkinter.Label(
                self, textvariable=self.alp_out_txt)
        else:
            self.alp_msg_txt = StringVar()
            self.alp_msg = tkinter.Label(
                self, textvariable=self.alp_msg_txt, font=('Roboto', 20), foreground='white', borderwidth=2, relief='solid')

        self.bind("<Control-Key>", self.key_callback)
        self.alpino_edit.bind("<Control-Key>", self.key_callback)
