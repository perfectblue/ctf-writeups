Spark
=====

Brief Idea:

Create UAF using -> open(), open(), link(0, 1), close(1)
reclaim UAF chunk using setxattr,
point links to userspace and stall it using userfaultfd,
get leaks using dmesg,
Set fake link's node pointer to fake spark_node chunk in userspace (so it gets added to array created in traversal)

close(fd[0]) -> our fake spark_node chunk in neighbours gets freed,
it calls kfree(chunk->neighbours->arr) which we control
so basically we have kfree(arbitrary_pointer)
we spray seq_operations and try to get one of those vtables freed using this (some brute needed)
and then we spray again using setxattr to reclaim that freed chunk and get RIP
