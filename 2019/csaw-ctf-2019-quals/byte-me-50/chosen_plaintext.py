""" Implement a Chosen Plaintext Attack
    Author: EiNSTeiN_ <einstein@g3nius.org>
"""

import random

class CiphertextNotStable(Exception): pass
class BlockInfoDetectionFailed(Exception): pass

class ChosenPlaintext(object):

  def __init__(self, use_predicted_iv=None):
    self.block_size = None
    self.plaintext_offset = None
    self.plaintext = ''

    self.use_predicted_iv = use_predicted_iv
    return

  def IV(self):
    """ The base class must return the predicted IV for the next ciphertext() call. """
    raise NotImplemented('IV() must be overriden')

  def ciphertext(self, plaintext):
    """ The base class must return the ciphertext for that plaintext """
    raise NotImplemented('ciphertext() must be overriden')

  def __get_ciphertext(self, plaintext):
    """ get the ciphertext for that plaintext, making sure to track the IV. """

    if self.use_predicted_iv:
      predicted_iv = self.IV()

      first_block = '\x00' * len(predicted_iv)
      first_block = ''.join([chr(ord(predicted_iv[i]) ^ ord(first_block[i])) for i in range(len(predicted_iv))])

      plaintext = first_block + plaintext

    return self.ciphertext(plaintext)

  def random_letters(self, n):
    """ Return a string of `n` random letters. """
    return ''.join([chr(c) for c in random.sample(range(ord('a'), ord('z')), n)])

  def random_pair(self):
    """ Return two random letters that are garanteed to not be the same. """
    a = b = self.random_letters(1)
    while b == a:
      b = self.random_letters(1)
    return a, b

  def test_stability(self):
    """ Test the stability of the encryption process. If the IV is fixed, the same plaintext will always encrypt to the same ciphertext. """
    letters = self.random_letters(random.randint(16,25))
    ciphertext = self.__get_ciphertext(letters)
    for i in range(10):
      if ciphertext != self.__get_ciphertext(letters):
        raise CiphertextNotStable('Same plaintext does not encrypt to same ciphertext.')
    return True

  def first_different_block(self, a, b, bs=8):
    """ Return the index of the first `bs`-byte block that is different between `a` and `b`. """
    assert len(a) == len(b)
    strlen = len(a)
    assert strlen % bs == 0
    a = self.blocks(a, bs)
    b = self.blocks(b, bs)
    i = 0
    for i in range(strlen / bs):
      if a[i] != b[i]:
        return i
      i += 1
    return None

  def find_block_info(self):
    """ Try to find the block size and the number of bytes 
        of plaintext required before overflowing into the 
        next block.

        This is done purely as a blackbox test, by encrypting 
        different plaintext and looking at the ciphertext. """

    # Send only one letter and check which block is the first "different" block.
    a, b = self.random_pair()
    first = self.__get_ciphertext(a)
    second = self.__get_ciphertext(b)
    base = self.first_different_block(first, second)

    # Test changing each byte until an overflow occurs
    for n in range(0, 20):
      # get two blocks that differ only by the last letter.
      a, b = self.random_pair()
      first = self.__get_ciphertext("%s%s" % ('a' * n, a))
      second = self.__get_ciphertext("%s%s" % ('a' * n, b))
      diff = self.first_different_block(first, second)
      if diff is None:
        continue
      if diff != base:
        self.block_size = 16 if (diff - base) == 2 else 8
        in_block = self.first_different_block(first, second, self.block_size) - 1
        self.plaintext_offset = (in_block * self.block_size) + (self.block_size - n)
        return

    raise BlockInfoDetectionFailed('Failed to detect block size and plaintext offset.')

  def blocks(self, c, bs=None):
    if bs is None:
      bs = self.block_size
    return [c[i * bs:(i + 1) * bs] for i in range(len(c) / bs)]

  def run(self):
    if (self.block_size is None or self.plaintext_offset is None) and self.test_stability():
      self.find_block_info()

    # find the length we want to decrypt, rounded up to a full block.
    c = self.__get_ciphertext('a')
    clen = len(c)
    decrypt_len = clen - self.plaintext_offset
    decrypt_len = (decrypt_len - (decrypt_len % self.block_size)) + self.block_size

    # length that we have to pad for getting to the end of the first block we control
    # (plaintext_offset + pad_length) is a multiple of block_size.
    pad_length = self.block_size - (self.plaintext_offset % self.block_size)

    # full plaintext length
    plength = pad_length + decrypt_len

    # this is the index of the last block we control
    known_block = ((self.plaintext_offset + plength) / self.block_size) - 1

    # Now the main blob, the hearth of the attack.
    self.plaintext = ''
    while len(self.plaintext) < (clen - self.plaintext_offset):
      # figure out the ciphertext that correspond to the next plaintext we want to guess.
      p = ('a' * (plength - 1 - len(self.plaintext)))
      c = self.__get_ciphertext(p)
      canary = self.blocks(c)[known_block]

      # Try each letter until we find a block that match our canary
      found = False
      charset = [ord(x) for x in '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~']
      for i in charset:
        p = ('a' * (plength - 1 - len(self.plaintext))) + self.plaintext + chr(i)
        c = self.__get_ciphertext(p)
        b = self.blocks(c)[known_block]
        if b == canary:
          self.plaintext += chr(i)
          #print 'FOUND!!!', repr(chr(i)), repr(self.plaintext)
          found = True
          break
      if not found:
        #print 'Cannot find next letter, %u of %u found' % (len(self.plaintext), clen - self.plaintext_offset)
        break

    return
