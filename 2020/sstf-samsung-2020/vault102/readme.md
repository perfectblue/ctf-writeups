# Vault102

The flag checker is implemented in a native library. Looking at the xmmwords, we find that user input is being decrypted using Salsa20. The key is being derived from hardcoded values and a few xor routines. At the end, a weird strcmp is implemented with xmmword xors and such. Extract ciphertext, and compute the key to get the flag. See solve script for fetching ciphertext and key.
