import sys
import urllib.parse
import urllib.request
import webbrowser
from optparse import OptionParser
from tkinter import (END, INSERT, SEL, SEL_FIRST, SEL_LAST, WORD, Label,
                     StringVar, Tk, filedialog, messagebox, ttk)

from chamd.cleanCHILDESMD import cleantext
from requests import get

import config
from functions import (ask_input, build_new_metadata, clean_string,
                       correct_parenthesize, is_whitelisted_system_keybind,
                       process_input)
from styles import apply_styles
from TK_extensions.text import ReadonlyText, TextWithCallback


class TredBridge(Tk):
    def __init__(self, input_path, *args, **kwargs):
        Tk.__init__(self, *args, **kwargs)
        self.input_path = input_path

        # input parse
        input_info = process_input(self.input_path)
        # all utterances and sentences
        self.origutt = input_info['origutt']
        self.revised_utt = input_info['revised_utt']
        self.alpino_input = input_info['alpino_input']
        self.sentence = input_info['sentence']
        self.sentid = input_info['sent_id']
        self.origsent = input_info['origsent']
        # fields present at time of input parse
        self.revised_exists = input_info['revised_exists']
        self.origsent_exists = input_info['origsent_exists']
        self.alpino_input_exists = input_info['alpino_input_exists']
        # XML contents
        self.xml_content = input_info['xml_content']
        self.new_xml = ''
        self.metadata = input_info['metadata']

        w, h = self.winfo_screenwidth(), self.winfo_screenheight()
        self.maxsize(w, h)
        frame = SinglePage(
            parent=self,
            orig_utterance=self.origutt,
            rev_utterance=self.revised_utt)
        frame.pack()
        frame.chat_edit.focus()


