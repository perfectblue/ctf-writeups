#!/usr/bin/env python
#
# Author:
#     Pawel Krawczyk (http://ipsec.pl)
# Parts based on C implementation by:
#     Ted Krovetz (tdk@acm.org)
#
# Licensed under GNU General Public License (GPL)
# Version 3, 29 June 2007
# http://www.gnu.org/licenses/gpl.html

import math

class OCB:
    """
This module provides pure Python implementation of authenticated encryption
mode OCB (Offset Codebook Mode, version 2) using AES block cipher. OCB offers
confidentiality, integrity and authenticity of data in single encryption
step and using single interface. It's alternative to traditional modes
(like CTR or CBC) with separate HMAC calculation.

Usage
=====
Data
----
The module operates on _bytearray_ objects. Key, nonce, header and plaintext
should be passed to OCB as bytearrays.

    >>> plaintext = bytearray('The Magic Words are Squeamish Ossifrage')
    >>> header = bytearray('Recipient: john.doe@example.com')
    >>> key = bytearray().fromhex('A45F5FDEA5C088D1D7C8BE37CABC8C5C')
    >>> nonce = bytearray(range(16))

Loading
-------
Load a block cipher and OCB mode:

    >>> from ocb.aes import AES
    >>> from ocb import OCB

The OCB module provides built-in AES implementation, but other block
ciphers can be used as well.

Initalize OCB-AES cipher objects:

    >>> aes = AES(128)
    >>> ocb = OCB(aes)

Parameters
----------
OCB has two parameters: _key_ and _nonce_. Key will be typically 128, 192 or 256
bit AES key:

    >>> key = bytearray().fromhex('A45F5FDEA5C088D1D7C8BE37CABC8C5C')
    >>> ocb.setKey(key)

Nonce **must** be selected as a new value for each message encrypted. Nonce has
to be the same length as underlying cipher block length, typically 128 bits:

    >>> nonce = bytearray(range(16))
    >>> ocb.setNonce(nonce)

Encryption
----------
Input _plaintext_ of arbitrary length. This block will be encrypted and its
integrity protected:

    >>> plaintext = bytearray('The Magic Words are Squeamish Ossifrage')

Optional, plaintext _header_ of arbitrary length. This block will **not**
be encrypted, but its integrity will be protected:

    >>> header = bytearray('Recipient: john.doe@example.com')

Encryption method over _plaintext_ and _header_ returns ciphertext and _authentication tag_. The tag protects integrity of both plaintext and header.

    >>> (tag,ciphertext) = ocb.encrypt(plaintext, header)
    >>> tag
    bytearray(b')\xc9vx\xda\xc9Z\x80)\xfe@\xd9)\x8d\x86\x91')
    >>> ciphertext
    bytearray(b'3D\xdf\x01\xf3;\xe8\x87\x84@\xef\xac\xbcyK:J_3} \x9e\x889\xcd\xa4NvW
\x88\xc1}5\x9a\x8b\xc3\x82\xd9Z')

Encryption resets nonce so that it needs to be assigned a fresh value before
repeating encryption.

Decryption
----------
The decrypt method takes _header_, _ciphertext_ and _tag_ on input. It returns a tuple of decrypted plaintext and flag indicating whether input data was not tampered with.

    >>> (is_authentic, plaintext2) = ocb.decrypt(header, ciphertext, tag)
    >>> is_authentic
    True
    >>> str(plaintext2)
    'The Magic Words are Squeamish Ossifrage'

The flag will be set to _False_ and plaintext will be empty if ciphertext is modified:

    >>> ciphertext[3] = 0
    >>> ocb.decrypt(header, ciphertext, tag)
    (False, [])

The same happens if header is modified (even ciphertext was not):

    >>> header[3] = 0
    >>> ocb.decrypt(header, ciphertext, tag)
    (False, [])

References
==========
* [The OCB Authenticated-Encryption Algorithm](http://www.cs.ucdavis.edu/~rogaway/papers/draft-krovetz-ocb-00.txt)
* [OCB Mode](http://en.wikipedia.org/wiki/OCB_mode) (Wikipedia)
    """
    def __init__(self, cipher):
        """ OCB() object must be initialized with block cipher instance """
        assert(cipher)
        self.cipher = cipher
        self.cipherKeySize = cipher.getKeySize()
        self.cipherRounds = cipher.getRounds()
        self.cipherBlockSize = cipher.getBlockSize()
        self.nonce = None

    def setNonce(self, nonce):
        """
        Configure nonce N for current OCB instance.
        Input: array of integers
        Lengths must be same as cipher block number
        """
        assert len(nonce) == self.cipherBlockSize
        self.nonce = nonce

    def setKey(self, key):
        """
        Configure key K for current OCB instance.
        Input: array of integers
        Length must be 16, 24, 32 depending on keys size.
        """
        assert len(key) == self.cipherKeySize
        self.cipher.setKey(key)

        # These routines manipulate the offsets which are used for pre- and
        # post-whitening of blockcipher invocations. The offsets represent
        # polynomials, and these routines multiply the polynomials by other
        # constant polynomials. Note that as an optimization two consecutive
        # invocations of "three_times" can be efficiently replaced:
        #    3(3(X)) == (2(2(X))) xor X
    def _times2(self, input_data):
        input_data = bytearray(input_data)
        blocksize = self.cipherBlockSize
        assert len(input_data) == blocksize
        # set carry = high bit of src
        output =  bytearray(blocksize)
        carry = input_data[0] >> 7 # either 0 or 1
        for i in range(len(input_data) - 1):
            output[i] = ((input_data[i] << 1) | (input_data[i + 1] >> 7)) % 256
        output[-1] = ((input_data[-1] << 1) ^ (carry * 0x87)) % 256
        assert len(output) == blocksize
        return output

    def _times3(self, input_data):
        assert len(input_data) == self.cipherBlockSize
        output = self._times2(input_data)
        output = self._xor_block(output, input_data)
        assert len(output) == self.cipherBlockSize
        return output

    def _xor_block(self, input1, input2):
        """
        Return block made of two XORed blocks. Don't need to be of "blocksize"
        lenght, must be  equal length.
        """
        assert len(input1) == len(input2)
        output = bytearray()
        for i in range(len(input1)):
            output.append(input1[i] ^ input2[i])
        return output

    def _pmac(self, header):
        """
        Calculates PMAC of optional user submitted header.

            Input: header, array of integers of arbitrary lenght
            Output: header authentication tag, array of integers

        """
        assert len(header)
        assert self.cipherBlockSize

        blocksize = self.cipherBlockSize

        # Break H into blocks
        m = int(max(1, math.ceil(len(header) / float(blocksize))))

        # Initialize strings used for offsets and checksums
        offset = self.cipher.encrypt(bytearray([0] * blocksize))
        offset = self._times3(offset)
        offset = self._times3(offset)
        checksum = bytearray(blocksize)

        # Accumulate the first m - 1 blocks
        # skipped if m == 1
        for i in range(m - 1):
            offset = self._times2(offset)
            H_i = header[(i * blocksize):(i * blocksize) + blocksize]
            assert len(H_i) == blocksize
            xoffset = self._xor_block(H_i, offset)
            encrypted = self.cipher.encrypt(xoffset)
            checksum = self._xor_block(checksum, encrypted)

        # Accumulate the final block
        offset = self._times2(offset)
        # check if full block
        H_m = header[((m - 1) * blocksize):]
        assert len(H_m) <= blocksize
        if len(H_m) == blocksize:
            # complete last block
            # this is only possible if m is 1
            offset = self._times3(offset)
            checksum = self._xor_block(checksum, H_m)
        else:
            # incomplete last block
            # pad with separator binary 1
            # then pad with zeros until full block
            H_m.append(int('10000000', 2))
            while len(H_m) < blocksize:
                H_m.append(0)
            assert len(H_m) == blocksize
            checksum = self._xor_block(checksum, H_m)
            offset = self._times3(offset)
            offset = self._times3(offset)

        # Compute PMAC result
        final_xor = self._xor_block(offset, checksum)
        auth = self.cipher.encrypt(final_xor)
        return auth

    def encrypt(self, plaintext, header, debug=False):
        """
        Encrypt a message of arbitrary length and optional header in OCB mode.

            Input: plaintext (bytearray), header (bytearray)
            Output: (tag, ciphertext)

        >>> (tag,ciphertext) = ocb.encrypt(plaintext, header)

        If key or nonce are not set an exception is raised. Encryption
        will reset nonce so that it needs to be set to a fresh value.
        """
        assert self.cipherBlockSize
        assert self.nonce

        blocksize = self.cipherBlockSize

        # Break H into blocks
        m = int(max(1, math.ceil(len(plaintext) / float(blocksize))))

        # Initialize strings used for offsets and checksums
        offset = self.cipher.encrypt(self.nonce)
        checksum = bytearray(blocksize)
        ciphertext = bytearray()

        # Encrypt and accumulate first m - 1 blocks
        # skipped if m == 1
        #for i = 1 to m - 1 do           // Skip if m < 2
        #    Offset = times2(Offset)
        #    Checksum = Checksum xor M_i
        #    C_i = Offset xor ENCIPHER(K, M_i xor Offset)
        #end for
        for i in range(m - 1):
            offset = self._times2(offset)
            M_i = plaintext[(i * blocksize):(i * blocksize) + blocksize]
            assert len(M_i) == blocksize
            checksum = self._xor_block(checksum, M_i)
            xoffset = self.cipher.encrypt(self._xor_block(M_i, offset))
            # print('$'*10)
            # print(xoffset)
            ciphertext += self._xor_block(offset, xoffset)
            assert len(ciphertext) % blocksize == 0

        # Encrypt and accumulate final block
        M_m = plaintext[((m - 1) * blocksize):]
        # Offset = times2(Offset)
        offset = self._times2(offset)
        #  b = bitlength(M_m) // Value in 0..BLOCKLEN
        bitlength = len(M_m) * 8
        assert bitlength <= blocksize * 8
        # num2str(b, BLOCKLEN)
        tmp = bytearray(blocksize)
        tmp[-1] = bitlength
        # Pad = ENCIPHER(K, num2str(b, BLOCKLEN) xor Offset)
        pad = self.cipher.encrypt(self._xor_block(tmp, offset))
        # print('~'*10)
        # print(pad)
        tmp = bytearray()
        # C_m = M_m xor Pad[1..b]         // Encrypt M_m
        # this MAY be a partial size block
        C_m = self._xor_block(M_m, pad[:len(M_m)])
        ciphertext += C_m
        # Tmp = M_m || Pad[b+1..BLOCKLEN]
        tmp = M_m + pad[len(M_m):]
        assert len(tmp) == blocksize
        # Checksum = Checksum xor Tmp
        if debug: print(tmp)
        checksum = self._xor_block(tmp, checksum)

        # Compute authentication tag
        offset = self._times3(offset)
        tag = self.cipher.encrypt(self._xor_block(checksum, offset))
        if len(header) > 0:
            tag = self._xor_block(tag, self._pmac(header))

        self.nonce = None

        return (tag, ciphertext)

    def decrypt(self, header, ciphertext, tag, debug=False):
        assert self.cipherBlockSize

        blocksize = self.cipherBlockSize

        # Break C into blocks
        m = int(max(1, math.ceil(len(ciphertext) / float(blocksize))))

        # Initialize strings used for offsets and checksums
        offset = self.cipher.encrypt(self.nonce)
        checksum = bytearray(blocksize)
        plaintext = bytearray()

