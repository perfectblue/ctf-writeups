# dual

`dual` mixes C's malloc/free, C++'s new/delete, Rust's alloc::RawVec/core::ptr::Unique and a handmade GC all in one program,
with some fun results.

In particular: when we write a zero length binary to a node, it will be encoded to zero length base64 string, which will be copied
to a alloc::RawVec. Unlike `malloc(0)`, which points into the heap, a zero length `RawVec<u8>`'s pointer will be `core::ptr::Unique<u8>::dangling()`, which is equal to `1`.
The garbage collector will intepret this slot as free (since `1 < 8`) and will happily put a node pointer into it.
This way we can overlap a node chunk and a text chunk.

# Exploit
After overlapping a node (call it X) and a zero length text, the GC will scan the chunk first as a text and
when it comes to scan it as a node, it will not follow any pointer's going from it, as it
was already marked as visited.
This will cause UAF on X's child nodes.
Then we allocate another text chunk to write a fake node and get heap read/write.
Finaly, we write a pointer to GOT into GC's pool, poison GOT, and get a shell.

See [solve.py](./solve.py).
