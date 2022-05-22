# Leggo my Stego

We discovered MD5 hash embedded in 9 of the images using our advanced steganography skills, whereas we found a plaintext in `oahu` image. Using md5decrypt.net, we were able to decrypt most of the hashes.

```
boston:4aada52c9abb92d32c57007091f35bc8:beanpot
chicago:a6ec1dcd107fc4b5373003db4ed901f3:deepdish
la:ae7a2a6b7b583aa9cee67bd13edb211e:cityofangels
miami:1312798c840210cd7d18cf7d1ff64a40:springbreak
ny:e115d6633cdecdad8c5c84ee8d784a55:fuhgeddaboudit
oahu:Use the command mnemonic that outputs moon.png
portland:20b7542ea7e35bf58e9c2091e370a77d:stayweird
sf:f24b6a952d3f0a8f724e3c70de2e250c:housingmarket
slc:09e829c63aff7b72cb849a92bf7e7b48:skiparadise
vegas:7cef397dfa73de3dfedb7e537ed8bf03:letsgolasvegas
```

After reading documentation for a while, we figured that to download a file from the satellite, we can use the `PLAYBACK_FILE` command, which essentially answers the `Use the command mnemonic that outputs moon.png`.

After connecting to the service, we sent our ticket and `PLAYBACK_FILE` command and thereafter the server presented us with a challenge-response with SHA256 hash. 

We took sha256sum of all the images and figured

```
6bc6fbee628c3278ef534fd22700ea4017914c2214aa86447805f858d9b8ad4  boston.jpg
04ca7d835e92ae1e4b6abc44fa2f78f6490e0058427fcb0580dbdcf7b15bbb55  chicago.jpg
242f693263d0bcc3dd3d710409c22673e5b6a58c1a1d16ed2e278a8d844d7b0b  la.jpg
2aa0736e657a05244e0f8a1c10c4492dde39907c032dba9f3527b49873f1d534  miami.jpg
983b1cc802ff33ab1ceae992591f55244538a509cd58f59ceee4f73b6a17b182  nyc.jpg
7e03349fe5fa4f9e56642e6787a0bfda27fb4f647e3c283faaf7bd91dbfd1d39  oahu.jpg
b4447c4b264b52674e9e1c8113e5f29b5adf3ee4024ccae134c2d12e1b158737  portland.jpg
f37e36824f6154287818e6fde8a4e3ca56c6fea26133aba28198fe4a5b67e1a1  sf.jpg
```

So, the challenge asked by the server was requesting for the answer which was the md5 decrypted string we cracked earlier. We tried against the server and it worked.

```
Ticket please:
ticket{sorry_our_ticket_is_private_use_yours_instead}
Can you regain control!
CMD>PLAYBACK_FILE
b4447c4b264b52674e9e1c8113e5f29b5adf3ee4024ccae134c2d12e1b158737?
>>stayweird
Thank you
983b1cc802ff33ab1ceae992591f55244538a509cd58f59ceee4f73b6a17b182?
```

The server thereafter asked multiple such questions for all the images and we wrote a script to quickly submit an answer before the timeout strikes. Eventually we were blessed with the flag 

```
flag{foxtrot962415papa3:GA-a3GIFSYvZ9Y6awZ6GybqsOzTNJIxVFU_2goQbSl_Vz03fUQuFLySr2h0hgpkq5q7JzRccqRD1Cre-P3FbH5A}
```
