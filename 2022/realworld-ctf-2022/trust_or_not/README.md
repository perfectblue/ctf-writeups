# Trust or Not

*a gentle introduction to trustzone*

Category: Rev

Solves: 7

Solve by: cts and theKidOfArcrania

Points: 357

---

i've been awake for way too long, so you get to enjoy my shitty lowercase word soup English in this writeup.

# challenge description

> We have lost some of our files and cannot retrieve the plaintext data originally stored.
> 
> Hint: flag file is stored in /data/tee/2 securely.
> 
> nc 47.242.114.24 7788
> 
> <attachment>

they give us a qemu vm and some random firmware files to go with it, and a run.sh.

```
QEMU_VIRTFS_AUTOMOUNT=y qemu-system-aarch64 \
  -nographic \
  -smp 2 \
  -machine virt,secure=on,gic-version=3,virtualization=false \
  -cpu cortex-a57 \
  -d unimp -semihosting-config enable=on,target=native \
  -m 1024 \
  -bios bl1.bin \
  -initrd rootfs.cpio.gz \
  -kernel Image -no-acpi \
  -append console="ttyAMA0,38400 keep_bootcon root=/dev/vda2  -object rng-random,filename=/dev/urandom,id=rng0 -device virtio-rng-pci,rng=rng0,max-bytes=1024,period=1000" \
  -no-reboot \
  -monitor null \
```

important aspect to note

 - `-machine virt,secure=on,gic-version=3,virtualization=false` <-- Enabled the EL3 (some TrustZone shit) and disabled the EL2 (visors)
 - `-bios bl1.bin` <-- Specify the custom bios.
 - `-object rng-random,filename=/dev/urandom,id=rng0 -device virtio-rng-pci,rng=rng0,max-bytes=1024,period=1000` <-- Specify a rng device for guest, why would we want this? Kind of scary.
 - `-monitor null` <-- Unfortunately, the author disabled the builtin qemu monitor so that we cannot cheese the challenge. This is really sad because now I will have to actually solve the challenge properly. Please remember to leave the monitor on in your future challenges everyone!

# whats going on in this bios shit?

First of all, the remote is identical to the local, so fuck the remote lol. It also means we can solve fully statically. And we can apply violence to solve any problems we encounter. Which is encouraging.

