import binascii
import socket
import ssl
import json
from telnetlib import Telnet
import time

import dataclasses
import enum
import random
from typing import Optional, Tuple


HOSTNAME = 'pppordle.chal.pwni.ng'
# HOSTNAME = 'localhost'


class Color(enum.Enum):
    GRAY = 'gray'
    YELLOW = 'yellow'
    GREEN = 'green'

    @classmethod
    def from_letter(cls, letter: str) -> 'Color':
        if letter == '-':
            return cls.GRAY
        elif letter == 'y':
            return cls.YELLOW
        elif letter == 'g':
            return cls.GREEN
        else:
            raise ValueError(f'What? {letter}')

    @classmethod
    def from_indicator_value(cls, value: int) -> 'Color':
        if value == 11035:
            return cls.GRAY
        elif value == 129000:
            return cls.YELLOW
        elif value == 129001:
            return cls.GREEN
        else:
            raise ValueError(f'What? {letter}')

    def to_letter(self) -> str:
        if self == Color.GRAY:
            return '-'
        elif self == Color.YELLOW:
            return 'y'
        else:
            return 'g'


@dataclasses.dataclass
class GuessAndResponse:
    guess: str
    response: Tuple[Color, Color, Color, Color, Color]

    def could_this_be_the_word(self, hypothetical_word: str) -> bool:
        assert len(self.guess) == len(hypothetical_word) == 5

        runes_left = list(hypothetical_word)

        indicators = []
        for word_rune, guess_rune in zip(hypothetical_word, self.guess):
            if word_rune == guess_rune:
                indicators.append(Color.GREEN)
                runes_left.remove(guess_rune)
            else:
                indicators.append(Color.GRAY)

        for i, (word_rune, guess_rune) in enumerate(zip(hypothetical_word, self.guess)):
            if word_rune == guess_rune:
                continue
            elif guess_rune in runes_left:
                indicators[i] = Color.YELLOW
                runes_left.remove(guess_rune)

        assert len(indicators) == 5
        return indicators == self.response

    def response_as_short_str(self) -> str:
        return ''.join(c.to_letter() for c in self.response)


class Solver:
    def __init__(self):
        self.responses = []

    def make_guess(self) -> str:
        raise NotImplementedError

    def update(self, response: GuessAndResponse) -> None:
        self.responses.append(response)

    def guess_is_sane(self, guess: str) -> bool:
        if len(guess) != 5:
            return False

        for r in self.responses:
            if not r.could_this_be_the_word(guess):
                return False

        return True

    def cli_interactive(self) -> None:
        for i in range(10):
            guess = self.make_guess()
            print(f'Guess: {guess}')
            response = input('Response (- = gray, y = yellow, g = green): ')
            assert len(response) == 5

            self.update(GuessAndResponse(guess, [Color.from_letter(c) for c in response]))

    def network_interactive(self, hostname: str, level: int, level_cert_fn:Optional[str]=None) -> None:
        context = ssl.create_default_context()
        context.check_hostname = False
        context.verify_mode = ssl.CERT_NONE
        context.load_verify_locations('client/certs/ca.pem')

        sock = socket.create_connection((hostname, 1337))
        ssock = context.wrap_socket(sock, server_hostname=hostname)
        dat = json.loads(ssock.recv(2048))
        print(dat)
        session_id = dat['SessionID']

        if level_cert_fn:
            level_context = ssl.create_default_context()
            level_context.check_hostname = False
            level_context.verify_mode = ssl.CERT_NONE
            level_context.load_cert_chain(f'client/certs/{level_cert_fn}.pem', f'client/certs/{level_cert_fn}.key')
        else:
            level_context = context

        level_sock = socket.create_connection((hostname, 1337 + level))
        level_ssock = level_context.wrap_socket(level_sock, server_hostname=(session_id+'.session'))

        for i in range(9999):
            dat = level_ssock.recv(2048)
            if dat:
                print(dat)
            if b'found' in dat:
                break
        else:
            raise RuntimeError

        level_ssock.close()
        level_sock.close()

        dat = ssock.recv(2048)
        print(dat)

        for i in range(10):
            guess = self.make_guess()
            print(f'Guess: {guess}')

            ssock.send(json.dumps({'Type':1,'Data':guess.upper()}).encode() + b'\n')
            resp_bytes = ssock.recv(2048)
            print(f'Response: {resp_bytes}')
            if not resp_bytes:
                return
            resp = json.loads(resp_bytes)

            response_obj = GuessAndResponse(guess, [Color.from_indicator_value(v) for v in resp['Indicators']])
            print(response_obj.response_as_short_str())
            self.update(response_obj)

            if resp.get('CompleteMessage'):
                raise RuntimeError('WE WON')

        print('Done')


class Level1Solver(Solver):

    def __init__(self):
        super().__init__()
        with open('server/level/assets/level1_wordlist.txt', 'r') as f:
            self.word_list = f.read().splitlines()

    def make_guess(self) -> str:
        filtered_words = [word for word in self.word_list if self.guess_is_sane(word)]
        return random.choice(filtered_words)


class Level2Solver_WordList(Solver):

    def __init__(self):
        super().__init__()
        with open('level2_wordlist.txt', 'r') as f:
            self.word_list = f.read().splitlines()

    def make_guess(self) -> str:
        filtered_words = [word for word in self.word_list if self.guess_is_sane(word)]
        return random.choice(filtered_words)


class Level2Solver(Solver):
    def __init__(self):
        super().__init__()
        with open('server/level/assets/level2_emojis.txt', 'r') as f:
            self.all_emojis = set(f.read())

    def make_guess(self) -> str:
        guess = [None, None, None, None, None]

        # this is a really silly but relatively simple approach
        shortlist = set()
        for r in self.responses:
            for guess_char, color in zip(r.guess, r.response):
                if color == Color.YELLOW:
                    shortlist.add(guess_char)
        for _ in range(50):
            shortlist.add(random.choice(list(self.all_emojis)))

        guess = ''
        for _ in range(9999):
            guess = ''
            for i in range(5):
                for r in self.responses:
                    if r.response[i] == Color.GREEN:
                        guess += r.guess[i]
                        break
                else:
                    guess += random.choice(list(shortlist))

            assert len(guess) == 5

            if self.guess_is_sane(guess):
                break

        else:
            raise ValueError("Couldn't find a solution in reasonable time")

        return guess


# Level2Solver().cli_interactive()

# Level1Solver().network_interactive(HOSTNAME, 1)

for _ in range(10):
    try:
        Level2Solver_WordList().network_interactive(HOSTNAME, 2, 'level2')
    except ConnectionResetError:
        pass

    import time
    time.sleep(1)
