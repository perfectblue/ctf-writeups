608060405260008060006101000a81548160ff02191690831515021790555034801561002a57600080fd5b506101ed8061003a6000396000f300608060405260043610610078576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806341e6bad81461007d5780636e97bce51461009457806390094524146100ab5780639e62c3f9146100c2578063a35a4e39146100d9578063ea602fa6146100f0575b600080fd5b34801561008957600080fd5b5061009261011f565b005b3480156100a057600080fd5b506100a961013b565b005b3480156100b757600080fd5b506100c0610157565b005b3480156100ce57600080fd5b506100d7610173565b005b3480156100e557600080fd5b506100ee61018f565b005b3480156100fc57600080fd5b506101056101ab565b604051808215151515815260200191505060405180910390f35b60016000806101000a81548160ff021916908315150217905550565b60008060006101000a81548160ff021916908315150217905550565b60008060006101000a81548160ff021916908315150217905550565b60008060006101000a81548160ff021916908315150217905550565b60008060006101000a81548160ff021916908315150217905550565b60008060009054906101000a900460ff169050905600a165627a7a7230582041ebacd799312d30b25e9ab1144d31b89d75c3a5a2464e8b35715da243d732640029

contract Contract {
    function main() {
        memory[0x40:0x60] = 0x80;
        storage[0x00] = (storage[0x00] & ~0xff) | 0x00;
        var var0 = msg.value;
    
        if (var0) { revert(memory[0x00:0x00]); }
    
        memory[0x00:0x0269] = code[0x3a:0x02a3];
        return memory[0x00:0x0269];
    }
}


contract Contract {
    function main() {
        memory[0x40:0x60] = 0x80;
    
        if (msg.data.length < 0x04) { revert(memory[0x00:0x00]); }
    
        var var0 = msg.data[0x00:0x20] / 0x0100000000000000000000000000000000000000000000000000000000 & 0xffffffff;
    
        if (var0 == 0x41e6bad8) {
            // Dispatch table entry for 0x41e6bad8 (unknown)
            var var1 = msg.value;
        
            if (var1) { revert(memory[0x00:0x00]); }
        
            var1 = 0x0092;
            func_011F();
            stop();
        } else if (var0 == 0x6e97bce5) {
            // Dispatch table entry for 0x6e97bce5 (unknown)
            var1 = msg.value;
        
            if (var1) { revert(memory[0x00:0x00]); }
        
            var1 = 0x00a9;
            func_013B();
            stop();
        } else if (var0 == 0x90094524) {
            // Dispatch table entry for 0x90094524 (unknown)
            var1 = msg.value;
        
            if (var1) { revert(memory[0x00:0x00]); }
        
            var1 = 0x00c0;
            func_0157();
            stop();
        } else if (var0 == 0x9e62c3f9) {
            // Dispatch table entry for 0x9e62c3f9 (unknown)
            var1 = msg.value;
        
            if (var1) { revert(memory[0x00:0x00]); }
        
            var1 = 0x00d7;
            func_0173();
            stop();
        } else if (var0 == 0xa35a4e39) {
            // Dispatch table entry for 0xa35a4e39 (unknown)
            var1 = msg.value;
        
            if (var1) { revert(memory[0x00:0x00]); }
        
            var1 = 0x00ee;
            func_018F();
            stop();
        } else if (var0 == 0xea602fa6) {
            // Dispatch table entry for 0xea602fa6 (unknown)
            var1 = msg.value;
        
            if (var1) { revert(memory[0x00:0x00]); }
        
            var1 = 0x0105;
            var1 = func_01AB();
            var temp0 = memory[0x40:0x60];
            memory[temp0:temp0 + 0x20] = !!var1;
            var temp1 = memory[0x40:0x60];
            return memory[temp1:temp1 + (temp0 + 0x20) - temp1];
        } else { revert(memory[0x00:0x00]); }
    }
    
    function func_011F() {
        storage[0x00] = (storage[0x00] & ~0xff) | 0x01;
    }
    
    function func_013B() {
        storage[0x00] = (storage[0x00] & ~0xff) | 0x00;
    }
    
    function func_0157() {
        storage[0x00] = (storage[0x00] & ~0xff) | 0x00;
    }
    
    function func_0173() {
        storage[0x00] = (storage[0x00] & ~0xff) | 0x00;
    }
    
    function func_018F() {
        storage[0x00] = (storage[0x00] & ~0xff) | 0x00;
    }
    
    function func_01AB() returns (var r0) { return storage[0x00] & 0xff; }
}

