# Secure Karte

The bug is that we can modify a freed chunk once. To solve this we can obtain a fake fast chunk in the global buffer to obtain unlimited fastbins fd dupe. We then use unsorted bin attack to place a libc pointer in global buffer, partial overwrite into stdout to obtain leaks. Then we obtain a fast chunk in pointers list using the pointer to the chunk in stdout, clobber lock, then since we now have leaks, we can easily fastbin dupe mallochook and win.
