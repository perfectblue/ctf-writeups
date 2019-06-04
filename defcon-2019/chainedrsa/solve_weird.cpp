#include <gmpxx.h>
#include <iostream>

using namespace std;

int main() {
  mpz_class N, d_lsb, e;
  N = "18124287714289743402921860391938805802906944341932734190758891000301642805787283973340941727556656120675062646859767074420729417460928052041684549291186350486192702257116139093095560252628248810430776502067798029785450370598920639213752554771109198941299551413244695219665502860981447997386724836679678700054291239269452259217963023624019166322528369986585547798712270732453471567989970215353656991131743368962985180857670259672216233279178569773887659929545184964755007100694401487078369858058626841614493546486096791429938543766723990477600948917835053748395083198627876893900000302394013137910547285785102127285297";
  d_lsb = "75073650098380961323202704021544554519284902416668772259175451675556891916363053991027297858326676404892335030893143225391683584849375989595122175116007435929920715901535647100257019132659969949286372271528707864913138194778633591726519156781503220972221389034460310128716838473395934217430038968194976982337";
  e = 65537;
  unsigned given_bits = 1023;
  unsigned brute_bits = 10;

  unsigned tot_bits = (given_bits - 1) * 2;
  cout << "Add: ";
  unsigned add; cin >> add;
  tot_bits += add;
  cout << "D: " << tot_bits << endl;

  int L = 1;
  int R = 65537 + 1;

  unsigned n_bits = mpz_sizeinbase(N.get_mpz_t(), 2);
  cout << "N: " << n_bits << endl;

  unsigned comm_bits = tot_bits - given_bits - brute_bits;

  mpz_class enc_2;
  mpz_powm(enc_2.get_mpz_t(), mpz_class(2).get_mpz_t(), mpz_class(e).get_mpz_t(), N.get_mpz_t());

  for(mpz_class k = L; k < R; k++) {
    if(k % 100 == 0)
      cout << k.get_str() << endl;
    if(k == 0) continue;
    mpz_class d_ = (mpz_class(1) + k*(N+mpz_class(1)))/e;
    unsigned cur_bits = mpz_sizeinbase(d_.get_mpz_t(), 2);
    d_ >>= cur_bits - comm_bits;
    for(int brute = 0; brute < (1 << brute_bits); brute++) {
      mpz_class d__ = d_;
      for(int bit = 0; bit < brute_bits; bit++) {
        d__ <<= 1;
        if(brute & (1 << bit)) {
          d__ += mpz_class(1);
        }
      }
      d__ <<= given_bits;
      d__ += d_lsb;
      if(((e * d__ - 1) % k) == 0) {
        mpz_class dec_2;
        mpz_powm(dec_2.get_mpz_t(), enc_2.get_mpz_t(), d__.get_mpz_t(), N.get_mpz_t());
        if(dec_2 == 2) {
          cout << d__.get_str() << endl;
          return 0;
        }
      }
    }
  }
}
