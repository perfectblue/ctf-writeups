import string
from pwn import *
import itertools

#base 256 lol
def to_num(s):
    x = 0
    for i in range(len(s)): x += ord(s[-1-i]) * pow(256, i)
    return x

#break string into substrings of size n
#base 256 them. if the last one isn't size n, append 00s
def get_nums(s, n):
    sections = [s[i:i+n] for i in range(0, len(s), n)]
    sections[-1] = sections[-1] + ("\x00" * (n - len(sections[-1])))
    return [to_num(x) for x in sections]

#put x in base 2^n? and then take last 8 'bits'
def get_vals(x, n):
    vals = []
    mask = (1 << n) - 1
    for i in range(8):
        vals.append(x & mask)
        x = x >> n
    vals.reverse()
    return vals

# go from a base 2^n expansion to char. ie reverse of get_vals
def get_chrs(val_list, n):
    x = val_list[0]
    chrs = []
    for i in range(1, len(val_list)):
        x <<= n
        x += val_list[i]
    for i in range(n):
        chrs.append(chr(x % 256))
        x //= 256
    chrs.reverse()
    return "".join(chrs)

def encr_vals(m_chr, k_chr, n):
    return (m_chr + k_chr) & ((1 << n) - 1)

def encrypt(k, m, n):
    if (n >= 8): raise ValueError("n is too high!")
    rep_k = k * (len(m) // len(k)) + k[:len(m) % len(k)] # repeated key
    m_val_list = [get_vals(x, n) for x in get_nums(m, n)]
    k_val_list = [get_vals(x, n) for x in get_nums(rep_k, n)]
    m_vals, k_vals, c_vals = [], [], []
    for lst in m_val_list: m_vals += lst
    for lst in k_val_list: k_vals += lst
    c_vals = [encr_vals(m_vals[i], k_vals[i % len(k_vals)], n)
        for i in range(0, len(m_vals))]
    c_val_list = [c_vals[i:i+8] for i in range(0, len(c_vals), 8)]
    return "".join([get_chrs(lst, n) for lst in c_val_list])


#computes alist - blist
def subtract(alist, blist, n):
    return [(alist[i] - blist[i])%(2**n) for i in range(8)]

# 'subtracts' s1 - s2
def unxor(ciphertext, k, n):
    rep_key = k * (len(ciphertext) // len(k)) + k[:len(ciphertext) % len(k)]
    c_val_list = [get_vals(num, n) for num in get_nums(ciphertext, n)]# [ [list], [list]]
    rk_val_list = [get_vals(num, n) for num in get_nums(rep_key, n)]

    plaintext_list = [subtract(c_val_list[i], rk_val_list[i], n) for i in range(len(c_val_list))]

    return ''.join([get_chrs(lst, n) for lst in plaintext_list])

c = '809fdd88dafa96e3ee60c8f179f2d88990ef4fe3e252ccf462deae51872673dcd34cc9f55380cb86951b8be3d8429839'.decode('hex')
c = '7d3e9d844eab63c28ebc7cd96633b0a57ca170c2babc70ba7fcf6e4d61e84c268b487fe30c2d959062c77616595534f7'.decode('hex')

k2 = '\x1b\xd2|a' # known start of key
# k3 = '>\xb3\xbc'
# k4 = '*3|!'

def try_block_length(n):
    if n == 2:
        k = k2
        known_bytes = 4
    # if n == 3:
    #     k = k3
    #     known_bytes = 3
    # if n == 4:
    #     k = k4
    #     known_bytes = 4

    for i in range(44):
        klen = len(k) + i
        message = unxor(c, k+('A'*i), n)
        all_printable = True
        for j in range(len(message)):
            if (j%klen < known_bytes) and message[j] not in string.printable:
                all_printable = False
                break
        if all_printable:
            print 'n = {}: len(k) = {}'.format(n, klen)

def try_decrypt():
    for char in string.printable:
        third_block = '{' + char
        k = k2 + unxor(c[4:6], third_block, 2)
        message = unxor(c, k, 2)

        all_printable = True
        for char2 in message:#flag should be printable
            if char2 not in string.printable:
                all_printable = False
                break
        if all_printable and '}' == message[-1]: #flag ends with }
            print message
            print k

try_decrypt()
#flag{!X0R_iS_aDDi+i0N_m0d=2,^buT_+hi5_is_MoD-4!}