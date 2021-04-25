# Fake Medallion

The challenge implements medallions through 30 qubit states, each of which can be in four states: |0>, |1>, |+>, or |->. These 30 states are encoded into a 60 bit value, which is then AES encrypted with a random key. We are also able to tamper with the qubit states through a circuit with any arbitrary unitary operation, and we have 3 qubits to play with for each qubit state.

To solve, we used quantum cloning for equatorial qubits. We can use 3 qubits to clone 1 qubit into 2 qubits with fidelity 1/2 + sqrt(1/8). Using this, we can redeem the medallion twice and get enough money to continuously generate medallions to recover python's RNG state. After recovering the RNG state, we can predict future medallion states, then claim enough money to get the flag.

The probability for successfully cloning 30 qubits into 60 qubits is (1/2 + sqrt(1/8))^60, which is approximately 1 in 13300 tries. We ran 48 instances for 5 hours and finally got the flag after approximately 40000 tries. Unlucky.

## Flag

`PCTF{1_D1d_nO7_L13_7O_YoU_R422l3_R34lLy_15_4_5c4M}`
