package main

import (
	_ "embed"
	"fmt"
	"math/rand"
	"os"
	"unicode"
)

//go:embed level2_emojis.txt
var level2ValidEmojis string

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

func main() {
	var start_seed uint64
	start_seed = 1649485920000

	const MAX = 10000

	var res [MAX]int

	target := []int{6814, 5721, 8025, 9678, 6315, 11760, 8076, 3987, 11706, 9601}

	new_emojis := []rune{}
	level2Emojis := []rune(level2ValidEmojis)

	for {
		if start_seed%1000 == 0 {
			fmt.Fprintf(os.Stderr, "%d\n", start_seed)
		}
		rand.Seed(int64(start_seed))
		for i := 0; i < MAX; i++ {
			res[i] = rand.Intn(12972)
		}

		for i := 0; i < MAX; i++ {
			j := 0
			last_one := 0
			if res[i] == target[j] {
				j++
				for k := i + 1; k < MAX; k++ {
					if res[k] == target[j] {
						j++
						if j == len(target) {
							last_one = k
							break
						}
					}
				}
				if j == len(target) {
					fmt.Fprintf(os.Stderr, "Found Seed: %d, starting at: %d\n", start_seed, i)

					rand.Seed(int64(start_seed))
					for x := 0; x < last_one+1; x++ {
						rand.Intn(12972)
					}

					for x := 0; x < 500; x++ {
						new_emojis = append(new_emojis, level2Emojis[rand.Intn(236)])
					}

					for x := 0; x < 495; x++ {
						word := []rune{}
						for y := 0; y < 5; y++ {
							word = append(word, unicode.ToUpper(new_emojis[x+y]))
						}
						fmt.Printf("%s\n", string(word))
					}
					return
				}
			}
		}
		start_seed++
	}
}
