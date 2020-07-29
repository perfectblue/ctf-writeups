We are given `flag * 2^10000` modulo some power of 10. We cannot divide by `2^10000` mod `10^k`, but instead
we can divide mod `k^5`. If the flag is smaller than `k^5` (it is) we will recover it's absolute value.

	y = '1002773875431658367671665822006771085816631054109509173556585546508965236428620487083647585179992085437922318783218149808537210712780660412301729655917441546549321914516504576'
	m = 5**len(y)
	print((int(y)*pow(2, -10000, m)%m).to_bytes(50, 'big'))
