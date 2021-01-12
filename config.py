# Debug mode (True/False)
from collections import OrderedDict
DEBUG = False

PARSER_URL = 'https://gretel.hum.uu.nl/api/src/router.php/parse_sentence/'
# PARSER_URL = 'http://localhost:4200/gretel/api/src/router.php/parse_sentence/'

TREE_VIS_URL = 'http:/gretel.hum.uu.nl/gretel4/ng/tree'

POS_TAGS_PATH = 'data/POS_tags.csv'

CAT_CONFIG = 'config/categories.csv'
POS_CONFIG = 'config/POS.csv'
POSTAGS_CONFIG = 'config/POS_tags.csv'

ALPINO_KEYBINDS = {
    # key: function name
    'o': 'pos',
    't': 'tae',
    'n': 'const',
    'k': 'skip',
    'h': 'phantom',
    'r': 'reset',
    'b': 'back_to_chat',
    's': 'save',
    'p': 'parse',
    'e': 'tree_preview',
}

CHAT_KEYBINDS = {
    # key: function name
    'p': 'parenthesize_selection',
    'g': 'prefix_ampersand',
    't': 'correct',
    'l': 'clean_continue_to_alpino',
    'r': 'reset_chat_edit'
}

SINGLE_PAGE_KEYBINDS = {
    'r': 'reset',
    'g': 'prefix_ampersand',
    't': 'correct',
    'p': 'parse',
    'e': 'tree_preview',
    's': 'save'
}

SYSTEM_KEYBINDS = [
    'c',
    'v',
    'a',
]

CAT_DICT = OrderedDict([
    (' ', 'no category'),
    ('ahi', 'aan het infinitive'),
    ('ap', 'adjectival phrase'),
    ('advp', 'adverbial phrase'),
    ('inf', 'bare infinitival phrase'),
    ('cp', 'complementizer phrase'),
    ('conj', 'coordinate phrase with conjunction'),
    ('list', 'coordinate phrase without conjunction'),
    ('detp', 'determiner phrase'),
    ('du', 'discourse unit'),
    ('whrel', 'free relative'),
    ('whq', 'main clause wh-question'),
    ('smain', 'main clause(SVO)'),
    ('mwu', 'multi word unit'),
    ('np', 'noun phrase'),
    ('oti', 'om te infinitive'),
    ('ppart', 'past participial phrase'),
    ('pp', 'prepositional phrase'),
    ('ppres', 'present participial phrase'),
    ('rel', 'relative clause'),
    ('top', 'root of a dependency structure'),
    ('whsub', 'subordinate clause wh-question'),
    ('ssub', 'subordinate clause(SOV)'),
    ('ti', 'te infinitive'),
    ('svan', 'van clause'),
    ('sv', 'verb initial clause(VSO)')
])

POS_DICT = OrderedDict([
    ('adj', 'adjective'),
    ('adv', 'adverb'),
    ('comp', 'complementizer'),
    ('comparative', 'comparative'),
    ('det', 'determiner'),
    ('fixed', 'fixed parts'),
    ('name', 'named entity'),
    ('noun', 'noun'),
    ('num', 'numeral'),
    ('part', 'particle'),
    ('pp', 'pronominal adverb'),
    ('pron', 'pronoun'),
    ('prep', 'preposition'),
    ('punct', 'punctuation'),
    ('tag', 'tag'),
    ('verb', 'verb'),
    ('vg', 'conjunction')
])

POS_TAG_DICT = OrderedDict([
    ("N(soort,ev,basis,zijd,stan)", "Noun, ev, zijdig"),
    ("N(soort,ev,basis,onz,stan)", "Noun, ev, onzijdig"),
    ("N(soort,ev,dim,onz,stan)", "Noun, ev, dim"),
    ("N(soort,mv,basis)", "Noun, mv"),
    ("N(soort,mv,dim)", "Noun, mv, dim"),
    ("ADJ(vrij,basis,zonder)", "Adj"),
    ("LID(onbep,stan,agr)", "Lid: een"),
    ("LID(bep,stan,rest)", "Lid: de"),
    ("LID(bep,stan,evon)", "Lid: het"),
    ("WW(pv,tgw,ev)", ""),
    ("WW(pv,tgw,met-t)", ""),
    ("WW(pv,tgw,mv)", ""),
    ("WW(inf,vrij,zonder)", "Inf"),
    ("WW(vd,vrij,zonder)", "Vd"),
    ("VNW(pers,pron,nomin,vol,1,ev)", "ik"),
    ("VNW(pers,pron,nomin,red,3,ev,masc)", "ie"),
    ("VNW(pers,pron,nomin,vol,3v,ev,fem)", "zij (ev, vr)"),
    ("VNW(aanw,det,stan,prenom,zonder,agr)", "zo’n")
])
