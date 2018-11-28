from tkinter import (DISABLED, END, INSERT, LEFT, SEL, SEL_FIRST, SEL_LAST,
                     Frame, StringVar, Text)
from tkinter.ttk import Label, Button

from chamd.cleanCHILDESMD import cleantext


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
