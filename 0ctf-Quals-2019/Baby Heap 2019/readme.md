# "Baby" Heap 2019 - 0ctf Quals 2019

0ctf qualifications was this past weekend, and oh boy was it amazing yet difficult. I, [VoidMercy](https://twitter.com/_VoidMercy), spent about 4 hours on this challenge after coming up with the exploit idea. I had instruction pointer control with 1 hour left in the CTF, but one gadgets did not work, so sadly, I didn't solve this challenge in time to submit it for points. However it took me only around 20 minutes to implement the idea to circumvent the one gadget failure after the CTF.

## The Binary and Vulnerability

The binary is running on libc-2.28.so (the one on Ubuntu 18.10). Reversing is the boring part, so let me just tell you what the binary does and what primitives we have. Essentially we could calloc(size) where 0 <= size <= 0x58, and we are able to maintain a pointer to 16 chunks at once. Then we can also free these chunks, view the contents of these chunks, and update the contents of these chunks. The vulnerability is a null byte overflow in the update function.

So what we have here is basically tcache with only fastbin sizes and a null byte overflow. This reminded me of HITCON's [babytcache](https://ctftime.org/task/68810) challenge, but the big difference is that we are not able to allocate chunks with smallbin sizes, only fastbins. As a result, if we attempt to null byte overflow a fastbin sized chunk, the size will be overflowed to 0x0, which causes all sorts of problem and malloc will definitely yell at you.

## How to Solve

The key to solving this problem is to reduce the size of the top chunk to 0x0, so that when we attempt to malloc a chunk, malloc_consolidate will be triggered. Malloc_consolidate iterates through the fastbin freelists and converts the fastbin to an unsorted bin while also checking before and after the chunk for free chunks and consolidating them. Using malloc_consolidate to create unsorted chunks, the null byte overflow, and the backwards consolidation of fastbins in malloc_consolidate, we can create overlapping chunks. This is how you do it:

```
shrink top so that we can call malloc_consolidate whenever we want
unsorted | fast
(fast to shrink) | shrunken unsort | fast (still maintains bigly prev_size and unset prev_in_use)
(fast to shrink) | fasts | hole | fast (still maintains bigly prev_size and unset prev_in_use)
(free fast) | (fasts) | hole | fast (still maintains bigly prev_size and unset prev_in_use)
=> trigger consolidate
unsorted | (fasts) | hole | fast (still maintains bigly prev_size and unset prev_in_use)
unsorted (size 0x30 so we can trigger consolidate) | (fasts) | hole | freed fast (still maintains bigly prev_size and unset prev_in_use)
=> trigger consolidate
BIGLY UNSORTED | OVERLAPPED FASTS | END OF CHUNK
```

First, we have to shrink the size of top, which we can do so by allocating chunks and using the null byte overflow to overwrite the lsb of top chunk. Next, we can control the heap in a way so that when we call malloc_consolidate, we have a single unsorted chunk preceding a fastbin chunk that we control a pointer to.

Next, we can allocate a fastbin chunk in the beginning of the big unsorted chunk, which splits the unsorted chunk. We then use that fastbin and the null byte overflow to shrink the size of the splitted chunk, thus causing subsequent prev_size updates to not touch the last fastbin. Essentially, we have now created a hole while the last fastbin still maintains prev_size and an unset prev_in_use bit.

We can use up the split and shrunken unsorted bin to regain primitives to malloc_consolidate again.

Next, we must then free a fastbin in the beginning of the unsorted bin so that when we trigger consolidate, the fastbin will be put into unsorted bins and obtain fd and bk pointers so that when we trigger backwards consolidation on the last fastbin, unlink won't scream seg fault. However, during this step we have to be careful, because when we malloc a chunk to trigger consolidate, it will convert free fastbins into unsorted bins, but also use the converted unsorted bins. Since we want the freed fastbin to be converted to and remain an unsorted bin, we must create another free fastbin elsewhere that will get used up after the consolidation. Additionally, we have to make sure the newly created unsorted bin's size is relatively small so that we can maintain primitives to malloc_consolidate by requesting a chunk bigger than its size.

Now we can free the last fastbin and place it into fastbin freelist so that when we trigger malloc_consolidate next, it will backwards conslidate with the first unsorted bin we have just created in the previous step.

Because we still control pointers to fastbins in the middle, we now have overlapping fastbin chunks. We can also leak libc pointers by splitting the newly bigly overlapping consolidated unsorted chunk, and reading its fd and bk pointers from our overlapped fastbins.

The rest of the exploit is relatively easy. We can place a heap pointer into the fastbins freelist in main arena, then use fastbin fd attack with a 0x50 sized fastbin on that heap pointer (since heap memory start with 0x55 or 0x56). With a fastbin chunk allocated in the fastbin freelist region of main arena, we can overwrite and control top chunk, using which we can get almost arbitrary write.

Specifically, by controlling top chunk, we can get arbitrary write after a non zero (and not super small) value in memory. I tried pointing top chunk before malloc_hook, getting a chunk there, and overwriting malloc_hook to a one gadget, but none of the one gadgets worked.

What we can do instead was point top chunk to the first non zero value before free hook, which was around 0xb00 bytes before free_hook. Then, we keep allocating chunks and zeroing the fastbin freelist so that we keep allocating from top chunk and eventually reach free hook. Pwned. Truly a "baby" level heap challenge.

The link to the solution script can be found [here](https://github.com/perfectblue/ctf-writeups/blob/master/0ctf-Quals-2019/Baby%20Heap%202019/solve.py).