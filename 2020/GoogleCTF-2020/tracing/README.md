# Tracing

Solved by sampriti

The binary reads in a series of "sensitive" uuids from argv. Then it is a socket server which takes in a list of uuids from the client, builds a binary search tree, and then searches each "sensitive" uuid in the BST.

(I know it is not memory corruption because it is Rust and i grepped for `unsafe` lmao.)

Unfortunately it is REALLY sensitive so it is VERY PAINFUL to do it in practice!!!! Though this goes without saying for timing attacks...

***What is the big brain strategy for when you must brute force or timing attack???***

# RENT VPS IN THE SAME DATACENTER AS THE CHALLENGE SERVER!!!!!

This trick is extremely STUPID and CRUDE but it has solved us so many challenge in the past!! If you need to timing attack or brute force, ELIMINATE NETWORK HOPS!! In the past, I have done **24 bits remote brute force** on stack canary with this trick!!! Top 10 stupid tricks CTF organizers DONT want you to know!!

Despite that, we still need to apply a lot of statistical violence to make it happen, but what can you do right. The idea, anyway, is since the BST is not self-balancing we can construct really imbalanced trees, like 2^10 elements in one branch. Then we do binary search on flag bits and brute bit by bit

`"CTF{1BitAtATime}"`