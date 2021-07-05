from pwn import *
import itertools
import string
import hashlib
import pykeepass
import shutil
import struct
import hashlib
import hmac
from construct import Container
from Crypto.Cipher import ChaCha20
from Crypto.Util.Padding import pad

# Signature + Version
header = b'\x03\xD9\xA2\x9A\x67\xFB\x4B\xB5\x00\x00\x04\x00'
# Cipher ID
header += b'\x02\x10\x00\x00\x00\xd6\x03\x8a+\x8boL\xb5\xa5$3\x9a1\xdb\xb5\x9a'
# Compression (No compression)
header += b'\x03\x04\x00\x00\x00\x00\x00\x00\x00'
# Master seed
header += b'\x04\x20\x00\x00\x00' + b'\x00' * 0x20
# Encryption IV
header += b'\x07\x08\x00\x00\x00' + b'\x00' * 0x8

# KDF parameters (important)
kdf_data = b'\x00\x01'
# UUID
kdf_data += b'\x42\x05\x00\x00\x00$UUID\x10\x00\x00\x00' + b'\xc9\xd9\xf3\x9ab\x8aD`\xbft\r\x08\xc1\x8aO\xea'
# Key
kdf_data += b'\x42\x01\x00\x00\x00S\x10\x00\x00\x00' + b'\x00' * 16
# Num of rounds (important)
kdf_data += b'\x05\x01\x00\x00\x00R\x08\x00\x00\x00' + b'\x00' * 8
kdf_data += b'\x00'

header += b'\x0b' + struct.pack('<I', len(kdf_data)) + kdf_data
print((b'\x0b' + struct.pack('<I', len(kdf_data)) + kdf_data).hex())

# End of header
header += b'\x00\x04\x00\x00\x00\x0D\x0A\x0D\x0A'

password = "rbtree"
password_composite = hashlib.sha256(password.encode('utf-8')).digest()
key_composite = hashlib.sha256(password_composite + b'').digest()
transformed_key = hashlib.sha256(key_composite).digest()

print(transformed_key)
master_key = hashlib.sha256(
    b'\x00' * 0x20 + # master seed
    transformed_key).digest()

sha256 = hashlib.sha256(header).digest()

cred_check = hmac.new(
    hashlib.sha512(
        b'\xff' * 8 +
        hashlib.sha512(
            b'\x00' * 0x20 + # Master seed
            transformed_key +
            b'\x01'
        ).digest()
    ).digest(),
    header,
    hashlib.sha256
).digest()

cipher = ChaCha20.new(key=master_key, nonce=b'\x00' * 0x8)