#        for i = 1 to m - 1 do           // Skip if a < 2
#            Offset = times2(Offset)
#            M_i = Offset xor DECIPHER(K, C_i xor Offset)
#            Checksum = Checksum xor M_i
#        end for
        for i in range(m - 1):
            offset = self._times2(offset)
            C_i = ciphertext[(i * blocksize):(i * blocksize) + blocksize]
            assert len(C_i) == blocksize
            tmp = self.cipher.decrypt(self._xor_block(C_i, offset))
            M_i = self._xor_block(offset, tmp)
            checksum = self._xor_block(checksum, M_i)
            plaintext += M_i
            assert len(plaintext) % blocksize == 0

            # Decrypt and accumulate final block
#         Offset = times2(Offset)
#         b = bitlength(C_m)              // Value in 0..BLOCKLEN
#         Pad = ENCIPHER(K, num2str(b, BLOCKLEN) xor Offset)
#         M_m = C_m xor Pad[1..b]
#         Tmp = M_m || Pad[b+1..BLOCKLEN]
#         Checksum = Checksum xor Tmp
        offset = self._times2(offset)
        C_m = ciphertext[((m - 1) * blocksize):]
        bitlength = len(C_m) * 8
        assert bitlength <= blocksize * 8
        tmp = bytearray(blocksize)
        tmp[-1] = bitlength
        pad = self.cipher.encrypt(self._xor_block(tmp, offset))
        tmp = []
        M_m = self._xor_block(C_m, pad[:len(C_m)])
        plaintext += M_m
        tmp = M_m + pad[len(M_m):]
        assert len(tmp) == blocksize
        checksum = self._xor_block(tmp, checksum)

        # Compute valid authentication tag
