# Trust or Not

Category: Rev

Solves: 7

Solve by: cts and theKidOfArcrania

Points: 357

---

i've been awake for way too long, so you get to enjoy my shitty lowercase word soup English in this writeup.

# whats going on in the shit?

First of all, the remote is identical to the local, so fuck the remote lol. It also means we can solve fully statically. And we can apply violence to solve any problems we encounter. Which is encouraging.

1. There's boot chain bl1 -> bl2 -> bl3 -> ... it's documented on arm's website and optee docs (poorly)

bl1, bl2 are just vendor firmware shit from arm, safe to ignore it lol

bl32_extra1 is optee kernel that run in trustzone. I think this is at EL3, but it's at "SEL1" secure el1. so in its code it think it's in EL1. a little bit confusing to me, but whatever.

bl33.bin is just your typical edk tianocore uefi shit. it's also safe to ignore. thankfully there's no uefi bullshit because i'm way too stupid to fuck with that black magic nonsense

in rootfs, the only file with newer modified timestamp is data/tee/2, that's where optee store encrypted blobs for its "secure object" storage api. it's some hash tree shit. But we're only give the blob "2", but with no directory node `dirf.db`.

That's basically the problem. How do we convince optee to read out this random blob without any of the rest of the metadata or root of the hash tree. We better apply some violence to this shit. to get it to cooperate

# what is ta?

`lib\optee_armtz/f4e750bb-1437-4fbf-8785-8d3580c34994.ta`

That's the trusted application, or TA. this shit is a user mode program that runs in Secure EL0 (so like usermode) but in the secure world. So you would imagine this is in an enclave. Obviously for us that is a fake news since we know the local is identical to remote, and the whole shit is in a qemu so we can apply violence to get around problems.

All the ta in optee is identified by uuid. On the host, you make request to optee, with the uuid of the ta you wanna talk to, and then the optee os (in the secure world) will service that request by dispatch to the appropriate ta. The ta basically is like daemon. You open a session to a ta, this spawn the TA task in the secure kernel, then each request call the entrypoint of the TA, then when you close, the TA goes away.

If you google the uuid, `f4e750bb-1437-4fbf-8785-8d3580c34994`,  you can tell they just copy pasted one of the online examples for optee. On how to use the secure storage api. And in ida pro its basically the exact same shit they just commented out the functionality to read back the shit.

# memes part 1

we take the online example (from optee_examples/secure_storage), and we just compile their stock ta since it's nearly identical to the one in the challenge rootfs. And we just replace the ta with ours. The shit they gave us all use the default signing keys I think so it doesn't matter. Anyways it doesnt complain about replacing that so who cares right.

Okay great, now we can talk to the secure storage api and ask it to make or retrieve objects. But problem!! We don't have the `dirf.db`, what now??

Solution: Make some random objects so it will populate a data/tee/0 , data/tee/1 , data/tee/2 (OVERWRITING THE ONE FROM THE CHALLENGE) , and data/tee/dirf.db

Then we'll just overwrite the new data/tee/2 with the original data/tee/2 from the challenge.

But this is bad because now we corrupted the data and it's fail the hashing and integrity bullshit! It's not happy and won't let us read that shit back! What do we do now???

# memes part 2

read the code for 6 hours, and dig through a lot of bullshit code and abstraction to finally figure out where the checks are.

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

    res = verify_root(ht); // Do not bypass me, it will corrupt the program. leave this shit alone.
    if (res != TEE_SUCCESS)
      goto out;

    res = init_tree_from_data(ht);
    if (res != TEE_SUCCESS)
      goto out;

    res = verify_tree(ht); // <-- bypass me! there are some hash checks here just make them do nothing.
  }

  // ...
}
```

Its not as simple as that since in ida all the shit got inlined a lot by the compiler so you have to be a little more MOTIVATED to get the shit accomplished, but end of the day, the optee os kernel image is not integrity checked it seems so that shit is gucci.

Then you can just read that shit back and its the good good.

`rwctf{b5f3a0b72861b4de41f854de0ea3da10}`