data = b'\x01\x04\x00\x00\x00' + b'\x00' * 4 + b'\x00' * 5 # InnerHeader
xml = b'<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n<KeePassFile>\n\t<Meta>\n\t\t<Generator>KeePassXC</Generator>\n\t\t<DatabaseName>Passwords</DatabaseName>\n\t\t<DatabaseNameChanged>246s1Q4AAAA=</DatabaseNameChanged>\n\t\t<DatabaseDescription/>\n\t\t<DatabaseDescriptionChanged>0o6s1Q4AAAA=</DatabaseDescriptionChanged>\n\t\t<DefaultUserName/>\n\t\t<DefaultUserNameChanged>0o6s1Q4AAAA=</DefaultUserNameChanged>\n\t\t<MaintenanceHistoryDays>365</MaintenanceHistoryDays>\n\t\t<Color/>\n\t\t<MasterKeyChanged>N4+s1Q4AAAA=</MasterKeyChanged>\n\t\t<MasterKeyChangeRec>-1</MasterKeyChangeRec>\n\t\t<MasterKeyChangeForce>-1</MasterKeyChangeForce>\n\t\t<MemoryProtection>\n\t\t\t<ProtectTitle>False</ProtectTitle>\n\t\t\t<ProtectUserName>False</ProtectUserName>\n\t\t\t<ProtectPassword>True</ProtectPassword>\n\t\t\t<ProtectURL>False</ProtectURL>\n\t\t\t<ProtectNotes>False</ProtectNotes>\n\t\t</MemoryProtection>\n\t\t<CustomIcons/>\n\t\t<RecycleBinEnabled>True</RecycleBinEnabled>\n\t\t<RecycleBinUUID>AAAAAAAAAAAAAAAAAAAAAA==</RecycleBinUUID>\n\t\t<RecycleBinChanged>0o6s1Q4AAAA=</RecycleBinChanged>\n\t\t<EntryTemplatesGroup>AAAAAAAAAAAAAAAAAAAAAA==</EntryTemplatesGroup>\n\t\t<EntryTemplatesGroupChanged>0o6s1Q4AAAA=</EntryTemplatesGroupChanged>\n\t\t<LastSelectedGroup>AAAAAAAAAAAAAAAAAAAAAA==</LastSelectedGroup>\n\t\t<LastTopVisibleGroup>AAAAAAAAAAAAAAAAAAAAAA==</LastTopVisibleGroup>\n\t\t<HistoryMaxItems>10</HistoryMaxItems>\n\t\t<HistoryMaxSize>6291456</HistoryMaxSize>\n\t\t<SettingsChanged>0o6s1Q4AAAA=</SettingsChanged>\n\t\t<CustomData>\n\t\t\t<Item>\n\t\t\t\t<Key>KPXC_DECRYPTION_TIME_PREFERENCE</Key>\n\t\t\t\t<Value>1000</Value>\n\t\t\t</Item>\n\t\t\t<Item>\n\t\t\t\t<Key>_LAST_MODIFIED</Key>\n\t\t\t\t<Value>Sun Jan 12 03:51:58 2020 GMT</Value>\n\t\t\t</Item>\n\t\t</CustomData>\n\t</Meta>\n\t<Root>\n\t\t<Group>\n\t\t\t<UUID>F69os494TDK6douojK65vQ==</UUID>\n\t\t\t<Name>Root</Name>\n\t\t\t<Notes/>\n\t\t\t<IconID>48</IconID>\n\t\t\t<Times>\n\t\t\t\t<LastModificationTime>0o6s1Q4AAAA=</LastModificationTime>\n\t\t\t\t<CreationTime>0o6s1Q4AAAA=</CreationTime>\n\t\t\t\t<LastAccessTime>0o6s1Q4AAAA=</LastAccessTime>\n\t\t\t\t<ExpiryTime>0o6s1Q4AAAA=</ExpiryTime>\n\t\t\t\t<Expires>False</Expires>\n\t\t\t\t<UsageCount>0</UsageCount>\n\t\t\t\t<LocationChanged>0o6s1Q4AAAA=</LocationChanged>\n\t\t\t</Times>\n\t\t\t<IsExpanded>True</IsExpanded>\n\t\t\t<DefaultAutoTypeSequence/>\n\t\t\t<EnableAutoType>null</EnableAutoType>\n\t\t\t<EnableSearching>null</EnableSearching>\n\t\t\t<LastTopVisibleEntry>AAAAAAAAAAAAAAAAAAAAAA==</LastTopVisibleEntry>\n\t\t</Group>\n\t\t<DeletedObjects/>\n\t</Root>\n</KeePassFile>\n'
data += xml
# data = pad(data, 16)
block_data = struct.pack("<I", len(data)) + cipher.encrypt(data)

block_checksum = hmac.new(
    hashlib.sha512(
        struct.pack('<Q', 0) +
        hashlib.sha512(
            b'\x00' * 0x20 +
            transformed_key + b'\x01'
        ).digest()
    ).digest(),
    struct.pack('<Q', 0) +
    struct.pack('<I', len(data)) +
    block_data[4:], hashlib.sha256
).digest()

empty_block_data = b'\x00' * 4

empty_block_checksum = hmac.new(
    hashlib.sha512(
        struct.pack('<Q', 1) +
        hashlib.sha512(
            b'\x00' * 0x20 +
            transformed_key + b'\x01'
        ).digest()
    ).digest(),
    struct.pack('<Q', 1) +
    struct.pack('<I', 0) +
    b'', hashlib.sha256
).digest()

