"""Rebuild internal state of Mersenne Twister from truncated output"""

from functools import reduce
from contextlib import closing
import gzip
import random
import cPickle as pickle

N = 624

print("Loading Magic")
magic = pickle.load(gzip.GzipFile("magic_data.gz"))
print("Done.")

def rebuild_random(data):
    """Create a random.Random() object from the data and the magic vectors

    :param list[str] magic: magic vector data
    :param str data: observed output from Mersenne Twister
    :rtype: random.Random
    """
    data_vals = [d for d in data]
    state = [0 for _ in range(N)]

    for bit_pos, magic_vals in enumerate(magic):
        # Magic-data AND MT-output
        xor_data = (a & b for a, b in zip(magic_vals, data_vals))
        # XOR all the bytes
        xor_data = reduce(lambda a, b: a ^ b, xor_data, 0)
        # XOR the bits of the result-byte
        xor_data = reduce(lambda a, b: a ^ b,
                          (xor_data >> i for i in range(30)))
        xor_data &= 1
        state[bit_pos // 32] |= xor_data << (31 - bit_pos % 32)

    state.append(N)
    ran = random.Random()
    ran.setstate((3, tuple(state), None))
    cmp_data = random_arr(len(data), ran)
    assert cmp_data == data
    return ran


def random_arr(length, random_obj):
    return [(random_obj.getrandbits(30)) for _ in range(length)]


def get_remote_random(first_random_arr):
    need_bytes = max(len(d) for d in magic)
    assert len(first_random_arr) == need_bytes
    my_random = rebuild_random(first_random_arr)
    return my_random


if __name__ == '__main__':
    main()
