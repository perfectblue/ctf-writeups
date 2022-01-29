movi            r7, 221
movi            r0, 0x14
lsli            r0, r0, 16
ori             r0, r0, 0x0a58
movi            r1, 0x14
lsli            r1, r1, 16
ori             r1, r1, 0x1a58
movi            r2, 0x14
lsli            r2, r2, 16
ori             r2, r2, 0x2a58
trap            0

movi            r7, 57
movi            r0, 0
trap            0
movi            r7, 23
movi            r0, 4
trap            0

movi            r7, 57
movi            r0, 1
trap            0
movi            r7, 23
movi            r0, 4
trap            0

movi            r7, 57
movi            r0, 4
trap            0

