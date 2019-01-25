import re

import lxml.etree as ET

from TK_extensions.entry_dialog import ComboBoxDialog, EntryDialog


def process_input(input_path):
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
