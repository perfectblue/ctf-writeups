608060405260008060006101000a81548160ff02191690831515021790555034801561002a57600080fd5b506101ed8061003a6000396000f300608060405260043610610078576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff1680638bae03ff1461007d5780639a5b39fb14610094578063a1bc626f146100ab578063c595770e146100c2578063ea602fa6146100d9578063ea88e37714610108575b600080fd5b34801561008957600080fd5b5061009261011f565b005b3480156100a057600080fd5b506100a961013b565b005b3480156100b757600080fd5b506100c0610157565b005b3480156100ce57600080fd5b506100d7610173565b005b3480156100e557600080fd5b506100ee61018f565b604051808215151515815260200191505060405180910390f35b34801561011457600080fd5b5061011d6101a5565b005b60008060006101000a81548160ff021916908315150217905550565b60016000806101000a81548160ff021916908315150217905550565b60008060006101000a81548160ff021916908315150217905550565b60008060006101000a81548160ff021916908315150217905550565b60008060009054906101000a900460ff16905090565b60008060006101000a81548160ff0219169083151502179055505600a165627a7a723058202186f7b7d285a6d0414a38af37a208c2d6ad5bd71f69c389a5c86670a5a540f00029

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
    
        if (var0 == 0x8bae03ff) {
            // Dispatch table entry for 0x8bae03ff (unknown)
            var var1 = msg.value;
        
            if (var1) { revert(memory[0x00:0x00]); }
        
            var1 = 0x0092;
            func_011F();
            stop();
        } else if (var0 == 0x9a5b39fb) {
            // Dispatch table entry for 0x9a5b39fb (unknown)
            var1 = msg.value;
        
            if (var1) { revert(memory[0x00:0x00]); }
        
            var1 = 0x00a9;
            func_013B();
            stop();
        } else if (var0 == 0xa1bc626f) {
            // Dispatch table entry for 0xa1bc626f (unknown)
            var1 = msg.value;
        
            if (var1) { revert(memory[0x00:0x00]); }
        
            var1 = 0x00c0;
            func_0157();
            stop();
        } else if (var0 == 0xc595770e) {
            // Dispatch table entry for 0xc595770e (unknown)
            var1 = msg.value;
        
            if (var1) { revert(memory[0x00:0x00]); }
        
            var1 = 0x00d7;
            func_0173();
            stop();
        } else if (var0 == 0xea602fa6) {
            // Dispatch table entry for 0xea602fa6 (unknown)
            var1 = msg.value;
        
            if (var1) { revert(memory[0x00:0x00]); }
        
            var1 = 0x00ee;
            var1 = func_018F();
            var temp0 = memory[0x40:0x60];
            memory[temp0:temp0 + 0x20] = !!var1;
            var temp1 = memory[0x40:0x60];
            return memory[temp1:temp1 + (temp0 + 0x20) - temp1];
        } else if (var0 == 0xea88e377) {
            // Dispatch table entry for 0xea88e377 (unknown)
            var1 = msg.value;
        
            if (var1) { revert(memory[0x00:0x00]); }
        
            var1 = 0x011d;
            func_01A5();
            stop();
        } else { revert(memory[0x00:0x00]); }
    }
    
    function func_011F() {
        storage[0x00] = (storage[0x00] & ~0xff) | 0x00;
    }
    
    function func_013B() {
        storage[0x00] = (storage[0x00] & ~0xff) | 0x01;
    }
    
    function func_0157() {
        storage[0x00] = (storage[0x00] & ~0xff) | 0x00;
    }
    
    function func_0173() {
        storage[0x00] = (storage[0x00] & ~0xff) | 0x00;
    }
    
    function func_018F() returns (var r0) { return storage[0x00] & 0xff; }
    
    function func_01A5() {
        storage[0x00] = (storage[0x00] & ~0xff) | 0x00;
    }
}