with open('database_base.kdbx', 'wb') as f:
    f.write(header)
    f.write(sha256)
    f.write(cred_check)
    f.write(block_checksum)
    f.write(block_data)
    f.write(empty_block_checksum)
    f.write(empty_block_data)

with open('database_base.kdbx', 'rb') as f:
    data = f.read()

shutil.copy('database_base.kdbx', 'database1.kdbx')
db = pykeepass.PyKeePass("database1.kdbx", password)
db.add_entry(db.root_group, "a" * 20, "a" * 20, "flag{this_is_fake_flag}")
db.save()

shutil.copy('database_base.kdbx', 'database2.kdbx')
db = pykeepass.PyKeePass("database2.kdbx", password)
db.add_entry(db.root_group, "a" * 20, "a" * 20, "flag{this_is_fake_flag}")
db.add_binary(b"\xbb" * 1)
db.save()

# 1. Import empty database with Chacha20
# r = remote('111.186.59.1', 10001)
# r.recvuntil('+')
# suffix = r.recv(16)
# r.recvuntil(' == ')
# digest = r.recv(64).decode()

# print(suffix, digest)

# for x in itertools.product(string.ascii_letters+string.digits, repeat=4):
#     if hashlib.sha256(''.join(x).encode() + suffix).hexdigest() == digest:
#         print(x)
#         r.sendlineafter('XXXX:', ''.join(x))
#         break

# r.sendlineafter('master password: ', 'rbtree')
# r.sendlineafter('(y/N)', 'y')
# r.sendlineafter('size: ', str(len(data)))
# r.sendlineafter('blob(hex): ', data.hex())

# r.interactive()

# exit(0)

# 2. get two streams!
# import time
# r1, r2 = remote('111.186.59.1', 10001), remote('111.186.59.1', 10001)
# r1.recvuntil('+')
# suffix1 = r1.recv(16)
# r1.recvuntil(' == ')
# digest1 = r1.recv(64).decode()

# r2.recvuntil('+')
# suffix2 = r2.recv(16)
# r2.recvuntil(' == ')
# digest2 = r2.recv(64).decode()

# ans1, ans2 = None, None

# for x in itertools.product(string.ascii_letters+string.digits, repeat=4):
#     if hashlib.sha256(''.join(x).encode() + suffix1).hexdigest() == digest1:
#         ans1 = ''.join(x)
#     if hashlib.sha256(''.join(x).encode() + suffix2).hexdigest() == digest2:
#         ans2 = ''.join(x)
    
#     if ans1 and ans2:
#         print(ans1, ans2)
#         r1.sendlineafter('XXXX:', ans1)
#         r2.sendlineafter('XXXX:', ans2)
#         break

# r1.sendlineafter('master password: ', 'rbtree')
# r2.sendlineafter('master password: ', 'rbtree')

# r1.sendlineafter('>', 'gimme_flag')
# time.sleep(0.5)
# r2.sendlineafter('>', 'leave')
# r2.sendlineafter('(y/N) ', 'y')
# print(r2.recvuntil('\n')) # Stream 1

# r1.sendlineafter('>', 'add_binary')
# r1.sendlineafter('size: ', '1')
# r1.sendlineafter('blob(hex): ', 'aa')
# r1.sendlineafter('>', 'leave')
# r1.sendlineafter('(y/N) ', 'y')
# print(r1.recvuntil('\n')) # Stream 2

# exit(0)

# 3. XOR the stream!!!