#         Offset = times3(Offset)
#         FullValidTag = ENCIPHER(K, Offset xor Checksum)
#         if bitlength(H) > 0 then
#            FullValidTag = FullValidTag xor PMAC(K, H)
#         end if
        offset = self._times3(offset)
        full_valid_tag = self.cipher.encrypt(self._xor_block(offset, checksum))
        if len(header) > 0:
            full_valid_tag = self._xor_block(full_valid_tag, self._pmac(header))
        # Compute results
        if tag == full_valid_tag:
            return (True, plaintext)
        else:
            return (False, [])

import unittest
from .aes import AES

class OcbTestCase(unittest.TestCase):
    def setUp(self):
        # draft-krovetz-ocb-00.txt, page 11
        self.vectors = (# header, plaintext, expected tag, expectec ciphertext
        ('', '', 'BF3108130773AD5EC70EC69E7875A7B0', ''),
        ('', '0001020304050607', 'A45F5FDEA5C088D1D7C8BE37CABC8C5C', 'C636B3A868F429BB'),
        ('', '000102030405060708090A0B0C0D0E0F', 'F7EE49AE7AA5B5E6645DB6B3966136F9', '52E48F5D19FE2D9869F0C4A4B3D2BE57'),
        ('', '000102030405060708090A0B0C0D0E0F1011121314151617', 'A1A50F822819D6E0A216784AC24AC84C', 'F75D6BC8B4DC8D66B836A2B08B32A636CC579E145D323BEB'),
        ('', '000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F', '09CA6C73F0B5C6C5FD587122D75F2AA3', 'F75D6BC8B4DC8D66B836A2B08B32A636CEC3C555037571709DA25E1BB0421A27'),
        ('', '000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F2021222324252627', '9DB0CDF880F73E3E10D4EB3217766688', 'F75D6BC8B4DC8D66B836A2B08B32A6369F1CD3C5228D79FD6C267F5F6AA7B231C7DFB9D59951AE9C'),
        ('0001020304050607', '0001020304050607', '8D059589EC3B6AC00CA31624BC3AF2C6', 'C636B3A868F429BB'),
        ('000102030405060708090A0B0C0D0E0F', '000102030405060708090A0B0C0D0E0F', '4DA4391BCAC39D278C7A3F1FD39041E6', '52E48F5D19FE2D9869F0C4A4B3D2BE57'),
        ('000102030405060708090A0B0C0D0E0F1011121314151617', '000102030405060708090A0B0C0D0E0F1011121314151617', '24B9AC3B9574D2202678E439D150F633', 'F75D6BC8B4DC8D66B836A2B08B32A636CC579E145D323BEB'),
        ('000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F', '000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F', '41A977C91D66F62C1E1FC30BC93823CA', 'F75D6BC8B4DC8D66B836A2B08B32A636CEC3C555037571709DA25E1BB0421A27'),
        ('000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F2021222324252627', '000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F2021222324252627', '65A92715A028ACD4AE6AFF4BFAA0D396', 'F75D6BC8B4DC8D66B836A2B08B32A6369F1CD3C5228D79FD6C267F5F6AA7B231C7DFB9D59951AE9C'),
               )

        # These nonce and key are part of test vector
        self.key = bytearray().fromhex('000102030405060708090A0B0C0D0E0F')
        self.nonce = bytearray().fromhex('000102030405060708090A0B0C0D0E0F')

    def test_pmac1_1(self):
        ocb = OCB(AES(128))
        ocb.setKey(bytearray(16))
        ocb.setNonce(bytearray(16))
        header = bytearray(list(range(30)))
        expected = bytearray([170, 167, 93, 215, 89, 168, 168, 248, 222, 127, 42, 231, 123, 50, 212, 230])
        out = ocb._pmac(header)
        self.assertEqual(out, expected)

    def test_pmac1_2(self):
        ocb = OCB(AES(128))
        ocb.setNonce(bytearray([32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47]))
        ocb.setKey(bytearray(list(range(16))))
        header = bytearray(list(range(90)))
        out = ocb._pmac(header)
        expected = bytearray([203, 23, 188, 81, 237, 161, 108, 134, 119, 64, 232, 75, 68, 126, 127, 187])
        self.assertEqual(out, expected)

    def test_xor_block(self):
        ocb = OCB(AES(128))
        i1 = bytearray([127, 128, 127, 128, 127, 128, 127, 200, 210, 220, 230, 240, 250, 251, 252, 255])
        i2 = bytearray([128, 128, 128, 128, 128, 128, 128, 89, 119, 101, 43, 17, 15, 12, 5, 1])
        out = ocb._xor_block(i1, i2)
        expected = bytearray([255, 0, 255, 0, 255, 0, 255, 145, 165, 185, 205, 225, 245, 247, 249, 254])
        self.assertEqual(out, expected)

    def test_times2_1(self):
        ocb = OCB(AES(128))
        i = bytearray([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15])
        expected = bytearray([0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30])
        out = ocb._times2(i)
        self.assertEqual(out, expected)

    def test_times2_2(self):
        ocb = OCB(AES(128))
        i = bytearray([127, 128, 127, 128, 127, 128, 127, 200, 210, 220, 230, 240, 250, 251, 252, 255])
        expected = bytearray([255, 0, 255, 0, 255, 0, 255, 145, 165, 185, 205, 225, 245, 247, 249, 254])
        out = ocb._times2(i)
        self.assertEqual(out, expected)

    def test_times3_1(self):
        ocb = OCB(AES(128))
        i = bytearray([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15])
        expected = bytearray([0, 3, 6, 5, 12, 15, 10, 9, 24, 27, 30, 29, 20, 23, 18, 17])
        out = ocb._times3(i)
        self.assertEqual(out, expected)

    def test_times3_2(self):
        ocb = OCB(AES(128))
        i = bytearray([127, 128, 127, 128, 127, 128, 127, 200, 210, 220, 230, 240, 250, 251, 252, 255])
        expected = bytearray([128, 128, 128, 128, 128, 128, 128, 89, 119, 101, 43, 17, 15, 12, 5, 1])
        out = ocb._times3(i)
        self.assertEqual(out, expected)

    def test_ocb(self):
        for key_len in (128, 192, 256):
            aes = AES(key_len)
            ocb = OCB(aes)
            ocb.setNonce(self.nonce)
            ocb.setKey(bytearray(list(range(key_len/8))))

            plaintext = bytearray('The Magic Words are Squeamish Ossifrage')
            header = bytearray('Recipient: john.doe@example.com')

            (tag, ciphertext) = ocb.encrypt(plaintext, header)

            # decryption
            aes = AES(key_len)
            ocb = OCB(aes)
            ocb.setNonce(self.nonce)
            ocb.setKey(bytearray(list(range(key_len/8))))

            (is_valid, plaintext2) = ocb.decrypt(header, ciphertext, tag)
            self.assertTrue(is_valid)
            self.assertEqual(plaintext2, plaintext)

    def test_vectors(self):
        for vec in self.vectors:
            (header, plaintext, expected_tag, expected_ciphertext) = vec

            # encryption
            aes = AES(128)
            ocb = OCB(aes)
            ocb.setNonce(self.nonce)
            ocb.setKey(self.key)

            (tag, ciphertext) = ocb.encrypt(bytearray().fromhex(plaintext), bytearray().fromhex(header))

            # decryption - use fresh objects
            aes = AES(128)
            ocb = OCB(aes)
            ocb.setNonce(self.nonce)
            ocb.setKey(self.key)

            (dec_valid, dec_plaintext) = ocb.decrypt(bytearray().fromhex(header), ciphertext, tag)

            # verify
            self.assertEqual(tag, bytearray().fromhex(expected_tag))
            self.assertEqual(ciphertext, bytearray().fromhex(expected_ciphertext))
            self.assertTrue(dec_valid)
            self.assertEqual(dec_plaintext, bytearray().fromhex(plaintext))

    def test_wrong(self):
        # Take one of the predefined ciphertext/tag pairs
        (header, plaintext, expected_tag, expected_ciphertext) = ('0001020304050607', '0001020304050607', '8D059589EC3B6AC00CA31624BC3AF2C6', 'C636B3A868F429BB')

        aes = AES(128)
        ocb = OCB(aes)
        ocb.setNonce(self.nonce)
        ocb.setKey(self.key)

        # Tamper with tag
        (dec_valid, dec_plaintext) = ocb.decrypt(bytearray().fromhex(header), bytearray().fromhex(expected_ciphertext), bytearray().fromhex(expected_tag.replace('0', '1')))
        self.assertFalse(dec_valid)

        # Tamper with ciphertext
        (dec_valid, dec_plaintext) = ocb.decrypt(bytearray().fromhex(header), bytearray().fromhex(expected_ciphertext.replace('3', '1')), bytearray().fromhex(expected_tag))
        self.assertFalse(dec_valid)

        # Tamper with header
        (dec_valid, dec_plaintext) = ocb.decrypt(bytearray().fromhex(header.replace('0', '1')), bytearray().fromhex(expected_ciphertext), bytearray().fromhex(expected_tag))
        self.assertFalse(dec_valid)

if __name__ == "__main__":
    unittest.main()
