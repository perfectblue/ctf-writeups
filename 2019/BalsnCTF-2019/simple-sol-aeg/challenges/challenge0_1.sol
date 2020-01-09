608060405260008060006101000a81548160ff02191690831515021790555034801561002a57600080fd5b5060ec806100396000396000f3006080604052600436106049576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806399bc9e1414604e578063ea602fa6146062575b600080fd5b348015605957600080fd5b506060608e565b005b348015606d57600080fd5b50607460aa565b604051808215151515815260200191505060405180910390f35b60016000806101000a81548160ff021916908315150217905550565b60008060009054906101000a900460ff169050905600a165627a7a723058204a193e308bef7a4c1addded33a28f96684a7e9d40cb50fc798ffa66fe8eac3340029


contract Contract {
    function main() {
        memory[0x40:0x60] = 0x80;
        storage[0x00] = (storage[0x00] & ~0xff) | 0x00;
        var var0 = msg.value;
    
        if (var0) { revert(memory[0x00:0x00]); }
    
        memory[0x00:0xec] = code[0x39:0x0125];
        return memory[0x00:0xec];
    }
}

contract Contract {
    function main() {
        memory[0x40:0x60] = 0x80;
    
        if (msg.data.length < 0x04) { revert(memory[0x00:0x00]); }
    
        var var0 = msg.data[0x00:0x20] / 0x0100000000000000000000000000000000000000000000000000000000 & 0xffffffff;
    
        if (var0 == 0x99bc9e14) {
            // Dispatch table entry for 0x99bc9e14 (unknown)
            var var1 = msg.value;
        
            if (var1) { revert(memory[0x00:0x00]); }
        
            var1 = 0x60;
            func_008E();
            stop();
        } else if (var0 == 0xea602fa6) {
            // Dispatch table entry for 0xea602fa6 (unknown)
            var1 = msg.value;
        
            if (var1) { revert(memory[0x00:0x00]); }
        
            var1 = 0x74;
            var1 = func_00AA();
            var temp0 = memory[0x40:0x60];
            memory[temp0:temp0 + 0x20] = !!var1;
            var temp1 = memory[0x40:0x60];
            return memory[temp1:temp1 + (temp0 + 0x20) - temp1];
        } else { revert(memory[0x00:0x00]); }
    }
    
    function func_008E() {
        storage[0x00] = (storage[0x00] & ~0xff) | 0x01;
    }
    
    function func_00AA() returns (var r0) { return storage[0x00] & 0xff; }
}

