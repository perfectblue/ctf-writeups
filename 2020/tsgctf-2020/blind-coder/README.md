Remote has 50 secret 32-bit integers, we can execute 1000 arbitrary predicates on all of them
and get back the count of integers that matched.

Simplest strategy is to use binary search, but it requires about 1300 queries to succeed.
For extra efficiency, whenever we have two ranges `[l1, r1)` and `[l2, r2)` with a single element
in both of them, we query them together. Result 0 or 2 means we can split two ranges for the
price of just one query. If result is 1, the ranges become entangled: if one range splits left,
the other one splits right and vice-versa. We memorize such pairs and continue as per usual,
and when we manage to split a range we also split all it's entangled pairs (recursively).
