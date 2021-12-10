from Crypto.Util.number import *

N = 73105772487291349396254686006336120330504972930577005514215080357374112681944087577351379895224746578654018931799727417401425288595445982938270373091627341969888521509691373957711162258987876168607165960620322264335724067238920761042033944418867358083783317156429326797580005138985469248465425537931352359757
e = 4537482391838140758438394964043410950504913123892269886065999941390882950665896428937682918187777255481111874006714423664290939580653075257588603498124366669194458116324464062487897262881136123858890202346251370203490050314565294751740805575602781718282190046613532413038947173662685728922451632009556797931
enc = 14558936777299241791239306943800914301296723857812043136710252309211457210786844069103093229876701608756952780774067174377636161903673229776614350695222134040119114881027349864098519027057618922872932074441000483969146246381640236171500856974180238934543370727793393492372475990330143750179123498797867932379

enc = pow(enc, N, N)

P.<x> = PolynomialRing(Zmod(N))

f = x - enc
for v in f.small_roots(beta=(1024 - 211 - 1) / 1024):
    print(long_to_bytes(int(v)))
