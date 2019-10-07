608060405260008060006101000a81548160ff021916908315150217905550606460015534801561002f57600080fd5b506101578061003f6000396000f30060806040526004361061004c576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806335302dfb14610051578063ea602fa61461007e575b600080fd5b34801561005d57600080fd5b5061007c600480360381019080803590602001909291905050506100ad565b005b34801561008a57600080fd5b50610093610115565b604051808215151515815260200191505060405180910390f35b8060016000828254039250508190555062056f9560015411156101125762056f9c60015410156100f65760016000806101000a81548160ff021916908315150217905550610111565b60008060006101000a81548160ff0219169083151502179055505b5b50565b60008060009054906101000a900460ff169050905600a165627a7a72305820e3f74dc1dbcc6e2810f77f3d6d52ec65216757884cb47b6aa1a5b68c62ba0c240029


contract Contract {
    function main() {
        memory[0x40:0x60] = 0x80;
        storage[0x00] = (storage[0x00] & ~0xff) | 0x00;
        storage[0x01] = 0x64;
        var var0 = msg.value;
    
        if (var0) { revert(memory[0x00:0x00]); }
    
        memory[0x00:0x0157] = code[0x3f:0x0196];
        return memory[0x00:0x0157];
    }
}


contract Contract {
    function main() {
        memory[0x40:0x60] = 0x80;
    
        if (msg.data.length < 0x04) { revert(memory[0x00:0x00]); }
    
        var var0 = msg.data[0x00:0x20] / 0x0100000000000000000000000000000000000000000000000000000000 & 0xffffffff;
    
        if (var0 == 0x35302dfb) {
            // Dispatch table entry for 0x35302dfb (unknown)
            var var1 = msg.value;
        
            if (var1) { revert(memory[0x00:0x00]); }
        
            var1 = 0x007c;
            var var2 = msg.data[0x04:0x24];
            func_00AD(var2);
            stop();
        } else if (var0 == 0xea602fa6) {
            // Dispatch table entry for 0xea602fa6 (unknown)
            var1 = msg.value;
        
            if (var1) { revert(memory[0x00:0x00]); }
        
            var1 = 0x0093;
            var1 = func_0115();
            var temp0 = memory[0x40:0x60];
            memory[temp0:temp0 + 0x20] = !!var1;
            var temp1 = memory[0x40:0x60];
            return memory[temp1:temp1 + (temp0 + 0x20) - temp1];
        } else { revert(memory[0x00:0x00]); }
    }
    
    function func_00AD(var arg0) {
        storage[0x01] = storage[0x01] - arg0;
    
        if (storage[0x01] <= 0x056f95) {
        label_0112:
            return;
        } else if (storage[0x01] >= 0x056f9c) {
            storage[0x00] = (storage[0x00] & ~0xff) | 0x00;
            goto label_0112;
        } else {
            storage[0x00] = (storage[0x00] & ~0xff) | 0x01;
            goto label_0112;
        }
    }
    
    function func_0115() returns (var r0) { return storage[0x00] & 0xff; }
}

