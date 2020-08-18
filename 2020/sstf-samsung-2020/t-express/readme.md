# T Express

There were three vulnerabilities: null byte overflow in user input, use after free, and negative indexing. We can use null byte overflow to tamper with the tcache freed key. Then, we can use the UAF to double free a tcache chunk. We then use negative indexing with the view option to obtain a libc leak. Then, simply tcache dup freehook to system and win. See solve script for exploit.
