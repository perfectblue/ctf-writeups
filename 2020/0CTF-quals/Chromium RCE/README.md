Chromium RCE
============

The bug is that we can detach and use arraybuffers. This results in UAF bug. Since arraybuffers use calloc, we have to perform fastbin attack. We can free an arraybuffer, overwrite the fastbin freelist and fastbin dup mallochook, then overwrite free with one gadget.
