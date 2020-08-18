# Vault101

This was an obfuscated APK flag checker. Strings were obfuscated, and classes/methods were obtained dynamically. To decrypt the strings, simply copy the decompiled string decoder and decrypt all of the strings. From the decrypted source, we can reverse it and find that an array is being decrypted to form a key. The key is used as IV and key in AES CBC to encrypt input and checked against the ciphertext. Extract key, ct, decrypt, win! See solve script for automated string decryption and flag.
