#include <iostream>
#include <algorithm>
#include <vector>
#include <stdint.h>

using namespace std;

int tbl1[16] = {9, 240, 193, 169, 186, 195, 141, 128, 161, 69, 210, 242, 3, 200, 152, 183};
int tbl2[16] = {218, 218, 238, 202, 208, 137, 128, 90, 199, 249, 162, 67, 79, 90, 82, 253};

int8_t dp[16][1 << 16][1200];
vector<vector<vector<int8_t> > > next_j;

int solve(int prv, int bitmask, int sum) {
  int i = __builtin_popcount(bitmask);
  if (i == 16) {
      sum += abs(tbl1[prv] - tbl1[0]);
      sum += abs(tbl2[prv] - tbl2[0]);
      if (sum == 0x470) {
        cout << "SICE" << " " << bitmask << " " << prv << endl;
        return 1;
      }
  }
  if(dp[prv][bitmask][sum] != -1) return dp[prv][bitmask][sum];

  int ans = 0;
  for(int j = 0; j < 16; j++) {
    if((bitmask & (1 << j)) == 0) {
      int new_sum = sum + abs(tbl1[j] - tbl1[prv]) + abs(tbl2[j] - tbl2[prv]);
      if(new_sum > 0x470) continue;
      ans = solve(j, bitmask | (1 << j), new_sum);
      if(ans) {
        next_j[prv][bitmask][sum] = j;
        break;
      }
    }
  }

  dp[prv][bitmask][sum] = ans;
  return ans;
}

int main() {
  next_j.resize(16);
  for(int j = 0; j < 16; j++) {
    next_j[j].resize(1 << 16);
    for(int k = 0; k < (1 << 16); k++) {
    next_j[j][k].resize(1200);
      for(int l = 0; l < 1200; l++) {
        dp[j][k][l] = -1;
      }
    }
  }

  cout << solve(9, (1 << 0) | (1 << 9), abs(tbl1[0] - tbl1[9]) + abs(tbl2[0] - tbl2[9])) << endl;

  int prv = 9;
  int sum = abs(tbl1[0] - tbl1[9]) + abs(tbl2[0] - tbl2[9]);
  int bitmask = (1 << 0) | (1 << 9);
  cout << "0 9 ";
  while(sum != 0x470) {
    int j = next_j[prv][bitmask][sum];
    cout << j << " ";
    sum += abs(tbl1[j] - tbl1[prv]) + abs(tbl2[j] - tbl2[prv]);
    bitmask |= (1 << j);
    prv = j;
  }
  cout << endl;
}
