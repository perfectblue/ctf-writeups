Lost the solve script but here is writeup. The vulnerability is that the size of the output protobuf after being parsed from array then serialized to string is not checked. This means we need a message that is longer after being parsed then serialized. It turns out backwards compatability with packed fields does this, so we can manually fuzz the message until we get a perfect off-by-one overflow into the next chunk after the message is serialized again. This message overflows with one 0x71 byte:

```
0a6ac182858a94a8d020c182858a94a8d020c182858a94a8d020c182858a94a8d020c182858a94a8d020c182858a94a8d020c182858a94a8d020c182858a94a8d020c182858a94a8d020c182858a94a8d020c182858a94a8d020c182858a94a8d020c182858a94a8d020717110effdb6f50d
```

Using this, we can easily obtain overlapping chunks, get leaks, overwrite tcache fd, overwrite freehook, win.
