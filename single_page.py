from tkinter import ttk, Tk, END
from TK_extensions.text import TextWithCallback


class SinglePage(ttk.Frame):
    def configure_grid(self, num_rows=2, num_cols=8):
        for i in range(0, num_rows):
            self.grid_rowconfigure(i, {'minsize': 85})
        for i in range(0, num_cols):
            self.grid_columnconfigure(i, {'minsize': 85})

    def __init__(self, parent, utterance):
        ttk.Frame.__init__(self)
        self.configure_grid()

        chat_editLabel = ttk.Label(
            self, text="Original utterance:\n" + utterance, anchor='center', font=('Roboto, 20'))
        chat_editLabel.grid(row=0, column=0, columnspan=8, sticky='NWSE')

        self.chat_edit = TextWithCallback(self, height=4, font=('Roboto, 20'))
        self.chat_edit.insert(END, utterance)
        self.chat_edit.grid(row=1, column=0, columnspan=8, sticky='NWSE')


def main(args=None):
    root = Tk()
    frame = SinglePage(root, utterance='boeboe')
    frame.pack()
    # app = SinglePage(input_path='test.xml', utterance='boeboe')
    root.mainloop()


if __name__ == '__main__':
    main()


# def main(args=None):
#     if args is None:
#         args = sys.argv[1:]

#     parser = OptionParser()
#     parser.add_option("-f", "--file", dest="filename",
#                       default=None, help="edit the given file (default: None)")
#     (options, args) = parser.parse_args(args)

#     app = None
#     if options.filename == None:
#         app = TredBridgeSinglePage(input_path='test.xml')
#     else:
#         app = TredBridgeSinglePage(input_path=options.filename)

#     apply_styles(app)
#     app.mainloop()


# if __name__ == '__main__':
#     main()
