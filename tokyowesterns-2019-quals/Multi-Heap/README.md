# Multi-Heap

The bug is a race condition while memcpying chunks. Memcpy can be run in a different thread, so we just race copy with free to copy over a freed chunk to an allocated chunk to obtain leaks. We use the same race to copy a fake fd pointing to malloc hook into a freed chunk to tcache dupe into malloc hook and win.