1. There's boot chain bl1 -> bl2 -> bl3 -> ... it's documented on [arm's website](https://chromium.googlesource.com/external/github.com/ARM-software/arm-trusted-firmware/+/v0.4-rc1/docs/firmware-design.md)

bl1, bl2 are just vendor firmware shit from arm, safe to ignore it lol

bl32_extra1 is optee kernel that run in tRuStzone. Trustzone is like arm's secure enclave shit. Kinda like intel SGX I think. I believe some big shit media companies like Netflix or Widevine use this form their DRM and whatnot. Sometimes when some oem's trustzone gets compromised, then they either have to let the scene/tracker people do the rips. Or they have to blacklist all those devices. Imagine that lol. Sorry buddy but you cannot watch the stream at the highest resolution. Because your trustzone is not TRUSTED enough. Heaven forbid we would not want you to STEAL the BYTES or even SHARE IT with your internet friends. get owned noob.

OpTEE (TEE = trusted execution environment) is basically a kernel that serves as a platform for writing sEcUrE applications in TrUsTzone. I think this is at EL3, but it's at "SEL1" secure el1. so in its code it think it's in EL1. a little bit confusing to me, but whatever. Oh also if you are new to ARM. EL0 = usermode, EL1 = kernel, EL2 = visor haha, EL3 = the mother fucking TRUST zone.

bl33.bin is just your typical edk tianocore uefi shit. it's also safe to ignore. since thankfully there's no uefi bullshit in this challenge. I think that's a good thing because I am not an operating systems developer. I am just a humble copy paster. so i'm way too dense to mess with that black magic nonsense. You could go as far as to say that I do not in fact fuck with tianocore. on god frfr.

# what is going on in the root filesystem?

in rootfs, there are basically only two interesting files.

There is `lib\optee_armtz/f4e750bb-1437-4fbf-8785-8d3580c34994.ta`, which I will explain later.

More importantly, the only file with newer modified timestamp (very important CTF cheesing strategy) is `data/tee/2`. that's where optee store encrypted blobs for its "secure object" storage api. it's some hash tree shit. The way the hash tree is setup is there's a bunch of encrypted blobs in `data/tee` and a encrypted directory node `dirf.db` as well. But we're only give the blob `2`, but with no directory node `dirf.db`.

The flag is stored in this encrypted blob. The problem is how do we decrypt it, or get optee to read it out.

# what is ta?

As promised earlier, now i will explain this file `lib\optee_armtz/f4e750bb-1437-4fbf-8785-8d3580c34994.ta`

That's the trusted application, or TA. It is basically an ELF with a signature header on top. this shit is a user mode program that runs in Secure EL0 (so like usermode) but in the "secure world". The secure world is basically like a secure enclave. **So the application that works with the encrypted blobs that we want to read is running in the secure enclave.** Obviously for us that is a fake news since we know the local is identical to remote, and the whole shit is in a qemu so we can always apply violence to get around problems if needed.

All the ta in optee is identified by uuid. On the host, you make request to optee, with the uuid of the ta you wanna talk to, and then the optee os (in the secure world) will service that request by dispatch to the appropriate ta. The ta basically is like daemon. You open a session to a ta, this spawn the TA task in the secure kernel, then each request call the entrypoint of the TA, then when you close, the TA goes away.

If you google the uuid, `f4e750bb-1437-4fbf-8785-8d3580c34994`,  you can tell they just copy pasted one of the online examples for optee. On how to use the secure storage api. And in ida pro its basically the exact same shit they just commented out the functionality to read back the shit.

# how is that shit encrypted?

Ok, so let's do a bit of digging and [read their docs](https://github.com/ForgeRock/optee-os/blob/master/documentation/secure_storage.md) on the secure object api.

ok tldr, it's basically like. You know the secure enclave in your smartphone. And how all the shit is designed around those enclaves. Like how all the phones have a device key that's burned into it at the factory. And then it's gonna do some fancy crypto deriving a bunch of shit from those device keys. Oh and the device key never leaves the enclave. And that's very secure and whatnot. So this optee secure object shit is basically like that but in trustzone. If you have no idea what i just said I recommend that you read apple's [200 page pdf](https://manuals.info.apple.com/MANUALS/1000/MA1902/en_US/apple-platform-security-guide.pdf) about how iphones are very secure. Great bedtime story for the whole family.

ANYWAYS HOWEVER. this is a ctf, so we need to find a meme right away. No way i am going to do Real Cryptography or anything like that. You are not going to make me use my brain. You overestimate me. I will do whatever is within my willpower to avoid thinking. Hell no.

> Secure Storage Key (SSK)
> 
> SSK is a per-device key and is generated and stored in secure memory when OP-TEE is booting. SSK is used to derive the TA Storage Key (TSK).
> 
> SSK is derived by:
>
> SSK = HMACSHA256 (HUK, Chip ID || "static string")
> The functions to get Hardware Unique Key (HUK) and chip ID depend on platform implementation.

platform specific hwid?. but its qemu right? so its got to be a meme, how can there be a chip id when it's all virtual? There is no factory or fuses or whatever.

> Important caveats
> 
> Currently no OP-TEE platform is able to support retrieval of the Hardware Unique Key or Chip ID required for secure operation.
> 
> For all platforms, a constant key is used, resulting in no protection against decryption, or Secure Storage duplication to other devices.
> 
> This is because information about how to retrieve key data from the SoC is considered sensitive by the vendors and it is not freely available.
> 
> In OP-TEE, there are apis for reading the keys generically from "One-Time Programmable" memory, or OTP. But there are no existing platform implementations.
> 
> To allow Secure Storage to operate securely on your platform, you must define implementations in your platform code for:
> 
>  `void tee_otp_get_hw_unique_key(struct tee_hw_unique_key *hwkey);`
>  `int tee_otp_get_die_id(uint8_t *buffer, size_t len);`
> 
> These implementations should fetch the key data from your SoC-specific e-fuses, or crypto unit according to the method defined by your SoC vendor.

Ok fuck it, enough reading lets just run the damn thing

```
I/TC: OP-TEE version: 3.15.0-231-g6ca9def9 (gcc version 10.2.1 20201103 (GNU Toolchain for the A-profile Architecture 10.2-2020.11 (arm-10.16))) #1 Fri Dec 31 10:10:16 UTC 2021 aarch64
I/TC: WARNING: This OP-TEE configuration might be insecure!
I/TC: WARNING: Please check https://optee.readthedocs.io/en/latest/architecture/porting_guidelines.html
```

This is very encouraging to me. it MIGHT BE INSECURE!!!

> In OP-TEE the HUK is just stubbed and you will see that in the function called tee_otp_get_hw_unique_key(...) in core/include/kernel/tee_common_otp.h. In a real secure product you must replace this with something else. If your device lacks the hardware support for a HUK, then you must at least change this to something else than just zeroes. But, remember it is not good secure practice to store a key in software, especially not the key that is the root for everything else, so this is not something we recommend that you should do.

stub, huh??

```c
// otp_stubs.c
__weak TEE_Result tee_otp_get_hw_unique_key(struct tee_hw_unique_key *hwkey)
{
  memset(&hwkey->data[0], 0, sizeof(hwkey->data));
  return TEE_SUCCESS;
}

__weak int tee_otp_get_die_id(uint8_t *buffer, size_t len)
{
  if (huk_subkey_derive(HUK_SUBKEY_DIE_ID, NULL, 0, buffer, len))
    return -1;

  return 0;
}
```

ok, now this is epic. see, this is why i really love qemu because that shit is always memeable in a ctf setting. for instance, if there is a kernel pwn, there's like a 95% chance the ASLR is ineffective or just disabled! Everything is so deterministic. psychologically, this is like an anchor in the face of the turbulence in life, where many catastrophic factors are completely out of anyone's control. how terrifying is that? But in the world of qemu, you are safe, it's like a weighted blanket to soothe and assuade the existential horror. There are many exploits that would not survive the harsh vicissitudes of reality. But in a qemu, Let's Fucking Go.

so anyways in theory all the qemu will have the same root SSK. TSK is derived from SSK+TA UUID, which is also same. Only mystery is the FEK which has some prng (from /dev/urandom?? idk lmao) mixed in. But FEK is encrypted with TSK. and stored in a header somewhere. So in theory we can decrypt everything statically.

However i'm lazy and i don't wanna figure out all that shit and how to reimplement it in pycryptodome. since there are a lot of complicated diagrams with and things like "GCM". whenever I see aes gcm, that's how i know this is some real Big Dick Cryptography going on, not for idiot reversers like me, and i don't want to deal with that. so i'm just gonna apply violence to "convince" Optee to decrypt all that shit for me! :-)

That's basically the problem. How do we convince optee to read out this random blob without any of the rest of the metadata or root of the hash tree. the central dogma of reverse engineering. how do i apply violence to get it to cooperate

# memes part 1

we take the online example (from optee_examples/secure_storage), and we just compile their stock ta since it's nearly identical to the one in the challenge rootfs. And we just replace the ta with ours. The shit they gave us all use the default signing keys I think so it doesn't matter. Anyways it doesnt complain about replacing that so who cares right.

Okay great, now we can talk to the secure storage api and ask it to make or retrieve objects. But problem!! We don't have the `dirf.db`, what now??

Solution: Make some random objects so it will populate a data/tee/0 , data/tee/1 , data/tee/2 (OVERWRITING THE ONE FROM THE CHALLENGE) , and data/tee/dirf.db

Then we'll just overwrite the new data/tee/2 with the original data/tee/2 from the challenge.

But this is bad because now we corrupted the data and it's fail the hashing and integrity bullshit! It's not happy and won't let us read that shit back! What do we do now???

# memes part 2

read the code for 6 hours, and dig through a lot of bullshit code and abstraction to finally figure out where the checks are. dig through syscall handler tables, way too many goddamn function pointers, and some context switches (yes, as in like swapping the vbar ie pagetable) too. then finally we can find what we are looking for.

then go in gdb and patch that shit up by poking the memory lol.

patch 1:

```c
static TEE_Result init_head_from_data(struct tee_fs_htree *ht,
              const uint8_t *hash)
{
  TEE_Result res;
  int idx;

  if (hash) {
    for (idx = 0;; idx++) {
      res = rpc_read_node(ht, 1, idx, &ht->root.node);
      if (res != TEE_SUCCESS)
        return res;

      // this shit basically checks "hey is this the correct child node i am looking for. based on the hash"
      // and my opinion is that it really IS the right child node, YOU are just hallucinating that the hash is wrong.
      // so please ALLOW ME to help CONVINCE you that my opinion is CORRECT.
      // i hope that we can come to an AGREEMENT and MUTAL UNDERSTANDING on this IMPORTANT QUESTION.

      if (!memcmp(ht->root.node.hash, hash, // <-- bypass me on second iteration! in gdb. will hit the breakpoint twice here. On first time, allow fail. On second time, force succeed the memcmp.
            sizeof(ht->root.node.hash))) {
        res = rpc_read_head(ht, idx, &ht->head);
        if (res != TEE_SUCCESS)
          return res;
        break;
      }

      if (idx)
        return TEE_ERROR_SECURITY;
    }
```

patch 2:

```c
TEE_Result tee_fs_htree_open(bool create, uint8_t *hash, const TEE_UUID *uuid,
           const struct tee_fs_htree_storage *stor,
           void *stor_aux, struct tee_fs_htree **ht_ret)
{
  // ...
  if (create) {
    // ...
  } else {
    res = init_head_from_data(ht, hash);
    if (res != TEE_SUCCESS)
      goto out;

    // dont fuck with this. I know it says "verify" which usually is bad.
    // because "verify" usually means "hassle me over some stupid shit i dont care about".
    // but if you fuck with it it will corrupt the program.
    // so leave this shit alone.
    res = verify_root(ht);
    if (res != TEE_SUCCESS)
      goto out;

    res = init_tree_from_data(ht);
    if (res != TEE_SUCCESS)
      goto out;

    // Ok, this is the BAD "verify". we need to NOP this shit.
    res = verify_tree(ht); // <-- bypass me! there are some hash checks here just make them do nothing.
  }

  // ...
}
```

Its not as simple as that since in ida all the shit got inlined a lot by the compiler so you have to be a little more MOTIVATED to get the shit accomplished, but end of the day, the optee os kernel image is not integrity checked it seems so that shit is gucci.


```c
// setup the TA connection
struct test_ctx ctx;
printf("Prepare session with the TA\n");
prepare_tee_session(&ctx);

TEEC_Result res;
char obj1_id[] = "object#1";    /* string identification for the object */
char* obj1_data = calloc(200,1);
strcpy(obj1_data, "this is my test data");
char* read_data = calloc(200,1);

// create a new object to populate data/tee/*
res = write_secure_object(&ctx, obj1_id, obj1_data, obj_size);
if (res != TEEC_SUCCESS) {
  printf("  -> create failed: 0x%x\n", res);
}

// ok fuck that shit up and replace the newly-created data/tee/2 with the one we actually wanna read
printf("corrupt object\n");
system("cp -f /mnt/a/2 /data/tee/2 ; chown tee:tee /data/tee/2 ; ");

// ok read that shit back but now with all the bad checks nullified in gdb
printf("- Read back the object\n");
res = read_secure_object(&ctx, obj1_id, read_data, obj_size);
if (res != TEEC_SUCCESS) {
  printf("read failed: 0x%x\n", res);
  break;
}
// succ.
printf("Read succ?\n");
for (size_t i = 0; i < obj_size; i++) {
  printf("%02x ", (uint8_t)read_data[i]);
}
printf("\n");

// make sure to free memory (VERY IMPORTANT!)
free(obj1_data);
free(read_data);
// exit the program gracefully
abort();
```

`rwctf{b5f3a0b72861b4de41f854de0ea3da10}`

did you know that I tried to submit the flag, but it was wrong the first time? it was because I copy pasted it wrong. I nearly had a heart attack you know.
