# Gas Machine

Just shellcode something that uses all the gas, realtively easy.

- Have around 60 JUMPDEST appended at the end 
- Check gas
- If less than 60 gas left
- Jump relative to end subtracting how much gas we need to use, as each JUMPDEST uses 1
- Otherwise keep doing it