stream1 = bytes.fromhex('03d9a29a67fb4bb5000004000210000000d6038a2b8b6f4cb5a524339a31dbb59a03040000000000000004200000000000000000000000000000000000000000000000000000000000000000000000070800000000000000000000000b4d00000000014205000000245555494410000000c9d9f39a628a4460bf740d08c18a4fea42010000005310000000000000000000000000000000000000000501000000520800000000000000000000000000040000000d0a0d0a32883b363253b7367054ebceef9d276ec3ab7379ededdd071db193c30efb2b796be1b7daa50c1314787121a101a133cbf21a953587932e31c107f81a788eb659195855114f76af6bc58568ea7499f9c10afa0b1acc729fd331032bdecfc72d19110b00009fd2d61e395d14999ce0d8e4cfa20cdd7cb1729a26195e814185b09c1a2db19bd8d89a3ec69dd0d11b667e701ac822c4bcf02c2f4be0a4b90b1dbd0037c2083ea5cc2799cb8247004cd5d638c42415b5c819d92bcf3f04f0a95b1b7688d1a0bbca3ee1e0228cbb1a2dfaed5387bb42952a7b727a31600170a66c919c98fa1f2a935be0404b632708c1a0b8996b0ff5a4b5407edbdfc54972dc49c28c36e0a4190c681218c8b6128a09decf5b095e3c9181309fe4b2528d3fa488b131c7574a0f42643013efd4c12ae4c22a3fd20f0799b12df0d60c277a52585a3caa9f14b049a9656cf78b548d0dc5ee6c108dcce7c3dcf8bcf8ce2d6940fd04593afb907c5e0fdb9a7d231b1e801601bc9d6bff09f5e66a8e40173d58ed6ab3bb323e7ec0c8cc09b8409e49b4ec07f6683e079b9c48e34713760e8064ae14b493da0f1822b388bbe59b83fda8b3cb6a997f3af55b35c69af37c373a8959bea6f9b1560b0c0faffdd638b9b436daa388c7346c246e58956f7b5e516c9c5c4996f05eae3adf8cf7d70de74caae86930d0346b46fd99f5fc2a865b5a46327ae83bd71589314c4853814cbe517a6fdaeef0b55a24e93016e0b70e26b4065b290af59ce2be337bcb97981f32e06cf0b43b074ae108660d1ec903834d2d484317af6ef0a15a8467884b241e3ee8a74c250d6840ba992682e5910af3c1fc6cfd3787fd951d7a2cd28e1109d0e93672f3f80c25608801b1bef3811bfe7eebd8f388b03ede2b057cda395b8825e587b204c19289be6601ac100e4f5626fcd0d775fcf4628ec6e2796421f35e699ac72ea1946a7f2c72dcb0233394b5cacfcfc49c2918b28b984f5eb2caba06cca4f3a0aa38741c439ce121fb28ad854a56226cd4cd0adaed9a7befa5521a619840e43e6d5d74ca3100f9863390ee8cda412463176e7e8b14f9248f92c0fe426cea4338ebe4599cf607aff3facd95b7223f7ddb4ba5eaba382235817efd1e6963af8e40e38978937d289301c6a35fd9520fceeb8c2ae38118fad6b99ab188ad9df89c34fcbad2797175fa1c0ecdd59b368410226bc21926c40ce872bfcb2e4679b487f41513b2da9457008d1fa1e9d5d36a8dfe3e62c44952e5ff81da574835948fd7ce0d99ec2e772966927d72c027ee468ed6c7a10b0b981cfc5769d63fdfd27363004be0cae24da501019a6855f714e1bf5c37eb620eb0834000418c9a285104e0abde055591f96e0e1de896182c5934d70884dda1c349ea065979db8a3dfe2bf4ce40cc7cefe4f3356a2e2b25719c9be2da53b31ddb16453c4f8344595591ba7476fb702893aee71dc7d29cc01b7978d4e263e5f74b1e9145cf9ba0a17d4dc8aa05fdc20aa8fd41c45701096975979d276edf28df7b371f2a78873b0b06bc96350701052429ee7837f71ac8db738c18556ca8f76678dfc29502547bd8dee95cac812227aa23b6fdb41da6a5818b8663467a5478e640a0fb6f21592a52d12de624aa79a074c6ee3219a581ede968a1eb709dc5670e69316d24db936af6d6c0139291275cd780ac019ea2d0e2ecd62d3a93bbeecc7fc85d01446aaf5f6604fa81e264e5c4d56b79d0634f16c6e1eeb10f8d7bbd369e3e4e90f61e7766357b26eac4c57626f82e7252599e8356f7787f421db6202eeb0aff84de5bcd3056143fdeaadb1b2fe719b37cbfecc411060328d1deb1b8494346de81edf6d16e07a1b34a32cc0f83dd5cb102437bb1ac90a0aca07462b1bbc9fb4a7187ca2fa68758822fd75314916cba0a8d45ef72e62eb1cdc3fa9bda30b8ac79ac0599310dd281429fac637a3a23d3f76a5adbed00099f6709331156c3649b259617aedc2ee3249dd9d8a4e86b4225126e14146e8bf16fdaea1f8199fff3394192924c8e3db3c6438a75e790da4a10516cbf0d97d1a7f8a9083edbb901e7588dda5d053cf0f9c487299e26135f23b3ecf4537ba58e44fb055599be2f3c9d94dd13ce49eeb97a5dc87bdabeb7c39a814069976c636c4137e8f5478f8dd31edb2ccee9747d51292d665b1e27dec920b08d572cbb24ff14fdd3d66a66c734e9c0386406b1cd3f77bc5d6bfb98dab3f7fbc207e3d5935729e2d5c9b28e74c68a9ffa1ed2411c742252c0ec3bccf8b5c2207eca57b8e1068f10935cc1dca1910e0a2d0f91e5f5e6a5f036c7ff2e1e8413c116e68907c51ea6862461f4a0c434a7ea5623d42e402c56686de8c300141918571c6fbf4213d052c81145debc3429501db390aff1b71a9c17fa2c761a886f412e4ded630d2bfe5cef0388efe556ef9f99b4dbd26921ee42309377b12be32045fe8fb171c4143b2ff6a6e900353cd8e01cad07de66dc5b7521aeeb6aa476eaef21e26ea97d8918bba9b8ea29f26c4a290bec9b74e2c473070bb9b55929cc7020d759de0349b4d614e11a19d4ca3ed23bf8941c558909cff1006a2c688b9568bbfda84eefc80fd18a8a73aaebc35f7502bea79cc9c5fd72d0c26ea40fee2b27f9e9d9c9bf1e5648421ac774ebe0ee67fe6b052f7aa79e06ca36998c41ac1698dce66621c36f300919a0417bb33009034747dc480ff4e3ef58a825e0c11ccb37e534b42026cf63eaf631afec9d614c29b64031a1b91a3b680241e5be8e25227ce7249eecd439e9fc021a8d6e428923c8b7513f3d82cf3faca72937ff4b14641c77a9c331e36783b70fe4dd520cb400521a86b5525957e63686ae20e1102ee221860e1a3bd39cce94565b4787a326605177074e2b4978bb84c07d10e6cdc0fe6437d1618e8071cb6b270c15d84f7c2c47ce9d428df727b5b1485c37ab3e6f3054f23a7652849afaeae3a379fe87cf4fa99d32c8c9079d26370bece0ce2cbee4de4f440255d43cee7ad80932d7f1ba1dd78245e77448a5161461e9d191d3a6242fb541a4c3235e5cd9a79ce9d6128f7a69e0b2f1ff30a2c6c5dcfa8d0b7bbefd58cf73c0e20ee10be844b6e605b4a0d0f00728242fa341fc13cfcb1ef9162dbd54ccd1195377b5ee7fe8feb90a00334ac568517b6732b29b9092df8a16ec99bb7a9a6516c925f9a649fd196198b715fa1d66088c57b05947457680b2ba11e008506df920c06708329409425bc3ed3ee4a92a2fa0788b47b102c50b939ad103225574c3950cf8a5d40fafb8be056e0ae30ce5f2d9314d65b45fa273fb23bf264159679167072210490c1c66bd066c603fa68d5cb1b3a6e7283d1c09e6e6795a21206b8a422656b86de8ba5c8b7c35dc818ab722e9d755144136105665e583d44b251a42ef8e9f9d76828ac493f21adb6cc7f2217211032308be7c02126784a725ab91b0c61049e6297a35234fe753d6cf81567c8a0578736473d912c8d82c408042d9032236d97e9de22ab12fd5fa3f6f3b4b907f28863e12eb8c1b52c5954a979f6ca6ad533a320919c35772e17c37369c6fa9dc09eef1c201b8bab8b00ab029e58adbdef51264f864331fc85f92d84243279a66e6875af6f30c177aa83d0a769d24690ab85b8f705565d2cc1cc4135c51b93a0ccd4fec0cb6e8d8d200e2a7f1463733e70183388037194c019c1507c41ee9c7ad3955aecc0e83debf8b1c320c79139af3cb81bf25648e72f849078fb909598b4936fd593567275a0465d685b15a04a6023b245cd91e1f9eb31f7839af7fb31fe73bf2e4fb09dc30cd6dd42a1866d4df8f115cc795b057a951e17eba39bb6ae568cee2c7a336d50aad26f892ce3c7a0ec5ccf99f36959d0dc8d9726f44a2199113ee3b8ab307ee5a3f3de413d0c41f72fe6aea26d71f0c23f72802c6558345ec7b39fceb25165fb5bf6f63608c8048e2b1a34d249756de6ea98fbcd238e10f07869dafe47c01e005bcbb76c813a72cc399e2a4a5e0d53cea2e1b7f697f0eff46ed9d23fa3ea5bf068212ee6e82f313a8ed482742e5e4450de9dd37473cd690005c198a77cee767960f79cfe550a051ab85de7912f3ca45c38cc34d03e040e9f31c67cd5210212495d2da38e857f6b595e5515dc819838abb33f076a243ebf5933c2556c24f319598956a5c5d70f08d78e80400a4b9027700000000')
stream2 = bytes.fromhex('03d9a29a67fb4bb5000004000210000000d6038a2b8b6f4cb5a524339a31dbb59a03040000000000000004200000000000000000000000000000000000000000000000000000000000000000000000070800000000000000000000000b4d00000000014205000000245555494410000000c9d9f39a628a4460bf740d08c18a4fea42010000005310000000000000000000000000000000000000000501000000520800000000000000000000000000040000000d0a0d0a32883b363253b7367054ebceef9d276ec3ab7379ededdd071db193c30efb2b796be1b7daa50c1314787121a101a133cbf21a953587932e31c107f81a788eb659eb205146303b82801959d548c6e097c2c415f8bd7b328f04c9dc99a4a43e410f180b00009dd4d61e395cbe9898e0d8e4cfa2309619d422fb5556538d48b0efd3240eac9683dae116cd8cc38e534e692034df26e0b2f1613c6db9db9f1d0080316a992029f5951199cb8c575f03f4f92dc8234a96cc24cb31c57330e2e60728788ed4b1e6961fcef52e8be4550cd5f85f80e40db4056e7e7d137b0550a06490e1c2af473ec76eea333e141504acbbbdb95e2faaf9e96151ced3c26b69d869c484379df03c037b161e97f933af18ccce48134b0c9d9d3dc2b3fe628524abc5ee7ee6725b1d43772a06dfd8dd27d5c33b25dc050de4e923a8c258127023762d0ea6f20fb5699c4533aad775a81cd7ef7f0a98fcebdfd1c9bde9d423634a80507c31fa946d0c47ca8c7e30201399265de7d361fb02f1bc38c651013e4bd667aa8b02336de0cec408c5189011a0b832fc191070a99025f84237512ec834f505a290c934153b83b8b6f6bb85f5a9ce9f46967131e50067ea95f9770b36944cbfb7e5bd5e010b5eeeb2a765ef8a6980fbc99e75402b6453a963664b507d8050419cf70fe000f481e1d61ce53388e575369a781c6ee5a9e9f836aa5b473b142fad2f8320833e3922618d21a55d5a5defb6bed1723cd92c12fc9b0e3bc95277261ee49daec91b63fb8b9c031ee047d6bf64441cb8754e0f539057cd290550730bab72dca171a26cd7190e1a1ff9a10052257070a69d3aaee5ae26e9c3f735b540d4a0bb19377586c07521c8d92a76efd40c1a4c9203bae7aa8a11e172fc9f9fb7ba27d43a0845c73811d116e381a90f9cda8da57d19ac4d3c7a5321f589c663eff7658e99b97d7f3aeb5e34d2c335ba8c6a226477ddba251896acfa82ecd7be3b10eb9a8e5c5db5cae55dc9a5f9a6813a6d2c0ec5c31df531add802563170d3df06dcd9c55ceea758542af666f93f6d022fca221cfe943f96dad395622163116f23c311d907c5b1c2e6645b9a522ef8e75e9ca95caad3d987cc8424055bf216edf4a7233323dc4cd21d6e63e09f56f08a7f9322738d1cddb249841a6eecfa8436afc467c5dca090a0859480f9d66ddcbbc86270268f3c14d0d2db65f1212866c855749d1ce47f83c6234157b88d8f2f00a5d3cd1c6cbc0eadef85997a81f3026fc94e7ce9f5fa88644f3a888885971d95e102410c47ee555dd433e643f1d6c7a10b0b981cfc5769d63fdfd2731f7c368ed9c66fe15f51d07859fa38d79a7d4bbe5e3e86b36752189c96256b0feda0fb095feca1605609bca3125d7743e504e9c6b2e76bd2580933cb8630c420f9c565c07692b0d7357939364f28b485fac95e820bf11446284bd8765f66bf8e4509fb702893aee71dc7d29cc01b7978d49e1f98994f31a40a8bf3ea896355dba734ebe808abe9459f18031572729ef77e46c130cc760609007a842f0f20a7b0290f11115971e02023a32fc2aa5dfb2a5901b3f3494dec86fd487c65c0cde46dbaab2024be2790e69201aeb595f6d24e496e454fbd1089f968306e084cdb3be27f8f7f935af2df4d19a581ede968a1eb709dc5670e69311158a6fd67d6e4897dcbd20e5ed0919b2380a8c6e6b78e26298fbaca9d33d25501595cac4a771fe69df036c1c2e6454de11c4f16c6e1eeb10f8d7bbd369e3e4e908a620a08385b14a3ad96293cf02e6f645a8b924deb646d1044b93b32ea15b3c1db53c60d4d032be0f5926267ad3ca931fab38a47030b23ecc5a6ac771c02df9cfbefcd2242a4bb4115ca079fae0bfb681b35e1a49abdddf83323e8f59ffe427aa0cc27baf405a919ca5d18c1379a2c9150e87be439cc95cda28f8e05b2dd57db37955c16c0a577aaf831321a05cfe26d53d9fa7d5dbd7c1d221a05bb469a37dc448aec2afa7b9faef4a9b34d2c411a54296f6689f07cd1e7158c94f2ea204d828c419f32bbd1599464e7eab053306611c667d9f6b7e4a905588ae548ad30dd8618503ee380ec9f39962613391ea2e4a7510c89831fc97728818f094f8d9cd506d353e7ca115feb4ba1c6dd8dbd915c69f84f6c207e33b88603d38da94c8f39cee1617542212865510b58b3af2cadeb16078315fd0784fbce7a6ec734e9ca39721fe09c5455bd4f21a8dad3b7f7fbc2079ef7995776e0aee9b29470c68a8ddd38e30f647e4e68fa9c3cbe9ac8e6652e9c1683cf068f418a78938bd6886e29357692e594d29ddc4cabac0f0bd559b125e4834dc57f87932c77e5a2b612b0e04b45ae2c3d7705296dcf925a656109222b69bc6e24d052d0195bcf826571751aa98783eaba1c942af020674dd76e233411d9697c05896ee36e93e2c564daefcafffed57336c2593d957f8c21ef3112ada2977dc8056c7cdb80e50c246b87e17eb75bea6cad750213a28671a645cecf68b72e845b8514aafeebc81ce8756e7454c58974c2ec7d0150faa93b3390442aa677a93145d9cd19c1282ca89572fb29f8b4345b8f5280c72c73287fccfd44aee8ff0cf9aa158dbe8002849cf1531819ba9eade18ab809fcd77bf341d2073efdfe8286c420474d431a8865e8f9f27de93259543e828415c820e4df61b103c189992601de7a695c66e06166a669500c4751d34858a7c1c353a83feecb16b66feb6ca07413c512c48103a381866c620b960964e19b363068184fefb4f3716c46e92c9fa1d62af4e62a078e3110a435e9f1752c26839674db801e3aea1655490a56ef8f14e86587a65dacd8421eba21471ea293434776fa2880986aae590ee223814d4146e386c0a2434e63ccb93c58443b4d352b5d76bbddae4d0ae8fbd5eb407c994bb49863c230482c1acb4e78207accc25e9bf322e7f9335c23a53e364c74fd29775688a7f8b5ad8c70e49dfc1ee5873ac8d4319e33240cebfbd57e9ae0f17a773a2ad43cee7ad80932d7f1ba1dd78245e70834d8781941db98f880f93e27b55c92c0364d5bdebc87bb8f128f7a69e0b2f1ef0b9ff082acfeb168678eba7bb27f83832eef2cee53819710828daebf7942303b8d38ff13b4f726d5212dbd43d7d91d5420e6c359e4f2a85d043027d63775714d1ecaa09fefc48825c8b9f22fda4830c529e8f11adf2c7b819f44a23861129b7bab54414d4b8abeab46e40b3d7ea604ca4d244aaf063f40cecd0cd1d97964857f91509d19c80d9ba7db0f330227e1a016e181895086aabe254604e557fdecb4221241be758e0bc02cc23d4c7955a41b586e395b0c3c4eb300372f098a9458a6f4cecb3d284b10f28b6a05052a41a63a1d59c576ec836da33370a7ad9fa275a7eb790d45214b191edb92d14a255553ec97838761dbd6bfd7d700c86ed18f72520c167a5dc13c220f72ddf25aebb1add34910e9296c3a2318b471fac4814c72800f05706824c445edd2066cf879d67e393bf75cbdab7ff10df9f13f7535419a027cc8041ce38d5650d69257889371ffaf3c05251949f0003ac67c72278363a48e5084bfe511a4bae28a0abb60afe2dcdee11066eb1d0107cf53c283532c009c7de18e03f49c33006af80f472fa40f71598814c5497e7d8195768a344c4db93635dc50a546deb9dbd716e0b488742f34eb51d829ef101f5706954c05ab21fed7fd0e0ae1f41c95928bd6400a1e6f5fc29985a6af397ae256f6511789ed3c4fd91f07ec583521241e3c76c49bf2103da6261d2c49f2381caead596409a321a21fa723f9f0be5edc3c8d7cc701780a9e8bd52a55cbd1eb00e847e4609b60e65b9c5cfb8fa9eb058756a42188e2c3243416c7df80ad2e92915d93c81d5a43bf18a254a21fc1fb2dd4422d34bf4babfe0c65f733a15ded0c1b2aae63799470805de84b75a1c137045b93826c6b6699865bd9baaa5669c40b8543a795e3b676af2515949989d97f09e610baa84dc31abc619cbcf3ababfb8774fd2e0c6b797d19c91dd28728f161efc52d8b1dfe3ed9e413bff9582555d3bf0857cdc6204d5693cf241751ca66d9e370d10d6aa5cc56bd5de587cd7a05f0da4198d4c84a05e057f8e47c3b9b18213a38ced2da38f15dfc91caaa0d50c410b6d5433c89f499b26bbb33f076a243ebf5933c2556c24f319598956a5c5d70f08d78e80400a4b9027700000000')

# for i in range(len(stream1)):
for i in range(2844 - 10, 2844 + 20):
    # t = b"flag{"
    # wow = b''
    # for j in range(len(t)):
    #     if i + j >= len(stream1):
    #         break
    #     wow += bytes([stream1[i + j] ^ stream2[i + j] ^ t[j]])
    
    # print(i, wow) # Printed 2844

    flag = list(b'">flag{')
    for j in range(100):
        if i + j >= len(stream1):
            break
        
        flag.append(stream2[i + j] ^ stream1[i + j] ^ flag[j])
    
    flag = bytes(flag)
    print(i, flag)
    # if b'}' in flag:
    #     print(i, flag)

