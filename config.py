# Debug mode (True/False)
DEBUG = False

GRETEL_URL = 'http://gretel.hum.uu.nl'
# GRETEL_URL = 'http://localhost:4200'

ALPINO_KEYBINDS = {
    # key: function name
    'p': 'pos',
    't': 'tae',
    'n': 'const',
    's': 'skip',
    'h': 'phantom',
    'r': 'reset',
    'b': 'back_to_chat',
    's': 'save',
    'a': 'parse',
}

CHAT_KEYBINDS = {
    # key: function name
    'p': 'parenthesize_selection',
    'g': 'prefix_ampersand',
    't': 'correct',
    'e': 'clean',
    'l': 'clean_continue_to_alpino',
    'r': 'reset_chat_edit'
}

CAT_DICT = {
    'no category': ' ',
    'aan het infinitive': 'ahi',
    'adjectival phrase': 'ap',
    'adverbial phrase': 'advp',
    'bare infinitival phrase': 'inf',
    'complementizer phrase': 'cp',
    'coordinate phrase with conjunction': 'conj',
    'coordinate phrase without conjunction': 'list',
    'determiner phrase': 'detp',
    'discourse unit': 'du',
    'free relative': 'whrel',
    'main clause wh-question': 'whq',
    'main clause(SVO)': 'smain',
    'multi word unit': 'mwu',
    'noun phrase': 'np',
    'om te infinitive': 'oti',
    'past participial phrase': 'ppart',
    'prepositional phrase': 'pp',
    'present participial phrase': 'ppres',
    'relative clause': 'rel',
    'root of a dependency structure': 'top',
    'subordinate clause wh-question': 'whsub',
    'subordinate clause(SOV)': 'ssub',
    'te infinitive': 'ti',
    'van clause': 'svan',
    'verb initial clause(VSO)': 'sv'
}

POS_DICT = {
    'adjective': 'adj',
    'adverb': 'adv',
    'complementizer': 'comp',
    'comparative': 'comparative',
    'determiner': 'det',
    'fixed parts': 'fixed',
    'named entity': 'name',
    'noun': 'noun',
    'numeral': 'num',
    'particle': 'part',
    'pronominal adverb': 'pp',
    'pronoun': 'pron',
    'preposition': 'prep',
    'punctuation': 'punct',
    'tag': 'tag',
    'verb': 'verb',
    'conjunction': 'vg'
}
