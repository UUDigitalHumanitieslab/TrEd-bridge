import re

import lxml.etree as ET

from TK_extensions.entry_dialog import ComboBoxDialog, EntryDialog


def process_input(input_path):
    tree = ET.parse(input_path)
    root = tree.getroot()

    origutt = root.find('.//meta[@name="origutt"]')
    origutt_value = origutt.get('value')
    revised_utt = root.find('.//meta[@name="revisedutt"]')
    revised_exists = True
    if not revised_utt:
        revised_utt = origutt
        revised_exists = False

    sentence = root.find('.//sentence')
    sentence_value = sentence.text
    origsent = root.find('.//meta[@name="origsent"]')
    if not origsent:
        origsent_value = sentence.text
        origsent_exists = False
    else:
        origsent_value = origsent.get('value')
        origsent_exists: True

    alpino_input = root.find('.//meta[@name="alpino_input"]')
    if not alpino_input:
        alpino_input_value = sentence.text
        alpino_input_exists = False
    else:
        alpino_input_value = alpino_input.get('value')
        alpino_input_exists = True

    return {'origutt': origutt_value,
            'revised_utt': revised_utt.get('value'),
            'revised_exists': revised_exists,
            'sentence': sentence_value,
            'origsent': origsent_value,
            'origsent_exists': origsent_exists,
            'alpino_input': alpino_input_value,
            'alpino_input_exists': alpino_input_exists
            }

    # origutt = root.find('.//meta[@name="origutt"]')
    # origutt_old = '<meta type="text" name="origutt_old" value="{}"/>\n'.format(
    #     origutt.get('value'))
    # metadata.insert(
    #     metadata.index(origutt)+1, ET.XML(origutt_old))
    # new_metadata = ET.tostring(metadata) + b'\n'

    # return origutt.get('value'), new_metadata


def build_new_metadata(metadata, revised_exists, revised_utt, sent_exists, sent):
    pass


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

    for letter in original:
        pattern += ('({})(.*)'.format(letter))
        replace_pattern += '(\{})\{}'.format(i, i+1)
        i += 2
    pattern = re.compile(pattern)

    # replace all diff with (diff)
    parenthesize = re.sub(pattern, replace_pattern, correction)
    #remove ()
    remove_empty = re.sub(r'\(\)', '', parenthesize)
    # split corrections with whitespace
    split_whitespace = re.sub(r'\((\S+)(\s+)(\S+)\)',
                              r'(\1)\2(\3)', remove_empty)

    return split_whitespace


def clean_punctuation(string):
    # remove newlines
    string = string.replace('\n', '')
    string = string.replace('\r', '')
    # add spaces around punctuation
    string = re.sub('([.,!?()\[\]])', r' \1 ', string)
    # reduce double spaces to singles
    string = re.sub('\s{2,}', ' ', string)
    return string
