M = 136798100663240822199584482903026244896116416344106704058806838213895795474149605111042853590
primes = [2]

for x in range(1201):
    primes.append(next_prime(primes[-1]))

sice = []
for x in primes:
    if M % x == 0:
        sice.append(x)

M_ = 1
for i in range(len(sice)):
    M_ *= sice[i]
    if M % M_ != 0:
        continue
    o_ = Mod(65537, M_).multiplicative_order()
    print(o_, log(M_, 2).n(), M_)
