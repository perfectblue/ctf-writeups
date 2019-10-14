# Trick or treat

We can do two offsetted writes into libc. We can change freehook to system, then trigger scanf's internal free on a %lx format string. %lx gets triggered only on hex characters, so we trigger system on the binary `ed` which only consists of hex characters but also gives us a shell.
