require 'json'
require 'openssl'

p = OpenSSL::BN::generate_prime(1024).to_i
q = OpenSSL::BN::generate_prime(1024).to_i

while true
    d = OpenSSL::BN::generate_prime(1024).to_i
    break if ((p - 1) * (q - 1)).gcd(d) == 1 && ((p - 1) * (q - 1)).gcd(d + 2) == 1
end

e1 = OpenSSL::BN.new(d).mod_inverse(OpenSSL::BN.new((p - 1) * (q - 1))).to_i
e2 = OpenSSL::BN.new(d + 2).mod_inverse(OpenSSL::BN.new((p - 1) * (q - 1))).to_i

flag = File.read('flag.txt')
msg = OpenSSL::BN.new(flag.unpack1("H*").to_i(16))
n = OpenSSL::BN.new(p * q)
enc = msg.mod_exp(OpenSSL::BN.new(e1), n)

puts ({ n: (p*q).to_s, e1: e1.to_s, e2: e2.to_s, enc: enc.to_s }).to_json
