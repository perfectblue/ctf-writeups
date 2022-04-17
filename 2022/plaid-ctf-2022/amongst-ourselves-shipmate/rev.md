# Amongst Ourselves: Shipmate - Recalibrate Engine (Rev)

If you reverse `misc/recalibrate-engine/engine`, you can find out that there is a secret nim game after the normal process.

1. Get 5 numbers `a[0] ~ a[4]` from the normal process
2. Press `6663232` quickly, to play a secret nim game
3. The game starts with the value `sum(a[0:5]) + 5`, and the CPU is the first player. We can pick the number from 1 to 9, and the CPU picks its number randomly.

You can get the flag by winning the nim game.

The flag is `PCTF{y_1s_th3_enG1n3_pl4Yin6_gAm3s}`.