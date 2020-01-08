from PIL import Image

ps = []
with open("colors") as f:
    for line in f:
        ps.append(tuple(map(int, line.strip().split(','))))

t = Image.open("Trip_to_Hoi_An.png")
pix = t.load()
vs = []
for x, y in ps:
    print(pix[x,y])
    vs += list(pix[x,y])

print(bytes(vs))