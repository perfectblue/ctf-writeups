require "openssl"
require "json"

p = OpenSSL::BN.generate_prime(1024)
q = OpenSSL::BN.generate_prime(1024)
k = OpenSSL::BN.generate_prime(2048, false)
n = p * q
File.write("pubkey.txt", { n: n.to_s, k: k.to_s }.to_json)
