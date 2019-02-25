import re

import lxml.etree as ET
from bs4 import BeautifulSoup, Tag

from TK_extensions.entry_dialog import ComboBoxDialog, EntryDialog


def process_input(input_path):
    tree = ET.parse(input_path)
    root = tree.getroot()
    metadata = root.find('metadata')

    origutt = root.find('.//meta[@name="origutt"]')
    origutt_value = origutt.get('value')
    revised_utt = root.find('.//meta[@name="revisedutt"]')
    revised_exists = True
    if revised_utt is None:
        revised_utt = origutt
        revised_exists = False

    sentence = root.find('.//sentence')
    sentence_value = sentence.text
    sent_id = sentence.get('sentid')
    origsent = root.find('.//meta[@name="origsent"]')
    if origsent is None:
        origsent_value = sentence.text
        origsent_exists = False
    else:
        origsent_value = origsent.get('value')
        origsent_exists = True

    alpino_input = root.find('.//meta[@name="alpino_input"]')
    if alpino_input is None:
        alpino_input_value = sentence.text
        alpino_input_exists = False
    else:
        alpino_input_value = alpino_input.get('value')
        alpino_input_exists = True

    return {'origutt': origutt_value,
            'revised_utt': revised_utt.get('value'),
            'revised_exists': revised_exists,
            'sentence': sentence_value,
            'sent_id': sent_id,
            'origsent': origsent_value,
            'origsent_exists': origsent_exists,
            'alpino_input': alpino_input_value,
            'alpino_input_exists': alpino_input_exists,
            'xml_content': ET.tostring(root)
            }


def build_new_metadata(frame, alpino_return=None):
    app = frame
    xml_content = app.xml_content
    soup = BeautifulSoup(xml_content, "xml")
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