class SinglePage(ttk.Frame):
    def configure_grid(self, num_rows=5, num_cols=14):
        for i in range(0, num_rows):
            self.grid_rowconfigure(i, {'minsize': 75, 'weight': 1})
        for i in range(0, num_cols):
            self.grid_columnconfigure(i, {'minsize': 35, 'weight': 1})

    def reset(self):
        app = self.winfo_toplevel()
        self.chat_edit.delete("1.0", END)
        self.chat_edit.insert(END, app.revised_utt)
        self.chat_edit.focus()

    def prefix_ampersand(self):
        ws = self.chat_edit.index(INSERT) + " wordstart"
        self.chat_edit.insert(ws, "&")
        self.chat_edit.focus()

    def correct(self):
        if self.chat_edit.tag_ranges(SEL):
            selection = self.chat_edit.get(SEL_FIRST, SEL_LAST)
            if ' ' in selection:
                messagebox.showerror(
                    "Error", "Correct only works for single words.")
                return

        ws = self.chat_edit.index(INSERT) + " wordstart"
        we = self.chat_edit.index(INSERT) + " wordend"
        word = self.chat_edit.get(ws, we)

        # when selecting at the end of the word, take the word before it
        if word == ' ':
            ws = self.chat_edit.index(INSERT) + "-1c wordstart"
            we = self.chat_edit.index(INSERT) + "-1c wordend"
            word = self.chat_edit.get(ws, we)

        self.chat_edit.mark_set("start_pos", ws)
        start_pos = self.chat_edit.index("start_pos")

        correction = ask_input(
            self, label_text="word: {}\ncorrection:".format(word))

        corrected_string = correct_parenthesize(word, correction)

        self.chat_edit.delete(ws, we)
        self.chat_edit.insert(start_pos, "{} ".format(corrected_string))

        self.chat_edit.focus()

    def parse(self):
        """Parse with alpino"""
        app = self.winfo_toplevel()

        text = self.chat_edit.get(1.0, "end-1c")
        chamd_cleaned_text = cleantext(text, repkeep=False)

        app.alpino_input = clean_string(chamd_cleaned_text)
        app.sentence = chamd_cleaned_text
        app.revised_utt = clean_string(text, punctuation=False)

        encoded_query = urllib.parse.quote(
            app.alpino_input)  # %-formatted symbols
        url = config.PARSER_URL + encoded_query

        if config.DEBUG:
            self.alpino_out.grid_remove()
        else:
            self.alp_msg.grid_remove()

        try:
            res = get(url)
            contents = res.content

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
                self.alp_msg_txt.set('Parse failed: {}'.format(e))
                self.alp_msg.configure(background="indian red")
                self.alp_msg.grid(
                    row=4, column=1, columnspan=4, sticky='NWSE')

        self.chat_edit.focus()

    def tree_preview(self):
        visualizer_url = config.TREE_VIS_URL
        app = self.winfo_toplevel()

        app = self.winfo_toplevel()
        # sent = self.alpino_edit.get(1.0, "end-1c")
        sent = app.alpino_input
        xml = app.new_xml
        parameter = urllib.parse.urlencode({
            'sent': sent,
            'xml': xml
        })
        url = "{}?{}".format(visualizer_url, parameter)
        webbrowser.get().open(url, new=2)

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

    def text_changed_callback(self, event):
        text = self.chat_edit.get("1.0", END)
        cleaned_text = clean_string(
            cleantext(text, repkeep=False), punctuation=False)
        self.clean_preview.set_readonly(cleaned_text)

    def key_callback(self, event):
        if event.state == 4:
            key = event.keysym if event.keysym != '??' else None
            if key is not None:
                try:
                    bind = config.CHAT_KEYBINDS[key]
                    exec('self.{}()'.format(bind))
                except:
                    pass
        if not is_whitelisted_system_keybind(event):
            return 'break'

    def set_label_wrap(self, event):
        wraplength = event.width-12  # 12, to account for padding and borderwidth
        event.widget.configure(wraplength=wraplength)

    def __init__(self, parent, orig_utterance, rev_utterance):
        ttk.Frame.__init__(self)
        self.configure_grid()

        # row 0
        origutt_text = ReadonlyText(
            self, label='original utterance', default=orig_utterance,)
        origutt_text.grid(row=0, column=1, columnspan=5,
                          sticky='NWSE', padx=5, pady=5)

        if orig_utterance != rev_utterance:
            revutt_text = ReadonlyText(
                self, label='revised utterance', default=rev_utterance)
            revutt_text.grid(row=0, column=6, columnspan=5,
                             sticky='NWSE', padx=5, pady=5)

        # row 1
        self.chat_edit = TextWithCallback(
            self, height=4, borderwidth=2, font=('Roboto, 20'), wrap=WORD, fg='white smoke')
        self.chat_edit.insert(END, rev_utterance)
        self.chat_edit.bind("<<TextChanged>>", self.text_changed_callback)
        reset_button = ttk.Button(self, text="reset",
                                  underline=0, command=self.reset)

        self.chat_edit.grid(row=1, column=1, columnspan=10, sticky='NWSE')
        reset_button.grid(row=1, column=11, columnspan=2, sticky='NWSE')

        # row 2
        self.clean_preview = ReadonlyText(self,
                                          label='cleaned utterance',
                                          bg='dimgrey',
                                          fg='white smoke')
        ignore_button = ttk.Button(
            self, text="ignore\n&<word>", underline=1,
            command=self.prefix_ampersand)
        correct_button = correct_button = ttk.Button(
            self, text="correct <word>", underline=6, command=self.correct)

        self.clean_preview.grid(
            row=2, column=1, columnspan=6, sticky='NWSE', ipadx=5, ipady=5)
        ignore_button.grid(row=2, column=7, columnspan=3, sticky='NWSE')
        correct_button.grid(row=2, column=10, columnspan=3, sticky='NWSE')

        # row 3
        parse_button = ttk.Button(self, text="parse",
                                  underline=0, command=self.parse)
        self.treepreview_button = ttk.Button(
            self, text="preview tree", underline=2, command=self.tree_preview)
        self.treepreview_button.state(["disabled"])
        self.save_button = ttk.Button(
            self, text="save" if config.DEBUG else "save & exit",
            underline=0, command=self.save)
        self.save_button.state(["disabled"])

        parse_button.grid(row=3, column=1, columnspan=4, sticky='NWSE')
        self.treepreview_button.grid(
            row=3, column=5, columnspan=4, sticky='NWSE')
        self.save_button.grid(row=3, column=9, columnspan=4, sticky='NWSE')

        # row 4
        # Output for Alpino. Full when in DEBUG, concise otherwise
        if config.DEBUG:
            self.alp_out_txt = StringVar(value="Alpino output")
            self.alpino_out = Label(
                self, textvariable=self.alp_out_txt)
        else:
            self.alp_msg_txt = StringVar()
            self.alp_msg = Label(
                self, textvariable=self.alp_msg_txt, font=('Roboto', 20),
                foreground='white', borderwidth=2, relief='solid')

        self.bind("<Control-Key>", self.key_callback)
        self.chat_edit.bind("<Control-Key>", self.key_callback)


def main(args=None):
    if args is None:
        args = sys.argv[1:]

    parser = OptionParser()
    parser.add_option("-f", "--file", dest="filename",
                      default=None, help="edit the given file (default: None)")
    (options, args) = parser.parse_args(args)

    app = None
    if options.filename is None:
        app = TredBridge(input_path='test.xml')
    else:
        app = TredBridge(input_path=options.filename)

    apply_styles(app)
    app.mainloop()


if __name__ == '__main__':
    main()
