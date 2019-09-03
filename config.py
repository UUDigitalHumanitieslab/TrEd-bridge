# Debug mode (True/False)
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
