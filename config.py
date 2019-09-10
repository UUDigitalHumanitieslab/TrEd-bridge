# Debug mode (True/False)
from collections import OrderedDict
DEBUG = False

PARSER_URL = 'http://gretel.hum.uu.nl/gretel4/api/src/router.php/parse_sentence/'
# PARSER_URL = 'http://localhost:4200/gretel/api/src/router.php/parse_sentence/'

TREE_VIS_URL = 'http:/gretel.hum.uu.nl/gretel4/ng/tree'

POS_TAGS_PATH = 'data/POS_tags.csv'

CAT_CONFIG = 'config/categories.csv'
POS_CONFIG = 'config/POS.csv'
POSTAGS_CONFIG = 'config/POS_tags.csv'

ALPINO_KEYBINDS = {
    # key: function name
    'p': 'pos',
    't': 'tae',
    'n': 'const',
    'k': 'skip',
    'h': 'phantom',
    'r': 'reset',
    'b': 'back_to_chat',
    's': 'save',
    'a': 'parse',
    'v': 'tree_preview',
}

CHAT_KEYBINDS = {
    # key: function name
    'p': 'parenthesize_selection',
    'g': 'prefix_ampersand',
    't': 'correct',
    'l': 'clean_continue_to_alpino',
    'r': 'reset_chat_edit'
}

CAT_DICT = OrderedDict([
    ('no category', ' '),
    ('aan het infinitive', 'ahi'),
    ('adjectival phrase', 'ap'),
    ('adverbial phrase', 'advp'),
    ('bare infinitival phrase', 'inf'),
    ('complementizer phrase', 'cp'),
    ('coordinate phrase with conjunction', 'conj'),
    ('coordinate phrase without conjunction', 'list'),
    ('determiner phrase', 'detp'),
    ('discourse unit', 'du'),
    ('free relative', 'whrel'),
    ('main clause wh-question', 'whq'),
    ('main clause(SVO)', 'smain'),
    ('multi word unit', 'mwu'),
    ('noun phrase', 'np'),
    ('om te infinitive', 'oti'),
    ('past participial phrase', 'ppart'),
    ('prepositional phrase', 'pp'),
    ('present participial phrase', 'ppres'),
    ('relative clause', 'rel'),
    ('root of a dependency structure', 'top'),
    ('subordinate clause wh-question', 'whsub'),
    ('subordinate clause(SOV)', 'ssub'),
    ('te infinitive', 'ti'),
    ('van clause', 'svan'),
    ('verb initial clause(VSO)', 'sv')
])

POS_DICT = OrderedDict([
    ('adjective', 'adj'),
    ('adverb', 'adv'),
    ('complementizer', 'comp'),
    ('comparative', 'comparative'),
    ('determiner', 'det'),
    ('fixed parts', 'fixed'),
    ('named entity', 'name'),
    ('noun', 'noun'),
    ('numeral', 'num'),
    ('particle', 'part'),
    ('pronominal adverb', 'pp'),
    ('pronoun', 'pron'),
    ('preposition', 'prep'),
    ('punctuation', 'punct'),
    ('tag', 'tag'),
    ('verb', 'verb'),
    ('conjunction', 'vg')
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
    ("VNW(pers,pron,nomin,vol,3v,ev,fem)", "zij (ev, vr)", "),
    ("VNW(aanw,det,stan,prenom,zonder,agr)", "zo’n")
])
