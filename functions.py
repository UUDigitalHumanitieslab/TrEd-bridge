import re
import sys

import lxml.etree as ET
from bs4 import BeautifulSoup, Tag

from TK_extensions.entry_dialog import ComboBoxDialog, EntryDialog
from tkinter import messagebox


def process_input(input_path):
    # read xml
    f = open(input_path, 'r')
    xml_content = f.read()
    f.close()
    soup = BeautifulSoup(xml_content, 'xml')
    meta = soup.metadata

    # original utterane
    origutt = meta.find('meta', {'name': 'origutt'})
    # revised utterance (optional)
    revised_utt = meta.find('meta', {'name': 'revisedutt'})
    revised_exists = False if revised_utt is None else True
    if revised_utt is None:
        revised_utt = origutt
    # sentence
    sentence = soup.sentence
    sentence_id = sentence['sentid']
    sentence_text = clean_string(
        sentence.text, newlines=True, punctuation=False, doublespaces=False)
    # orignal sentence (optional)
    orig_sent = meta.find('meta', {'name': 'origsent'})
    (orig_sent_text, orig_sent_exists) = \
        (sentence_text, False) if orig_sent is None \
        else (orig_sent['value'], True)
    # Alpino input (optional)
    alpino_input = meta.find('meta', {'name': 'alpino_input'})
    (alpino_input_text, alpino_input_exists) = \
        (sentence_text, False) if alpino_input is None \
        else (alpino_input['value'], True)

    return {'origutt': origutt['value'],
            'revised_utt': revised_utt['value'],
            'revised_exists': revised_exists,
            'sentence': sentence_text,
            'sent_id': sentence_id,
            'origsent': orig_sent_text,
            'origsent_exists': orig_sent_exists,
            'alpino_input': alpino_input_text,
            'alpino_input_exists': alpino_input_exists,
            'xml_content': soup.prettify()
            }


def hard_reset_metadata(app):
    soup = BeautifulSoup(app.xml_content, "xml")
    meta = soup.metadata

    # remove revisedutt and alpino_input
    revised_utt = meta.find('meta', {'name': 'revisedutt'})
    if revised_utt:
        revised_utt.decompose()
    alpino_input = meta.find('meta', {'name': 'alpino_input'})
    if alpino_input:
        alpino_input.decompose()

    # reset sentence
    orig_sent = meta.find('meta', {'name': 'origsent'})
    if orig_sent:
        sentence_tag = Tag(builder=soup.builder,
                           name="sentence",
                           attrs={'sentid': app.sentid})
        sentence_tag.string = orig_sent.attrs['value']
        soup.sentence.replace_with(sentence_tag)
        orig_sent.decompose()

    # save the xml
    with open(app.input_path, 'w+') as f:
        f.write(soup.prettify())

    messagebox.showinfo(
        "", "Succesfully reset!\nPress OK to exit the program.")

    # exit the program
    sys.exit()


def build_new_metadata(app, alpino_return=None):
    soup = BeautifulSoup(app.xml_content, "lxml")
    meta = soup.metadata

    revised_utt_tag = Tag(builder=soup.builder,
                          name="meta",
                          attrs={'name': 'revisedutt', 'value': app.revised_utt})
    alpino_input_tag = Tag(builder=soup.builder,
                           name="meta",
                           attrs={'name': 'alpino_input', 'value': app.alpino_input})
    sentence_tag = Tag(builder=soup.builder,
                       name="sentence",
                       attrs={'sentid': app.sentid})
    sentence_tag.string = app.sentence

    # guaranteed replacements
    soup.sentence.replace_with(sentence_tag)

    # conditional replacements/additions
    if app.revised_exists:
        revised_utt = meta.find('meta', {'name': 'revisedutt'})
        revised_utt.replace_with(revised_utt_tag)
    else:
        meta.append(revised_utt_tag)

    if app.alpino_input_exists:
        orig_alpino_input = meta.find('meta', {'name': 'alpino_input'})
        orig_alpino_input.replace_with(alpino_input_tag)
    else:
        meta.append(alpino_input_tag)

    if not app.origsent_exists:
        orig_sent_tag = Tag(builder=soup.builder,
                            name="meta",
                            attrs={'name': 'origsent', 'value': app.origsent})
        meta.append(orig_sent_tag)

    if alpino_return:
        a_r = BeautifulSoup(alpino_return, "xml")
        soup.node.replace_with(a_r.node)

    return soup.prettify()


def ask_input(frame, label_text='', options=[]):
    if options != []:
        inputDialog = ComboBoxDialog(frame, label_text, options)
    else:
        inputDialog = EntryDialog(frame, label_text)

    frame.wait_window(inputDialog.top)
    return inputDialog.results


def correct_parenthesize(original, correction):
    '''
    take a string and its corrected equivalent.
    calculate the differences between the two and parenthesizes these.
    differences with whitespace should be split.
    '''
    ws_pattern = re.compile(r'(\S+)\s+(\S+)')
    pattern = r'(.*)'
    replace_pattern = r''
    i = 1

    if len(correction) > len(original):
        ws_pattern = re.compile(r'(\S+)\s+(\S+)')
        pattern = r'(.*)'
        replace_pattern = r''
        i = 1

        for letter in original:
            pattern += ('({})(.*)'.format(letter))
            replace_pattern += '(\{})\{}'.format(i, i+1)
            i += 2
        pattern = re.compile(pattern)

        # replace all diff with (diff)
        parenthesize = re.sub(pattern, replace_pattern, correction)
        # remove ()
        remove_empty = re.sub(r'\(\)', '', parenthesize)
        # split corrections with whitespace
        split_whitespace = re.sub(r'\((\S+)(\s+)(\S+)\)',
                                  r'(\1)\2(\3)', remove_empty)
        return split_whitespace

    else:
        return '{} [:{}] '.format(original, correction)


def clean_string(string, newlines=True, punctuation=True, doublespaces=True):
    # remove newlines
    if newlines:
        string = string.replace('\n', '')
        string = string.replace('\r', '')

    # add spaces around punctuation
    if punctuation:
        string = re.sub('([.,!?()\[\]])', r' \1 ', string)

    # reduce double spaces to singles
    if doublespaces:
        string = re.sub('\s{2,}', ' ', string)

    return string
