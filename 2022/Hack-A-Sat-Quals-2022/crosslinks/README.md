# Crosslinks

## Background

In this challenge, we are given satellite observation data which includes range and range rate data. The task is to figure out which satellite is making these observations.

## Solution

To solve this, we can brute force through each satellite. For each satellite, we can compute the error of both the range and range rate data. The satellite for which the computed error is the smallest will be the answer.

To compute range, we can use the skyfield python library to get each satellie's position at a given time. Then, we simply compute the distance between the two points and take its square of the difference as error.

To compute range rate, we note that range rate is computed as the projection of the difference in velocities onto the displacement vector. The skyfield python library can get us both position and velocity data as a given time. using these values, we can compute the range rate. Again, we use least squares error as the computed error.

## Solve Script

The final script is in solve.py. Run with `python solve.py`
