# The Problem

We control the azimuth and the elevation of a receiving antenna, and
we need to keep it pointing at a satellite (which is moving!).

# Solution

## Initial position

Challenge description hints at the satellite being towards the north and near the horizon.
In numerical terms, that means azimuth and elevation are both near 0°. We do a simple grid
search around that point:

```python
for az in np.linspace(-10, 10, 5):
    for el in np.linspace(00, 20, 5):
        send_cmd(az, el)
        sig = recv_signal()
        power = np.mean(np.abs(sig))
        print(az, el, np.mean(np.abs(sig)))
```

This gives us an initial guess of `az, el = 10, 20`. Running the procedure again with tighter
search bounds shows that `10, 20` is pretty much the maximum.

A careful reader will notice that we conduct our search over a single connection to the challenge,
paying no attention to the fact that the satellite can move while we search.
This was an oversight on our part, but, as we learned later, the satellite doesn't move during
the first 50 or so queries.

## Tracking the sat


See `./control_antenna.py` for the final solution.

We take a quick and dirty approach here: we move the antenna by a small random amount at each step,
and if that improved our signal we keep the change, otherwise revert it.

```python
az, el = 10, 20
old_power = 500
old = az, el
for i in range(400):
    az += random.uniform(-0.2, 0.2)
    el += random.uniform(-0.2, 0.2)
    send_cmd(az, el)

    sig = recv_signal()
    power = np.mean(np.abs(sig))
    if power < old_power:
        az, el = old
    else:
        old = az, el

    # NB: old_power is updated unconditionally
    #     old_power is NOT the-highest-seen-so-far power, but the previous one
    old_power = power
```

Unfortunately this is not enough. The random guesses at satellite's direction are just too poor on average.
We try to improve by including an inertia term from the previous successful step:

```diff
  az, el = 10, 20
  old_power = 500
  old = az, el
+ d_az = 0
+ d_el = 0
  for i in range(400):
-     az += random.uniform(-0.2, 0.2)
-     el += random.uniform(-0.2, 0.2)
+     az += random.uniform(-0.2, 0.2) + d_az*0.8
+     el += random.uniform(-0.2, 0.2) + d_el*0.8
      send_cmd(az, el)
  
      sig = recv_signal()
      power = np.mean(np.abs(sig))
      if power < old_power:
          az, el = old
      else:
+         d_az = az - old[0]
+         d_el = el - old[1]
          old = az, el
  
      old_power = power
```

... and this is just enough to get a decodable signal. See `./pos_power_log.dat` for the
positions our control loop produced.

## Demodulation

See `./decode.py`.

As long as the antenna is pointing in a more-or-less correct direction, we get back very clean
IQ samples free from offsets or skews of any kind. The modulation used is QPSK, exactly 10 samples per symbol,
8 bits per character, no start-stop-parity bits, little endian order.
