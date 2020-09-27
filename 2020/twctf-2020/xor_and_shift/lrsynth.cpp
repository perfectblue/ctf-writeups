#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <algorithm>
#include <vector>
#include <iostream>
#include <limits.h>
#include <math.h>
#include <unordered_map>
#include <assert.h>
using namespace std;

#define ran(i, a, b) for (auto (i) = (a); (i) < (b); (i)++)
typedef pair<int, int> ii;
typedef long long ll;
#define DEBUG(...) cerr << __VA_ARGS__ << endl;
#ifndef SHIROKO1_LOCAL
#undef DEBUG
#define DEBUG(...) ((void)0)
#define NDEBUG
#endif

static const int MAX = 3010;

template <typename T, T P>
struct intmod {
	intmod() {}
	constexpr intmod(T t) : x((t+P)%P) {}
	T value() const { return x; }
	bool operator!=(const intmod<T, P> i) { return x != i.x; }
	bool operator==(const intmod<T, P> i) { return x == i.x; }
	intmod<T, P> &operator+=(const intmod<T, P> i) { x = (x+i.x)%P; return *this; }
	intmod<T, P> &operator-=(const intmod<T, P> i) { x = (x+P-i.x)%P; return *this; }
	intmod<T, P> &operator*=(const intmod<T, P> i) { x = ((long long)x*i.x)%P; return *this; }
	intmod<T, P> &operator/=(const intmod<T, P> i) { x = ((long long)x*i.inverse().x)%P; return *this; }
	intmod<T, P> operator+(const intmod<T, P> i) const { auto j = *this; return j += i; }
	intmod<T, P> operator-(const intmod<T, P> i) const { auto j = *this; return j -= i; }
	intmod<T, P> operator*(const intmod<T, P> i) const { auto j = *this; return j *= i; }
	intmod<T, P> operator/(const intmod<T, P> i) const { auto j = *this; return j /= i; }
	intmod<T, P> operator-() const { intmod<T, P> n; n.x = (P-x)%P; return n; }
	intmod<T, P> inverse() const
	{
		if (x == 0)
			return 0;
		T a = x, b = P;
		T aa = 1, ab = 0;
		T ba = 0, bb = 1;
		while (a) {
			T q = b/a;
			T r = b%a;
			ba -= aa*q;
			bb -= ab*q;
			swap(ba, aa);
			swap(bb, ab);
			b = a;
			a = r;
		}
		intmod<T, P> ix = intmod<T, P>(aa) + intmod<T, P>(ba);
		assert(ix*x == unity);
		return ix;
	}
	static const intmod<T, P> zero;
	static const intmod<T, P> unity;
private:
	T x;
};
template <typename T, T P>
constexpr intmod<T, P> intmod<T, P>::zero = 0;
template <typename T, T P>
constexpr intmod<T, P> intmod<T, P>::unity = 1;

using rem = intmod<char, 2>;

template <typename K>
static vector<K> berlekamp_massey(vector<K> ss)
{
	vector<K> ts(ss.size());
	vector<K> cs(ss.size());
	cs[0] = K::unity;
	fill(cs.begin()+1, cs.end(), K::zero);
	vector<K> bs = cs;
	int l = 0;
	int m = 1;
	K b = K::unity;
	for (int k = 0; k < (int)ss.size(); k++) {
		K d = ss[k];
		assert(l <= k);
		for (int i = 1; i <= l; i++)
			d += cs[i]*ss[k-i];
		if (d == K::zero) {
			m++;
		} else if (2*l <= k) {
			K w = d/b;
			ts = cs;
			for (int i = 0; i < (int)cs.size()-m; i++)
				cs[i+m] -= w*bs[i];
			l = k+1-l;
			swap(bs, ts);
			b = d;
			m = 1;
		} else {
			K w = d/b;
			for (int i = 0; i < (int)cs.size()-m; i++)
				cs[i+m] -= w*bs[i];
			m++;
		}
		//cout << "l = " << l << "/" << k << "\n";
	}
	cs.resize(l+1);
	while (cs.back() == K::zero)
		cs.pop_back();
	return cs;
}

static vector<int> out[MAX];
static int n;
static rem i_deg[MAX];

namespace poly {
	template <typename K>
	void mul(vector<K> &dest, const vector<K> &l, const vector<K> &r)
	{
		int ln = l.size();
		int rn = r.size();
		int dn = ln+rn-1;
		dest.resize(dn, K::zero);
		ran (i, 0, ln)
		ran (j, 0, rn)
			dest[i+j] += l[i] * r[j];
	}

	template <typename K>
	K eval(const vector<K> &poly, rem x)
	{
		int n = poly.size();
		rem acc = K::zero;
		for (int i = n-1; i >= 0; i--) {
			acc = acc*x + poly[i];
		}
		return acc;
	}

	template <typename K>
	K eval_d(const vector<K> &poly, rem x)
	{
		int n = poly.size();
		rem acc = K::zero;
		for (int i = n-1; i > 0; i--) {
			acc = acc*x + rem(i)*poly[i];
		}
		return acc;
	}
};

template <typename K>
ostream &operator<<(ostream &o, const vector<K> &poly)
{
	o << "{";
	int n = poly.size();
	ran (i, 0, n-1)
		o << poly[i].value() << ", ";
	o << poly[n-1].value() << "}";
	return o;
}

int main()
{
	vector<rem> time_series;
	int bit;
	while (cin >> bit) {
		time_series.emplace_back(bit);
	}
	cout << "read " << time_series.size() << " bits" << endl;
	vector<rem> lr_poly = berlekamp_massey(time_series);
	cout << "linear complexity: " << lr_poly.size()-1 << "/" << time_series.size() << endl;
	cout << "char: 1";
	int nonzero_cnt = 0;
	ran (i, 1, (int)lr_poly.size()) {
		cout << ' ' << (int)lr_poly[i].value();
		if (lr_poly[i] != rem::zero) {
			nonzero_cnt += 1;
		}
	}
	cout << '\n';
	/*
	cout << "taps: ";
	ran (i, 1, (int)lr_poly.size()) {
		if (lr_poly[i] != rem::zero) {
			cout << ' ' << i;
		}
	}
	cout << '\n';
	*/

	vector<rem> prod(time_series.size(), 0);
	ran (i, 0, time_series.size()-lr_poly.size()) {
		ran (j, 0, lr_poly.size())
			prod[i+j] += time_series[i]*lr_poly[j];
	}
	cout << "seed:";
	ran (i, 0, (int)lr_poly.size()-1) {
		cout << ' ' << (int)prod[i].value();
	}
	cout << '\n';
	ran (i, lr_poly.size(), time_series.size()-lr_poly.size()) {
		if (prod[i] != 0) {
			cout << "FAILED\n";
			return 1;
		}
	}
	return 0;
}
