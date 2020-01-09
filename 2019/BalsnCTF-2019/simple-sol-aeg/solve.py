from pow import pow
from web3.auto import w3
from pwn import *

ABI = [
	{
		"constant": True,
		"inputs": [],
		"name": "isKing",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"payable": False,
		"stateMutability": "pure",
		"type": "function"
	}
]

r = remote('aab2596ac4a422a9f803ed317089c399b818bb72.balsnctf.com', 30731)
pow(r)

def get_contract():
    r.recvuntil('9:\n')
    data = r.recvline()
    return data

def deploy_contract(data, cur_abi=ABI):
    deet = w3.eth.sendTransaction({'from': w3.eth.accounts[0], 'data' : data})
    contract_address = w3.eth.getTransactionReceipt(deet)['contractAddress']
    cntract = w3.eth.contract(abi=cur_abi, address=contract_address)
    return cntract

def remove_constructor(bytecode):
    bytecode = bytecode[4:]
    chode_index = bytecode.index('6080') #Starter code
    return bytecode[chode_index:]

def get_all_signatures(runtime_code):
    return [X[:8] for X in runtime_code.split('8063') if X[8:12] == '1461' or X[8:12] == '1460'] #hackerman regex


def challenge_0(bytecode):
    
    current_contract_bytecode =  bytecode   

    print("Deploying challenge_0...")
    deployed_contract = deploy_contract(current_contract_bytecode)

    print("Deployed at -> {}".format(deployed_contract.address))

    #solve here------
    print("Solving challenge_0...")
    runtime_code = w3.eth.getCode(deployed_contract.address).hex()[2:]
    all_functions = get_all_signatures(runtime_code)
    all_functions.remove('ea602fa6')
 
    #solve end------
    print("Solution -> {}".format(all_functions[0]))

    print("Veryifying solution...")

    w3.eth.sendTransaction({'from': w3.eth.accounts[0],'to': deployed_contract.address, 'data':all_functions[0]})

    if not deployed_contract.functions.isKing().call():
        print("WRONG DEET")
        exit()
    print("Solution VERIFIED")

    return all_functions[0]

def challenge_1(bytecode):
    current_contract_bytecode = bytecode   

    print("Deploying challenge_1...")
    deployed_contract = deploy_contract(current_contract_bytecode)

    print("Deployed at -> {}".format(deployed_contract.address))

    #Solve ----
    print("Solving challenge_1...")
    runtime_code = w3.eth.getCode(deployed_contract.address).hex()[2:]
    all_functions = get_all_signatures(runtime_code)
    all_functions.remove('ea602fa6')
    
    print("Extracted all functions -> {}".format(all_functions))

    for func in all_functions:
        w3.eth.sendTransaction({'from': w3.eth.accounts[0],'to': deployed_contract.address, 'data':func})
        if deployed_contract.functions.isKing().call():
            print("Found solution -> {}".format(func))
            return func

    return ""

def challenge_2(bytecode):

    current_contract_bytecode = bytecode   

    print("Deploying challenge_2...")
    deployed_contract = deploy_contract(current_contract_bytecode)

    print("Deployed at -> {}".format(deployed_contract.address))

    #Solve ----
    print("Solving challenge_2...")
    runtime_code = w3.eth.getCode(deployed_contract.address).hex()[2:]
    all_functions = get_all_signatures(runtime_code)
    all_functions.remove('ea602fa6')
    
    print("Extracted all functions -> {}".format(all_functions))

    secret_index = runtime_code.index('555062')+6
    secret_val = int(runtime_code[secret_index:secret_index+6], 16) +1

    print("Secret arg -> 0x{:x}".format(secret_val))

    secret_sol = (hex((0x64-secret_val)&0xfffff))[2:].rjust(64, 'f')

    print("Solution -> {}".format(all_functions[0]+secret_sol))

    txn = w3.eth.sendTransaction({'from': w3.eth.accounts[0],'to': deployed_contract.address, 'data':all_functions[0]+secret_sol})

    print("Verifying solution...")

    if not deployed_contract.functions.isKing().call():
        print("WRONG DEET")
        exit()
    print("Solution VERIFIED")
    return all_functions[0] + secret_sol

def solve_contract(bytecode):
    codelen = len(bytecode)
    print(bytecode)
    if codelen == 586:
        return challenge_0(bytecode)
    elif codelen == 812:
        return challenge_2(bytecode)
    else:
        return challenge_1(bytecode)

    print("NOT DETECTED")

    return ""


chall0 = get_contract().decode().strip()
r.sendlineafter('data: ', challenge_0(chall0))

chall1 = get_contract().decode().strip()
r.sendlineafter('data: ', challenge_1(chall1))

chall2 = get_contract().decode().strip()
r.sendlineafter('data: ', challenge_2(chall2))

print("-"*0x80)


for m in range(7):
    chall3 = get_contract().decode().strip()
    r.sendlineafter('data: ', solve_contract(chall3))

r.interactive()

#Balsn{Ea5ytoS0lveR1ght_AwesomeSymExec}
