import urllib.request
# import xml.etree.ElementTree as ET
import lxml.etree as ET
from tkinter import END, INSERT, LEFT, Button, Label, StringVar, Text, Tk, X, Y, filedialog
from tkinter.ttk import Button, Entry, Frame, Label, Style

import nltk
from nltk.tokenize import word_tokenize
nltk.download('punkt')


class UtteranceGUI:
    def __init__(self, master, input_path):
        s = Style()
        s.theme_use('clam')
        self.master = master
        master.title("Edit utterance")

        self.origutt, self.new_metadata = self.process_input(input_path)

        self.origuttFrame = Frame(master, borderwidth=3)
        self.origuttFrame.pack(fill=X, expand=True)
        self.origuttVar = StringVar(
            value="Original utterance:\n" + self.origutt)
        self.origuttLabel = Label(
            self.origuttFrame, textvariable=self.origuttVar)
        self.origuttLabel.pack()

        self.labelText = StringVar()
        self.utterance = Entry(
            master, textvariable=self.labelText)
        self.utterance.pack(fill=X, expand=True)
        self.utterance.insert(END, self.origutt)

        self.print_button = Button(master, text="print", command=self.printT)
        self.print_button.pack(side=LEFT, fill='both', expand=True)

        self.process_button = Button(
            master, text="Process & Save", command=self.process_altered)
        self.process_button.pack(side=LEFT, fill='both', expand=True)

        self.close_button = Button(master, text="Close", command=master.quit)
        self.close_button.pack(side=LEFT, fill='both', expand=True)

    def process_altered(self):
        parsed = self.alpino_parse(self.utterance.get())
        if parsed is None:
            return
        new_xml = self.construct_output_xml(parsed)
        self.file_save(new_xml)

    def construct_output_xml(self, parsed_string):
        parsed_xml = ET.fromstring(parsed_string)
        sentence = parsed_xml.find('sentence')
        parsed_xml.insert(parsed_xml.index(sentence) +
                          1, ET.XML(self.new_metadata))
        origutt = parsed_xml.find('.//meta[@name="origutt"]')
        origutt.attrib['value'] = self.utterance.get()
        return ET.tostring(parsed_xml, encoding='utf-8')

    def file_save(self, output_xml_string):
        f = filedialog.asksaveasfile(mode='wb', defaultextension=".xml")
        if f is None:
            print('gaat fout')
            return
        f.write(output_xml_string)
        f.close()

    def alpino_parse(self, altered_utterance):
        tokens = word_tokenize(altered_utterance)
        url = 'http://gretel.hum.uu.nl/gretel4/api/src/router.php/parse_sentence/' +\
            '%20'.join(tokens)
        contents = urllib.request.urlopen(url).read()
        return contents

    def process_input(self, input_path):
        tree = ET.parse(input_path)
        root = tree.getroot()
        metadata = root.find('metadata')
        origutt = root.find('.//meta[@name="origutt"]')
        origutt_old = '<meta type="text" name="origutt_old" value="{}"/>\n'.format(
            origutt.get('value'))
        metadata.insert(
            metadata.index(origutt)+1, ET.XML(origutt_old))
        new_metadata = ET.tostring(metadata) + b'\n'
        return origutt.get('value'), new_metadata

    def printT(self):
        print(self.utterance.get())
        print(self.utterance.index(INSERT))

    def insert_into_entry(self, addition):
        cursor_position = self.utterance.index(INSERT)
        prefix = self.utterance.get()[0:cursor_position]
        suffix = self.utterance.get()[cursor_position:-1]
        self.labelText.set(prefix + addition + suffix)


root = Tk()
root.geometry('500x500')
my_gui = UtteranceGUI(
    root, 'vk_example.xml')
root.mainloop()
