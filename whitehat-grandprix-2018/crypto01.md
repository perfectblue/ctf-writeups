ToPlayer - crypto01 writeup
===========================

```
./chatclient 43.224.35.245 3425

one of secret key:

id: manh

key: 0x7f6949db22eeada0 Can you get the secret?

material.grandprix.whitehatvn.com/crypto01
```

We are given the code for a chat bot and a chat client that communicate over a
custom encrypted protocol. The functionality is very simple, the client sends messages
from the user to the bot server and the bot server finds a response for the message
from its records file.

The bot server also has some special commands: "super" and "secret", that we will
talk about later.

At the beginning, the client asks for a user id and the user's secret key, and it generates
a encryption key using the secret key and the current timestamp. Then it uses the encryption
key to generate a stream cipher using A5/1 cryptosystem, and sends it to the server along with
the timestamp used for the genration of the key. The server uses the key for the user id and
generates its own timestamp to create another keystream for encrypting data sent back to the client.
Each timestamp is valid for 30 seconds after which the keystreams are re-generated.

The obvious vulnerability here is a known plaintext attack. The cipher is basically xor encryption,
and if we know the plaintext for a certain message sent, we can extract the keystream used and use it
to decode further messages until the timestamp expires.

Now, looking back at the two special commands:

```
    } else if (sInput == "super") {
      superMode = true;
      if (!a51Comm.send(std::string("Enter supper mode!"))) {
        // some error occured
        std::cerr << "Some error occured at send\n";
        return (1);
      }
      l.log("Enter super mode");
      getSuperSecretKey(superSecretKey, argv[3]);
      a51Comm = A51Comm(superSecretKey, COMM_TIMEOUT, fd, fd);
    } else if (sInput == "secret") {
      if (!superMode) {
        if (!a51Comm.send(std::string("You have not entered super mode!"))) {
          // some error occured
          std::cerr << "Some error occured at send\n";
          return (1);
        }
        l.log("Have not entered super mode!");
      } else {
        std::string data = "Secret: ";
        data += getSecretData(argv[4]);
        if (!a51Comm.send(data)) {
          // some error occured
          std::cerr << "Some error occured at send\n";
          return (1);
        }
        l.log("Sent secret");
      }
    } else {
```

It looks like we are trying to get the secret data which will be our flag, if we
try to do this naively using our chat client, we get some garbage data
when we try to print our secret and moreover it doesn't even match the expected length.

```
==============Set up communication===============
Your id: manh
Input your key: 0x7f6949db22eeada0
Your id is found. Enter encrypted mode!
super
sessionKey: 498181133
block1: 98da4a431d27c1a24cd4e817fece
timestamp: 1534857965
data-length: 18
partnerSessionKey: 498181133
block1: 98da4a431d27c1a24cd4e817fece
block1: f4c6c3e2a2dca6030c30579185c7
Enter supper mode!
secret
sessionKey: 498181133
block1: 98da4a431d27c1a24cd4e817fece
timestamp: 1534857966
data-length: 3
partnerSessionKey: 461928030
block1: be64e610e8e23bf8dbb4d9a47da4
Ȼ

```

The reason for this is that, when we enter the `super` command, the server switches to a
new secret key that we don't know about:

```
a51Comm = A51Comm(superSecretKey, COMM_TIMEOUT, fd, fd);
```

As the server generates a new encryption key using the new secret key but we use our personal
key, we cannot correctly encrypt the commands sent to the server or decrypt the data received.

Here, we can make use of the fixed responses to get the xor key that is used for communication.
If we send a string which is the same length as `How are you?` no matter what the content is,
the server almost always sends back the string `I'm a bot, I don't feel much of anything, how about you?`.
This being a very long response, we can get the first 56 bytes of the encryption key by XORing the
ciphertext returned with this plaintext. Once we do that, we can send our correctly encrypted `secret` command
and decode the returned secret data.

I made some changes to the chat client to print the ciphertext in hex encoded format and some extra debug
information for better understanding of the cipher. The final solve script is:

```
from pwn import *

#proc = process(["chat-client/chatclient", "0.0.0.0", "1234"])
proc = process(["chat-client/chatclient", "43.224.35.245", "3425"])

proc.sendline("manh")
proc.sendline("0x7f6949db22eeada0")
proc.recvuntil("encrypted mode!\n")

proc.sendline("super")
proc.recvuntil("finish-comms\n")

proc.sendline("How are you?")
proc.recvlines(4)
length = int(proc.recvline().strip().split()[1])
if length != 56:
    print("FAIL: Retry")
    exit()
proc.recvline()
my_key = ""
for i in range(4):
    my_key += proc.recvline().strip().split()[1]
recv = proc.recvline().strip()
recv_actl = xor(recv.decode('hex'), my_key.decode('hex'))
print recv.encode('hex')
known = "I'm a bot, I don't feel much of anything, how about you?"
key = xor(recv_actl, known)
for i in range(4):
    print key[14*i:14*(i+1)].encode('hex')

my_key = my_key.decode('hex')
proc.recvuntil("finish-comms\n")

proc.sendline(xor(xor('secret', my_key[0:6]), key[0:6]))
#proc.sendline("How are you?")
proc.recvuntil("partnerSessionKey: ")
proc.recvline()
fin = None
while True:
    fin = proc.recvline().strip()
    if not fin.startswith('block1'):
        break
print fin
fin = fin.decode('hex')

print xor(xor(fin, my_key), key)[:len(fin)]
```

Running this script, we get the output `Secret: WhiteHat{63638833b68d6668d67415a749ffff899e7c5c7��`.
Since we know the flag format is `WhiteHat{<some_sha1_hash>}`, we can calculate the length of the entire
expected secret which is 58. As our known key length is 56, the last two characters come out as garbage.
Since the last character is a `}`, we can submit all the 16 combinations to find the correct flag which is
`WhiteHat{63638833b68d6668d67415a749ffff899e7c5c75}`
